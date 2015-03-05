//
//  GameOverScreen.m
//  DartWheel
//
//  Created by tang on 12-7-28.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "GameOverScreen.h"
#import "cocos2d.h"
#import "GameMain.h"
#import "GameState.h"
#import "AppDelegate.h"
#import "LifeOver.h"
#import "UIImageView+WebCache.h"
#import "SimpleAudioEngine.h"
#import <Chartboost/Chartboost.h>
#import "LevelSelectionScene.h"
#import <sqlite3.h>

#define ShareToFacebook @"FacebookShare"

CGSize ws;

@implementation GameOverScreen

@synthesize background;

@synthesize playAgainMI,playAgainButton,pasp1,pasp2,cvsp1,cvsp2,chooseVictimMI,chooseVictimButton,gameMain,text1,text2,text3,text4,matchScore,LevelScore,score,toTalscore,num,menuBack,LevelCompletion,wheel;
@synthesize topview,bottomview1,backgroundView,play,cancel,level1,lblNewScore;

// on "init" you need to initialize your instance
-(id)init
{
    if( (self=[super init])) {
         appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
        rootViewControl=  (UIViewController*)[(AppDelegate*)[[UIApplication sharedApplication] delegate] getRootViewController];
        
        //*********** Add abMob banner
       
//        rootViewController = (UIViewController*)[(AppDelegate*)[[UIApplication sharedApplication] delegate] getRootViewController];
//        adf = [[AdMobFullScreenViewController alloc]init];
//        [rootViewController presentViewController:adf animated:YES completion:nil];

        
     
        
        // not live
        /*   [Chartboost startWithAppId:@"54a6a79804b0160e56ced5fa"
         appSignature:@"8e3ae764dbe498705c7cf82d053ebccf8f1f61d4"
         delegate:self];;*/

       //Live
       /* [Chartboost startWithAppId:@"54870c31c909a668589390f5"
                      appSignature:@"b5d7759d477fc9f7ded8b5b9b37890dbb08ff309"
                          delegate:self];*/
        
        /************** chart boost*/////////////////
        
        
        
                //create background
        CGSize ws=[[CCDirector sharedDirector]winSize];
        userDefault = [NSUserDefaults standardUserDefaults];
        
        if ([UIScreen mainScreen].bounds.size.height>500) {
            self.background=[CCSprite spriteWithFile:@"gameover_i5.png"];
        }
        else {
            self.background=[CCSprite spriteWithFile:@"gamover_i4.png"];
        }
        
        self.background.position=ccp(ws.width/2, ws.height/2);
        [self addChild:self.background];
        
        CCSprite *spriteBackgroundScore = [CCSprite spriteWithFile:@"Score.png"];
        
        if ([UIScreen mainScreen].bounds.size.height>500) {
            spriteBackgroundScore.position=ccp(ws.width/2, ws.height-225);
        }
        else {
            spriteBackgroundScore.position=ccp(ws.width/2, ws.height-205);
        }
        
        [self.background addChild:spriteBackgroundScore];
        
        //Rajeev
        ws=[[CCDirector sharedDirector]winSize];
        
        self.strPostMessage=[[NSString alloc]init];
        self.levelCompletionText=[[NSString alloc]init];
        
        //self.shareBtnImage=[CCMenuItemImage itemFromNormalImage:@"share.png" selectedImage:@"share.png"];
//        self.shareBtnImage = [CCMenuItemImage itemFromNormalImage:@"share.png" selectedImage:@"share.png" target:self selector:@selector(facebookBtnClick)];
//        //self.shareBtnImage.position=ccp(ws.width/2-70, 90);
//        //[self addChild:self.shareBtnImage];
//        self.shareBtnImage.visible=NO;
//        
//        self.shareButtons=[CCMenu menuWithItems:self.shareBtnImage, nil];
//        self.shareButtons.position=ccp(ws.width/2-70, 90);
//        [self.shareButtons alignItemsHorizontally];
//        //[self addChild:self.shareButtons];
//        [self.shareButtons setVisible:NO];
        
        
        /*self.shareOnFb=[CCMenuItemImage itemFromNormalImage:@"facebooknew.png" selectedImage:@"facebooknew.png" target:self selector:@selector(facebookBtnClick)];
         
         self.shareButtons=[CCMenu menuWithItems:self.shareOnFb, nil];
         self.shareButtons.position=ccp(ws.width/2, 95);
         [self.shareButtons alignItemsHorizontally];
         [self addChild:self.shareButtons];
         [self.shareButtons setVisible:NO];*/
        
        // Rajeev
       
        
        
 
        
       // self.num=1;
        self.playMI=[CCMenuItemImage itemFromNormalImage:@"next.png" selectedImage:@"next.png" target:self  selector:@selector(nextButtonClicked)];
        
        self.playAgainButton=[CCMenu menuWithItems:self.playMI, nil];
        self.playAgainButton.position=ccp(ws.width-50,105);
        [self addChild:playAgainButton];
        
       
       
        
        self.LevelCompletion=[CCMenuItemImage itemFromNormalImage:@"level_completed.png" selectedImage:@"level_completed.png"];
       levelcomplete=[CCMenu menuWithItems:self.LevelCompletion, nil];
        if([UIScreen mainScreen].bounds.size.height>500)
        {
            levelcomplete.position=ccp(ws.width-145,530);

        }
        else
        {
            levelcomplete.position=ccp(ws.width-150,460);
        }
        [self addChild:levelcomplete];

        
        matchScore = [CCSprite spriteWithFile:@"matchscore.png"];
        self.matchScore.visible=YES;
        [self addChild:matchScore];
        
       LevelScore = [CCSprite spriteWithFile:@"levelbonus.png"];
        self.LevelScore.visible=YES;
        [self addChild:LevelScore];
        
        score = [CCSprite spriteWithFile:@"bullseye.png"];
        self.score.visible=YES;
        [self addChild:score];
        
        toTalscore = [CCSprite spriteWithFile:@"totalscore.png"];
        self.toTalscore.visible=YES;
        [self addChild:toTalscore];
        
        self.text1=[CCLabelTTF labelWithString:@"9999999" fontName:@"TerrorPro" fontSize:20];
        self.text2=[CCLabelTTF labelWithString:@"9999999" fontName:@"TerrorPro" fontSize:20];
        self.text3=[CCLabelTTF labelWithString:@"9999999" fontName:@"TerrorPro" fontSize:20];
        self.text4=[CCLabelTTF labelWithString:@"9999999" fontName:@"TerrorPro" fontSize:25];
        
       // NSString * levelClear=[NSString stringWithFormat:@"Level %i completed",[GameState sharedState].levelNumber-1];
        //self.lifeBML=[CCLabelTTF labelWithString:@"0" fontName:@"frank-highlight-1361541867.ttf" fontSize:35];
       
      /*  ccColor3B color=  {65.0 / 255.0f, 65.0 / 255.0f, 6.0 / 255.0f};
         self.lifeBML.color=color;
        if([UIScreen mainScreen].bounds.size.height>500){
            self.lifeBML.position=ccp(160, 510);
        }
        else{
            self.lifeBML.position=ccp(160, 450);
        }
        [self addChild:self.lifeBML];*/
        
        /********************/
       /* UIColor *strokeColor = [UIColor colorWithRed:(CGFloat)214/255 green:(CGFloat)120/255  blue:(CGFloat)7/255  alpha:1];
        UIColor *textColor = [UIColor whiteColor];
        UIFont *textFont = [UIFont fontWithName:@"TerrorPro" size:22];
        //UIFont *f1 = [UIFont boldSystemFontOfSize:35];
        NSNumber *w = [NSNumber numberWithFloat:-3.0f];
        NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:strokeColor,NSStrokeColorAttributeName,textColor,NSForegroundColorAttributeName,textFont,NSFontAttributeName,w,NSStrokeWidthAttributeName, nil];
        
        
        NSAttributedString *attStr = [[NSAttributedString alloc] initWithString:self.text1 attributes:dict];
       // [self.text1 setAttributedTitle:attStr forState:UIControlStateNormal];
        self.text1.*/
       /**************************/
        
        CCMenuItem *menuItemBack = [CCMenuItemImage itemFromNormalImage:@"backLevel.png" selectedImage:@"backLevel.png" target:self selector:@selector(back:)];
        
        menuBack = [CCMenu menuWithItems: menuItemBack, nil];
        if([UIScreen mainScreen].bounds.size.height>500){
            menuBack.position = ccp(40, ws.height-70);
        }
        else{
            menuBack.position = ccp(40, ws.height-50);
        }
        [menuBack alignItemsHorizontally];
        [self addChild:menuBack z:100];
        
        
        
        self.text1.color=ccBLACK;
        self.text2.color=ccBLACK;
        self.text3.color=ccBLACK;
        self.text4.color=ccBLACK;
//        self.text1.scale=0.7;
//        self.text2.scale=0.7;
//        self.text3.scale=0.7;
//        self.text4.scale=0.7;
        self.text1.anchorPoint=self.text2.anchorPoint=self.text3.anchorPoint=ccp(1,0);
        
        if([UIScreen mainScreen].bounds.size.height>500){
            
            matchScore.position=ccp(125,410);
            LevelScore.position=ccp(125,380);
            score.position=ccp(128,340);
            toTalscore.position=ccp(150,300);
            self.text1.position=ccp(280,400);
            self.text2.position=ccp(280,370);
            self.text3.position=ccp(280,330);
            
            self.text4.position=ccp(160,250);
            
        }else{
            matchScore.position=ccp(115,350);
            LevelScore.position=ccp(110,320);
            score.position=ccp(128,280);
            toTalscore.position=ccp(160,240);
            self.text1.position=ccp(275,340);
            self.text2.position=ccp(275,310);
            self.text3.position=ccp(275,270);
            self.text4.position=ccp(160,205);
        }
        
       
        [self addChild:self.text1];
        [self addChild:self.text2];
        [self addChild:self.text3];
        [self addChild:self.text4];
    }
     return self;
}




// Rajeev

//-(void)playAgianButtonClicked:(id)sender {
//   [self playButtonClicked];
//}

-(void)playButtonClicked {
    gm.theTime=20;
    
    RevMobFullscreen *ad = [[RevMobAds session] fullscreen]; // you must retain this object
    [ad loadWithSuccessHandler:^(RevMobFullscreen *fs) {
        [fs showAd];
        //NSLog(@"Ad loaded Revmob");
        [[CCDirector sharedDirector] pause];
    } andLoadFailHandler:^(RevMobFullscreen *fs, NSError *error) {
        NSLog(@"Ad error Revmob: %@",error);
    } onClickHandler:^{
        //NSLog(@"Ad clicked Revmob");
    } onCloseHandler:^{
        //NSLog(@"Ad closed Revmob");
        [[CCDirector sharedDirector] resume];
    }];
 // [viewHost1 removeFromSuperview];
    
    int lifeUserDefault = (int)[userDefault integerForKey:@"life"];
    
    if (lifeUserDefault>0) {
        [self removeChild:self.spriteBackground cleanup:YES];
       // [self removeChild:self.lblPOsition cleanup:YES];
        [self removeChild:self.menuNextLevel cleanup:YES];
     //   [self removeChild:self.lblHeader cleanup:YES];
       // [self removeChild:self.lblFbBeatFrnd cleanup:YES];
        self.backgroundView.hidden=YES;
        if (gm.checkLevelClear)
        {
            
          
            NSLog(@"LIFe in playbutton  GOver %d",lifeUserDefault);
           
          [[CCDirector sharedDirector]replaceScene:[LevelSelectionScene node]];
           // [gm newGame:gm.currentChoosedVictimID];
                    }
        else{
             [[NSNotificationCenter defaultCenter]postNotificationName:kReachabilityChangedNotification object:nil];
            BOOL  check=[[NSUserDefaults standardUserDefaults]boolForKey:@"NetworkStatus"];
            if (check) {
                int darts;
                if ([GameState sharedState].levelNumber<=10) {
                    darts=15;
                }
                else if([GameState sharedState].levelNumber>10&& [GameState sharedState].levelNumber<=30)
                {
                    darts=25;
                }
                else {
                    darts=30;
                }
                [[NSUserDefaults standardUserDefaults]setInteger:darts forKey:@"darts"];
                [[NSUserDefaults standardUserDefaults]synchronize];
                [ gm.lblDarts setString:[NSString stringWithFormat:@"Darts : %i",darts]];
                [gm newGame:gm.currentChoosedVictimID];
            }

            else
            {
            int darts;
            if ([GameState sharedState].levelNumber<=10) {
                darts=15;
            }
            else if([GameState sharedState].levelNumber>10&& [GameState sharedState].levelNumber<=30)
            {
                darts=25;
            }
            else {
                darts=30;
            }
            [[NSUserDefaults standardUserDefaults]setInteger:darts forKey:@"darts"];
            [[NSUserDefaults standardUserDefaults]synchronize];
            [ gm.lblDarts setString:[NSString stringWithFormat:@"Darts : %i",darts]];
             [gm newGame:gm.currentChoosedVictimID];
            }
        }
        self.visible=NO;
    }

    else{
        NSLog(@"No life Get extra Lifes");
        //[self removeChild:menuBack cleanup:YES];
        [menuBack removeFromParentAndCleanup:YES];
         self.backgroundView.hidden=YES;
        [self showLifeOver];
       
    }
}
-(void) showLifeOver {
//    [self removeChild:c cleanup:YES];
    if(!self.lifeOverLayer){
        self.lifeOverLayer=[[LifeOver alloc]init];
        [self addChild:self.lifeOverLayer];
    }
    else{
        ((LifeOver*)self.lifeOverLayer).visible=YES;
    }
}
-(void)facebookBtnClick {
    [Chartboost showInterstitial:CBLocationStartup];
    
    NSLog(@"Facebook share Button Clicked...");
     [[NSNotificationCenter defaultCenter]postNotificationName:kReachabilityChangedNotification object:nil];
    BOOL connect=[[NSUserDefaults standardUserDefaults]boolForKey:@"NetworkStatus"];
    if (connect==NO) {
        UIAlertView *alert =[[UIAlertView alloc] initWithTitle:@"There is no Internet Connection in your device" message:@"Check Internet Connection First" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
        return;
    }
    // [Chartboost showInterstitial:CBLocationStartup];
    self.strPostMessage = [NSString stringWithFormat:@"Completed Level %i  with  score %i.!Hi Friends, Please join me in Dart Wheel Chief. Select from 3 funny characters and try to avoid them with your darts hitting on the targets. Lets see who can get a bulls eye!.",[GameState sharedState].levelNumber-1,totalScore];
    NSLog(@"Messaga == %@",self.strPostMessage);
    NSString *strLife = [NSString stringWithFormat:@"Level %d",[GameState sharedState].levelNumber-1];
    
    /*  NSMutableDictionary *params =
     [NSMutableDictionary dictionaryWithObjectsAndKeys:
     self.strPostMessage, @"description", strLife, @"caption",
     @"https://globussoft.com", @"link",@"Dart Wheel",@"name",
     @"http://i.imgur.com/zhNdgpi.png?1",@"picture",
     nil];*/
    NSMutableDictionary *params =
    [NSMutableDictionary dictionaryWithObjectsAndKeys:
     self.strPostMessage, @"description", strLife, @"caption",
     @"https://itunes.apple.com/app/id892026202", @"link",@"Dart Wheel",@"name",
     @"http://i.imgur.com/zhNdgpi.png?1",@"picture",
     nil];
    
    
    
    NSDictionary *storyDict = [NSDictionary dictionaryWithObjectsAndKeys:@"level",FacebookType,[NSString stringWithFormat:@"Completed %@",strLife],FacebookTitle,self.strPostMessage,FacebookDescription,@"complete",FacebookActionType, nil];
    
    appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    // appDelegate.openGraphDict = storyDict;
    appDelegate.delegate = nil;
    BOOL fbconnect=[[NSUserDefaults standardUserDefaults]boolForKey:FacebookConnected];
    if (fbconnect) {
        if (FBSession.activeSession.isOpen) {
            
            [appDelegate shareOnFacebookWithParams:params];
            
        }
        else{
            //        [appDelegate shareOnFacebookWithParams:params];
            // [[NSUserDefaults standardUserDefaults]setBool:NO forKey:FacebookConnected];
            // [[NSUserDefaults standardUserDefaults]synchronize];
            [appDelegate openSessionWithLoginUI:1 withParams:params];
        }
    }
    

    
    
    
    
//else
//{
//    //[[NSUserDefaults standardUserDefaults]setBool:NO forKey:FacebookConnected];
//    //[[NSUserDefaults standardUserDefaults]synchronize];
//   // [appDelegate openSessionWithLoginUI:1 withParams:params];
//    
//}


   /* //if (self.lblFbFirstName)
    if(if_beated){
       // [self scheduleOnce:@selector(beatFriendStoryPost) delay:1.2];
        
        [self schedule:@selector(beatFriendStoryPost) interval:1.2];
       
    }
    
    if(isNewHighScore == YES){
        //[self scheduleOnce:@selector(newHighScoreStoryPost) delay:1.2];
        [self schedule:@selector(newHighScoreStoryPost) interval:1.2];
    }*/
 
}

#pragma mark-  story post

-(void)storypostMethod{
    NSLog(@"Facebook share Button Clicked...");
   /* BOOL connect=[[NSUserDefaults standardUserDefaults]boolForKey:@"NetworkStatus"];
    if (connect==NO) {
        UIAlertView *alert =[[UIAlertView alloc] initWithTitle:@"There is no Internet Connection in your device" message:@"Check Internet Connection First" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
        return;
    }*/
    
    //self.strPostMessage = [NSString stringWithFormat:@"Completed Level %i  with  score %i!",[GameState sharedState].levelNumber-1,totalScore];
    
  /*  self.strPostMessage = [NSString stringWithFormat:@"Completed Level %i  with  score %i! ",[GameState sharedState].levelNumber-1,totalScore];
    NSLog(@"Messaga == %@",self.strPostMessage);
    NSString *strLife = [NSString stringWithFormat:@"Level %d",[GameState sharedState].levelNumber-1];
    appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
   
    appDelegate.delegate = nil;
    
    NSMutableDictionary *params =
    [NSMutableDictionary dictionaryWithObjectsAndKeys:
     self.strPostMessage, @"description", @"", @"caption",
     @"https://itunes.apple.com/app/id892026202", @"link",@"Dart Wheel",@"name",
     @"http://i.imgur.com/zhNdgpi.png?1",@"picture",
     nil];
    
    BOOL fbconnect=[[NSUserDefaults standardUserDefaults]boolForKey:FacebookConnected];
    if (fbconnect) {
    if (FBSession.activeSession.isOpen) {
    
        [appDelegate shareOnFacebookWithParams:params];
    }
     else{
     
         [appDelegate openSessionWithLoginUI:1 withParams:params];
     }
 }*/
   
    if (if_completed) {
        
       
        
        /*  NSMutableDictionary *params =
         [NSMutableDictionary dictionaryWithObjectsAndKeys:
         self.strPostMessage, @"description", strLife, @"caption",
         @"https://globussoft.com", @"link",@"Dart Wheel",@"name",
         @"http://i.imgur.com/zhNdgpi.png?1",@"picture",
         nil];*/
        
        self.strPostMessage = [NSString stringWithFormat:@"Completed Level %i  with  score %i.!Dart Wheel Chief is a unique game, it gives a sense of freshness every time you play it.Throw the darts at target and Beat my score!!!!" "Try it up"".",[GameState sharedState].levelNumber-1,totalScore];
        NSString *strLife = [NSString stringWithFormat:@"Level %d",[GameState sharedState].levelNumber-1];
      //  [NSString stringWithFormat:@" %@",strLife]
        
        NSDictionary *storyDict = [NSDictionary dictionaryWithObjectsAndKeys:@"level",FacebookType,@"",FacebookTitle,self.strPostMessage,FacebookDescription,@"complete",FacebookActionType, nil];
         appDelegate.openGraphDict = storyDict;
       
        
        [appDelegate storyPostwithDictionary:storyDict];
    }
    
     
     //if (self.lblFbFirstName)
     if(if_beated){
     // [self scheduleOnce:@selector(beatFriendStoryPost) delay:1.2];
         
         if (if_beated==YES) {
             
             //[self schedule:@selector(beatFriendStoryPost) interval:1.2];
             
             // Set channel
             /*
              NSDictionary *data = [NSDictionary dictionaryWithObjectsAndKeys:
              @"I beat you in this level!", @"alert",
              @"Increment", @"badge",
              @"cheering.caf", @"sound",
              nil];
              */
            
             //        [self beatFriendStoryPostOnWall];
             
         }
         
         
         
     
     [self schedule:@selector(beatFriendStoryPost) interval:1.2];
     
     }
     
     if(isNewHighScore == YES){
     //[self scheduleOnce:@selector(newHighScoreStoryPost) delay:1.2];
     [self schedule:@selector(newHighScoreStoryPost) interval:1.2];
     }
}
-(void) newHighScoreStoryPost{
    [self unschedule:@selector(newHighScoreStoryPost)];
   // NSString *title = [NSString stringWithFormat:@"new highscore %@",self.scoreText.string];
    NSString *title = [NSString stringWithFormat:@"New highscore %d",totalScore];
  //  NSString *description = [NSString stringWithFormat:@"Hey I got new highscore %@ in level %d",self.scoreText.string,[GameState sharedState].levelNumber-1];
     NSString *description = [NSString stringWithFormat:@"Hey..! I got new highscore %d in level %d.Dart Wheel Chief is a unique game, it gives a sense of freshness every time you play it.Throw the darts at target and Beat my score!!!!" "Try it up"".",totalScore,[GameState sharedState].levelNumber-1];
    
    NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:@"highscore",FacebookType,title,FacebookTitle,description,FacebookDescription,@"set",FacebookActionType, nil];
    
    appDelegate.openGraphDict = dict;
    
    [appDelegate storyPostwithDictionary:dict];
}
-(void) beatFriendStoryPost{
    
    [self unschedule:@selector(beatFriendStoryPost)];
    NSString *title = [NSString stringWithFormat:@"%@ ",self.lblFbFirstName];
    
    //NSString *description = [NSString stringWithFormat:@"%@ at level %d and made score %@!",title,[GameState sharedState].levelNumber-1,self.scoreText.string];
    NSString *description = [NSString stringWithFormat:@"Beat %@ at level %d and made score %d!.Dart Wheel Chief is a unique game, it gives a sense of freshness every time you play it.Throw the darts at target and Beat my score!!!!" "Try it up"".",title,[GameState sharedState].levelNumber-1,totalScore];
    
    NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:@"friend",FacebookType,@"",FacebookTitle,description,FacebookDescription,@"Beat",FacebookActionType, nil];
    
    
    
    
    
    appDelegate.openGraphDict = dict;
    [appDelegate storyPostwithDictionary:dict];
}

//set score2

-(void)setScore{
    
    if (adm) {
        adm=nil;
    }
    adm = [[AdMobViewController alloc]init];
    if([UIScreen mainScreen].bounds.size.height>500)
    {
        adm.frame =CGRectMake(0, 520, 320, 50);
    }
    else{
        adm.frame =CGRectMake(0, 430, 320, 50);
    }
    viewHost1 = adm.view;
    [[[CCDirector sharedDirector] openGLView] addSubview:viewHost1];
      [Chartboost showInterstitial:CBLocationStartup];
   /* BOOL connect=[[NSUserDefaults standardUserDefaults]boolForKey:@"NetworkStatus"];
    if(connect)
    {
        [[NSUserDefaults standardUserDefaults]setInteger:0 forKey:@"darts"];
        [[NSUserDefaults standardUserDefaults]synchronize];
        int life=(int)[[NSUserDefaults standardUserDefaults]integerForKey:@"life"];
        int darts=(int)[[NSUserDefaults standardUserDefaults]integerForKey:@"darts"];
        if (life<=0) {
            [[CCDirector sharedDirector]replaceScene:[LifeOver node]];
        }
       else if (darts<=0) {
            gm.musicIsOn=NO;
           [[SimpleAudioEngine sharedEngine] stopBackgroundMusic];
            UIAlertView * alert=[[UIAlertView alloc]initWithTitle:@"You do not have enough darts."  message:@"Watch video for darts" delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
            [alert show];
            //[Chartboost showRewardedVideo:CBLocationStartup];
            //[gm newGame:gm.currentChoosedVictimID];
        }
        else if (gm.checkLevelClear==NO)
        {
            [[CCDirector sharedDirector]replaceScene:[LevelSelectionScene node]];
        }
    }
   */
    
    gm=(GameMain*)self.gameMain;
        
    self.text1.string=gm.scoreText.string;
    NSLog(@"Score Text -==- %@",gm.scoreText.string);
    //    int levelBonus=(gm.wheel.currentLevel-1)*4000;
    int levelBonus;
    if(gm.checkLevelClear)
    {
    levelBonus=([GameState sharedState].levelNumber-1)*4000;
    self.text2.string=[NSString stringWithFormat:@"%i",levelBonus];
    }
    else{
        levelBonus=0;
        self.text2.string=[NSString stringWithFormat:@"%i",levelBonus];
    }
    int bullseyeBonus=gm.bullseye*500;
    self.text3.string=[NSString stringWithFormat:@"%i",bullseyeBonus];
    totalScore=levelBonus+gm.score+bullseyeBonus;
    self.text4.string=[NSString stringWithFormat:@"%i",totalScore];
    
   // NSUInteger position=self.mutArrScores.count;
    if (gm.checkLevelClear) {
        BOOL fbconnect=[[NSUserDefaults standardUserDefaults]boolForKey:FacebookConnected];
         [[NSNotificationCenter defaultCenter]postNotificationName:kReachabilityChangedNotification object:nil];
        BOOL netWorkCheck=[[NSUserDefaults standardUserDefaults]boolForKey:@"NetworkStatus"];
        NSString * connectFBId=[[NSUserDefaults standardUserDefaults]objectForKey:ConnectedFacebookUserID];
        if (netWorkCheck) {
            if(fbconnect)
            {
                [self saveScoreToParse:totalScore forLevel:[GameState sharedState].levelNumber-1 bullsEyes:gm.bullseye];
            }
        
        else  if(!connectFBId)
        {
            [self retriveScoreSqlite:totalScore withLevel:[GameState sharedState].levelNumber-1 bullsEyes:gm.bullseye];
        }
        else{
            [self saveScoreToParse:totalScore forLevel:[GameState sharedState].levelNumber-1 bullsEyes:gm.bullseye];
        }
    }
        else{
             [self retriveScoreSqlite:totalScore withLevel:[GameState sharedState].levelNumber-1 bullsEyes:gm.bullseye];
        }
       // NSString * levelClear=[NSString stringWithFormat:@"Level %i completed",[GameState sharedState].levelNumber];
       // self.lifeBML.string=levelClear;
        
        [self.LevelCompletion setNormalImage:[CCSprite spriteWithFile:@"level_completed.png"]];
        [self.LevelCompletion setSelectedImage:[CCSprite spriteWithFile:@"level_completed.png"]];
        [self.playMI setNormalImage:[CCSprite spriteWithFile:@"next.png"]];
        [self.playMI setSelectedImage:[CCSprite spriteWithFile:@"next.png"]];
        
        // [self.shareButtons setVisible:YES];
        //        self.shareText.visible=YES;
        // self.shareBtnImage.visible=YES;
        
    }
    else{
        //self.shareButtons.visible=NO;
        //self.shareBtnImage.visible=NO;
        
       // NSString * levelClear=[NSString stringWithFormat:@"Level %i not completed",[GameState sharedState].levelNumber];
        //self.lifeBML=[CCLabelTTF labelWithString:levelClear fontName:@"frank-highlight-1361541867.ttf" fontSize:45];
       // self.lifeBML.string=levelClear;
        
//        if([UIScreen mainScreen].bounds.size.height>500){
//            self.lifeBML.position=ccp(60, 510);
//        }
//        else{
//            self.lifeBML.position=ccp(60, 410);
//        }

        [self.LevelCompletion setNormalImage:[CCSprite spriteWithFile:@"level_not_completed.png"]];
        [self.LevelCompletion setSelectedImage:[CCSprite spriteWithFile:@"level_not_completed.png"]];
        
        [self.playMI setNormalImage:[CCSprite spriteWithFile:@"retry.png"]];
        [self.playMI setSelectedImage:[CCSprite spriteWithFile:@"retry.png"]];
       

    }
}

-(void)lblDisplayOnUI{
    self.lblHeader=[[UILabel alloc]init];
    self.lblFbBeatFrnd=[[UILabel alloc]init];
    self.lblNewScore=[[UILabel alloc]init];
    NSUInteger position=self.mutArrScores.count;
    
    if([UIScreen mainScreen].bounds.size.height<500){
        
        
        if(isNewHighScore == YES){
            NSLog(@"You set a new high score");
            
            
            NSString *str=[NSString stringWithFormat:@"New highest score "];
            self.lblHeader.text=str;
            self.lblNewScore.text=[NSString stringWithFormat:@"%d",totalScore];
            self.lblNewScore.backgroundColor=[UIColor clearColor];
            self.lblNewScore.font=[UIFont fontWithName:@"LittleLordFontleroyNF" size:35];
            self.lblHeader.backgroundColor = [UIColor clearColor];
            self.lblHeader.lineBreakMode = NSLineBreakByCharWrapping;
            
            self.lblHeader.font=[UIFont fontWithName:@"LittleLordFontleroyNF" size:40];
            [self.lblHeader setTextColor:[UIColor blackColor]];
            [self.lblHeader sizeToFit];
            
            if ([UIScreen mainScreen].bounds.size.height>500) {
                
                self.lblHeader.frame=CGRectMake(40, 150, 200, 40);
                
            }
            else {
                self.lblHeader.frame=CGRectMake(30, 105, 200, 40);
                self.lblNewScore.frame=CGRectMake(110, 130, 150, 40);
            }
          
        }
        else{
            //                               NSLog(@"You beat your friend, facebook id is== %@",fbID);
            position++;
            
             NSString *strH=[NSString stringWithFormat:@"Your Score is %d",totalScore];
            self.lblHeader.text=strH;
            self.lblHeader.font=[UIFont fontWithName:@"LittleLordFontleroyNF" size:35];
            self.lblHeader.backgroundColor = [UIColor clearColor];
            [self.lblHeader setTextColor:[UIColor blackColor]];
             self.lblHeader.lineBreakMode = NSLineBreakByCharWrapping;
            [self.lblHeader sizeToFit];
            if ([UIScreen mainScreen].bounds.size.height>500) {
                
                self.lblHeader.frame=CGRectMake(40, 150, 200, 40);
                }
            else{
                
                self.lblHeader.frame=CGRectMake(30, 120, 200, 40);
               
            }
            
        }
        if (if_beated) {
            
            NSString * str=[NSString stringWithFormat:@"You beat %@",self.lblFbFirstName];
            self.lblFbBeatFrnd.text=str;
            self.lblFbBeatFrnd .numberOfLines = 0;
            self.lblFbBeatFrnd.lineBreakMode = NSLineBreakByCharWrapping;
            self.lblFbBeatFrnd.font=[UIFont fontWithName:@"LittleLordFontleroyNF" size:27];
            self.lblFbBeatFrnd.frame=CGRectMake(20, 180, 220, 40);
            self.lblFbBeatFrnd.backgroundColor = [UIColor clearColor];
            self.lblFbBeatFrnd.lineBreakMode = NSLineBreakByCharWrapping;
            [self.lblFbBeatFrnd sizeToFit];
            [self.topview addSubview:self.lblFbBeatFrnd];
            
        }

    }
    else{
        
        if(isNewHighScore == YES){
            NSLog(@"You set a new high score in else");
            NSString *str=[NSString stringWithFormat:@"New highest score"];
            self.lblHeader.text=str;
            self.lblNewScore.text=[NSString stringWithFormat:@"%d",totalScore];
            self.lblNewScore.backgroundColor=[UIColor clearColor];
            [self.lblNewScore setTextColor:[UIColor blackColor]];
            self.lblNewScore.font=[UIFont fontWithName:@"LittleLordFontleroyNF" size:35];
            self.lblHeader.font=[UIFont fontWithName:@"LittleLordFontleroyNF" size:40];
            [self.lblHeader setTextColor:[UIColor blackColor]];
            self.lblHeader.lineBreakMode = NSLineBreakByCharWrapping;
            [self.lblHeader sizeToFit];
            self.lblHeader.backgroundColor = [UIColor clearColor];
            
            if ([UIScreen mainScreen].bounds.size.height>500) {
                
                self.lblHeader.frame=CGRectMake(40, 120, 200, 40);
                self.lblNewScore.frame=CGRectMake(110, 145, 150, 40);
            }
            else {
                self.lblHeader.frame=CGRectMake(40, 120, 200, 40);
               
            }
           

        }
        
        else{
            //                               NSLog(@"You beat your friend, facebook id is== %@",fbID);
            position++;
            
            
            NSString *strH=[NSString stringWithFormat:@"Your Score is %d",totalScore];
            self.lblHeader.text=strH;
            self.lblHeader.font=[UIFont fontWithName:@"LittleLordFontleroyNF" size:35];
            [self.lblHeader setTextColor:[UIColor blackColor]];
            self.lblHeader.backgroundColor = [UIColor clearColor];
            self.lblHeader.lineBreakMode = NSLineBreakByCharWrapping;
            [self.lblHeader sizeToFit];
            if ([UIScreen mainScreen].bounds.size.height>500) {
                
                self.lblHeader.frame=CGRectMake(30, 120, 200, 40);
            }
            else {
                
                self.lblHeader.frame=CGRectMake(40, 120, 200, 40);
            }
           
        }
        if (if_beated) {
            
            NSString * str=[NSString stringWithFormat:@"You beat %@",self.lblFbFirstName];
            self.lblFbBeatFrnd.text=str;
            self.lblFbBeatFrnd .numberOfLines = 0;
            self.lblFbBeatFrnd.lineBreakMode = NSLineBreakByCharWrapping;
            [self.lblFbBeatFrnd sizeToFit];
            self.lblFbBeatFrnd.font=[UIFont fontWithName:@"LittleLordFontleroyNF" size:27];
            self.lblFbBeatFrnd.frame=CGRectMake(20, 170, 220, 40);
            self.lblFbBeatFrnd.backgroundColor = [UIColor clearColor];
            [self.topview addSubview:self.lblFbBeatFrnd];
        }
    }
    
    [self.topview addSubview:self.lblHeader];
    [self.topview addSubview:self.lblNewScore];
    

}

#pragma mark -
#pragma mark create UI
- (void) createUIBg{
    
    [viewHost1 removeFromSuperview];
    CGRect frame = [UIScreen mainScreen].bounds;
    if (!self.backgroundView) {
        //self.backgroundView=[[UIView alloc]init];
        self.backgroundView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
       // self.backgroundView.backgroundColor = [UIColor colorWithRed:(CGFloat)155/255 green:(CGFloat)155/255 blue:(CGFloat)155/255 alpha:1];
        self.backgroundView.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"popupbg2.png"]];

        [rootViewControl.view addSubview:self.backgroundView];
        [self uiviewCreation];
    }
    else{
        self.backgroundView.hidden = NO;
    }
     [[NSNotificationCenter defaultCenter]postNotificationName:kReachabilityChangedNotification object:nil];
    BOOL fbCheck = [[NSUserDefaults standardUserDefaults] boolForKey:FacebookConnected];
    bool connect=[[NSUserDefaults standardUserDefaults]objectForKey:@"NetworkStatus"];
    if (fbCheck==YES && connect) {
        [self displayScore];
        
    }
}
-(void)uiviewCreation{
    //-----UIView------
    self.topview=[[UIView alloc]init];
    self.bottomview1=[[UIView alloc]init];
    self.bottomview1.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"highscore.png"]];
    [self lblDisplayOnUI];
    
    self.topview.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"popup.png"]];
    [self.backgroundView addSubview:self.topview];
    

   // self.bottomview1.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"highscore.png"]];
    [self.backgroundView addSubview:self.bottomview1];
    
    NSString * levelno=[NSString stringWithFormat:@"Level %d",[GameState sharedState].levelNumber-1] ;
    
    self.level1 =[[UILabel alloc]init];
    self.level1.backgroundColor=[UIColor clearColor] ;
    [level1 setTextColor:[UIColor blackColor]];
    [level1 setText:levelno];
    [level1 setFont:[UIFont fontWithName:@"ShallowGraveBB" size:40]];
    [self.topview addSubview:level1];

    self.play=[UIButton buttonWithType: UIButtonTypeCustom];
    [self.play setImage:[UIImage imageNamed:@"play.png"] forState:UIControlStateNormal];
    [self.play addTarget:self action:@selector(playButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    [self.topview addSubview:self.play];
    [self fadein:self.play.layer duratio:2];
    
    UIButton  * share=[UIButton buttonWithType: UIButtonTypeCustom];
    [share setImage:[UIImage imageNamed:@"share.png"] forState:UIControlStateNormal];
    [share addTarget:self action:@selector(facebookBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.topview addSubview:share];
    [self fadein:share.layer duratio:2];
    
    self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(5, 10, 280, 160)];
    self.scrollView.backgroundColor = [UIColor clearColor];
    [self.bottomview1 addSubview:self.scrollView];
    
    self.cancel = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.cancel setImage:[UIImage imageNamed:@"close.png"] forState:UIControlStateNormal];
    [self.cancel addTarget:self action:@selector(cancelButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.topview addSubview:self.cancel];
    
    UIImageView * goldStar=[[UIImageView alloc]init];
    goldStar.frame=CGRectMake(50+60+20, 70, 40, 40);
    goldStar.image= [UIImage imageNamed:@"star_emmpty.png"];
    [self.topview addSubview:goldStar];
    
   UIImageView * silverStar=[[UIImageView alloc]initWithFrame:CGRectMake(50+40, 70, 40, 40)];
    silverStar.image=[UIImage imageNamed:@"star_emmpty.png"];
        [self.topview addSubview:silverStar];
    
    UIImageView * bronzeStar=[[UIImageView alloc]initWithFrame:CGRectMake(50, 70, 40, 40)];
    bronzeStar.image= [UIImage imageNamed:@"star_emmpty.png"];
    [self.topview addSubview:bronzeStar];
    
    UIImageView * medal=[[UIImageView alloc]initWithFrame:CGRectMake(50+40+90, 70, 40, 40)];
    [self.topview addSubview:medal];
    
    
    

    
    
    if(gm.bullseye<=3){
        goldStar.image =[UIImage imageNamed:@"star_emmpty.png"];
        silverStar.image =[UIImage imageNamed:@"star_emmpty.png"];

        bronzeStar.image=[UIImage imageNamed:@"star_red.png"];
        medal.image=[UIImage imageNamed:@"medal_red.png"];
        
    }
    else if (gm.bullseye==4){
        silverStar.image=[UIImage imageNamed:@"star_green.png"];
        bronzeStar.image=[UIImage imageNamed:@"star_red.png"];
         goldStar.image =[UIImage imageNamed:@"star_emmpty.png"];
        medal.image=[UIImage imageNamed:@"medal_green.png"];
    }
    else if(gm.bullseye==5 || gm.bullseye>5){
        
        silverStar.image=[UIImage imageNamed:@"star_green.png"];
        bronzeStar.image=[UIImage imageNamed:@"star_red.png"];
        goldStar.image=[UIImage imageNamed:@"star_purple.png"];
        medal.image=[UIImage imageNamed:@"medal_purple.png"];
        }
    if([UIScreen mainScreen].bounds.size.height<500)
    {
        
        self.topview.frame=CGRectMake(25, 25,265 , 290);
        self.bottomview1.frame=CGRectMake(10, 310,315 , 165);
        self.play.frame=CGRectMake(170, 245, 70, 32);
        self.cancel.frame=CGRectMake(227, 3, 33, 33);
        self.level1.frame=CGRectMake(95, 30, 150, 40);
        share.frame=CGRectMake(25, 230, 70, 60);
    }
    else{
       // self.bottomview1.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"highscore@2xcopy1.png"]];
        self.topview.frame=CGRectMake(25, 40,265 , 320);
        self.bottomview1.frame=CGRectMake(10, 340,315 , 165);
        self.play.frame=CGRectMake(170, 255, 70, 30);
        self.cancel.frame=CGRectMake(210, -15, 66, 66);
        self.level1.frame=CGRectMake(95, 30, 200, 40);
        share.frame=CGRectMake(20, 240, 70, 60);
    }
   
    
}

// animation for button


-(void)fadein:inlayer duratio:(CFTimeInterval)intime
{
    CABasicAnimation * fade;
    
    
    fade=[CABasicAnimation animationWithKeyPath:@"opacity"];
    
    fade.duration=intime;
    
    fade.repeatCount= 1e100f;

    
    fade.autoreverses=YES;
    
    fade.fromValue=[NSNumber numberWithFloat:1.0];
    fade.toValue=[NSNumber numberWithFloat:0.1];
    
    
    [inlayer addAnimation:fade
                   forKey:@"animateOpacity"];
}



-(void) cancelButtonAction:(id)sender{
    
    self.backgroundView.hidden = YES;
    [[CCDirector sharedDirector]replaceScene:[LevelSelectionScene node]];
    
}



-(void)nextButtonClicked{
    
   
    [viewHost1 removeFromSuperview];
    
    if (!gm.checkLevelClear){
        NSLog(@"Retry Action");

        self.backgroundView.hidden=YES;
        self.text1.visible=YES;
        self.text2.visible=YES;
        self.text3.visible=YES;
        self.text4.visible=YES;
        
        
        [self playButtonClicked];
       
        return;
    }
   //
    
   // [viewHost1 removeFromSuperview];
     [[NSNotificationCenter defaultCenter]postNotificationName:kReachabilityChangedNotification object:nil];
    BOOL connect=[[NSUserDefaults standardUserDefaults]boolForKey:@"NetworkStatus"];
    BOOL fbCheck=[[NSUserDefaults standardUserDefaults]boolForKey:FacebookConnected];
    if(connect && fbCheck)
    {
        if_completed=YES;
        [self storypostMethod];
        [self createUIBg];
    }
    else{
        [[CCDirector sharedDirector]replaceScene:[LevelSelectionScene node]];
    }
       [FBAppEvents logEvent:FBAppEventNameAchievedLevel];
    
    
}

-(void) displayScore{
    
//    for (UIView *subView in [self.backgroundView subviews]){
//        subView.hidden = YES;
//    }
    
    NSArray *scoreDataAry = [GameState sharedState].friendsScoreInfoArray;
   
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        //CGFloat y = 60;
        for (int i =0; i<scoreDataAry.count; i++) {
            // NSLog(@"count %d",ary[i]);
//            
//            if (i == 3) {
//                break;
//            }
            PFObject *obj = [scoreDataAry objectAtIndex:i];
            NSLog(@"PFOBJEct -==- %@",obj);
            
            NSNumber *ascore = obj[@"Score"];
            NSString *name = obj[@"Name"];
            NSString *player1 = obj[@"PlayerFacebookID"];
            NSURL *url=[NSURL URLWithString:[NSString stringWithFormat:@"http://graph.facebook.com/%@/picture?type=large",player1]];
           
            
            dispatch_async(dispatch_get_main_queue(), ^{
                UIImageView *aimgeView = (UIImageView*)[self.scrollView viewWithTag:100+i];
                UILabel *label = (UILabel*)[self.scrollView viewWithTag:300+i];
                UILabel * positionLabel=(UILabel *)[self.scrollView viewWithTag:3000+i];
                
                if (aimgeView == nil) {
                    UIImageView *profileImageView = [[UIImageView alloc] initWithFrame:CGRectMake(20+(i*90), 70, 35, 35)];
                    profileImageView.tag = 100+i;
                    profileImageView.layer.borderWidth=2;
                    profileImageView.layer.borderColor=[[UIColor orangeColor]CGColor];
                    [self.scrollView addSubview:profileImageView];
                    [profileImageView setImageWithURL:url placeholderImage:[UIImage imageNamed:@"58x58.png"]];
                }
                else{
                    aimgeView.hidden = NO;
                    [aimgeView setImageWithURL:url placeholderImage:[UIImage imageNamed:@"58x58.png"]];
                }
                
                if (label==nil) {
                    UILabel *infoLabel = [[UILabel alloc] initWithFrame:CGRectMake(10+(i*90), 110, 90, 35)];
                    infoLabel.tag = 300+i;
                    infoLabel.backgroundColor = [UIColor clearColor];
                    infoLabel.font = [UIFont systemFontOfSize:10];
                    infoLabel.numberOfLines = 0;
                    infoLabel.lineBreakMode = NSLineBreakByCharWrapping;
                    infoLabel.text = [NSString stringWithFormat:@"%@\n%@",name,ascore];
                    [self.scrollView addSubview:infoLabel];
                    
                    [infoLabel sizeToFit];
                }
                else{
                    label.hidden = NO;
                    label.text = [NSString stringWithFormat:@"%@\n%@",name,ascore];
                    [label sizeToFit];
                }
                
                if(positionLabel==nil)
                {
                     UILabel * position=[[UILabel alloc] initWithFrame:CGRectMake(35+(i*90), 38, 30, 45)];                    position.tag = 3000+i;
                    position.textColor = [UIColor orangeColor];
                    position.backgroundColor=[UIColor clearColor];
                    [position setFont:[UIFont fontWithName:@"ShallowGraveBB" size:20]];
                    position.numberOfLines = 0;
                    position.lineBreakMode = NSLineBreakByCharWrapping;
                    position.text = [NSString stringWithFormat:@"%d",i+1];
                    [self.scrollView addSubview:position];
                    
                }
                else
                {
                    positionLabel.hidden=NO;
                    positionLabel.text = [NSString stringWithFormat:@"%d",i+1];
                    
                    
                }
                
            });
           
        }
        self.scrollView.contentSize = CGSizeMake(scoreDataAry.count*100, 80);
    });
    
    
}


#pragma mark -
#pragma mark Save To Parse

-(void) saveScoreToParse:(NSInteger)ascore forLevel:(NSInteger)level  bullsEyes:(NSInteger)bullseye{
    
   /* RevMobFullscreen *ad = [[RevMobAds session] fullscreen]; // you must retain this object
    [ad loadWithSuccessHandler:^(RevMobFullscreen *fs) {
        [fs showAd];
        //NSLog(@"Ad loaded Revmob");
        [[CCDirector sharedDirector] pause];
    } andLoadFailHandler:^(RevMobFullscreen *fs, NSError *error) {
        NSLog(@"Ad error Revmob: %@",error);
    } onClickHandler:^{
        //NSLog(@"Ad clicked Revmob");
    } onCloseHandler:^{
        //NSLog(@"Ad closed Revmob");
        [[CCDirector sharedDirector] resume];
    }];*/

    
    
    self.currentLevel=level;
   // self.levelScore = score;
    NSString *fbID = [[NSUserDefaults standardUserDefaults] objectForKey:ConnectedFacebookUserID];
    NSLog(@" [GameState sharedState].levelNumber%d",[GameState sharedState].levelNumber);
   
    NSString *strCheckFirstRun = [[NSUserDefaults standardUserDefaults] objectForKey:[NSString stringWithFormat:@"levelFirstRun%d",[GameState sharedState].levelNumber]];
    //  strCheckFirstRun=nil;
    NSLog(@"%@",strCheckFirstRun);

    if (fbID && ![fbID isEqualToString:@"Master"]) {
        
        BOOL isUpdateScore = NO;
        
        NSArray *ary = [GameState sharedState].friendsScoreInfoArray;
        NSMutableArray *mutableArray = [[NSMutableArray alloc] initWithArray:ary];
        
        for (int i = 0; i<mutableArray.count; i++) {
            
            PFObject *obj = [mutableArray objectAtIndex:i];
            NSString *store_fbID = obj[@"PlayerFacebookID"];
            if ([fbID isEqualToString:store_fbID]) {
                isUpdateScore = YES;
                break;
            }
        }// End For Loop
        
        if (isUpdateScore==NO) {//if3
            [[NSUserDefaults standardUserDefaults] setObject:@"hello" forKey:[NSString stringWithFormat:@"levelFirstRun%d",[GameState sharedState].levelNumber ]];
            [[NSUserDefaults standardUserDefaults] synchronize];
            //isNewHighScore =YES;
            NSLog(@"Current Level == %d",(int)level);
            NSLog(@"Level Score == %ld",(long)ascore);
            
            PFObject *object = [PFObject objectWithClassName:ParseScoreTableName];
            object[@"PlayerFacebookID"] = fbID;
            object[@"Level"] = [NSNumber numberWithInteger:level];
           // object[@"Level"] = [NSString stringWithFormat:@"%d",(int)level];
            //object[@"Levels"]=[NSNumber numberWithInteger:level];
            object[@"Score"] = [NSNumber numberWithInteger:ascore];
            object[@"BullsEye"]=[NSNumber numberWithInteger:bullseye];
           object[@"Name"] =[NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] objectForKey: @"ConnectedFacebookUserName"]];
            
            
            
            [mutableArray addObject:object];
            
            NSSortDescriptor* sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"Score" ascending:NO];
            NSArray* sortedArray = [mutableArray sortedArrayUsingDescriptors:[NSArray arrayWithObject:sortDescriptor]];
            [GameState sharedState].friendsScoreInfoArray = sortedArray;
            BOOL fbconnect=[[NSUserDefaults standardUserDefaults]boolForKey:FacebookConnected];
            if (fbconnect) {
                 [self findBeatedFriend:object];
            }
           
            
            NSLog(@"ConnectedFacebookUserName%@",[NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] objectForKey: @"ConnectedFacebookUserName"]]);
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
                [object saveEventually:^(BOOL succeed, NSError *error){
                    
                    if (succeed) {
                        NSLog(@"Save to Parse");
                        
                        //[self retriveFriendsScore:level andScore:score];
                    }
                    if (error) {
                        NSLog(@"Error to Save == %@",error.localizedDescription);
                    }
                }];
            });
        }//if3
        else{
            NSLog(@"Update row................yes ");
            [self updateScoreOn:ascore level:level  bullsEyes:bullseye];
        }
    }//End FB check
    else{
        [self retriveScoreSqlite:totalScore withLevel:level  bullsEyes:bullseye];
        NSLog(@"Not connected with Facebook");
    }
}

/*-(void) saveScoreToParse:(NSInteger)score forLevel:(NSInteger)level{
    
    NSString *fbID = [[NSUserDefaults standardUserDefaults] objectForKey:ConnectedFacebookUserID];
    
    NSString *strCheckFirstRun = [[NSUserDefaults standardUserDefaults] objectForKey:[NSString stringWithFormat:@"levelFirstRun%d",[GameState sharedState].levelNumber ]];
    //  strCheckFirstRun=nil;
    NSLog(@"%@",strCheckFirstRun);
    if (fbID) {
        NSLog(@"First time in level................................yes");
        if (!strCheckFirstRun) {//if3
            [[NSUserDefaults standardUserDefaults] setObject:@"hello" forKey:[NSString stringWithFormat:@"levelFirstRun%d",[GameState sharedState].levelNumber ]];
            [[NSUserDefaults standardUserDefaults] synchronize];
            isNewHighScore=YES;
            NSLog(@"Current Level == %d",(int)level);
            NSLog(@"Level Score == %d",score);
            
            PFObject *object = [PFObject objectWithClassName:ParseScoreTableName];
            object[@"PlayerFacebookID"] = fbID;
            object[@"Level"] = [NSString stringWithFormat:@"%d",(int)level];
            object[@"Score"] = [NSNumber numberWithInteger:score];
            object[@"Name"] =[NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] objectForKey: @"ConnectedFacebookUserName"]];
            
            
            
            NSArray *ary = [GameState sharedState].friendsScoreInfoArray;
            NSMutableArray *mutableArray = [[NSMutableArray alloc] initWithArray:ary];
            [mutableArray addObject:object];
            
            NSSortDescriptor* sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"Score" ascending:NO];
            NSArray* sortedArray = [mutableArray sortedArrayUsingDescriptors:[NSArray arrayWithObject:sortDescriptor]];
            [GameState sharedState].friendsScoreInfoArray = sortedArray;
            
            [self findBeatedFriend:object];
            
            NSLog(@"ConnectedFacebookUserName%@",[NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] objectForKey: @"ConnectedFacebookUserName"]]);
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
                [object saveEventually:^(BOOL succeed, NSError *error){
                    
                    if (succeed) {
                        NSLog(@"Save to Parse");
                        
                        //[self retriveFriendsScore:level andScore:score];
                    }
                    if (error) {
                        NSLog(@"Error to Save == %@",error.localizedDescription);
                    }
                }];
            });
        }//if3
        else{
            NSLog(@"Update row................yes ");
            [self updateScoreOn:score level:level];
        }
    }//End FB check
    else{
        NSLog(@"Not connected with Facebook");
    }
}*/
-(void) updateScoreOn:(NSInteger)ascore level:(NSInteger) level  bullsEyes:(NSInteger)bullseye{
    
    
    NSString *fbID = [[NSUserDefaults standardUserDefaults] objectForKey:ConnectedFacebookUserID];
    PFQuery *query = [PFQuery queryWithClassName:ParseScoreTableName];
    if(fbID)
    {
       /* [query whereKey:@"PlayerFacebookID" equalTo:fbID];
        [query whereKey:@"Level" equalTo:[NSString stringWithFormat:@"%d",(int)level]];
        [query orderByDescending:@"Score"];*/
        
        [query whereKey:@"PlayerFacebookID" equalTo:fbID];
        [query whereKey:@"Level" equalTo:[NSNumber numberWithInteger:level]];
        [query orderByDescending:@"Score"];

        
        //        NSArray *aryCount=[query findObjects];
        [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
            NSLog(@"ffff = %@",objects);
            for (int a =0; a<objects.count;a++) {
                
                PFObject *object = [objects objectAtIndex:a];
                
                if (a==0) {
                    NSLog(@"PFOBJEct -==- %@",object);
                    NSNumber *scoreOld = object[@"Score"];
                    
                   
                    if (ascore > [scoreOld integerValue]) {
                        NSLog(@"Current Level == %d",(int)level);
                        NSLog(@"Level Score == %d",(int)ascore);
                        
                        object[@"Score"] = [NSNumber numberWithInteger:ascore];
                        object[@"BullsEye"]=[NSNumber numberWithInteger:bullseye];
                        NSLog(@"%@",[NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] objectForKey: @"ConnectedFacebookUserName"]]);
                        
                        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
                            
                            [object saveEventually:^(BOOL succeed, NSError *error){
                                
                                if (succeed) {
                                    NSLog(@"Save to Parse");
                                    // [self retriveFriendsScore:level andScore:score];
                                }
                                else{
                                    NSLog(@"Error to Save == %@",error.localizedDescription);
                                }
                            }];
                        });// End dispatch Queue Save Data
                        NSArray *ary = [GameState sharedState].friendsScoreInfoArray;
                        NSMutableArray *mutableArray = [[NSMutableArray alloc] initWithArray:ary];
                       
   
                        NSLog(@"Mutable array %@",mutableArray);
                        for(int i=0;i<mutableArray.count;i++)
                        {
                            PFObject *obj=[mutableArray objectAtIndex:i];
                            NSString *id1=obj[@"PlayerFacebookID"];
                            NSLog(@"id1 %@",id1);
                            if([id1 isEqualToString:fbID])
                            {
                               // [mutableArray replaceObjectAtIndex:i withObject:object];
                                [mutableArray removeObject:obj];

                            }
                        }
                        [mutableArray addObject:object];
                        NSLog(@"Mutable array %@",mutableArray);

                           
                        
                        NSSortDescriptor* sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"Score" ascending:NO];
                        NSArray* sortedArray = [mutableArray sortedArrayUsingDescriptors:[NSArray arrayWithObject:sortDescriptor]];
                        [GameState sharedState].friendsScoreInfoArray = sortedArray;
                        [mutableArray release];
                      
                        if (ascore > [scoreOld integerValue])
                        {
                            BOOL fbconnect=[[NSUserDefaults standardUserDefaults]boolForKey:FacebookConnected];
                            if (fbconnect) {
                                [self findBeatedFriend:object];
                            }
                            //[self findBeatedFriend:object];
                        }
                    }//End if block Score check
                    
                }//End if Block a-0
                else{
                    [object deleteInBackground];
                }
                
            }//End of For loop
            
        }];
    }//// End if block fbID check
    
}
-(void)findBeatedFriend:(PFObject *)object{

    
    
    NSArray *ary = [GameState sharedState].friendsScoreInfoArray;
    
    NSMutableArray *mutableArray = [[NSMutableArray alloc] initWithArray:ary];
    if ([mutableArray containsObject:object]) {
        
        NSInteger position = [mutableArray indexOfObject:object];
        NSLog(@"Position = %ld",(long)position);
        if (position<=mutableArray.count-2 && mutableArray.count>1) {
            
            NSString *curFBID = [[NSUserDefaults standardUserDefaults] objectForKey:ConnectedFacebookUserID];
            
            PFObject *beatedObject = [mutableArray objectAtIndex:position+1];
            beated_fbID = beatedObject[@"PlayerFacebookID"];
            NSLog(@"Beated Friends ID = %@",beatedObject[@"PlayerFacebookID"]);
            NSLog(@"Beated Friends Score = %@",beatedObject[@"Score"]);
            NSLog(@"Beated Friends Name = %@",beatedObject[@"Name"]);
            
            NSNumber * numscore=object[@"Score"];
            int beatscore=numscore.intValue;
            [[NSUserDefaults standardUserDefaults]setInteger:beatscore forKey:@"beatScore"];
            [[NSUserDefaults standardUserDefaults]synchronize];

            
           if ([beated_fbID isEqualToString:curFBID]) {
               
                NSLog(@"Set new Score in this level");
                if_beated = NO;
                [mutableArray removeObject:beatedObject];
            }
            else{
                if_beated = YES;
                
                self.lblFbFirstName=beatedObject[@"Name"];
       
                [self sendePushToAll:object];
                [self beatFriendStoryPostOnWall];
                self.lblFbFirstName = beatedObject[@"Name"];
            }
            
            
        }
        
        if (position==0) {
            NSLog(@"new high score");
            isNewHighScore = YES;
        }
    }
}


#pragma mark- push notification to all friends
-(void)sendePushToAll:(PFObject *)object{
    NSArray * arr=[GameState sharedState].friendsScoreInfoArray;
    if (arr.count<1) {
        return;
    }
    NSMutableArray *mutArrFBID =[[NSMutableArray alloc]init];
    NSNumber * scorePush=object[@"Score"];
    for (int i=0; i<arr.count; i++) {
        PFObject * obj=[arr objectAtIndex:i];
        NSString * beatID=obj[@"PlayerFacebookID"];
        NSNumber * beat_Score=obj[@"Score"];
        if (scorePush.intValue > beat_Score.intValue) {
            [mutArrFBID addObject:beatID];
        }
        
        
        
    }
    
      NSString *connectedName = [[NSUserDefaults standardUserDefaults]objectForKey:@"ConnectedFacebookUserName"];
    
  /*  NSDictionary * data;
   
    data = @{
             @"Type": @"500",@"FriendName":self.lblFbFirstName,@"action": @"com.globussoft.dartwheelchief",
             @"alert":[NSString stringWithFormat:@"%@ beat you in level %d",connectedName,[GameState sharedState].levelNumber]
             
             };*/
    NSString * Message =[NSString stringWithFormat:@"%@ beat you in level %d",connectedName,[GameState sharedState].levelNumber-1];
   
    NSDictionary *data = [NSDictionary dictionaryWithObjectsAndKeys:
                          Message, @"alert",
                          @"Increment", @"badge",
                          @"cheering.caf",@"sound",
                          @"com.globussoft.dartWheelchief.UPDATE_STATUS",@"action",
                          Message,@"Message",@"type",@"1",
                          nil];

    PFQuery *pushQuery = [PFInstallation query];
    [pushQuery whereKey:@"PlayerFacebookID" containedIn:mutArrFBID];
    
    PFPush * push = [[PFPush alloc] init];
    [push setQuery:pushQuery];
    [push setData:data];
    [push sendPushInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (!error) {
            if (succeeded) {
                NSLog(@"Successful Push send");
            }
        } else {
            NSLog(@"Push sending error: %@", [error userInfo]);
        }
    }];

}
#pragma  mark- post on friends Wall

-(void)beatFriendStoryPostOnWall{
    
    
    NSString *fbID = [[NSUserDefaults standardUserDefaults] objectForKey:ConnectedFacebookUserID];
   
    
    NSString *str3 = [NSString stringWithFormat:@"I have cleared level %li with a score of %ld  and beat you in this Level. Hi Friends, Please join me in Dart Wheel Chief. Select from 3 funny characters and try to avoid them with your darts hitting on the targets. Lets see who can get a bulls eye!.",(long)[GameState sharedState].levelNumber-1,(long)[[NSUserDefaults standardUserDefaults]integerForKey:@"beatScore"]];
   // NSString * beat=[NSString stringWithFormat:@"Beat %@",self.lblFbBeatFrnd];
    NSMutableDictionary *params =
    [NSMutableDictionary dictionaryWithObjectsAndKeys:
     str3, @"description", @"", @"caption",
     @"https://itunes.apple.com/app/id892026202", @"link",@"Dart Wheel Chief",@"name",
     @"http://i.imgur.com/zhNdgpi.png?1",@"picture",beated_fbID,@"to",fbID,@"from",
     nil];
    NSString * fbid=[[NSUserDefaults standardUserDefaults]boolForKey:FacebookConnected];
    
    if (!fbid) {
        return;
    }
    AppDelegate * appDelegate=(AppDelegate*)[UIApplication sharedApplication].delegate;
    if (FBSession.activeSession.isOpen) {
        
        [appDelegate shareBeatStoryWithParams:params];
    }
    else{
        
        [appDelegate openSessionWithLoginUI:1 withParams:params];
        
    }
}

/*#pragma mark -
#pragma mark Save To Parse
-(void) saveScoreToParse:(NSInteger)score forLevel:(NSInteger)level{
    
    RevMobFullscreen *ad = [[RevMobAds session] fullscreen]; // you must retain this object
    [ad loadWithSuccessHandler:^(RevMobFullscreen *fs) {
        [fs showAd];
        //NSLog(@"Ad loaded Revmob");
        [[CCDirector sharedDirector] pause];
    } andLoadFailHandler:^(RevMobFullscreen *fs, NSError *error) {
        NSLog(@"Ad error Revmob: %@",error);
    } onClickHandler:^{
        //NSLog(@"Ad clicked Revmob");
    } onCloseHandler:^{
        //NSLog(@"Ad closed Revmob");
        [[CCDirector sharedDirector] resume];
    }];

    
//    activityInd=[[UIActivityIndicatorView alloc]initWithFrame:CGRectMake(ws.width/2, ws.height/2, 50, 50)];
//    activityInd.activityIndicatorViewStyle=UIActivityIndicatorViewStyleWhiteLarge;
//    activityInd.color=[UIColor redColor];
    
//    UIViewController *rootViewController = (UIViewController*)[(AppDelegate*)[[UIApplication sharedApplication] delegate] getRootViewController];
//    
//    [rootViewController.view addSubview:activityInd];
    //    [activityInd startAnimating];
    
    NSString *fbID = [[NSUserDefaults standardUserDefaults] objectForKey:ConnectedFacebookUserID];
    
    if (!fbID) {
        return;
    }
    NSString *strCheckFirstRun = [[NSUserDefaults standardUserDefaults] objectForKey:[NSString stringWithFormat:@"levelFirstRun%d",[GameState sharedState].levelNumber ]];
    
    if (!strCheckFirstRun) {
        NSLog(@"First time in level................................yes");
        [[NSUserDefaults standardUserDefaults] setObject:@"hello" forKey:[NSString stringWithFormat:@"levelFirstRun%d",[GameState sharedState].levelNumber ]];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        if (fbID) {
            //NSLog(@"Current Level == %d",level);
            //NSLog(@"Level Score == %d",score);
            isNewHighScore=YES;
            PFObject *object = [PFObject objectWithClassName:ParseScoreTableName];
            object[@"PlayerFacebookID"] = fbID;
            object[@"Level"] = [NSString stringWithFormat:@"%ld",(long)level];
            object[@"Score"] = [NSNumber numberWithInteger:score];
            object[@"Name"] =[NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] objectForKey: @"ConnectedFacebookUserName"]];
            
            NSLog(@"ConnectedFacebookUserName %@",[NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] objectForKey: @"ConnectedFacebookUserName"]]);
            
            dispatch_async(dispatch_get_global_queue(0, 0), ^{
                [object saveEventually:^(BOOL succeed, NSError *error){
                    
                    if (succeed) {
                        NSLog(@"Save to Parse");
                        
                        [self retriveFriendsScore:level andScore:score];
                    }
                    if (error) {
                        NSLog(@"Error to Save == %@",error.localizedDescription);
                    }
                }];
            });
        }
    }
    else{
        NSLog(@"Update row................yes ");
        [self updateScoreOn:score level:level];    }
}
-(void) updateScoreOn:(NSInteger) score level:(NSInteger) level{
    
    NSLog(@"score is %d",score);
    NSLog(@"level is %d",level);
    
    NSString *fbID = [[NSUserDefaults standardUserDefaults] objectForKey:ConnectedFacebookUserID];
    PFQuery *query = [PFQuery queryWithClassName:ParseScoreTableName];
    if(fbID)
    {
     
        [query whereKey:@"PlayerFacebookID" equalTo:fbID];
        [query whereKey:@"Level" equalTo:[NSString stringWithFormat:@"%d",[GameState sharedState].levelNumber-1]];
        
        NSArray *aryCount=[query findObjects];
        NSLog(@"Arrycount %d",aryCount.count);
        
        for (int i =0; i<aryCount.count; i++) {
            
            PFObject *object = [aryCount objectAtIndex:i];
            NSLog(@"PFOBJEct -==- %@",object);
            NSNumber *scoreOld = object[@"Score"];
            NSLog(@"oldscore %@",scoreOld);
            
            if (score > [scoreOld integerValue]) {
                isNewHighScore=YES;
                NSLog(@"Current Level == %d",(int)level);
                NSLog(@"Level Score == %d",(int)score);
                
                object[@"Score"] = [NSNumber numberWithInteger:score];
                
                NSLog(@"%@",[NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] objectForKey: @"ConnectedFacebookUserName"]]);
                
               
                
                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
                    
                    [object saveEventually:^(BOOL succeed, NSError *error){
                        
                        if (succeed) {
                            NSLog(@"Save to Parse");
                            [self retriveFriendsScore:level andScore:score];
                        }
                        else{
                            NSLog(@"Error to Save == %@",error.localizedDescription);
                        }
                    }];
                });// End dispatch Queue Save Data
                
            }// End if block Score check
        }//End of For loop
    }//// End if block fbID check
}
*/
-(void) retriveFriendsScore:(NSInteger)level andScore:(NSInteger)ascore{
    
    NSMutableArray *mutArr = [[NSMutableArray alloc]init];
    //    NSArray *arr =[[NSUserDefaults standardUserDefaults] objectForKey:FacebookGameFrindes];
    mutArr =[[NSUserDefaults standardUserDefaults] objectForKey:FacebookGameFrindes];
    
    NSMutableArray *arrMutableCopy = [mutArr mutableCopy];
    
    NSString *strUserFbId = [[NSUserDefaults standardUserDefaults]objectForKey:ConnectedFacebookUserID];
    NSNumber *numFbIdUser =  [NSNumber numberWithLongLong:[strUserFbId longLongValue]];
    
    if (strUserFbId) {
        if (![arrMutableCopy containsObject:strUserFbId]) {
            [arrMutableCopy addObject:strUserFbId];
        }
    }
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        
        self.currentLevel = level;
        
      //  NSString *strLevel = [NSString stringWithFormat:@"%i",(int)level];
        
        PFQuery *query = [PFQuery queryWithClassName:ParseScoreTableName];
        
        [query whereKey:@"Level" equalTo:(int)level];
        
        [query whereKey:@"PlayerFacebookID" containedIn:arrMutableCopy];
        
        [query orderByDescending:@"Score"];
        NSArray *ary = [query findObjects];
        
        if (ary.count<1) {
            isNewHighScore = YES;
            NSLog(@"New High Score");
            NSLog(@"Not contain any Object");
            return;
        }
        
        else{
            self.mutArrScores = [[NSMutableArray alloc] init];
            
            isNewHighScore = NO;
            for (int i =0; i<ary.count; i++) {
                
                PFObject *obj = [ary objectAtIndex:i];
                NSLog(@"PFOBJEct -==- %@",obj);
                NSNumber *scoreOld = obj[@"Score"];
                NSNumber *fbId = obj[@"PlayerFacebookID"];
                //            NSLog(@"Score Old -==- %@",scoreOld);
                
                int storeScore = [scoreOld intValue];
                
                if (ascore<storeScore) {
                    [self.mutArrScores addObject:scoreOld];
                }
                else{
                    
                    if (self.mutArrScores.count==0) {
                        isNewHighScore = YES;
                        NSLog(@"You create new high Score.");
                    }
                    else{
                        
                        if ([fbId longLongValue]== [numFbIdUser longLongValue]) {
                            
                        }
                        else{
                            
                            NSString *name = obj[@"Name"];
                            self.lblFbFirstName = name;
                            /*
                            NSString *urlString = [NSString   stringWithFormat:@"https://graph.facebook.com/%@",fbId];
                            NSLog(@"url String=-=- %@",urlString);
                            
                            NSMutableURLRequest *request = [[[NSMutableURLRequest alloc] init] autorelease];
                            [request setURL:[NSURL URLWithString:urlString]];
                            [request setHTTPMethod:@"GET"];
                            [request setValue:@"application/xml" forHTTPHeaderField:@"Content-Type"];
                            NSURLResponse* response;
                            NSError* error = nil;
                            
                            //Capturing server response
                            NSData* result = [NSURLConnection sendSynchronousRequest:request  returningResponse:&response error:&error];
                            
                            NSString *str = [[NSString alloc] initWithData:result encoding:NSUTF8StringEncoding];
                            NSLog(@"Data =-= %@",str);
                            if (str) {
                                
                                NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:result options:0 error:NULL];
                                self.lblFbFirstName = [dict objectForKey:@"first_name"];
                                
                                self.lblFbLastName = [dict objectForKey:@"last_name"];
                                
                                NSLog(@"First Name =-=- %@",self.lblFbFirstName);
                                NSLog(@"last name =-=- %@",self.lblFbLastName);
//                                [activityInd stopAnimating];
                             
                            }*/
                            return;
                        }
                    }
                }
            }
        }
    });
}


-(void) saveScoreLocally:(NSInteger)alevel withScore:(NSInteger)ascore{
    NSDictionary *d = [[NSUserDefaults standardUserDefaults] objectForKey:@"SavedLevelScore"];
    NSMutableDictionary *scoreDict;
    if (d == nil) {
        scoreDict = [[NSMutableDictionary alloc] init];
    }
    else{
        scoreDict = [[NSMutableDictionary alloc] initWithDictionary:d];
    }
    
    [scoreDict setObject:[NSString stringWithFormat:@"%ld",(long)ascore] forKey:[NSString stringWithFormat:@"Level%ld",(long)alevel]];
    
    [[NSUserDefaults standardUserDefaults] setObject:scoreDict forKey:@"SavedLevelScore"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

#pragma mark- save score in sqlite

-(void)retriveScoreSqlite:(NSInteger)ascore withLevel:(NSInteger)alevel bullsEyes:(NSInteger)bullseye
{
    
    BOOL check_Update;
    check_Update=FALSE;
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    
    NSLog(@"%@",paths);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *databasePath = [documentsDirectory stringByAppendingPathComponent:@"GameScoreDb.sqlite"];
    NSString * keyLevel=[NSString stringWithFormat:@"%d",(int)alevel];
    // Check to see if the database file already exists
    NSString * connectedFBid=[[NSUserDefaults standardUserDefaults]objectForKey:ConnectedFacebookUserID];
    NSString *query = [NSString stringWithFormat:@"select * from GameScoreFinal where PlayerFbId = \"%@\"",connectedFBid];
    sqlite3_stmt *stmt=nil;
    if(sqlite3_open([databasePath UTF8String], &_databaseHandle)!=SQLITE_OK)
        NSLog(@"error to open");
    
    if (sqlite3_prepare_v2(_databaseHandle, [query UTF8String], -1, &stmt, NULL)== SQLITE_OK)
    {
        NSLog(@"prepared");
    }
    else
        NSLog(@"error");
    // sqlite3_step(stmt);
    @try
    {
        while(sqlite3_step(stmt)==SQLITE_ROW)
        {
            
            char *level = (char *) sqlite3_column_text(stmt,1);
            char *score = (char *) sqlite3_column_text(stmt,2);
            char * bullseye=(char *) sqlite3_column_text(stmt,5);
            NSString *strLevel= [NSString  stringWithUTF8String:level];
            
            NSString *strScore  = [NSString stringWithUTF8String:score];
            
            NSString * strBullseye=[NSString stringWithUTF8String:bullseye];
            NSLog(@"Level %@ and Score %@ and bullseye %@",strLevel,strScore,strBullseye);
            if([strLevel isEqualToString:keyLevel])
            {
                check_Update=TRUE;
            }
            
        }
    }
    @catch(NSException *e)
    {
        NSLog(@"%@",e);
    }
    if(check_Update)
    {
        [self updateScoreSqlite:ascore withScore:alevel andBullsEye:bullseye];
    }
    else
    {
        [self saveScoreSqlite:ascore withScore:alevel andBullsEye:bullseye];
    }
    
}


-(void)saveScoreSqlite:(NSInteger)ascore withScore:(NSInteger)alevel andBullsEye:(NSInteger)bullsEye
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSLog(@"%@",paths);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *databasePath = [documentsDirectory stringByAppendingPathComponent:@"GameScoreDb.sqlite"];
    sqlite3_stmt *inset_statement = NULL;
    NSString * keyLevel=[NSString stringWithFormat:@"%d",(int)alevel];
    NSString * keyScore=[NSString stringWithFormat:@"%d",(int)ascore];
    NSString * keyBulls=[NSString stringWithFormat:@"%d",(int)bullsEye];
    NSString * connectedFBid=[[NSUserDefaults standardUserDefaults]objectForKey:ConnectedFacebookUserID];
    if(!connectedFBid)
    {
        [[NSUserDefaults standardUserDefaults] setObject:@"Master" forKey:
         ConnectedFacebookUserID];
    }
    connectedFBid=[[NSUserDefaults standardUserDefaults]objectForKey:ConnectedFacebookUserID];
    
    NSString *insertSQL = [NSString stringWithFormat:
                           @"INSERT INTO GameScoreFinal (Level, Score,PlayerFbId,Name,BullsEye) VALUES (\"%@\", \"%@\",\"%@\",\"%@\",\"%@\")",
                           keyLevel,
                           keyScore,connectedFBid,[NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] objectForKey: @"ConnectedFacebookUserName"]],keyBulls];
    
    const char *insert_stmt = [insertSQL UTF8String];
    if (sqlite3_open([databasePath UTF8String], &_databaseHandle)!=SQLITE_OK) {
        NSLog(@"Error to Open");
        return;
    }
    
    if (sqlite3_prepare_v2(_databaseHandle, insert_stmt , -1,&inset_statement, NULL) != SQLITE_OK ) {
        NSLog(@"%s Prepare failure '%s' (%1d)", __FUNCTION__, sqlite3_errmsg(_databaseHandle), sqlite3_errcode(_databaseHandle));
        NSLog(@"Error to Prepare");
        
    }
    
    if(sqlite3_step(inset_statement) == SQLITE_DONE) {
        UIAlertView *message = [[UIAlertView alloc] initWithTitle:@""
                                                          message:@"Data Saved"
                                                         delegate:nil
                                                cancelButtonTitle:@"OK"
                                                otherButtonTitles:nil];
       // [message show];
        NSLog(@"Success");
    }
}
-(void)updateScoreSqlite:(NSInteger)ascore withScore:(NSInteger)alevel andBullsEye:(NSInteger)bullsEye
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSLog(@"%@",paths);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *databasePath = [documentsDirectory stringByAppendingPathComponent:@"GameScoreDb.sqlite"];
    sqlite3_stmt *inset_statement = NULL;
    NSString * keyLevel=[NSString stringWithFormat:@"%d",(int)alevel];
    NSString * keyScore=[NSString stringWithFormat:@"%d",(int)ascore];
    NSString * keyBulls=[NSString stringWithFormat:@"%d",(int)bullsEye];
    NSString * connectedFBid=[[NSUserDefaults standardUserDefaults]objectForKey:ConnectedFacebookUserID];
    NSString * name=[[NSUserDefaults standardUserDefaults]objectForKey:@"ConnectedFacebookUserName"];
    
    NSLog(@"Existsing data, Update Please");
    NSString *updateSQL = [NSString stringWithFormat:@"UPDATE GameScoreFinal set  Score = '%@', PlayerFbId = '%@' Name = '%@' BullsEye = '%@' WHERE Level =%@",keyScore,connectedFBid,name,keyLevel,keyBulls];
    
    const char *update_stmt = [updateSQL UTF8String];
    if (sqlite3_open([databasePath UTF8String], &_databaseHandle)!=SQLITE_OK) {
        NSLog(@"Error to Open");
        return;
    }
    
    if (sqlite3_prepare_v2(_databaseHandle, update_stmt , -1,&inset_statement, NULL) != SQLITE_OK )
    {
        NSLog(@"%s Prepare failure '%s' (%1d)", __FUNCTION__, sqlite3_errmsg(_databaseHandle), sqlite3_errcode(_databaseHandle));
        NSLog(@"Error to Prepare");
        
    }
    if(sqlite3_step(inset_statement) == SQLITE_DONE) {
        UIAlertView *message = [[UIAlertView alloc] initWithTitle:@""
                                                          message:@"Data update"
                                                         delegate:nil
                                                cancelButtonTitle:@"OK"
                                                otherButtonTitles:nil];
       // [message show];
        NSLog(@"Success");
    }
    //NSLog(@"%s Prepare failure '%s' (%1d)", __FUNCTION__, sqlite3_errmsg(_databaseHandle), sqlite3_errcode(_databaseHandle));
    sqlite3_finalize(inset_statement);
    sqlite3_close(_databaseHandle);
}


/*
#pragma  mark-  alert view delegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex==0) {
       
        [Chartboost showRewardedVideo:CBLocationStartup];
        self.backgroundView.hidden = YES;
        //[[CCDirector sharedDirector]replaceScene:[LevelSelectionScene node]];
    }
}
*/
-(void) dealloc
{
    [self.background release];
    [self.playAgainMI release];
    [self.chooseVictimMI release];
    [self.playAgainButton release];
    [self.chooseVictimButton release];
    [self.pasp1 release];
    [self.pasp2 release];
    [self.cvsp1 release];
    [self.cvsp2 release];
    [super dealloc];
}

-(void)back:(id)sender {
    [viewHost1 removeFromSuperview];
    [[CCDirector sharedDirector]replaceScene:[LevelSelectionScene node]];
   }

-(void)didCloseInterstitial:(CBLocation)location{
   
   }



@end
