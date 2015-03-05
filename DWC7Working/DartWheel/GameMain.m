//
//  GameMain.m
//  DartWheel
//
//  Created by tang on 12-7-21.
//  Copyright __MyCompanyName__ 2012年. All rights reserved.
//

// Import the interfaces
#import "GameMain.h"
#import "WheelMan.h"
#import "SimpleAudioEngine.h"
#import "Dart.h"
#import "cocos2d.h"
#import <CoreGraphics/CoreGraphics.h>
#import "GamePauseScene.h"
#import "GameState.h"
#import "LevelSelectionScene.h"
#import "IntroLayer.h"
#import "LifeOver.h"
#import "AppDelegate.h"
#import "RootViewController.h"
#import <Chartboost/Chartboost.h>

@implementation GameMain

@synthesize background,gameCMC,wheel,gameIsOver,stageSize,spriteCache;
@synthesize dartArr,musicIsOn,soundOnItem,soundOnMenu,soundOffItem,soundOffMenu,runTimeUICMC,removeDartsNum,spriteLifes,lifesAction,life,dartIsReady,lifeBML,dartsInWheelArr,gameOverScreen,dartsCMC,currentChoosedVictimID,levelBML,scoreText,score,bullseye,greatBonus,bullseyeBonus, gameOverBannerCheck,videoWatched;
@synthesize numberofDarts,count,lblDarts,darts;

+(CCScene *) scene{
	CCScene *scene = [CCScene node];
//	GameMain *layer = [GameMain node];
    GameMain *layer = [[GameMain alloc]init];
	[scene addChild: layer];
	return scene;
}

-(void) hideAndDisplayBanner:(BOOL) value{
    AppDelegate *appDelegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
    [appDelegate.viewController displayBannerView:value];
    [[NSNotificationCenter defaultCenter]postNotificationName:kReachabilityChangedNotification object:nil];
    BOOL connect=[[NSUserDefaults standardUserDefaults]boolForKey:@"NetworkStatus"];
    if(connect)
    {
   /*  if (value==YES) {
       if(!adm)
        {
        
        adm = [[AdMobViewController alloc]init];
        adm.frame =CGRectMake(0, 0, 320, 50);
        viewHost1 = adm.view;
        //[rootViewController.view addSubview:viewHost1];
        [[[CCDirector sharedDirector] openGLView] addSubview:viewHost1];
        }
        else{
            viewHost1.hidden=NO;
              [[[CCDirector sharedDirector] openGLView] addSubview:viewHost1];
        }
    }
    else{
        [viewHost1 removeFromSuperview];
    }*/
    }
    
}


-(void)updateTime{
   self.theTime=(int)[[NSUserDefaults standardUserDefaults]integerForKey:@"theTime"];
}
// on "init" you need to initialize your instance
-(id) init:(int)victimId
{
    //[[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(showGameOver) name:@"showGameOver" object:nil];
    //[[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(updateTime) name:@"TheTime" object:nil];
	// always call "super" init
	// Apple recommends to re-assign "self" with the "super" return value
	if( (self=[super initWithColor:ccc4(0,0,0,255)])) {
        
         AppDelegate *appDelegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
        windowSize = [CCDirector sharedDirector].winSize;
        [self hideAndDisplayBanner:YES];
        self.gameOverBannerCheck=NO;
        self.wheel=nil;
        limitTime=20;
        self.count=0;
        self.darts=(int)[[NSUserDefaults standardUserDefaults]integerForKey:@"darts"];
        
        failVideo=NO;
        delegateNo=YES;
      //  self.checkLevelClear=NO;
       // self.videoWatched=YES;
        // Live     [Chartboost startWithAppId:@"54870c31c909a668589390f5"
               // appSignature:@"b5d7759d477fc9f7ded8b5b9b37890dbb08ff309"
                //         delegate:self];
      
        if (firstTimeChartBoost==NO) {
//     Not Live
            [Chartboost startWithAppId:@"54d343e70d60253588bccfa9"
                          appSignature:@"b463aee174e22839018d592aad71ef42ceb44286"
                              delegate:self];
            
//      //Sir    //Live
           /* [Chartboost startWithAppId:@"54870c31c909a668589390f5"
              appSignature:@"b5d7759d477fc9f7ded8b5b9b37890dbb08ff309"
                      delegate:self];*/
            firstTimeChartBoost=YES;
        }
       
 
        
     // [Chartboost cacheRewardedVideo:CBLocationStartup];
        userDefault = [NSUserDefaults standardUserDefaults];
        
        // Check for First Run
        
        BOOL checkFirstRun = [userDefault boolForKey:@"firstrun"];
        
        if (!checkFirstRun) {
            [userDefault setObject:@"0" forKey:@"currentDate"];
            [userDefault setBool:YES forKey:@"firstrun"];
            [userDefault setInteger:5 forKey:@"life"];
            [userDefault synchronize];
            
            
        }
        
                self.spriteCache=[CCSpriteFrameCache sharedSpriteFrameCache];
        [self.spriteCache addSpriteFramesWithFile:@"sheet.plist"];
        
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updatelblDarts:) name:@"updatelblDarts" object:nil];
      
          //[Chartboost cacheRewardedVideo:CBLocationStartup];
        
       
        
        
        
        //////////////////////////////
        //define some parameters
        self.isTouchEnabled=YES;
        self.stageSize=[[CCDirector sharedDirector]winSize];
        self.gameIsOver=NO;
        self.musicIsOn=YES;
        ///////////////////////////////
        
        self.runTimeUICMC=[[CCSprite alloc]init];
        
        //create game container clip
        self.gameCMC=[CCSprite node];
        self.gameCMC.visible=NO;
        [self addChild:self.gameCMC];
        //create game background
       
        if([UIScreen mainScreen].bounds.size.height<500){
       
        self.background=[CCSprite spriteWithFile:@"playscreen.png"];
        self.background.anchorPoint=ccp(0,0);
        [self.gameCMC addChild:self.background];
        }
        else{
        
            self.background=[CCSprite spriteWithFile:@"playscreeniphone5.png"];
            self.background.anchorPoint=ccp(0,0);
            [self.gameCMC addChild:self.background];
        }
        ////music mute button(s)
        
        CCSprite *soundOnSprite=[CCSprite spriteWithFile: @"musicOn.png"];
        CCSprite *soundOnSprite2=[CCSprite spriteWithFile:@"musicOn.png"];
        
        self.soundOnItem=[CCMenuItemSprite itemFromNormalSprite:soundOnSprite selectedSprite:soundOnSprite2 target:self selector:@selector(muteMusicClicked)];
        self.soundOnMenu=[CCMenu menuWithItems:soundOnItem, nil];
        
        CCSprite *soundOffSprite=[CCSprite spriteWithFile:@"musicOff.png"];
        CCSprite *soundOffSprite2=[CCSprite spriteWithFile:@"musicOff.png"];
        self.soundOffItem=[CCMenuItemSprite itemFromNormalSprite:soundOffSprite selectedSprite:soundOffSprite2 target:self selector:@selector(muteMusicClicked)];
        self.soundOffMenu=[CCMenu menuWithItems:soundOffItem, nil];
        
        self.soundOnMenu.position=self.soundOffMenu.position=ccp(windowSize.width/2,20);
        self.soundOnMenu.scale=0.6;
        self.soundOffMenu.scale=0.6;
        self.soundOnMenu.anchorPoint=ccp(0, 0);
        self.soundOffMenu.anchorPoint=ccp(0, 0);
        
        [self.runTimeUICMC addChild:soundOnMenu];
        [self.runTimeUICMC addChild:soundOffMenu];
        
        if(self.musicIsOn){
            self.soundOnMenu.visible=YES;
            self.soundOffMenu.visible=NO;
        }
        else{
            self.soundOnMenu.visible=NO;
            self.soundOffMenu.visible=YES;
        }

        //preload sounds
        
        if (self.musicIsOn) {
            [[SimpleAudioEngine sharedEngine] preloadBackgroundMusic:@"music.wav"];
            
        }
        
        [[SimpleAudioEngine sharedEngine] preloadEffect:@"bullseye.wav"];
        [[SimpleAudioEngine sharedEngine] preloadEffect:@"hit.wav"];
        [[SimpleAudioEngine sharedEngine] preloadEffect:@"miss.wav"];
        [[SimpleAudioEngine sharedEngine] preloadEffect:@"ouch1.wav"];
        [[SimpleAudioEngine sharedEngine] preloadEffect:@"ouch2.wav"];
        [[SimpleAudioEngine sharedEngine] preloadEffect:@"ouch3.wav"];
        [[SimpleAudioEngine sharedEngine] preloadEffect:@"shoot.wav3"];
        
        if(self.musicIsOn){
            [self schedule:@selector(playBGM) interval:0.5];
        }
       
        [self addChild:self.runTimeUICMC];
        
        /// lifes sprite (dart on the bottom left side )
        self.spriteLifes=[[CCSprite alloc]initWithSpriteFrameName:@"dartFill0060.png"];
        NSMutableArray *lifesArr=[NSMutableArray array];
        for (int i=1; i<=60; i++) {
            NSString *lifesSpriteStr;
            if(i<10){
                lifesSpriteStr=[NSString stringWithFormat:@"dartFill000%i.png",i];
                
            }else{
                lifesSpriteStr=[NSString stringWithFormat:@"dartFill00%i.png",i];
            }
            id lifesSprite=[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:lifesSpriteStr];
            [lifesArr addObject:lifesSprite];
        }
        self.lifesAction=[CCAnimate actionWithAnimation:[CCAnimation animationWithFrames:lifesArr delay:0.006f]];
        self.spriteLifes.anchorPoint=CGPointZero;
        self.spriteLifes.position=ccp(4,4);
        [self.runTimeUICMC addChild:self.spriteLifes];
        
        //////life label 
        
        self.lifeBML=[CCLabelTTF labelWithString:@"3" fontName:@"frank-highlight-1361541867.ttf" fontSize:30];
//        self.lifeBML.anchorPoint=ccp(0,0);
        self.lifeBML.position=ccp(40,20);
        [self.runTimeUICMC addChild:self.lifeBML];
        
        ////////////////
        
        [self hideLifeSprites];
        
        // Rajeev
        // Pause Button
        
        self.lblTime=[CCLabelTTF labelWithString:[NSString stringWithFormat:@"Time : %i",limitTime] fontName:@"frank-highlight-1361541867.ttf" fontSize:20];
        self.lblTime.position=ccp(65, windowSize.height-70);
        [self.runTimeUICMC addChild:self.lblTime];
        
        self.theTime=limitTime;
        
        self.lblDarts=[CCLabelTTF labelWithString:[NSString stringWithFormat:@"Darts %i",self.darts] fontName:@"frank-highlight-1361541867.ttf" fontSize:20];
        self.lblDarts.position=ccp(160, windowSize.height-40);
        [self.runTimeUICMC addChild:self.lblDarts];
        
        
        self.pauseBtn=[CCMenuItemImage itemFromNormalImage:@"pause1.png" selectedImage:@"pause1.png" target:self selector:@selector(pauseBtnClicked:)];
        
        CCMenu *menuPause = [CCMenu menuWithItems:self.pauseBtn, nil];
        if ([[[UIDevice currentDevice]systemVersion]floatValue]>8.0) {
            menuPause.position=ccp(120, 20);
        }
        else{
        menuPause.position=ccp(120, 20);
        }
        [self.runTimeUICMC addChild:menuPause];
        
        mainLife=(int)[userDefault integerForKey:@"life"];
        NSString *strLife = [NSString  stringWithFormat:@"Life : %i", mainLife];
        self.labelLife = [CCLabelTTF labelWithString:strLife fontName:@"frank-highlight-1361541867.ttf" fontSize:20];
        self.labelLife.color=ccWHITE;
        self.labelLife.position=ccp(windowSize.width-70, windowSize.height-70);
        [self.runTimeUICMC addChild:self.labelLife];
        
        //==============================
        
        //game over screen
        
        self.gameOverScreen=[[GameOverScreen alloc]init];
        self.gameOverScreen.gameMain=self;
        
        [self addChild:self.gameOverScreen];
        self.dartsCMC=[[CCSprite alloc]init];
        [self addChild:self.dartsCMC];
        self.gameOverScreen.visible=NO;
        
        //bitmap labels
        
        self.levelBML=[CCLabelTTF labelWithString:@"" fontName:@"frank-highlight-1361541867.ttf" fontSize:25];
        self.levelBML.position=ccp(windowSize.width-10,80);
        [self.runTimeUICMC addChild:self.levelBML];

        self.scoreText=[CCLabelTTF labelWithString:@"0" fontName:@"frank-highlight-1361541867.ttf" fontSize:25];
        self.scoreText.position=ccp(windowSize.width-50,10);
        [self.runTimeUICMC addChild:self.scoreText];
        
        //bonus clips 
        
        self.greatBonus=[CCSprite spriteWithSpriteFrameName:@"great.png"];
        self.bullseyeBonus=[CCSprite spriteWithSpriteFrameName:@"bullseye.png"];
        self.bullseyeBonus.visible=NO;
        self.greatBonus.visible=NO;
        [self addChild:self.greatBonus];
        [self addChild:self.bullseyeBonus];
        [self newGame:victimId];
         [[NSNotificationCenter defaultCenter]postNotificationName:kReachabilityChangedNotification object:nil];
        BOOL connect=[[NSUserDefaults standardUserDefaults]boolForKey:@"NetworkStatus"];
        if(connect)
        {
            //[Chartboost cacheRewardedVideo:CBLocationStartup];
        }
        
	}
    
	return self;
}
-(void)levelNotClearSetting {
    
    self.gameIsOver = YES;
    //[[NSUserDefaults standardUserDefaults]setInteger:0 forKey:@"darts"];
   // [[NSUserDefaults standardUserDefaults]synchronize];
   int lifeUserDefault = (int)[userDefault integerForKey:@"life"];
    
    
   
   
    NSLog(@"lifeuserdefault is %d",lifeUserDefault);
    
    NSString *numlife = [wrapperLife objectForKey:(__bridge id)kSecAttrLabel];
    
    int retrievednumLife = [numlife intValue];
    
    if (retrievednumLife>0) {
        
        retrievednumLife--;
        NSString *lifeString = [NSString stringWithFormat:@"%i",retrievednumLife];

        [wrapperLife setObject:lifeString forKey:(__bridge id)kSecAttrLabel];
        
        if(retrievednumLife==0){
            [userDefault setBool:NO forKey:@"elife"];
            [userDefault synchronize];
        }
    }
    
    if(lifeUserDefault<0){
        [userDefault setInteger:0 forKey:@"life"];
        [userDefault synchronize];
    }
    else{
        [userDefault setInteger:lifeUserDefault forKey:@"life"];
        [userDefault synchronize];
       
         [[NSNotificationCenter defaultCenter]postNotificationName:kReachabilityChangedNotification object:nil];
        BOOL check=[[NSUserDefaults standardUserDefaults]boolForKey:@"NetworkStatus"];
        if (check) {
            int darts=(int)[[NSUserDefaults standardUserDefaults]integerForKey:@"darts"];
            if (darts<=1) {
                [[CCDirector sharedDirector]pause];
               
                /*UIAlertView * alert=[[UIAlertView alloc]initWithTitle:@"Do you want to refill darts?"  message:nil delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK",@"Cancel", nil];
                [alert show];*/
                //failVideo=NO;
                AppDelegate *appDelegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
                NSLog(@"failed to load %d", failVideo);
                if (failVideo) {
                    [[AppDelegate sharedAppDelegate]showToastMessage:@"Sorry ad failed to load"];
                    [[CCDirector sharedDirector]resume];
                    int life2=(int)[[NSUserDefaults standardUserDefaults]integerForKey:@"life"];
                    life2--;
                    [[NSUserDefaults standardUserDefaults]setInteger:life2 forKey:@"life"];
                    [[NSUserDefaults standardUserDefaults]synchronize];
                    [self showGameOver];
                }
                else{
                    [self createUI];
                }
                
               
                
               

                
                //[self hideAndDisplayBanner:NO];
                
               // GamePauseScene *actionScene = [[[GamePauseScene alloc] init] autorelease];
            
              //  [[CCDirector sharedDirector] pushScene:actionScene];
                
                //[Chartboost showRewardedVideo:CBLocationStartup];

            }
            else{
                if (self.theTime==0 ||self.life==0) {
                    lifeUserDefault--;
                    [userDefault setInteger:lifeUserDefault forKey:@"life"];
                    [self showGameOver];
                }
                else{
                
                [self showGameOver];
            }
            }
        }
        else{
            lifeUserDefault--;
            [userDefault setInteger:lifeUserDefault forKey:@"life"];
            [self showGameOver];
        }
        NSString *lifeString = [NSString stringWithFormat:@"%i",lifeUserDefault];
        [wrapperLife setObject:lifeString forKey:(__bridge id)kSecAttrLabel];
    }
         //theTime=20;
   // }
    
    //[userDefault synchronize];
    
    NSString *str =[userDefault objectForKey:@"currentDate"];
    
    if (lifeUserDefault<5 && [str isEqualToString:@"0"]) {
        
        NSDate* now = [NSDate date];
        NSDateFormatter *df = [[NSDateFormatter alloc] init];
        [df setDateFormat:@"dd/MM/yyyy HH:mm:ss"];
        NSString *dateStr = [df stringFromDate:now];
        
        [userDefault setObject:dateStr forKey:@"currentDate"];
        [userDefault synchronize];
    }
    if (lifeUserDefault<=0) {
        self.gameOverBannerCheck=YES;
        [self compareDate];
    }
    self.checkLevelClear=NO;
    [self unschedule:@selector(updateTimeDisplay)];

}

-(void)updatelblDarts:(id)sender{
    int reward=[[NSUserDefaults standardUserDefaults]integerForKey:@"darts"];
    [self.lblDarts  setString:[NSString stringWithFormat:@"Darts : %i",reward]];
    
}

#pragma  mark-  alert view delegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex==0) {
        gm.musicIsOn=NO;
        [[SimpleAudioEngine sharedEngine] stopBackgroundMusic];
       
            
            // [Chartboost showRewardedVideo:CBLocationStartup];
            
       // [[CCDirector sharedDirector] popScene];
        //
              
                self.menuResume.visible=NO;
                self.menuHomePage.visible=NO;
        
    }
    else{
          [[CCDirector sharedDirector] resume];
        int life1=(int)[[NSUserDefaults standardUserDefaults]integerForKey:@"life"];
        life1--;
        [[NSUserDefaults standardUserDefaults]setInteger:life1 forKey:@"life"];
        [[NSUserDefaults standardUserDefaults]synchronize];
      
        [self showGameOver];
    }
        //[[CCDirector sharedDirector]replaceScene:[LevelSelectionScene node]];
   
}

-(void)updateTimeDisplay{
    self.theTime--;
    [self.lblTime  setString:[NSString stringWithFormat:@"Time : %i",self.theTime]];
    [[NSUserDefaults standardUserDefaults]setInteger:self.theTime forKey:@"theTime"];
    [[NSUserDefaults standardUserDefaults]synchronize];
    if (self.theTime==0) {
        
        [self levelNotClearSetting];
        
//        if (mainLife==0) {
//            [userDefault setBool:NO forKey:@"elife"];
//            [userDefault synchronize];
//        }
//       else if (mainLife>0) {
//            [userDefault setInteger:mainLife forKey:@"life"];
//            [userDefault synchronize];
//            theTime=20;
//            [self showGameOver];
//        }
    }
}

-(void)pauseBtnClicked:(id)sender {
    NSLog(@"Game Pause");
//    [[CCDirector sharedDirector] pause];
//    
//    [self gamePauseScene];
  
    [self hideAndDisplayBanner:NO];
    
    GamePauseScene *actionScene = [[[GamePauseScene alloc] init] autorelease];
    
    [[CCDirector sharedDirector] pushScene:actionScene];
}
-(void)gamePauseScene {
    
    if (!self.imageResume) {
        self.imageResume = [CCMenuItemImage itemFromNormalImage:@"resume.png" selectedImage:@"resume.png" target:self selector:@selector(resumeGame)];
        
        self.menuResume=[CCMenu menuWithItems:self.imageResume, nil];
        self.menuResume.position=ccp(windowSize.width/2, windowSize.height/2);
        [self addChild:self.menuResume];
    }
    else{
        self.menuResume.visible=YES;
    }
    if (!self.imageMainPage) {
        self.imageMainPage = [CCMenuItemImage itemFromNormalImage:@"menu.png" selectedImage:@"menu.png" target:self selector:@selector(homePage)];
        
        self.menuHomePage=[CCMenu menuWithItems:self.imageMainPage
                           , nil];
        self.menuHomePage.position=ccp(windowSize.width/2, windowSize.height/2+40);
        [self addChild:self.menuHomePage];
    }
    else {
        self.menuHomePage.visible=YES;
    }
}
-(void)resumeGame {
    
    [[CCDirector sharedDirector] resume];
    self.menuResume.visible=NO;
//    [self removeChild:self.menuResume cleanup:YES];
//    [self.menuResume release];
//    [self.imageResume release];
    
    self.menuHomePage.visible=NO;
//    [self removeChild:self.menuHomePage cleanup:YES];
//    [self.menuHomePage release];
}
-(void)homePage {
    [self hideAndDisplayBanner:NO];
    self.menuResume.visible=NO;
    [self removeChild:self.menuResume cleanup:YES];
    [self.menuResume release];
    
    self.menuHomePage.visible=NO;
    [self removeChild:self.menuHomePage cleanup:YES];
    [self.menuHomePage release];
    
//    [self removeChild:self.wheel cleanup:YES];
//    [self.wheel release];
    
    [[CCDirector sharedDirector] pushScene:[IntroLayer scene]];
}
// show bomus clips , great and bullseye
-(void) showBonus:(int)theID pos:(CGPoint)thePoint{
    
    id theAction;
    id ap=[CCFadeTo actionWithDuration:0.3 opacity:0];
    CCCallFunc * cccf;
    id seq;
    [self.bullseyeBonus stopAllActions];
    [self.greatBonus stopAllActions];
    
    if(theID==1){
        self.bullseyeBonus.visible=YES;
        self.bullseyeBonus.opacity=255;
        self.bullseyeBonus.position=thePoint;
        theAction=[CCMoveTo actionWithDuration:0.3 position:ccp(self.bullseyeBonus.position.x,self.bullseyeBonus.position.y+30)];
         
        cccf=[CCCallFunc actionWithTarget:self selector:@selector(hideBonus)];
        seq=[CCSequence actions:theAction,[CCDelayTime actionWithDuration:0.2],ap,cccf, nil];
        [self.bullseyeBonus runAction:seq];
    }
    else if(theID==2){
        self.greatBonus.visible=YES;
        self.greatBonus.opacity=255;
        self.greatBonus.position=thePoint;
        theAction=[CCMoveTo actionWithDuration:0.3 position:ccp(self.greatBonus.position.x,self.greatBonus.position.y+30)];
        cccf=[CCCallFunc actionWithTarget:self selector:@selector(hideBonus)];
        seq=[CCSequence actions:theAction,[CCDelayTime actionWithDuration:0.2],ap,cccf, nil];
        [self.greatBonus runAction:seq];
    }
}

//hide bonus clips

-(void) hideBonus{
    self.greatBonus.visible=self.bullseyeBonus.visible=NO;
    self.greatBonus.opacity=self.bullseyeBonus.opacity=255;
}

//stop game
-(void)unLoadGame{
    [self unschedule:@selector(loop)];
    [self.wheel stop];
    [self.wheel removeAllDatrts:NO];
    [self hideLifeSprites];
}
//show some sprites when game is playing
-(void) showAndReSetLifeSprites{
    self.life=3;
     AppDelegate *appDelegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
     [[NSNotificationCenter defaultCenter]postNotificationName:kReachabilityChangedNotification object:nil];
    BOOL check =[[NSUserDefaults standardUserDefaults]boolForKey:@"NetworkStatus"];
    if (check) {
        
    
    if (appDelegate.videoWatched) {
  
    if (self.count==0) {
        if ([GameState sharedState].levelNumber<=10) {
            self.count=15;
            
        }
        else if ([GameState sharedState].levelNumber>10 &&[GameState sharedState].levelNumber<=30){
            self.count=25;
            }
        else{
          self.count=30;
        }
        [self.lblDarts  setString:[NSString stringWithFormat:@"Darts : %i",self.count]];
        [[NSUserDefaults standardUserDefaults]setInteger:self.count forKey:@"darts"];
        [[NSUserDefaults standardUserDefaults]synchronize];
    }
        //appDelegate.videoWatched=NO;
}
    
    
       else if (gm.checkLevelClear==YES) {
            if (gm.count==0) {
                if ([GameState sharedState].levelNumber<=10) {
                    gm.count=15;
                   
                }
                else if ([GameState sharedState].levelNumber>10 &&[GameState sharedState].levelNumber<=30){
                    gm.count=25;
                }
                else{
                    gm.count=30;
                }
                
                [self.lblDarts  setString:[NSString stringWithFormat:@"Darts : %i",gm.count]];
                [[NSUserDefaults standardUserDefaults]setInteger:gm.count forKey:@"darts"];
                [[NSUserDefaults standardUserDefaults]synchronize];
               // gm.checkLevelClear=NO;
            }
        }
    }
    else{
        //if (gm.checkLevelClear==YES) {
            if (self.count==0) {
                if ([GameState sharedState].levelNumber<=10) {
                    self.count=15;
                    [[NSUserDefaults standardUserDefaults]setInteger:15 forKey:@"darts"];
                    
                }
                else if ([GameState sharedState].levelNumber>10 &&[GameState sharedState].levelNumber<=30){
                    self.count=25;
                    [[NSUserDefaults standardUserDefaults]setInteger:25 forKey:@"darts"];
                }
                else{
                    self.count=30;
                    [[NSUserDefaults standardUserDefaults]setInteger:30 forKey:@"darts"];
                }
                [[NSUserDefaults standardUserDefaults]setInteger:self.count forKey:@"darts"];
                [[NSUserDefaults standardUserDefaults]synchronize];
                int darts=[[NSUserDefaults standardUserDefaults]integerForKey:@"darts"];
                [self.lblDarts  setString:[NSString stringWithFormat:@"Darts : %i",darts]];
               // gm.checkLevelClear=NO;
            //}
        }
    }
    /*else{
            UIAlertView * alert=[[UIAlertView alloc]initWithTitle:@"You do not have enough darts."  message:@"Watch video for darts" delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
            [alert show];
            
        }*/
   

  
   
    NSLog(@"self.numberofDarts %d",gm.count);
   
    
    self.lifeBML.visible=YES;
    self.spriteLifes.visible=YES;
    self.lblDarts.visible=YES;
    self.lifeBML.string=[NSString stringWithFormat:@"%i",self.life];
    
    self.pauseBtn.visible=YES;
    self.lblTime.visible=YES;
    self.wheel.currentLevel=[GameState sharedState].levelNumber;
    NSLog(@"Current Level == %i",[GameState sharedState].levelNumber);
    [self updateLevelText];
    self.levelBML.visible=YES;
    
    self.scoreText.visible=YES;
}
//update level label
-(void) updateLevelText{
    
    id moveTo=[CCMoveTo actionWithDuration:0.5 position:ccp(320,20)];
    CCCallFunc *cccf=[CCCallFunc actionWithTarget:self selector:@selector(levelBMLHided)];
    id seq=[CCSequence actions:moveTo,cccf, nil];
    [self.levelBML runAction:seq];
}

#pragma  mark-  alert view delegate
/*- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex==0) {
        [Chartboost showRewardedVideo:CBLocationStartup];
        [[CCDirector sharedDirector]replaceScene:[LevelSelectionScene node]];
    }
}*/
#pragma mark--

//level bitmap label hided 

-(void) levelBMLHided{

    self.levelBML.string=[NSString stringWithFormat:@"LEVEL-%i",[GameState sharedState].levelNumber];
   // NSLog(@"LevelBML STring =-=- %@",self.levelBML.string);
    id moveTo=[CCMoveTo actionWithDuration:0.5 position:ccp(320-self.levelBML.contentSize.width,40)];
    [self.levelBML runAction:moveTo];
}

//hide some sprites when game is not playing
-(void) hideLifeSprites{
    
    self.lifeBML.visible=NO;
    self.spriteLifes.visible=NO;
    self.lblDarts.visible=NO;
    self.pauseBtn.visible=NO;
    self.lblTime.visible=NO;
    self.levelBML.visible=NO;
    
    self.scoreText.visible=NO;
}

// the main loop of the game 

-(void) loop{
    
    for (int i=0; i<[self.dartArr count]; i++) {
      //  NSLog(@"ndarts %lu",(unsigned long)self.dartArr.count);
        Dart *dart=[self.dartArr objectAtIndex:i];
        if(dart.state==0){
            double goX=dart.position.x-(dart.position.x-dart.targetX)*0.3;
            double goY=dart.position.y-(dart.position.y-dart.targetY)*0.6;
            dart.position=ccp(goX,goY);
            
            dart.rotation = -atan2(dart.position.y - dart.targetY, dart.position.x- dart.targetX) * 180/M_PI;
        }
        
        if(dart.state==1){
           // if (self.numberofDarts<=0) {
                //theTime=0;
              //  [self levelNotClearSetting];
                
                
            //}
           // else{
                dart.position=ccp(dart.targetX,dart.targetY);
//            NSLog(@"Target X-==-%f, target y--%f , dart x--%f , dart y -- %f",dart.targetX,dart.targetY,dart.position.x,dart.position.y);
         
        
            [self addDartToWheel:dart.targetX y:dart.targetY rotation:dart.rotation oldDart:dart newDart:dart.xinDart];
                //self.numberofDarts--;
              
            dart.state=2;
           
        }
    }
    
    //remove darts ,and clear array
    
    for (int j=0; j<self.removeDartsNum; j++) {
        [(Dart*)[self.dartArr objectAtIndex:0] removeFromParentAndCleanup:YES];
        [self.dartArr removeObjectAtIndex:0];
    }
    self.removeDartsNum=0;
}
//delay for playing music
-(void)playBGM{
    [self unschedule:@selector(playBGM)];
    self.soundOnMenu.visible=self.musicIsOn;
    self.soundOffMenu.visible=!self.musicIsOn;
    [[SimpleAudioEngine sharedEngine] playBackgroundMusic:@"music.wav" loop:YES];
}
//simple play sound function
-(void) playSnd:(NSString *) snd{
    [[SimpleAudioEngine sharedEngine]playEffect:snd];
}
//mute music button clicked
-(void)muteMusicClicked{
    
    self.musicIsOn=!self.musicIsOn;
    self.soundOnMenu.visible=self.musicIsOn;
    self.soundOffMenu.visible=!self.musicIsOn;
    
    if(self.musicIsOn){
        [[SimpleAudioEngine sharedEngine] playBackgroundMusic:@"music.wav" loop:YES];
    }
    
    else {
        [[SimpleAudioEngine sharedEngine] stopBackgroundMusic];
    }
}
//add dart to the wheel

-(void) addDartToWheel:(int) theX y:(int) theY rotation:(double) theRotation oldDart:(Dart *)od newDart:(Dart *)nd{
    CGPoint newPoint= [self.wheel.wheel convertToNodeSpace:[self convertToWorldSpace:CGPointMake(theX, theY)]];
//    NSLog(@"newpoint of x and y %f %f",newPoint.x,newPoint.y);
    int darts=(int)[[NSUserDefaults standardUserDefaults]integerForKey:@"darts"];
    if (darts<=1) {
        
        [self levelNotClearSetting];
    }
   else  if([self.wheel isHitMan:newPoint]){
        
        Dart *wDart= nd;
        wDart.position=ccp(theX,theY);
        wDart.rotation=theRotation-self.wheel.wheel.rotation;
        [self.dartsCMC addChild:wDart];
        [wDart fall];
        
        int ouchID=((int)(arc4random()%3))+1;
        [self.wheel playOuch:ouchID];
        NSString *ouchStr=[NSString stringWithFormat:@"ouch%i.wav",ouchID];
        [self playSnd:ouchStr];
        [self missOneDart];
        darts--;
       [self.lblDarts  setString:[NSString stringWithFormat:@"Darts : %i",darts]];
       [[NSUserDefaults standardUserDefaults]setInteger:darts forKey:@"darts"];
       [[NSUserDefaults standardUserDefaults]synchronize];
    }
    else if([self.wheel isMissed:newPoint]){
        
        [self playSnd:@"miss.wav"];
        Dart *wDart= nd;
        wDart.position=ccp(theX,theY);
        wDart.rotation=theRotation-self.wheel.wheel.rotation;
        [self.dartsCMC  addChild:wDart];
        [wDart fall];
       
        [self missOneDart];
        darts--;
        [self.lblDarts  setString:[NSString stringWithFormat:@"Darts : %i",darts]];
        [[NSUserDefaults standardUserDefaults]setInteger:darts forKey:@"darts"];
        [[NSUserDefaults standardUserDefaults]synchronize];
        
    }else {
        [self playSnd:@"hit.wav"];
        Dart *wDart= nd;
        wDart.endLifeFallParent=(CCSprite *)self.dartsCMC;
        [wDart playHitAction];
        wDart.position=ccp(newPoint.x,newPoint.y);
        wDart.rotation=theRotation-self.wheel.wheel.rotation;
        wDart.gameMain=self;
        [self.wheel.wheel addChild:wDart];
        [self.wheel.dartsInWheelArr addObject:wDart]; 
        
        darts--;
        [self.lblDarts  setString:[NSString stringWithFormat:@"Darts : %i",darts]];
        [[NSUserDefaults standardUserDefaults]setInteger:darts forKey:@"darts"];
        [[NSUserDefaults standardUserDefaults]synchronize];
        int scoreLevel=[self.wheel getScoreLevel:newPoint];
         
        if(scoreLevel==1){
            self.score+=100;
        }
        else if(scoreLevel==2){
            self.score+=200;
        }
        else if(scoreLevel==3){
            self.score+=400;
            [self showBonus:2 pos:ccp(theX,theY)];
        }
        else if(scoreLevel==4){
            self.score+=600;
            [self showBonus:1 pos:ccp(theX,theY)];
            self.bullseye++;
            
            [self playSnd:@"bullseye.wav"];
        }
      
      [self updateScore:self.score updateGMTexts:NO];
      BOOL checkLevelClear =  [self.wheel tryLevelUp:0.5f];
        
        if (checkLevelClear) {
            
            NSLog(@"level after clear -==-%i",[GameState sharedState].levelNumber);
            [GameState sharedState].levelNumber=[GameState sharedState].levelNumber+1;
            
            [userDefault setInteger:[GameState sharedState].levelNumber forKey:@"level"];
            //NSLog(@"UserDefault Level After level Clear =-= %i",[userDefault integerForKey:@"level"]);
            
            int level=(int)[userDefault integerForKey:@"levelClear"];
            
            if ([GameState sharedState].levelNumber>level) {
                [userDefault setInteger:[GameState sharedState].levelNumber forKey:@"levelClear"];
                [userDefault synchronize];
                //NSLog(@"UserDefault Level After level Clear =-= %i",[userDefault integerForKey:@"levelClear"]);
            }

            self.theTime=20;
            self.checkLevelClear=YES;
            
            self.gameIsOver = YES;
            
            [self showGameOver];
            [self unschedule:@selector(loop)];
            [self unschedule:@selector(updateTimeDisplay)];
        }
    }
    od.visible=NO;
    self.removeDartsNum++;
}

//update score label 

-(void) updateScore:(int)scr updateGMTexts:(BOOL) ugmt{
    
   self.scoreText.string=[NSString stringWithFormat:@"%i",scr];
}

// when a dart missed
-(void) missOneDart{
    self.life--;
    NSLog(@"Self.life %d",self.life);
    self.lifeBML.string=[NSString stringWithFormat:@"%i",self.life];
    
    if ( self.life==0) {
        [self levelNotClearSetting];
//        mainLife--;
//        if (mainLife>0) {
//            theTime=20;
//            [userDefault setInteger:mainLife forKey:@"life"];
//            [userDefault synchronize];
//        }
//        else {
//             
//        }
//        self.gameIsOver=YES;
//        [self showGameOver];
    }
}

//show game over screen (dealy)

-(void) showGameOver{
    
    [self schedule:@selector(delayForGameOver) interval:0.7f];
    [self hideAndDisplayBanner:NO];
}
//show game over screen


-(void) delayForGameOver{
    [viewHost1 removeFromSuperview];
    self.dartsCMC.visible=NO;
    [self hideLifeSprites];
    [self.wheel removeAllDatrts:NO];
    self.gameOverScreen.visible=YES;
    [self unLoadGame];
    
    [self.gameOverScreen setScore];
    [self unschedule:_cmd];
}

//ready darts , fill the dart on the bottom left side 
-(void)playDartFill{
    [self.spriteLifes stopAllActions];
    id cccf=[CCCallFunc actionWithTarget:self selector:@selector(dartReady)];
    id seq=[CCSequence actions:self.lifesAction,cccf, nil];
    [self.spriteLifes runAction:seq];
}
//dart is ready (shoot-able now )
-(void) dartReady{
    self.dartIsReady=YES;
}
//shoot dart
-(void) shoot:(CGPoint )point{
    if(self.dartIsReady==NO||self.life==0){
        return;
    }
    
        
    
    int colorID=(int)(arc4random()%4+1);
    
    Dart *dart=[[Dart alloc]initWithColorID:colorID preloadOriginalFrame:NO mayHasMissAction:NO];
    dart.xinDart=[[Dart alloc]initWithColorID:colorID preloadOriginalFrame:YES mayHasMissAction:YES];
    
    [dart playHitAction];
    dart.targetX=point.x;
    dart.targetY=point.y;
    
   
        [self.dartArr addObject:dart];
  //  NSLog(@"number of darts %d",self.dartArr.count);
    
    
    
    
    if(point.x>160){
        dart.position=ccp(320,0);
        
    }else{
        dart.position=ccp(0,0);
    }
    
    [self.dartsCMC addChild:dart];
    [dart playShootAction];
    [self playSnd:@"shoot.wav"];
    [self playDartFill];
    
    self.dartIsReady=NO;
}

//create a new game

-(void)newGame:(int)theGuy{
    [self hideAndDisplayBanner:YES];
   // int life1=(int)[[NSUserDefaults standardUserDefaults]integerForKey:@"life"];
   // if (life1<=0) {
         [self compareDate];
   // }
   
    if (self.gameOverBannerCheck) {
    if(self.wheel){
       
        [self.wheel stop];
        [self.spriteLifes stopAllActions];
        [self.dartsCMC removeAllChildrenWithCleanup:YES];
        [self.gameCMC removeChild:self.wheel cleanup:YES];
        [self.wheel release];
        [self unschedule:@selector(loop)];
    }
    self.bullseye=0;
    self.score=0;
    self.currentChoosedVictimID=theGuy;
    self.dartsCMC.visible=YES;
    self.dartIsReady=YES;
    self.removeDartsNum=0;
    self.gameCMC.visible=YES;
    self.dartArr=[[NSMutableArray alloc]init];
    self.gameIsOver=NO;
    [self showAndReSetLifeSprites];
    self.wheel=[[WheelMan alloc]initWithTheGuyID:theGuy];
   
    self.wheel.gameMain=self;
    self.wheel.position=ccp(self.stageSize.width*0.5,self.stageSize.height*0.5);
    [self.gameCMC addChild:self.wheel];
    self.scoreText.string=[NSString stringWithFormat:@"0"];
    mainLife=(int)[userDefault integerForKey:@"life"];
    self.labelLife.string=[NSString stringWithFormat:@"Life : %i",mainLife];
    [self schedule:@selector(loop) interval:1/30];
    [self schedule:@selector(updateTimeDisplay) interval:1];
    }
    
}
//touch

-(void)ccTouchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
        UITouch *touch=[touches anyObject];
        CGPoint loc=[touch locationInView:[touch view]];
        loc=[[CCDirector sharedDirector]convertToGL:loc];
    self.gameIsOver=NO;
    if(!self.gameIsOver){
    
        //shoot  a dart , when game is running
        CGPoint point=CGPointMake(loc.x, loc.y);
        [self shoot:point];
    }
}

#pragma mark
#pragma mark Extra Life Code
#pragma mark ================================

-(void)compareDate {
    
    NSString *strDate = [userDefault objectForKey:@"currentDate"];
    
    if (![strDate isEqualToString:@"0"]) {
        
        NSDate *currentDate = [NSDate date];
        
        NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
        [formatter setDateFormat:@"dd/MM/yyyy HH:mm:ss"];
        
        NSString *strCurrentDate = [formatter stringFromDate:currentDate];
        
        currentDate=[formatter dateFromString:strCurrentDate];
        
        NSDateFormatter *formatter1 = [[NSDateFormatter alloc]init];
        [formatter1 setDateFormat:@"dd/MM/yyyy HH:mm:ss"];
        
        NSDate *oldDate = [formatter1 dateFromString:strDate];
        
        unsigned int unitFlags = NSHourCalendarUnit | NSMinuteCalendarUnit | NSDayCalendarUnit | NSMonthCalendarUnit | NSSecondCalendarUnit;
        NSCalendar *gregorianCal = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
        
        NSDateComponents *conversionInfo = [gregorianCal components:unitFlags fromDate:oldDate  toDate:currentDate  options:0];
        
        //int months = (int)[conversionInfo month];
        int days = (int)[conversionInfo day];
        int hours = (int)[conversionInfo hour];
        int minutes = (int)[conversionInfo minute];
        int seconds = (int)[conversionInfo second];
        
        //NSLog(@"%d months , %d days, %d hours, %d min %d sec", months, days, hours, minutes, seconds);
        
        [self getExtraLife:days andHour:hours andMin:minutes andSec:seconds];
    }
    else{
        self.gameOverBannerCheck=YES;
        
        int levelValue = (int)[userDefault integerForKey:@"level"];
//        int life = (int)[userDefault integerForKey:@"life"];
        
        if(levelValue==0){
//            [self showLevelInfoThenGoNextLevel:@"Ready" theLevel:1 theLife:life];
        }
        else{
//            [self showLevelInfoThenGoNextLevel:@"Ready" theLevel:levelValue theLife:life];
        }
    }
}

-(void)getExtraLife :(int)day andHour:(int)hour andMin:(int)min andSec:(int)sec {
    
    int hoursInMin = hour*60;
    hoursInMin=hoursInMin+min;
    
    int totalTime = min*60+sec;
    
    int life1 = (int)[userDefault integerForKey:@"life"];
    int rem =min%5;
    
    int remTimeforLife = rem*60+sec;
    
    remTimeforLife=300-remTimeforLife;
    
    [userDefault setInteger:remTimeforLife forKey:@"timeRem"];
    [userDefault synchronize];
    
    NSString *numHints = [wrapperLife objectForKey:(__bridge id)kSecAttrLabel];
    
    int retrievedMultiArrows = [numHints intValue];
    //NSLog(@"Multiple arrow before reset -==- %d",retrievedMultiArrows);
    
    if (day>0 || hoursInMin>=25) {
        [self.labelLife setString:[NSString stringWithFormat:@"Life: 5"]];
        [userDefault setInteger:5 forKey:@"life"];
        [userDefault setObject:@"0" forKey:@"currentDate"];
    }
//    else if(totalTime>=1800){
//        int extralife =min/30;
    else if(totalTime>=300){
        int extralife =min/5;

        
        if(life1>=5){
            [self.labelLife setString:[NSString stringWithFormat:@"Life: 5"]];
            [userDefault setInteger:5 forKey:@"life"];
            [userDefault setObject:@"0" forKey:@"currentDate"];
        }
        if (life1<5) {
            if (extralife>5) {
                extralife = 5;
            }
            [self.labelLife setString:[NSString stringWithFormat:@"Life: %i",extralife]];
//            [userDefault setObject:@"0" forKey:@"currentDate"];
            [userDefault setInteger:life1 forKey:@"life"];
        }
        [userDefault synchronize];
    }
    
    if (life1>0 || retrievedMultiArrows>0) {
//        int levelValue = (int)[userDefault integerForKey:@"level"];
        [GameState sharedState].checkLife=YES;
        [GameState sharedState].checkLevelClear=NO;
        self.gameOverBannerCheck=YES;
        
//        [self showLevelInfoThenGoNextLevel:@"Ready" theLevel:levelValue theLife:life];
    }
    
    else{
        
        if (!self.gameOverBannerCheck) {
            [self unschedule:@selector(updateTimeDisplay)];
            [self showLifeOver];
        }
        else{
            [GameState sharedState].checkLife=NO;
           
                [self showNotification ];
            
        }
    }
}
-(void)showNotification{
    
    
    [[UIApplication sharedApplication]cancelAllLocalNotifications];
    UILocalNotification * notify=[[UILocalNotification alloc]init];
    NSDate *now=[NSDate date];
    
    NSDate * firedate=[now dateByAddingTimeInterval:1500];
    NSLog(@"now date %@",now);
    NSLog(@"firedate %@",firedate);
    
    notify.fireDate=firedate;
    notify.alertBody=@"WOW..! You got 5 Lives..!";
    notify.alertAction=@"See";
    
    [[NSUserDefaults standardUserDefaults]setBool:NO forKey:@"notify"];
    [[NSUserDefaults standardUserDefaults]synchronize];
    
    [[UIApplication sharedApplication]scheduleLocalNotification:notify];
}
-(void) showLifeOver {
    
    
    if(!self.lifeOverLayer){
        self.lifeOverLayer=[[LifeOver alloc]init];
        [self addChild:self.lifeOverLayer];
    }
    else{
        ((LifeOver*)self.lifeOverLayer).visible=YES;
    }
    [self hideAndDisplayBanner:NO];
}
-(void)scheduleTime {
    
    int lifeUserDefault = (int)[userDefault integerForKey:@"life"];
    
    if (lifeUserDefault<5) {
        lifeUserDefault++;
        
        [userDefault setObject:@"0" forKey:@"currentDate"];
        
        [userDefault setInteger:lifeUserDefault forKey:@"life"];
        [userDefault synchronize];
        [self.labelLife setString:[NSString stringWithFormat:@"Life: %i",lifeUserDefault]];
    }
}

// on "dealloc" you need to release all your retained objects
- (void) dealloc
{
	// in case you have something to dealloc, do it in this method
	// in this particular example nothing needs to be released.
	// cocos2d will automatically release all the children (Label)
	
	// don't forget to call "super dealloc"
    [self.gameCMC release];
    [self.wheel release];
    [self.background release];
    
	[super dealloc];
}

#pragma mark- popView

-(void) createUI{
     rootViewController = (UIViewController*)[(AppDelegate*)[[UIApplication sharedApplication] delegate] getRootViewController];
    if (self.displayRequestView) {
        self.displayRequestView=nil;
    }
   
        self.displayRequestView = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
        self.displayRequestView.backgroundColor = [UIColor blackColor];
        self.displayRequestView.alpha = 0.9f;
        [rootViewController.view addSubview:self.displayRequestView];
        
        self.containerView = [[UIView alloc] initWithFrame:CGRectMake(15, -300, 284, 278)];
        self.containerView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"Score.png"]];
        [self.displayRequestView addSubview:self.containerView];
        

        
        self.messageLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 80, 250, 60)];
        self.messageLabel.textColor = [UIColor blackColor];
        self.messageLabel.textAlignment = NSTextAlignmentCenter;
        self.messageLabel.numberOfLines = 0;
        self.messageLabel.lineBreakMode = NSLineBreakByCharWrapping;
        [self.containerView addSubview:self.messageLabel];
        
        
        //=
        self.cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
        self.cancelButton.frame = CGRectMake(20, 200, 100, 45);
        //self.cancelButton.titleLabel.textColor = [UIColor whiteColor];
        //[self.cancelButton setTitle:@"Cancel" forState:UIControlStateNormal];
        [self.cancelButton setBackgroundImage:[UIImage imageNamed:@"cancel.png"] forState:UIControlStateNormal];
        [self.cancelButton addTarget:self action:@selector(cancelButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        [self.containerView addSubview:self.cancelButton];
        //=
        self.sendButton = [UIButton buttonWithType:UIButtonTypeCustom];
        self.sendButton.frame = CGRectMake(158, 200, 100, 45);
        //        self.sendButton.titleLabel.textColor = [UIColor whiteColor];
        //        [self.sendButton setTitle:@"Send" forState:UIControlStateNormal];
        [self.sendButton setBackgroundImage:[UIImage imageNamed:@"accept.png"] forState:UIControlStateNormal];
        [self.sendButton addTarget:self action:@selector(sendButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        [self.containerView addSubview:self.sendButton];
    
    
    //self.nameLabel.text = [NSString stringWithFormat:@"Help %@",senderName];
    
   

        self.messageLabel.text = [NSString stringWithFormat:@"Do you want to refill darts?"];
   
    

    
    self.displayRequestView.hidden = NO;
    [UIView animateWithDuration:.3 animations:^{
        self.containerView.frame = CGRectMake(17, 65, 284, 278);
    }];
}

-(void)sendButtonClicked:(id)sender
{
    AppDelegate *appDelegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
    if (failVideo) {
        self.displayRequestView.hidden=YES;
        [[AppDelegate sharedAppDelegate]showToastMessage:@"Sorry no video ads available at this time"];
        // self.videoWatched=NO;
        int life2=(int)[[NSUserDefaults standardUserDefaults]integerForKey:@"life"];
        life2--;
        [[NSUserDefaults standardUserDefaults]setInteger:life2 forKey:@"life"];
        [[NSUserDefaults standardUserDefaults]synchronize];
        //failVideo=NO;
       [Chartboost showInterstitial:CBLocationStartup];
        [[CCDirector sharedDirector]resume];
        
        [self showGameOver];
    }
    else{
         self.displayRequestView.hidden=YES;
        [[NSNotificationCenter defaultCenter]postNotificationName:kReachabilityChangedNotification object:nil userInfo:nil];
        BOOL connect=[[NSUserDefaults standardUserDefaults]boolForKey:@"NetworkStatus"];
        if (!connect) {
            [[CCDirector sharedDirector]resume];
            [self showGameOver];
        }
        else{
            gm.musicIsOn=NO;
            [[SimpleAudioEngine sharedEngine] stopBackgroundMusic];
            //delegateNo=NO;
    
    
            [Chartboost showRewardedVideo:CBLocationStartup];
            [self performSelector:@selector(gontLoadVideo) withObject:nil afterDelay:5.0f];
            self.menuResume.visible=NO;
            self.menuHomePage.visible=NO;
        }
    }
}

-(void)gontLoadVideo{
    //AppDelegate *appDelegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
    if(delegateNo)
    {
        self.displayRequestView.hidden=YES;
        [[AppDelegate sharedAppDelegate]showToastMessage:@"Sorry no video ads available at this time."];
        // self.videoWatched=NO;
        int life2=(int)[[NSUserDefaults standardUserDefaults]integerForKey:@"life"];
        life2--;
        [[NSUserDefaults standardUserDefaults]setInteger:life2 forKey:@"life"];
        [[NSUserDefaults standardUserDefaults]synchronize];
       failVideo=NO;
       //
        [Chartboost showInterstitial:CBLocationStartup];
       
        [[CCDirector sharedDirector]resume];
        
        [self showGameOver];

    }
    
}
-(void)cancelButtonClicked:(id)sender{
    
     self.displayRequestView.hidden=YES;
    [[CCDirector sharedDirector] resume];
    int life1=(int)[[NSUserDefaults standardUserDefaults]integerForKey:@"life"];
    life1--;
    [[NSUserDefaults standardUserDefaults]setInteger:life1 forKey:@"life"];
    [[NSUserDefaults standardUserDefaults]synchronize];
    [Chartboost showInterstitial:CBLocationStartup];
    [self showGameOver];


}



#pragma mark -

#pragma mark-  chart boost delegate methods


- (BOOL)shouldDisplayRewardedVideo:(CBLocation)location{
    
    NSLog(@"here1");
    self.videoWatched=NO;
    failVideo=NO;
    return YES;
}

- (void)didDisplayRewardedVideo:(CBLocation)location{
    NSLog(@"here2");delegateNo=NO;
}

- (void)didCacheRewardedVideo:(CBLocation)location{
    NSLog(@"here3");
    if(self.videoWatched==YES)
    {
        self.videoWatched=YES;
    }
    else{
        self.videoWatched=NO;
        int reward;
        int darts=[[NSUserDefaults standardUserDefaults]integerForKey:@"darts"];
        if (darts>0) {
            return;
        }
        if ([GameState sharedState].levelNumber<=10) {
            reward=15;
            
        }
        else if ([GameState sharedState].levelNumber>10 &&[GameState sharedState].levelNumber<=30){
            reward=25;
        }
        else{
            reward=30;
        }
        [self.lblDarts  setString:[NSString stringWithFormat:@"Darts : %i",reward]];
        [[NSUserDefaults standardUserDefaults]setInteger:reward forKey:@"darts"];
        [[NSUserDefaults standardUserDefaults]synchronize];
       // [[CCDirector sharedDirector]resume];
        if (self.theTime==20) {
            self.theTime=20;
        }
        else{
            self.theTime=(int)[[NSUserDefaults standardUserDefaults]integerForKey:@"theTime"];
        }//[self schedule:@selector(loop) interval:1/30];
        //[self schedule:@selector(updateTimeDisplay) interval:1];
        
    }

    
}

- (void)didFailToLoadRewardedVideo:(CBLocation)location
                         withError:(CBLoadError)error{
    NSLog(@"here4");
    failVideo=YES;
    [self schedule:@selector(updateTimeDisplay) interval:1];
   /* if(self.videoWatched==YES)
    {
        self.videoWatched=YES;  int reward;
        if ([GameState sharedState].levelNumber<=10) {
            reward=15;
            
        }
        else if ([GameState sharedState].levelNumber>10 &&[GameState sharedState].levelNumber<=30){
            reward=25;
        }
        else{
            reward=30;
        }
        [self.lblDarts  setString:[NSString stringWithFormat:@"Darts : %i",reward]];
        [[NSUserDefaults standardUserDefaults]setInteger:reward forKey:@"darts"];
        [[NSUserDefaults standardUserDefaults]synchronize];
        [[CCDirector sharedDirector]resume];
        // theTime=(int)[[NSUserDefaults standardUserDefaults]integerForKey:@"theTime"];
        //[self schedule:@selector(loop) interval:1/30];
       // [self schedule:@selector(updateTimeDisplay) interval:1];
    }
    else{
        if (self.videoWatched==NO) {
            self.videoWatched=NO;
            int life2=(int)[[NSUserDefaults standardUserDefaults]integerForKey:@"life"];
            life2--;
            [[NSUserDefaults standardUserDefaults]setInteger:life2 forKey:@"Life"];
            [[NSUserDefaults standardUserDefaults]synchronize];
            [self showGameOver];
        }
       */
       /* int reward;
        if ([GameState sharedState].levelNumber<=10) {
            reward=15;
            
        }
        else if ([GameState sharedState].levelNumber>10 &&[GameState sharedState].levelNumber<=30){
            reward=25;
        }
        else{
            reward=30;
        }
        [self.lblDarts  setString:[NSString stringWithFormat:@"Darts : %i",reward]];
        [[NSUserDefaults standardUserDefaults]setInteger:reward forKey:@"darts"];
        [[NSUserDefaults standardUserDefaults]synchronize];
        [[CCDirector sharedDirector]resume];
        if (self.theTime==20) {
            self.theTime=20;
        }
        else{
       self.theTime=(int)[[NSUserDefaults standardUserDefaults]integerForKey:@"theTime"];
        }[self schedule:@selector(loop) interval:1/30];*/
        //[self schedule:@selector(updateTimeDisplay) interval:1];
        
    // self.unableLoadVideo=YES;
    // }
       
   // }
}

- (void)didDismissRewardedVideo:(CBLocation)location{
    NSLog(@"here5");
}

- (void)didCloseRewardedVideo:(CBLocation)location{
    NSLog(@"here6");
       //
    if(self.videoWatched==YES)
    {
        self.videoWatched=YES;
        
         [[CCDirector sharedDirector]resume];
        [self schedule:@selector(updateTimeDisplay) interval:1];
    
    }
    else{
        self.videoWatched=NO;
        
                 [[CCDirector sharedDirector]resume];
        int life1=(int)[[NSUserDefaults standardUserDefaults]integerForKey:@"life"];
        life1--;
        [[NSUserDefaults standardUserDefaults]setInteger:life1 forKey:@"life"];
        [[NSUserDefaults standardUserDefaults]synchronize];
         [Chartboost showInterstitial:CBLocationStartup];
        [self showGameOver];
       
        
    }
    /* not required if ([GameState sharedState].levelNumber<=10) {
     gm.numberofDarts=15;
     }
     else if ([GameState sharedState].levelNumber>10 &&[GameState sharedState].levelNumber<=30){
     gm.numberofDarts=25;
     }
     else{
     gm.numberofDarts=30;
     }
     
     gm.gameOverBannerCheck=YES;
     gm.gameIsOver=NO;
     gm.currentChoosedVictimID=[GameState sharedState].victimId;
     NSLog(@"gm.VictimID %d",[GameState sharedState].victimId);
     int victim=1;
     [gm newGame:victim];*/
}

- (void)didClickRewardedVideo:(CBLocation)location{
    NSLog(@"here7");
}



- (void)didCacheInPlay:(CBLocation)location{
    NSLog(@"here8");
}

- (void)didFailToLoadInPlay:(CBLocation)location
                  withError:(CBLoadError)error{
    NSLog(@"here9");
}

- (void)willDisplayVideo:(CBLocation)location{
    NSLog(@"here10");
}

- (void)didCompleteRewardedVideo:(CBLocation)location
                      withReward:(int)reward{
    // if (self.count==0) {
    failVideo=NO;
    delegateNo=NO;
    if ([GameState sharedState].levelNumber<=10) {
        reward=15;
        
    }
    else if ([GameState sharedState].levelNumber>10 &&[GameState sharedState].levelNumber<=30){
        reward=25;
    }
    else{
        reward=30;
    }
    [self.lblDarts  setString:[NSString stringWithFormat:@"Darts : %i",reward]];
    [[NSUserDefaults standardUserDefaults]setInteger:reward forKey:@"darts"];
    [[NSUserDefaults standardUserDefaults]synchronize];
    //}
    NSLog(@"watched");
    self.videoWatched=YES;
    
    
}

- (void)didCloseInterstitial:(CBLocation)location
{
    NSLog(@"Interstial add");
    //[[CCDirector sharedDirector]resume];
}



@end
