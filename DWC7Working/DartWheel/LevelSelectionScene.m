//
//  LevelSelectionScene.m
//  BowHunting
//
//  Created by Sumit Ghosh on 03/05/14.
//  Copyright (c) 2014 tang. All rights reserved.
//

#import "LevelSelectionScene.h"
#import "AppDelegate.h"
#import "GameMain.h"
#import "IntroLayer.h"
#import "GameState.h"
#import "UIImageView+WebCache.h"

@implementation LevelSelectionScene
{
    int skip;
}
@synthesize  topview,bottomview1,play,level1,backgroundView;
-(id)init {
    
    if (self=[super init]) {
       
       // [NSNotificationCenter defaultCenter]postNotificationName:<#(NSString *)#> object:(id)
        [[NSNotificationCenter defaultCenter]postNotificationName:kReachabilityChangedNotification object:nil];
        BOOL connect=[[NSUserDefaults standardUserDefaults]boolForKey:@"NetworkStatus"];
        if(connect)
            
        {
            BOOL getLevel=[[NSUserDefaults standardUserDefaults]boolForKey:FacebookConnected];
            if (getLevel==YES) {
                
                              // [[NSUserDefaults standardUserDefaults]setBool:NO forKey:@"clearLevel"];
               // [[NSUserDefaults standardUserDefaults]synchronize];
            }
            skip=0;
            
            if (adm) {
                adm=nil;
            }
            
            adm = [[AdMobViewController alloc]init];
            if([UIScreen mainScreen].bounds.size.height>500)
            {
                 adm.frame =CGRectMake(0, 0, 320, 50);
               // adm.frame =CGRectMake(0, 520, 320, 50);
            }
            else{
                adm.frame =CGRectMake(0, 0, 320, 50);
            }
            viewHost1 = adm.view;
            [[[CCDirector sharedDirector] openGLView] addSubview:viewHost1];
            /////////////////////NEED to handle mmory
            
            
          //  [Chartboost cacheRewardedVideo:CBLocationStartup];
           // if (adf) {
            //    adf=nil;
            //}
           // adf = [[AdMobFullScreenViewController alloc]init];
//        rootViewController = (UIViewController*)[(AppDelegate*)[[UIApplication sharedApplication] delegate] getRootViewController];
//                adf = [[AdMobFullScreenViewController alloc]init];
//                [rootViewController presentViewController:adf animated:YES completion:nil];
        }
        
        BOOL fbconnnect=[[NSUserDefaults standardUserDefaults]boolForKey:FacebookConnected];
        if (fbconnnect) {
            
           [self findFriendsLevel];
        }
        
        int life=(int)[[NSUserDefaults standardUserDefaults]integerForKey:@"life"];
        if (life<=0) {
             [self compareDate];
        }
       
       
        currentContentOffsetHeight = 0;
        CGSize ws=[[CCDirector sharedDirector]winSize];
        
        if ([UIScreen mainScreen].bounds.size.height>500) {
            spriteBackground=[CCSprite spriteWithFile:@"bgblankiPhone.png"];
        }
        else {
            spriteBackground=[CCSprite spriteWithFile:@"bgblank.png"];
        }
        
        spriteBackground.position=ccp(ws.width/2,ws.height/2);
        [self addChild:spriteBackground z:0];

        rootViewController = (UIViewController*)[(AppDelegate*)[[UIApplication sharedApplication] delegate] getRootViewController];
        
        CCMenuItemImage *menuItemImageBack = [CCMenuItemImage  itemFromNormalImage:@"backLevel.png" selectedImage:@"backLevel.png" target:self selector:@selector(backBtnAction:)];
        
        menuBack=[CCMenu menuWithItems:menuItemImageBack, nil];
        
        CGRect ff;
        
         if([UIScreen mainScreen].bounds.size.height>500){
          
           scrollV = [[UIScrollView alloc] initWithFrame:CGRectMake(25, 130, 800, 250)];
             ff = CGRectMake(148, 370, 30, 30);
             //scrollV = [[UIScrollView alloc] initWithFrame:CGRectMake(25, 80, 800, 320)];
         }
         else{
          
             scrollV = [[UIScrollView alloc] initWithFrame:CGRectMake(25, 75, 270, 250)];
             ff=CGRectMake(148, 290, 30, 30);
             //scrollV = [[UIScrollView alloc] initWithFrame:CGRectMake(25, 70, 270, 300)];
             
         }
        menuBack.position=ccp(50, ws.height-70);
      
        scrollV.contentSize=CGSizeMake(270, 500);
       // scrollV.scrollEnabled=YES;
        scrollV.delegate = self;
        scrollV.showsHorizontalScrollIndicator=YES;
        
        [rootViewController.view addSubview:scrollV];
       
        [self addChild:menuBack];
       /*  BOOL fbCheck=[[NSUserDefaults standardUserDefaults]boolForKey:FacebookConnected];
        if (fbCheck) {
            

        
        }*/
       
       
       
        
        
        //========================================
        
        arrowButton = [UIButton buttonWithType:UIButtonTypeCustom];
        arrowButton.frame = ff;
        [arrowButton setBackgroundImage:[UIImage imageNamed:@"Arrow_down1.png"] forState:UIControlStateNormal];
        [arrowButton addTarget:self action:@selector(downButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        [rootViewController.view addSubview:arrowButton];
        
        //---------------------------------------
        UIColor *strokeColor = [UIColor colorWithRed:(CGFloat)214/255 green:(CGFloat)120/255  blue:(CGFloat)7/255  alpha:1];
        UIColor *textColor = [UIColor whiteColor];
        UIFont *textFont = [UIFont fontWithName:@"TerrorPro" size:22];
        //UIFont *f1 = [UIFont boldSystemFontOfSize:35];
         NSNumber *w = [NSNumber numberWithFloat:-3.0f];
        NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:strokeColor,NSStrokeColorAttributeName,textColor,NSForegroundColorAttributeName,textFont,NSFontAttributeName,w,NSStrokeWidthAttributeName, nil];
        //======================================
        for (int i=0; i<4; i++) {
            
            for (int j=0; j<10; j++) {
                btnLevels = [UIButton buttonWithType:UIButtonTypeSystem];
            
                btnLevels.frame=CGRectMake(15+65*i, 50*j, 51, 41);
              int buttonNumber = j*4+i+1;
                btnLevels.tag=buttonNumber;
               
                //btnLevels.titleLabel.font=[UIFont fontWithName:@"TerrorPro" size:20];
                
                
                
                //[btnLevels setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                [btnLevels addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];

                [scrollV addSubview:btnLevels];
                
                int levelNumbers =(int)[[NSUserDefaults standardUserDefaults] integerForKey:@"levelClear"];
                
                if (levelNumbers==0) {
                    
                    if (buttonNumber==1) {
                        [btnLevels setBackgroundImage:[UIImage imageNamed:@"unlocklevel.png"] forState:UIControlStateNormal];
                        NSString *str =[NSString stringWithFormat:@"%ld",(long)btnLevels.tag];
                       // [btnLevels setTitle:str forState:UIControlStateNormal];
                        NSAttributedString *attStr = [[NSAttributedString alloc] initWithString:str attributes:dict];
                        [btnLevels setAttributedTitle:attStr forState:UIControlStateNormal];

                    }
                    else{
                        [btnLevels setBackgroundImage:[UIImage imageNamed:@"locklevel.png"] forState:UIControlStateNormal];
                    }
                }
                
                else {
                    if (buttonNumber>levelNumbers) {
                    [btnLevels setBackgroundImage:[UIImage imageNamed:@"locklevel.png"] forState:UIControlStateNormal];
                    }
                    else {
                        [btnLevels setBackgroundImage:[UIImage imageNamed:@"unlocklevel.png"] forState:UIControlStateNormal];
                        NSString *str =[NSString stringWithFormat:@"%ld",(long)btnLevels.tag];
                        //[btnLevels setTitle:str forState:UIControlStateNormal];
                        
                        NSAttributedString *attStr = [[NSAttributedString alloc] initWithString:str attributes:dict];
                        [btnLevels setAttributedTitle:attStr forState:UIControlStateNormal];
                    }
                    
                 }
            }
        }
        
    }
    BOOL getLevel=[[NSUserDefaults standardUserDefaults]boolForKey:FacebookConnected];
    if (getLevel==YES) {
     [self displayFriendsListUI];
    }
    return self;
}

-(void)LevelNumber{
   
        
    
        
   

}

-(void)choosegame
{
    self.backgroundView.hidden = YES;
    scrollV.hidden=YES;
    arrowButton.hidden=YES;
    [self removeChild:spriteBackground cleanup:YES];
    [self removeChild:menuBack cleanup:YES];
    [[CCDirector sharedDirector]replaceScene:[CCTransitionFadeTR transitionWithDuration:1.0 scene:[GameMain scene]]];
    
}
- (void) createUIBg{
    
    self.bottomScroll.hidden=YES;
    self.friendsView.hidden=YES;
    CGRect frame = [UIScreen mainScreen].bounds;
    if (self.backgroundView) {
        self.backgroundView=nil;
    
    }
        menuBack.visible=NO;
        // self.backgroundView=[[UIView alloc]init];
        self.backgroundView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        //self.backgroundView.backgroundColor = [UIColor colorWithRed:(CGFloat)155/255 green:(CGFloat)155/255 blue:(CGFloat)155/255 alpha:1];
       
        self.backgroundView.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"popupbg2.png"]];
        
       
        [rootViewController.view addSubview:self.backgroundView];
        
        if(self.topview)
        {
            self.topview=nil;
        }
            self.topview=[[UIView alloc]init];
            self.topview.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"popup.png"]];
            [self.backgroundView addSubview:self.topview];
        
        self.topview.hidden=NO;
        if(self.bottomview1)
        {
            self.bottomview1=nil;
        }
            self.bottomview1=[[UIView alloc]init];
            [self.backgroundView addSubview:self.bottomview1];
    
        self.bottomview1.hidden=NO;
        self.bottomview1.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"highscore.png"]];
        
        levelno=[NSString stringWithFormat:@"Level %d",[GameState sharedState].levelNumber] ;
        if (self.level1) {
            self.level1=nil;
        }
        self.level1 =[[UILabel alloc]init];
        self.level1.backgroundColor=[UIColor clearColor] ;
        [level1 setTextColor:[UIColor blackColor]];
        [level1 setText:levelno];
        [level1 setFont:[UIFont fontWithName:@"ShallowGraveBB" size:40]];
        [self.topview addSubview:level1];
        
        
        
        self.play=[UIButton buttonWithType: UIButtonTypeCustom];
        [self.play setImage:[UIImage imageNamed:@"play.png"] forState:UIControlStateNormal];
        [self.play addTarget:self action:@selector(chooseGameScreen) forControlEvents:UIControlEventTouchUpInside];
        [self.topview addSubview:self.play];
        [self fadein:self.play.layer duratio:2];
        
        self.cancel = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.cancel setImage:[UIImage imageNamed:@"close.png"] forState:UIControlStateNormal];
        [self.cancel addTarget:self action:@selector(cancelButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.topview addSubview:self.cancel];
        
        
        UIImage * skinny=[UIImage imageNamed:@"skinny.png"];
        UIImageView * imgview= [[UIImageView alloc]init];
        imgview.image=skinny;
        [self.topview addSubview:imgview];
        
        UIImage * fat=[UIImage imageNamed:@"Fatty.png"];
        UIImageView * imgview1= [[UIImageView alloc]init];
        imgview1.image=fat;
        [self.topview addSubview:imgview1];
        
        
        
        UIImage * newguy=[UIImage imageNamed:@"Newguy.png"];
        UIImageView * imgview2= [[UIImageView alloc]init];
        imgview2.image=newguy;
        [self.topview addSubview:imgview2];
        
        //    self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(7, 20, 250, 180)];
        //    self.scrollView.backgroundColor = [UIColor redColor];
        //    [self.bottomview1 addSubview:self.scrollView];
    
    
    
        
        if([UIScreen mainScreen].bounds.size.height<500)
        {
            self.topview.frame=CGRectMake(25, 25,265 , 290);
            self.bottomview1.frame=CGRectMake(10, 310,305 , 165);
            self.play.frame=CGRectMake(95, 230, 70, 40);
            self.cancel.frame=CGRectMake(227, 3, 33, 33);
            self.level1.frame=CGRectMake(95, 20, 150, 40);
            imgview.frame=CGRectMake(20, 120, 80, 50);
            imgview2.frame=CGRectMake(70, 170, 80, 50);
            imgview1.frame=CGRectMake(140, 120, 100, 50);
            
        }
        else{
           // self.bottomview1.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"highscore3@2x.png"]];
            self.topview.frame=CGRectMake(25, 40,265 , 320);
            self.bottomview1.frame=CGRectMake(10, 340,315 , 165);
            self.play.frame=CGRectMake(100, 250, 70, 50);
            self.level1.frame=CGRectMake(95, 20, 200, 40);
            self.cancel.frame=CGRectMake(210, -15, 66, 66);
            imgview.frame=CGRectMake(20, 120, 80, 50);
            imgview2.frame=CGRectMake(70, 180, 80, 50);
            imgview1.frame=CGRectMake(140, 120,100 , 50);
        }
        
        
        

        
        //[self uiviewCreation];
   // }
   /* else{
        self.backgroundView.hidden = NO;
        //[self uiviewCreation];

    }*/
}
-(void)uiviewCreation{
    //-----UIView------
  /*  if(!self.topview)
    {
    self.topview=[[UIView alloc]init];
    self.topview.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"popup.png"]];
    [self.backgroundView addSubview:self.topview];
    }
    self.topview.hidden=NO;
    if(!self.bottomview1)
    {
        self.bottomview1=[[UIView alloc]init];
        [self.backgroundView addSubview:self.bottomview1];
    }
    self.bottomview1.hidden=NO;
    
    
//levelno=[NSString stringWithFormat:@"Level %d",[GameState sharedState].levelNumber] ;
    if (self.level1) {
        self.level1=nil;
    }
    self.level1 =[[UILabel alloc]init];
    self.level1.backgroundColor=[UIColor clearColor] ;
    [level1 setTextColor:[UIColor blackColor]];
    [level1 setText:levelno];
    [level1 setFont:[UIFont fontWithName:@"ShallowGraveBB" size:40]];
    [self.topview addSubview:level1];
    
    

    self.play=[UIButton buttonWithType: UIButtonTypeCustom];
    [self.play setImage:[UIImage imageNamed:@"play.png"] forState:UIControlStateNormal];
    [self.play addTarget:self action:@selector(chooseGameScreen) forControlEvents:UIControlEventTouchUpInside];
    [self.topview addSubview:self.play];
    [self fadein:self.play.layer duratio:2];
    
    self.cancel = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.cancel setImage:[UIImage imageNamed:@"close.png"] forState:UIControlStateNormal];
    [self.cancel addTarget:self action:@selector(cancelButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.topview addSubview:self.cancel];
    
    
    UIImage * skinny=[UIImage imageNamed:@"skinny.png"];
    UIImageView * imgview= [[UIImageView alloc]init];
    imgview.image=skinny;
    [self.topview addSubview:imgview];
    
    UIImage * fat=[UIImage imageNamed:@"Fatty.png"];
    UIImageView * imgview1= [[UIImageView alloc]init];
    imgview1.image=fat;
    [self.topview addSubview:imgview1];
    
   
    
    UIImage * newguy=[UIImage imageNamed:@"Newguy.png"];
    UIImageView * imgview2= [[UIImageView alloc]init];
    imgview2.image=newguy;
    [self.topview addSubview:imgview2];

//    self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(7, 20, 250, 180)];
//    self.scrollView.backgroundColor = [UIColor redColor];
//    [self.bottomview1 addSubview:self.scrollView];
    
    
    if([UIScreen mainScreen].bounds.size.height<500)
    {
        self.topview.frame=CGRectMake(25, 25,265 , 290);
        self.bottomview1.frame=CGRectMake(7, 310,305 , 167);
        self.play.frame=CGRectMake(95, 230, 70, 40);
        self.cancel.frame=CGRectMake(227, 3, 33, 33);
        self.level1.frame=CGRectMake(95, 40, 150, 40);
        imgview.frame=CGRectMake(20, 80, 70, 70);
        imgview2.frame=CGRectMake(70, 150, 70, 70);
        imgview1.frame=CGRectMake(150, 100, 100, 50);
        self.bottomview1.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"highscorecopy.png"]];
    }
    else{
        self.bottomview1.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"highscore@2xcopy1.png"]];
        self.topview.frame=CGRectMake(25, 40,265 , 320);
        self.bottomview1.frame=CGRectMake(7, 340,308 , 180);
        self.play.frame=CGRectMake(100, 250, 70, 50);
        self.level1.frame=CGRectMake(95, 40, 200, 40);
        self.cancel.frame=CGRectMake(210, -15, 66, 66);
        imgview.frame=CGRectMake(20, 80, 70, 70);
        imgview2.frame=CGRectMake(70, 170, 70, 70);
        imgview1.frame=CGRectMake(150, 100,100 , 50);
    }

    
*/
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
    
  
    [inlayer addAnimation:fade forKey:@"animateOpacity"];
}





-(void)backBtnAction:(id)sender {
    // scrollV.hidden=YES;
    NSArray * view= rootViewController.view.subviews;
    for(UIScrollView * v in view)
    {
        [v removeFromSuperview];
    }
    
    arrowButton.hidden = YES;
    [self removeChild:spriteBackground cleanup:YES];
    [self removeChild:menuBack cleanup:YES];
    self.bottomScroll.hidden=YES;
    self.friendsView.hidden=YES;
    [[CCDirector sharedDirector] replaceScene:[IntroLayer node]];
}
-(void)chooseGameScreen {
    //create game choose screen
    int darts=[[NSUserDefaults standardUserDefaults]objectForKey:@"darts"];
    if (darts>=0) {
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
    }
     [viewHost1 removeFromSuperview];
        self.backgroundView.hidden = YES;
        // scrollV.hidden=YES;
        NSArray * view= rootViewController.view.subviews;
        for(UIScrollView * v in view)
        {
            [v removeFromSuperview];
        }
        arrowButton.hidden=YES;
        [self removeChild:spriteBackground cleanup:YES];
        [self removeChild:menuBack cleanup:YES];
        self.backgroundView.hidden = YES;
        self.gameChooseScreen=[[GameChooseScreen alloc]init];
        self.gameChooseScreen.gm=self;
        self.gameChooseScreen.visible=YES;
        [[CCDirector sharedDirector] replaceScene:[GameChooseScreen node]];
   
}

-(void) cancelButtonAction:(id)sender{
    
   
    NSString * connectedFB=[[NSUserDefaults standardUserDefaults]boolForKey:FacebookConnected];
    if (connectedFB) {
         [self displayFriendsListUI];
        [self findFriendsLevel];
    }
    
    self.backgroundView.hidden = YES;
    menuBack.visible=YES;
   
}
#pragma mark -
-(void)btnAction:(id)sender {
    [viewHost1 removeFromSuperview];
    int levelNumbers = (int)[[NSUserDefaults standardUserDefaults] integerForKey:@"levelClear"];
    
    if(levelNumbers < [sender tag] && levelNumbers != 0){
        return;
    }
    currentSelectedLevel = [sender tag];
    [GameState sharedState].levelNumber=(int)[sender tag];
    NSLog(@"level here is %d",[GameState sharedState].levelNumber);
    
    if ([sender isKindOfClass:[UIButton class]]) {
        //NSLog(@"Sender Button Tag =-=-=- %ld",(long)[sender tag]);
        NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
        
       // keyChainLife = [[KeychainItemWrapper alloc] initWithIdentifier:@"elife" accessGroup:nil];
       // NSString *numLife = [keyChainLife objectForKey:(__bridge id)kSecAttrLabel];
       // int retrievedLife = [numLife intValue];

        NSInteger selectedLevel = [sender tag];
         [[NSNotificationCenter defaultCenter]postNotificationName:kReachabilityChangedNotification object:nil];
        BOOL connect=[[NSUserDefaults standardUserDefaults]boolForKey:@"NetworkStatus"];
        int life=(int)[userDefault integerForKey:@"life"];
        if (life>0) {
            
            // BOOL fbCheck = [userDefault boolForKey:FacebookConnected];
             levelno=[NSString stringWithFormat:@"Level %d",[GameState sharedState].levelNumber] ;
            [self createUIBg];
           // NSLog(@"connectio %@",connect);
            NSString *connectedFBID = [userDefault boolForKey:FacebookConnected];
            if (connect) {
                if (!connectedFBID) {
                    [self retriveFriendsRandomScore:selectedLevel];
                }
                else{
                    NSLog(@"Fetched score from parse and display play option");
                    [self retriveBullsEye:selectedLevel];
                    [self retriveFriendsScore:selectedLevel];
                }
            }// if fb check
            else{
                NSLog(@"display Play option with selected level");
                //[self chooseGameScreen];
            }// else fb check
            
        }// if life check
        else{
            NSLog(@"Display game over Scene");
            self.backgroundView.hidden = YES;
            self.friendsView.hidden=YES;
            self.bottomScroll.hidden=YES;
            scrollV.hidden=YES;
            arrowButton.hidden=YES;
            [self removeChild:spriteBackground cleanup:YES];
            [self removeChild:menuBack cleanup:YES];
            [[CCDirector sharedDirector]replaceScene:[LifeOver node]];
        }
    }

    
    

    
    
/*
    if ([sender isKindOfClass:[UIButton class]]) {
        //NSLog(@"Sender Button Tag =-=-=- %ld",(long)[sender tag]);
        NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
        
      //  NSString *life = [userDefault objectForKey:@"life"];
        
        NSInteger selectedLevel = [sender tag];
        //self.life=[[NSUserDefaults standardUserDefaults]integerForKey:@"life"];
        self.life=1;
        NSLog(@"life in levelselection %ld",(long)self.life);
        if (self.life>0) {
            
            // BOOL fbCheck = [userDefault boolForKey:FacebookConnected];
            
            NSString *connectedFBID = [userDefault objectForKey:ConnectedFacebookUserID];
            
            if (connectedFBID) {
                NSLog(@"Fetched score from parse and display play option");
               // [self retriveFriendsScore:selectedLevel andfbid:connectedFBID];
                
                [self retriveFriendsScore:selectedLevel];
                
                NSLog(@"Sender Button Tag =-=-=- %ld",(long)[sender tag]);
                [GameState sharedState].levelNumber=(int)selectedLevel;
                if (selectedLevel ==1) {
                    [[NSUserDefaults standardUserDefaults] setInteger:selectedLevel forKey:@"level"];
                    scrollV.hidden=YES;
                    arrowButton.hidden = YES;
                    [self removeChild:spriteBackground cleanup:YES];
                    [self removeChild:menuBack cleanup:YES];
                    
                    
                    [self createUIBg];
                    
                    //[self chooseGameScreen];
                    
                }
                
                else {
                    int levelNumbers = (int)[[NSUserDefaults standardUserDefaults] integerForKey:@"levelClear"];
                    //            levelNumbers=21;
                    //        for (int k=0; k<=levelNumbers; k++) {
                    
                    if (selectedLevel <= levelNumbers) {
                        [[NSUserDefaults standardUserDefaults] setInteger:selectedLevel forKey:@"level"];
                        scrollV.hidden=YES;
                        arrowButton.hidden=YES;
                        [self removeChild:spriteBackground cleanup:YES];
                        [self removeChild:menuBack cleanup:YES];
                        
                        
                        [self createUIBg];
                        //[self chooseGameScreen];
                        
                        //                [[CCDirector sharedDirector]replaceScene:[CCTransitionFadeTR transitionWithDuration:1.0 scene:[GameMain scene]]];
                    }
                
                
            }
        }// if fb check
            else{
                NSLog(@"Sender Button Tag =-=-=- %ld",(long)[sender tag]);
                [GameState sharedState].levelNumber=(int)selectedLevel;
                if (selectedLevel ==1) {
                    [[NSUserDefaults standardUserDefaults] setInteger:selectedLevel forKey:@"level"];
                    scrollV.hidden=YES;
                    arrowButton.hidden = YES;
                    [self removeChild:spriteBackground cleanup:YES];
                    [self removeChild:menuBack cleanup:YES];
                    
                    
                    [self createUIBg];
                    
                    //[self chooseGameScreen];
                    
                }
                
                else {
                    int levelNumbers = (int)[[NSUserDefaults standardUserDefaults] integerForKey:@"levelClear"];
                    //            levelNumbers=21;
                    //        for (int k=0; k<=levelNumbers; k++) {
                    
                    if (selectedLevel <= levelNumbers) {
                        [[NSUserDefaults standardUserDefaults] setInteger:selectedLevel forKey:@"level"];
                        scrollV.hidden=YES;
                        arrowButton.hidden=YES;
                        [self removeChild:spriteBackground cleanup:YES];
                        [self removeChild:menuBack cleanup:YES];
                        
                        
                        [self createUIBg];
                        //[self chooseGameScreen];
                        
                        //                [[CCDirector sharedDirector]replaceScene:[CCTransitionFadeTR transitionWithDuration:1.0 scene:[GameMain scene]]];
                    }
                }

                
                NSLog(@"display Play option with selected level");
            }// else fb check
            
        }// if life check
        else{
            NSLog(@"Display game over Scene");
            [[CCDirector sharedDirector]replaceScene:[LifeOver node]];
        }

    }
 */
}
#pragma mark-retrive bullsEye

-(void)retriveBullsEye:(NSInteger)selectedLevel
{
    NSString *fbID = [[NSUserDefaults standardUserDefaults] objectForKey:ConnectedFacebookUserID];
    
    PFQuery *query = [PFQuery queryWithClassName:ParseScoreTableName];
    [query whereKey:@"Level" equalTo:[NSNumber numberWithInteger:selectedLevel]];
    [query whereKey:@"PlayerFacebookID" equalTo:fbID];
      dispatch_async(dispatch_get_main_queue(), ^{
    NSArray * arr=[query findObjects];
    if (arr.count<1) {
        return;
    }
    for (int i=0;i<arr.count; i++) {
        PFObject * obj=[arr objectAtIndex:i];
        bullseye= [[obj objectForKey:@"BullsEye"]intValue];
        NSLog(@"bulls eye -==- %d",bullseye);
    }
    
    
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
    
    
    
    
    
    
    if(bullseye<=3){
        goldStar.image =[UIImage imageNamed:@"star_emmpty.png"];
        silverStar.image =[UIImage imageNamed:@"star_emmpty.png"];
        
        bronzeStar.image=[UIImage imageNamed:@"star_red.png"];
        medal.image=[UIImage imageNamed:@"medal_red.png"];
        
    }
    else if (bullseye==4){
        silverStar.image=[UIImage imageNamed:@"star_green.png"];
        bronzeStar.image=[UIImage imageNamed:@"star_red.png"];
        goldStar.image =[UIImage imageNamed:@"star_emmpty.png"];
        medal.image=[UIImage imageNamed:@"medal_green.png"];
    }
    else if(bullseye>=5 ){
        
        silverStar.image=[UIImage imageNamed:@"star_green.png"];
        bronzeStar.image=[UIImage imageNamed:@"star_red.png"];
        goldStar.image=[UIImage imageNamed:@"star_purple.png"];
        medal.image=[UIImage imageNamed:@"medal_purple.png"];
    }
     });
}
#pragma mark- find friends current level

-(void)displayFriendsListUI{
    //rootViewController = (UIViewController*)[(AppDelegate*)[[UIApplication sharedApplication] delegate] getRootViewController];
    
    
    NSMutableArray *mutArr1 = [[NSMutableArray alloc]init];
    mutArr1 =[[NSUserDefaults standardUserDefaults] objectForKey:FacebookGameFrindes];
    if(!self.friendsView)
    {
        self.friendsView=[[UIView alloc]init];
        if([UIScreen mainScreen].bounds.size.height<500)
        {
            self.friendsView.frame=CGRectMake(10, 320, 295, 160);
        }
        else{
            self.friendsView.frame=CGRectMake(10, 400, 295, 160);
        }
        //self.friendsView.backgroundColor=[UIColor colorWithRed:(CGFloat)183/255 green:(CGFloat)222/255 blue:(CGFloat)243/255 alpha:0.7];
        self.friendsView.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"friends_level.png"]];
        self.friendsView.layer.cornerRadius=4;
        self.friendsView.clipsToBounds=YES;
        [rootViewController.view addSubview:self.friendsView];
    }
    self.friendsView.hidden=NO;
    if(!self.bottomScroll)
    {
        self.bottomScroll=[[UIScrollView alloc]init];
        self.bottomScroll.frame=CGRectMake(0, 10, self.friendsView.frame.size.width,self.friendsView.frame.size.height);
        self.bottomScroll.backgroundColor=[UIColor clearColor];
        [self.friendsView addSubview:self.bottomScroll];
    }
    self.bottomScroll.hidden=NO;
    
    self.bottomScroll.contentSize=CGSizeMake(mutArr1.count*70, self.bottomScroll.frame.size.height);
    //    adf = [[AdMobFullScreenViewController alloc]init];
    //    [rootViewController presentViewController:adf animated:YES completion:nil];
}



-(void)findFriendsLevel{
    NSMutableArray *mutArr = [[NSMutableArray alloc]init];
    mutArr =[[NSUserDefaults standardUserDefaults] objectForKey:FacebookGameFrindes];
    NSLog(@"MutArray %@",mutArr);
    if (mutArr.count<1) {
        return;
    }
    
    
    NSMutableArray * level=[[NSMutableArray alloc]init];
    NSMutableArray * name=[[NSMutableArray alloc]init];
    NSMutableArray * Id=[[NSMutableArray alloc]init];
    
    // NSMutableArray * printLevel=[[NSMutableArray alloc]init];
    
    
    //    for (int i=0; i<mutArr.count; i++) {
    //        NSLog(@"%@",mutArr[i]);
    
    //NSSortDescriptor* sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"Level" ascending: YES];
  /*  PFQuery * query=[PFQuery queryWithClassName:ParseScoreTableName];
    [query whereKey:@"PlayerFacebookID" containedIn:mutArr];
    [query orderByDescending:@"Levels"];*/
    
    PFQuery * query=[PFQuery queryWithClassName:ParseScoreTableName];
    [query whereKey:@"PlayerFacebookID" containedIn:mutArr];
    [query orderByDescending:@"Level"];
    
   // [query setSkip:skip];
    
    //  [query whereKey:@"PlayerFacebookID" equalTo:mutArr[i]];
    //[query orderByDescending:@"Level"];
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
       [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
            
        
        NSLog(@"detail of friends %@",objects);
        if (objects.count<1) {
            return ;
        }
        for (int j=0; j<objects.count; j++) {
            PFObject * obj=[objects objectAtIndex:j];
            for(int k=0;k<mutArr.count;k++)
            {
                if(![Id containsObject:obj[@"PlayerFacebookID"]])
                {
                    [level addObject:obj[@"Level"]];
                    [name addObject:obj[@"Name"]];
                    [Id addObject:obj[@"PlayerFacebookID"]];
                }
            }
        }
        if (Id.count<3) {
            self.bottomScroll.contentSize=CGSizeMake(self.bottomScroll.frame.size.width, self.bottomScroll.frame.size.height);
        }
        
        NSLog(@"Level %@",level);
        for(int i=0;i<level.count;i++)
        {
            NSURL *url=[NSURL URLWithString:[NSString stringWithFormat:@"http://graph.facebook.com/%@/picture?type=large",Id[i]]];
            
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                
                UIImageView *aimgeView = (UIImageView*)[self.friendsView viewWithTag:100+i];
                UILabel *label = (UILabel*)[self.friendsView viewWithTag:300+i];
                UILabel *positionLabel=(UILabel*)[self.friendsView viewWithTag:3000+i];
                if (aimgeView == nil) {
                    UIImageView *profileImageView = [[UIImageView alloc] initWithFrame:CGRectMake(20+(i*90), 60, 35, 35)];
                    profileImageView.tag = 100+i;
                    profileImageView.tag = 100+i;
                    profileImageView.layer.borderWidth=2;
                    profileImageView.layer.borderColor=[[UIColor orangeColor]CGColor];
                    
                    [self.bottomScroll addSubview:profileImageView];
                    [profileImageView setImageWithURL:url placeholderImage:[UIImage imageNamed:@"58x58.png"]];
                }
                else{
                    aimgeView.hidden = NO;
                    [aimgeView setImageWithURL:url placeholderImage:[UIImage imageNamed:@"58x58.png"]];
                }
                if (label==nil) {
                    UILabel *infoLabel = [[UILabel alloc] initWithFrame:CGRectMake(10+(i*90), 100, 90, 35)];
                    infoLabel.tag = 300+i;
                    infoLabel.backgroundColor = [UIColor clearColor];
                    infoLabel.font = [UIFont systemFontOfSize:10];
                    infoLabel.numberOfLines = 0;
                    infoLabel.lineBreakMode = NSLineBreakByCharWrapping;
                    infoLabel.text = [NSString stringWithFormat:@"%@",name[i]];
                    [self.bottomScroll addSubview:infoLabel];
                    
                    [infoLabel sizeToFit];
                }
                else{
                    label.hidden = NO;
                    label.text = [NSString stringWithFormat:@"%@",name[i]];
                    [label sizeToFit];
                }
                
                
                if(positionLabel==nil)
                {
                    int sum=0;
                    sum=(int)level[i];
                    sum=sum+1;
                    
                    UILabel * position=[[UILabel alloc] initWithFrame:CGRectMake(35+(i*90), 30, 30, 45)];
                    position.tag = 3000+i;
                    position.textColor = [UIColor orangeColor];
                    position.backgroundColor=[UIColor clearColor];
                    [position setFont:[UIFont fontWithName:@"ShallowGraveBB" size:20]];
                    position.numberOfLines = 0;
                    position.lineBreakMode = NSLineBreakByCharWrapping;
                    position.text = [NSString stringWithFormat:@"%@",[NSString stringWithFormat:@"%@", level[i]]];
                    [self.bottomScroll addSubview:position];
                    
                }
                else
                {
                    positionLabel.hidden=NO;
                    positionLabel.text = [NSString stringWithFormat:@"%@",[NSString stringWithFormat:@"%@", level[i]]];
                    
                    
                }
                
                
            });
        }
           }];
    });
    
    
}

/*- (void)scrollViewDidScrollToTop:(UIScrollView *)scrollView{
    skip=5;
    [self findFriendsLevel];

}*/

#pragma mark- random score
-(void) retriveFriendsRandomScore:(NSInteger)level{
    NSMutableArray *mutArr = [[NSMutableArray alloc]init];
    mutArr =[[NSUserDefaults standardUserDefaults] objectForKey:FacebookGameFrindes];
    // self.arrMutableCopy = [mutArr mutableCopy];
    // if (mutArr.count<1) {
    //    return;
    // }
    NSLog(@"level%ld",(long)level);
    //  NSString *fbID = [[NSUserDefaults standardUserDefaults] objectForKey:ConnectedFacebookUserID];
    //  NSArray *allAry = [mutArr arrayByAddingObject:[NSString stringWithFormat:@"%@",fbID]];
    /* PFQuery *query = [PFQuery queryWithClassName:ParseScoreTableName];
     [query whereKey:@"Level" equalTo:[NSString stringWithFormat:@"%ld",(long)levelSelected]];
     [query whereKey:@"PlayerFacebookID" containedIn:allAry];
     [query orderByDescending:@"Score"];*/
    
    PFQuery *query = [PFQuery queryWithClassName:ParseScoreTableName];
    [query whereKey:@"Level" equalTo:[NSNumber numberWithInteger:level]];
    //[query whereKey:@"PlayerFacebookID" containedIn:mutArr];
    [query orderByDescending:@"Score"];
    query.limit=3;
    for (UIView *subView in [self.bottomview1 subviews]){
        subView.hidden = YES;
    }
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        
        NSArray *ary = [query findObjects];
        
        [GameState sharedState].friendsScoreInfoArray = [NSArray arrayWithArray:ary];
        
        NSLog(@"Ary == %@",ary);
        
        // CGFloat y = 60;
        for (int i =0; i<ary.count; i++) {
            // NSLog(@"count %d",ary[i]);
            
            if (i ==3) {
                break;
                //self.bottomScroll.contentSize=CGSizeMake(self.bottomScroll.frame.size.width, self.bottomScroll.frame.size.height);
            }
            PFObject *obj = [ary objectAtIndex:i];
            NSLog(@"PFOBJEct -==- %@",obj);
            
            NSNumber *score_saved = obj[@"Score"];
            
            NSString *player1 = obj[@"PlayerFacebookID"];
            NSString * name=obj[@"Name"];
            NSURL *url=[NSURL URLWithString:[NSString stringWithFormat:@"http://graph.facebook.com/%@/picture?type=large",player1]];
            //
            //            NSString *urlString = [NSString   stringWithFormat:@"https://graph.facebook.com/%@",player1];
            //            //for name
            //            NSString *name = [self forName:urlString];
            if (mutArr.count<5) {
                self.bottomScroll.contentSize=CGSizeMake(self.bottomScroll.frame.size.width, self.bottomScroll.frame.size.height);
            }
            
            
            dispatch_async(dispatch_get_main_queue(), ^{
                UIImageView *aimgeView = (UIImageView*)[self.bottomview1 viewWithTag:100+i];
                UILabel *label = (UILabel*)[self.bottomview1 viewWithTag:300+i];
                UILabel *positionLabel=(UILabel*)[self.bottomview1 viewWithTag:3000+i];
                if (aimgeView == nil) {
                    UIImageView *profileImageView = [[UIImageView alloc] initWithFrame:CGRectMake(20+(i*90), 70, 35, 35)];
                    profileImageView.tag = 100+i;
                    profileImageView.tag = 100+i;
                    profileImageView.layer.borderWidth=2;
                    profileImageView.layer.borderColor=[[UIColor orangeColor]CGColor];
                    
                    [self.bottomview1 addSubview:profileImageView];
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
                    infoLabel.text = [NSString stringWithFormat:@"%@\n%@",name,score_saved];
                    [self.bottomview1 addSubview:infoLabel];
                    
                    [infoLabel sizeToFit];
                }
                else{
                    label.hidden = NO;
                    label.text = [NSString stringWithFormat:@"%@\n%@",name,score_saved];
                    [label sizeToFit];
                }
                if(positionLabel==nil)
                {
                    UILabel * position=[[UILabel alloc] initWithFrame:CGRectMake(35+(i*90), 38, 30, 45)];
                    position.tag = 3000+i;
                    position.textColor = [UIColor orangeColor];
                    position.backgroundColor=[UIColor clearColor];
                    [position setFont:[UIFont fontWithName:@"ShallowGraveBB" size:20]];
                    position.numberOfLines = 0;
                    position.lineBreakMode = NSLineBreakByCharWrapping;
                    position.text = [NSString stringWithFormat:@"%d",i+1];
                    [self.bottomview1 addSubview:position];
                    
                }
                else
                {
                    positionLabel.hidden=NO;
                    positionLabel.text = [NSString stringWithFormat:@"%d",i+1];
                    
                    
                }
                
            });
            
        }
        
    });
    
}


//------------------
-(void) retriveFriendsScore:(NSInteger)levelSelected {
    
    NSMutableArray *mutArr = [[NSMutableArray alloc]init];
    mutArr =[[NSUserDefaults standardUserDefaults] objectForKey:FacebookGameFrindes];
    // self.arrMutableCopy = [mutArr mutableCopy];
   // if (mutArr.count<1) {
    //    return;
   // }
    NSLog(@"level%ld",(long)levelSelected);
    NSString *fbID = [[NSUserDefaults standardUserDefaults] objectForKey:ConnectedFacebookUserID];
    NSArray *allAry = [mutArr arrayByAddingObject:[NSString stringWithFormat:@"%@",fbID]];
   /* PFQuery *query = [PFQuery queryWithClassName:ParseScoreTableName];
    [query whereKey:@"Level" equalTo:[NSString stringWithFormat:@"%ld",(long)levelSelected]];
    [query whereKey:@"PlayerFacebookID" containedIn:allAry];
    [query orderByDescending:@"Score"];*/
   
    PFQuery *query = [PFQuery queryWithClassName:ParseScoreTableName];
    [query whereKey:@"Level" equalTo:[NSNumber numberWithInteger:levelSelected]];
    [query whereKey:@"PlayerFacebookID" containedIn:allAry];
    [query orderByDescending:@"Score"];
    
    for (UIView *subView in [self.bottomview1 subviews]){
        subView.hidden = YES;
    }
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        
        NSArray *ary = [query findObjects];
             
        [GameState sharedState].friendsScoreInfoArray = [NSArray arrayWithArray:ary];
        
        NSLog(@"Ary == %@",ary);
        
       // CGFloat y = 60;
        for (int i =0; i<ary.count; i++) {
            // NSLog(@"count %d",ary[i]);
            
            if (i == 3) {
                break;
            }
            PFObject *obj = [ary objectAtIndex:i];
            NSLog(@"PFOBJEct -==- %@",obj);
            
            NSNumber *score_saved = obj[@"Score"];
            
            NSString *player1 = obj[@"PlayerFacebookID"];
            NSString * name=obj[@"Name"];
            NSURL *url=[NSURL URLWithString:[NSString stringWithFormat:@"http://graph.facebook.com/%@/picture?type=large",player1]];
//            
//            NSString *urlString = [NSString   stringWithFormat:@"https://graph.facebook.com/%@",player1];
//            //for name
//            NSString *name = [self forName:urlString];
            
            
            dispatch_async(dispatch_get_main_queue(), ^{
                UIImageView *aimgeView = (UIImageView*)[self.bottomview1 viewWithTag:100+i];
                UILabel *label = (UILabel*)[self.bottomview1 viewWithTag:300+i];
                UILabel *positionLabel=(UILabel*)[self.bottomview1 viewWithTag:3000+i];
                if (aimgeView == nil) {
                    UIImageView *profileImageView = [[UIImageView alloc] initWithFrame:CGRectMake(20+(i*90), 70, 35, 35)];
                    profileImageView.tag = 100+i;
                    profileImageView.tag = 100+i;
                    profileImageView.layer.borderWidth=2;
                    profileImageView.layer.borderColor=[[UIColor orangeColor]CGColor];
                   
                    [self.bottomview1 addSubview:profileImageView];
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
                    infoLabel.text = [NSString stringWithFormat:@"%@\n%@",name,score_saved];
                    [self.bottomview1 addSubview:infoLabel];
                    
                     [infoLabel sizeToFit];
                }
                else{
                    label.hidden = NO;
                    label.text = [NSString stringWithFormat:@"%@\n%@",name,score_saved];
                     [label sizeToFit];
                }
                if(positionLabel==nil)
                {
                    UILabel * position=[[UILabel alloc] initWithFrame:CGRectMake(35+(i*90), 38, 30, 45)];
                    position.tag = 3000+i;
                    position.textColor = [UIColor orangeColor];
                    position.backgroundColor=[UIColor clearColor];
                    [position setFont:[UIFont fontWithName:@"ShallowGraveBB" size:20]];
                    position.numberOfLines = 0;
                    position.lineBreakMode = NSLineBreakByCharWrapping;
                    position.text = [NSString stringWithFormat:@"%d",i+1];
                    [self.bottomview1 addSubview:position];
                    
                }
                else
                {
                    positionLabel.hidden=NO;
                    positionLabel.text = [NSString stringWithFormat:@"%d",i+1];
                    
                    
                }
                
            });
            
        }
        
    });
    //        NSString *strLevel = [NSString stringWithFormat:@"%d",level];
}

/*-(void) retriveFriendsScore:(NSInteger)levelT {
    
    NSMutableArray *mutArr = [[NSMutableArray alloc]init];
    mutArr =[[NSUserDefaults standardUserDefaults] objectForKey:FacebookGameFrindes];
    
    PFQuery *query = [PFQuery queryWithClassName:ParseScoreTableName];
    query.limit = 5;
    [query whereKey:@"Level" equalTo:[NSString stringWithFormat:@"%d",levelT]];
    [query whereKey:@"PlayerFacebookID" containedIn:mutArr];
    [query orderByDescending:@"Score"];
    
    for (UIView *subView in [self.bottomview1 subviews]){
        subView.hidden = YES;
    }
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        
        NSArray *ary = [query findObjects];
        [GameState sharedState].friendsScoreInfoArray = [NSArray arrayWithArray:ary];
//        CGFloat x = 20;
//        CGFloat y = 10;
        for (int i =0; i<ary.count; i++) {
            // NSLog(@"count %d",ary[i]);
            
            if (i == 3) {
                break;
            }
            PFObject *obj = [ary objectAtIndex:i];
            NSLog(@"PFOBJEct -==- %@",obj);
            
            NSNumber *score = obj[@"Score"];
            NSString *name = obj[@"Name"];
            NSString *player1 = obj[@"PlayerFacebookID"];
            NSURL *url=[NSURL URLWithString:[NSString stringWithFormat:@"http://graph.facebook.com/%@/picture?type=large",player1]];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                UIImageView *aimgeView = (UIImageView*)[self.bottomview1 viewWithTag:100+i];
                UILabel *label = (UILabel*)[self.bottomview1 viewWithTag:300+i];
                UILabel * positionLabel=(UILabel *)[self.bottomview1 viewWithTag:3000+i];
                
                if (aimgeView == nil) {
                    UIImageView *profileImageView = [[UIImageView alloc] initWithFrame:CGRectMake(20+(i*90), 70, 35, 35)];
                    profileImageView.tag = 100+i;
                    [self.bottomview1 addSubview:profileImageView];
                    [profileImageView setImageWithURL:url placeholderImage:[UIImage imageNamed:@"58x58.png"]];
                    //profileImageView.image = [UIImage imageNamed:@"58x58.png"];

                }
                else{
                    aimgeView.hidden = NO;
                    [aimgeView setImageWithURL:url placeholderImage:[UIImage imageNamed:@"58x58.png"]];
                    //aimgeView.image = [UIImage imageNamed:@"58x58.png"];
                }
                
                if (label==nil) {
                    UILabel *infoLabel = [[UILabel alloc] initWithFrame:CGRectMake(10+(i*90), 110, 90, 35)];
                    infoLabel.tag = 300+i;
                    infoLabel.backgroundColor = [UIColor clearColor];
                    infoLabel.font = [UIFont systemFontOfSize:10];
                    infoLabel.numberOfLines = 0;
                    infoLabel.textAlignment = NSTextAlignmentLeft;
                    infoLabel.lineBreakMode = NSLineBreakByCharWrapping;
                    infoLabel.text = [NSString stringWithFormat:@"%@\n%@",name,score];
                    [self.bottomview1 addSubview:infoLabel];
                    
                    [infoLabel sizeToFit];
                }
                else{
                    label.hidden = NO;
                    label.text = [NSString stringWithFormat:@"%@\n%@",name,score];
                    [label sizeToFit];
                }
                if(positionLabel==nil)
                {
                    UILabel * position=[[UILabel alloc] initWithFrame:CGRectMake(35+(i*90), 38, 30, 45)];
                    position.tag = 3000+i;
                    position.textColor = [UIColor orangeColor];
                    [position setFont:[UIFont fontWithName:@"ShallowGraveBB" size:20]];
                    position.numberOfLines = 0;
                    position.lineBreakMode = NSLineBreakByCharWrapping;
                    position.text = [NSString stringWithFormat:@"%d",i+1];
                    [self.bottomview1 addSubview:position];
                    
                }
                else
                {
                    positionLabel.hidden=NO;
                    positionLabel.text = [NSString stringWithFormat:@"%d",i+1];
                    
                    
                }
                

                
            });
            
        }
    });
    //        NSString *strLevel = [NSString stringWithFormat:@"%d",level];
}
*/

/*
-(void)btnAction:(id)sender {
    
    if ([sender isKindOfClass:[UIButton class]]) {
        NSLog(@"Sender Button Tag =-=-=- %ld",(long)[sender tag]);
        [GameState sharedState].levelNumber=(int)[sender tag];
        if ([sender tag] ==1) {
            [[NSUserDefaults standardUserDefaults] setInteger:[sender tag] forKey:@"level"];
            scrollV.hidden=YES;
            arrowButton.hidden = YES;
           // [self removeChild:spriteBackground cleanup:YES];
            [self removeChild:menuBack cleanup:YES];
            
         
                 [self createUI];

            //[self chooseGameScreen];
          
        }

        else {
        int levelNumbers = (int)[[NSUserDefaults standardUserDefaults] integerForKey:@"levelClear"];
//            levelNumbers=21;
//        for (int k=0; k<=levelNumbers; k++) {
            
            if ([sender tag] <= levelNumbers) {
                [[NSUserDefaults standardUserDefaults] setInteger:[sender tag] forKey:@"level"];
                scrollV.hidden=YES;
                arrowButton.hidden=YES;
                //[self removeChild:spriteBackground cleanup:YES];
                [self removeChild:menuBack cleanup:YES];
                

                    [self createUI];
                    //[self chooseGameScreen];
                
//                [[CCDirector sharedDirector]replaceScene:[CCTransitionFadeTR transitionWithDuration:1.0 scene:[GameMain scene]]];
            }
            else{
//                 [[[UIAlertView alloc]initWithTitle:@"" message:@"Unlock Level" delegate:nil cancelButtonTitle:@"Cancel" otherButtonTitles: nil] show];
            }
 
            if (k==[sender tag]) {
                [[NSUserDefaults standardUserDefaults] setInteger:[sender tag] forKey:@"level"];
                scrollV.hidden=YES;
                [[CCDirector sharedDirector]replaceScene:[CCTransitionFadeTR transitionWithDuration:1.0 scene:[GameMain scene:self.checkMusic]]];
                
                return;
            }
            else{
                [[[UIAlertView alloc]initWithTitle:@"" message:@"Unlock Level" delegate:nil cancelButtonTitle:@"Cancel" otherButtonTitles: nil] show];
            }
        }
        }
             */
        /*
        NSMutableArray *arrClearLevels = [[NSUserDefaults standardUserDefaults] objectForKey:@"levelClear"];
    
        if ([sender tag] ==1) {
            [[NSUserDefaults standardUserDefaults] setInteger:[sender tag] forKey:@"level"];
            scrollV.hidden=YES;
            [[CCDirector sharedDirector]replaceScene:[CCTransitionFadeTR transitionWithDuration:1.0 scene:[GameMain scene:self.checkMusic]]];
        }
        
        else{
        for (int k=0; k<[arrClearLevels count]; k++) {
            
            NSString *str = [arrClearLevels objectAtIndex:k];
            
            int level = [str integerValue];
            
            if (level==[sender tag]) {
                [[NSUserDefaults standardUserDefaults] setInteger:[sender tag] forKey:@"level"];
                scrollV.hidden=YES;
                [[CCDirector sharedDirector]replaceScene:[CCTransitionFadeTR transitionWithDuration:1.0 scene:[GameMain scene:self.checkMusic]]];
            }
            else{
                [[[UIAlertView alloc]initWithTitle:@"" message:@"Unlock Level" delegate:nil cancelButtonTitle:@"Cancel" otherButtonTitles: nil] show];
            }
        }
        }
         */
    //}
   // }
   // else
      //  return;
//}
#pragma  mark-  alert view delegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
 if (buttonIndex==0) {
 [Chartboost showRewardedVideo:CBLocationStartup];
     self.backgroundView.hidden = YES;
 [[CCDirector sharedDirector]replaceScene:[LevelSelectionScene node]];
 }
}

#pragma mark -
#pragma mark Down And Up Button Action
-(void) downButtonClicked:(id)sender{
    NSLog(@"down button clicked");
    //NSLog(@"Current == %d",currentContentOffsetHeight);
    
    if (currentContentOffsetHeight<241) {
        currentContentOffsetHeight = currentContentOffsetHeight+30;
    }
    
    [scrollV setContentOffset:CGPointMake(0, currentContentOffsetHeight) animated:YES];
}
#pragma mark Scrollview Delegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    NSLog(@"Scrolling");
    CGPoint offset = scrollView.contentOffset;
    CGRect bounds = scrollView.bounds;
    CGSize size = scrollView.contentSize;
    UIEdgeInsets inset = scrollView.contentInset;
    float y = offset.y + bounds.size.height - inset.bottom;
    float h = size.height;
    NSLog(@"y = %f", y);
    NSLog(@"h = %f", h);
    
    NSLog(@"hoff= %f",offset.y);
    
    if (offset.y>240) {
        currentContentOffsetHeight = 240;
    }
    else if (offset.y<0){
        currentContentOffsetHeight = 0;
    }
    else{
        currentContentOffsetHeight = offset.y;
    }
    
    
    if (y<250) {
        currentContentOffsetHeight = 0;
    }
}


#pragma mark -
-(void)compareDate {
    
    NSString *strDate = [[NSUserDefaults standardUserDefaults] objectForKey:@"currentDate"];
    
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
    
}

-(void)getExtraLife :(int)day andHour:(int)hour andMin:(int)min andSec:(int)sec {
    
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    int hoursInMin = hour*60;
    hoursInMin=hoursInMin+min;
    
    int totalTime = min*60+sec;
    
    int life1 = (int)[userDefault integerForKey:@"life"];
    NSLog(@"life1 %d",life1);
    int rem =min%5;
    
    int remTimeforLife = rem*60+sec;
    
    remTimeforLife=300-remTimeforLife;
    
    [userDefault setInteger:remTimeforLife forKey:@"timeRem"];
    [userDefault synchronize];
    
    
    
    if (day>0 || hoursInMin>=25) {
        [userDefault setInteger:5 forKey:@"life"];
        [userDefault setObject:@"0" forKey:@"currentDate"];
    }
    //    else if(totalTime>=1800){
    //        int extralife =min/30;
    else if(totalTime>=300){
        //int extralife =min/5;
       // NSLog(@"extralife in %d",extralife);
        if(life1>=5){
            [userDefault setInteger:5 forKey:@"life"];
            [userDefault setObject:@"0" forKey:@"currentDate"];
        }
      /*  if (life1<5) {
            if (extralife>5) {
                extralife = 5;
            }
            */
            //[userDefault setInteger:extralife forKey:@"life"];
        //}
        
    }
    else{
        //int extralife =min/5;
     //   NSLog(@"extralife in levelselection %d",extralife);
        [userDefault setInteger:life1 forKey:@"life"];
    }
    [userDefault synchronize];
}

@end
