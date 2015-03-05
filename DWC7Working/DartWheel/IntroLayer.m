//
//  IntroLayer.m
//  PresentStacker
//
//  Created by tang on 12-7-12.
//  Copyright __MyCompanyName__ 2012年. All rights reserved.
//


// Import the interfaces
#import "IntroLayer.h"
#import "GameMain.h"
#import "AppDelegate.h"
#import "cocos2d.h"
#import <Parse/Parse.h>
#import "LevelSelectionScene.h"
//#import <RevMobAds/RevMobAds.h>
#import "Store.h"
#import "HintSprite.h"
#import "AppDelegate.h"
#import "AdMobViewController.h"
#import "FriendsViewController.h"
#import "InviteViewController.h"

#import <FacebookSDK/FacebookSDK.h>


#pragma mark - IntroLayer

// HelloWorldLayer implementation
@implementation IntroLayer

// Helper class method that creates a Scene with the HelloWorldLayer as the only child.
+(CCScene *) scene
{
	// 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
	
	// 'layer' is an autorelease object.
	IntroLayer *layer = [[IntroLayer alloc] init];
	
	// add layer as a child to scene
	[scene addChild: layer];
	
	// return the scene
	return scene;
}

-(id)init{
    playButton=YES;
    if (self=[super init]){
         [[NSNotificationCenter defaultCenter]postNotificationName:kReachabilityChangedNotification object:nil];
        BOOL connect=[[NSUserDefaults standardUserDefaults]boolForKey:@"NetworkStatus"];
        if(connect)
        {
            
           /* if (adm) {
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
            [[[CCDirector sharedDirector] openGLView] addSubview:viewHost1];*/
            
            [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(loginSuccess) name:@"LogginSuccess" object:nil];

            [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(loginFail) name:@"LogginFail" object:nil];
//            rootViewController = (UIViewController*)[(AppDelegate*)[[UIApplication sharedApplication] delegate] getRootViewController];
//            adf = [[AdMobFullScreenViewController alloc]init];
//            [rootViewController presentViewController:adf animated:YES completion:nil];
                           // rootViewController = (UIViewController*)[(AppDelegate*)[[UIApplication sharedApplication] delegate] getRootViewController];
                //adf = [[AdMobFullScreenViewController alloc]init];
                //[rootViewController presentViewController:adf animated:YES completion:nil];;
            
          /*  if (adm) {
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
        [[[CCDirector sharedDirector] openGLView] addSubview:viewHost1];*/
        }
        
        CCSprite *background;
        
        if ([UIScreen mainScreen].bounds.size.height>500) {
            background = [CCSprite spriteWithFile:@"mainscreeniPhone5.png"];
        }
        else {
            background = [CCSprite spriteWithFile:@"mainscreen.png"];
        }
        
        //background.position = ccp(size.width/2, size.height/2);
        background.anchorPoint=ccp(0,0);
        // add the label as a child to this Layer
        [self addChild: background];
        
        CCMenuItem *menuItemPlay = [CCMenuItemImage itemFromNormalImage:@"play.png" selectedImage:@"play.png" target:self selector:@selector(playButtonAction)];
        
        CCMenu *menuPlay = [CCMenu menuWithItems:menuItemPlay, nil];
        [self addChild:menuPlay];
        
        CCMenuItem * contestBtn=[CCMenuItemImage itemFromNormalImage:@"join_contest.png" selectedImage:@"join_contest.png" target:self selector:@selector(contestButtonAction)];
        CCMenu * menuContest=[CCMenu menuWithItems:contestBtn, nil];
        [self addChild:menuContest];
        
        
        CCMenuItem *menuItemStore = [CCMenuItemImage itemFromNormalImage:@"Store.png" selectedImage:@"Store.png" target:self selector:@selector(storeButtonAction)];
        
        CCMenu *menuStore = [CCMenu menuWithItems:menuItemStore, nil];
        [self addChild:menuStore];
        
        CCMenuItem *menuItemHint = [CCMenuItemImage itemFromNormalImage:@"Hint.png" selectedImage:@"Hint.png" target:self selector:@selector(hintButtonAction)];
        
        CCMenu *menuHint = [CCMenu menuWithItems:menuItemHint, nil];
        [self addChild:menuHint];
        
        if([UIScreen mainScreen].bounds.size.height<500) {
            menuContest.position=ccp(160, 30);
            menuPlay.position=ccp(170, 180);
            menuStore.position=ccp(270, 130);
            menuHint.position=ccp(95, 130);
        }
        else{
             menuContest.position=ccp(160, 240);
            menuPlay.position=ccp(170, 180);
            menuStore.position=ccp(270, 130);
            menuHint.position=ccp(95, 130);
        }
        //---------------------------------------
        //BOOL connect=[[NSUserDefaults standardUserDefaults]boolForKey:@"NetworkStatus"];
        
            if (self.connectWithFB) {
                self.connectWithFB=nil;
            }
            self.connectWithFB=[CCMenuItemImage itemFromNormalImage:@"connect.png" selectedImage:@"connect.png" target:self selector:@selector(connectwithFacebook)];
            
            self.connectWithFB=[CCMenu menuWithItems:self.connectWithFB, nil];
            if([UIScreen mainScreen].bounds.size.height<500) {
                self.connectWithFB.position=ccp(165, 70);
            }
            else{
                self.connectWithFB.position=ccp(165, 90);
            }
            [self addChild:self.connectWithFB];
        
     
       
            if (self.inviteFriend) {
                self.inviteFriend=nil;
            }
            self.inviteFriend=[CCMenuItemImage itemFromNormalImage:@"logout.png" selectedImage:@"logout.png" target:self selector:@selector(LogoutFriendButtonAction)];
            self.inviteFriend=[CCMenu menuWithItems:self.inviteFriend, nil];
            if([UIScreen mainScreen].bounds.size.height<500) {
                self.inviteFriend.position=ccp(170, 70);
            }
            else{
                self.inviteFriend.position=ccp(170, 90);
                
            }
            [self addChild:self.inviteFriend];
        
//        BOOL connect1=[[NSUserDefaults standardUserDefaults]boolForKey:@"NetworkStatus"];
//        if(connect1)
//        {

        BOOL fbCheck=[[NSUserDefaults standardUserDefaults]boolForKey:FacebookConnected];
      //  if (fbCheck==NO){
        if (!FBSession.activeSession.isOpen)
        {
            
             [[NSUserDefaults standardUserDefaults] setBool:NO forKey :FacebookConnected];
            self.connectWithFB.visible=YES;
            self.inviteFriend.visible=NO;
        }
        else{
            self.connectWithFB.visible=NO;
            self.inviteFriend.visible=YES;
        }
       // }
       /* else{
            self.connectWithFB.visible=NO;
            self.inviteFriend.visible=NO;
        }*/

    
        /*CCMenuItem *facebookLogin = [CCMenuItemImage itemFromNormalImage:@"connect.png"
                                                           selectedImage:@"connect.png"
                                                                  target:nil
                                                                selector:nil];
        
        
        CCMenuItem *facebookLogout = [CCMenuItemImage itemFromNormalImage:@"logout.png"
                                                            selectedImage:@"logout.png"
                                                                   target:nil
                                                                 selector:nil];*/
        
        //BOOL FBConnected = [[NSUserDefaults standardUserDefaults] boolForKey:FacebookConnected];
       // if (FBConnected==YES) {
         //   self.fbToggle = [CCMenuItemToggle itemWithTarget:self
                                                   // selector:@selector(fbButtonTapped:)
                                                  //     items: facebookLogout,facebookLogin, nil];
            
       // }
       // else{
        
       // self.fbToggle = [CCMenuItemToggle itemWithTarget:self
                                             //   selector:@selector(fbButtonTapped:)
                                               //    items:facebookLogin, facebookLogout, //nil];
            
            // self.fbToggle.selectedIndex=1;
       // }
     // CCMenu *  connectWithFB=[CCMenu menuWithItems:self.fbToggle, nil];
        
      //  if([UIScreen mainScreen].bounds.size.height<500){
            //connectWithFB.position=ccp(165, 70);
      //  }else{
      //      connectWithFB.position=ccp(165, 90);
      //  }
       // [self addChild:connectWithFB];
    

    
    
    
      /*  BOOL FBConnected = [[NSUserDefaults standardUserDefaults] boolForKey:FacebookConnected];
        if (FBConnected==NO) {
            if (self.connectWithFB) {
                self.connectWithFB=nil;
            }
            self.connectWithFB=[CCMenuItemImage itemFromNormalImage:@"connect.png" selectedImage:@"connect.png" target:self selector:@selector(connectwithFacebook:)];
            
            self.connectWithFB=[CCMenu menuWithItems:self.connectWithFB, nil];
            if([UIScreen mainScreen].bounds.size.height<500) {
                self.connectWithFB.position=ccp(165, 70);
            }
            else{
                self.connectWithFB.position=ccp(165, 90);
            }
            [self addChild:self.connectWithFB];
        }
        else{
        if (self.inviteFriend) {
            self.inviteFriend=nil;
        }
        self.inviteFriend=[CCMenuItemImage itemFromNormalImage:@"logout.png" selectedImage:@"logout.png" target:self selector:@selector(LogoutFriendButtonAction:)];
        self.inviteFriend=[CCMenu menuWithItems:self.inviteFriend, nil];
        if([UIScreen mainScreen].bounds.size.height<500) {
            self.inviteFriend.position=ccp(170, 70);
        }
        else{
            self.inviteFriend.position=ccp(170, 90);
            
        }
        [self addChild:self.inviteFriend];
    }
        */
        
    
    }
    
    return self;
}

#pragma mark-Contest action 
-(void)contestButtonAction{
    NSLog(@"Contest button clicked");
}

-(void)loginSuccess{
    self.connectWithFB.visible=NO;
    self.inviteFriend.visible=YES;
}
-(void)loginFail{
    self.connectWithFB.visible=YES;
    self.inviteFriend.visible=NO;
}

#pragma  mark-invite facebook friends

-(void) fbButtonTapped: (id) sender
{
      BOOL FBConnected = [[NSUserDefaults standardUserDefaults] boolForKey:FacebookConnected];
    
    
    if ((self.fbToggle.selectedIndex==1)&& FBConnected==NO) {
        NSLog(@"Sound button tapped!");
        [self connectwithFacebook];
        self.fbToggle.selectedIndex=0;
    }else{
        
        [self LogoutFriendButtonAction];
        self.fbToggle.selectedIndex=1;
        
    }
    
}


-(void)LogoutFriendButtonAction{
    
    [[NSNotificationCenter defaultCenter]postNotificationName:kReachabilityChangedNotification object:nil];
    BOOL connect=[[NSUserDefaults standardUserDefaults]boolForKey:@"NetworkStatus"];
    if(connect)
    {

    BOOL FBConnected = [[NSUserDefaults standardUserDefaults] boolForKey:FacebookConnected];
    if (FBConnected) {
       
        self.connectWithFB.visible=YES;
        self.inviteFriend.visible=NO;
        
        if (FBSession.activeSession.isOpen) {
            [FBSession.activeSession closeAndClearTokenInformation];
            [FBSession.activeSession close];
            [FBSession setActiveSession:nil];
           
            //[[NSUserDefaults standardUserDefaults]setBool:NO forKey:@"clearLevel"];
          
           
            
        }
        [[NSUserDefaults standardUserDefaults]setBool:NO forKey:FacebookConnected];
        [[NSUserDefaults standardUserDefaults]synchronize];
        
    }
    }

    else{
        self.connectWithFB.visible=NO;
        self.inviteFriend.visible=YES;
        UIAlertView *alert =[[UIAlertView alloc] initWithTitle:@"There is no Internet Connection in your device" message:@"Check Internet ConnectionFirst" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
    }
}


/*-(void) gotoFriendsView{
    
    AppDelegate * appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    appDelegate.delegate = nil;
    RootViewController *viewCntrler = (RootViewController*)[appDelegate getRootViewController];
    CGRect frame = [UIScreen mainScreen].bounds;
    if (!self.invite) {
        self.invite = [[[InviteViewController alloc] initWithHeaderTitle:@"Invite Friends"] autorelease];
        [self.invite updateFriendsView];
        //WithNibName:@"FriendsViewController" bundle:nil];
    }
    else{
        [self.invite updateFriendsView];
    }
    //self.invite.delegate =self;
    NSArray *frndsListArray = [[NSUserDefaults standardUserDefaults] objectForKey:FacebookInviteFriends];
    NSLog(@"frnds = %@",frndsListArray);
    self.fbFrnds.friendListArray = [NSArray arrayWithArray:frndsListArray];
   // self.fbFrnds.isLifeRequest = NO;
    self.fbFrnds.view.frame = CGRectMake(0, 0, frame.size.height, 0);
    
    //fbFrnds.headerTitle = @"Ask Life";
    [UIView animateWithDuration:1 animations:^{
        
        self.fbFrnds.view.frame = CGRectMake(0, 0, frame.size.height, frame.size.width);
        [viewCntrler presentViewController:self.fbFrnds animated:YES completion:nil];
        //[viewCntrler.view addSubview:fbFrnds.view];
    }];

}*/

-(void) gotoFriendsView{
    
    AppDelegate * appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    appDelegate.delegate = nil;
    RootViewController *viewCntrler = (RootViewController*)[appDelegate getRootViewController];
    CGRect frame = [UIScreen mainScreen].bounds;
    if (!self.fbFrnds) {
        self.fbFrnds = [[[FriendsViewController alloc] initWithHeaderTitle:@"Invite Friends"] autorelease];
       // [self.fbFrnds updateFriendsView];
        //WithNibName:[@"FriendsViewController" bundle:nil];
    }
    else{
       // [self.fbFrnds updateFriendsView];
    }
    //self.invite.delegate =self;
    NSArray *frndsListArray = [[NSUserDefaults standardUserDefaults] objectForKey:FacebookInviteFriends];
    NSLog(@"frnds = %@",frndsListArray);
    self.fbFrnds.friendListArray = [NSArray arrayWithArray:frndsListArray];
     //self.fbFrnds.isLifeRequest = NO;
    self.fbFrnds.view.frame = CGRectMake(0, 0, frame.size.height, 0);
    
    //fbFrnds.headerTitle = @"Ask Life";
    [UIView animateWithDuration:1 animations:^{
        
        self.fbFrnds.view.frame = CGRectMake(0, 0, frame.size.height, frame.size.width);
        [viewCntrler presentViewController:self.fbFrnds animated:YES completion:nil];
        //[viewCntrler.view addSubview:fbFrnds.view];
    }];
    
}


/*-(void) gotoFriendsView{
    
    AppDelegate * appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    appDelegate.delegate = nil;
    RootViewController *viewCntrler = (RootViewController*)[appDelegate getRootViewController];
    CGRect frame = [UIScreen mainScreen].bounds;
    FriendsViewController *fbFrnds = [[FriendsViewController alloc] initWithHeaderTitle:@"Invite Friend"];//WithNibName:@"FriendsViewController" bundle:nil];
    fbFrnds.view.frame = CGRectMake(0, 0, frame.size.height, 0);
    fbFrnds.isLifeRequest=YES;
    //fbFrnds.headerTitle = @"Ask Life";
    [UIView animateWithDuration:1 animations:^{
        
        fbFrnds.view.frame = CGRectMake(0, 0, frame.size.height, frame.size.width);
        [viewCntrler presentViewController:fbFrnds animated:YES completion:nil];
        //[viewCntrler.view addSubview:fbFrnds.view];
    }];
}*/




//
/*
-(void) onEnter
{
	[super onEnter];
 
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

	// ask director for the window size
	//CGSize size = [[CCDirector sharedDirector] winSize];

	CCSprite *background;
    
    if ([UIScreen mainScreen].bounds.size.height>500) {
        background = [CCSprite spriteWithFile:@"mainscreeniPhone5.png"];
    }
    else {
        background = [CCSprite spriteWithFile:@"mainscreen.png"];
    }
	
    //background.position = ccp(size.width/2, size.height/2);
    background.anchorPoint=ccp(0,0);
	// add the label as a child to this Layer
	[self addChild: background];
    
    CCMenuItem *menuItemPlay = [CCMenuItemImage itemFromNormalImage:@"play.png" selectedImage:@"play.png" target:self selector:@selector(playButtonAction)];
    
    CCMenu *menuPlay = [CCMenu menuWithItems:menuItemPlay, nil];
    [self addChild:menuPlay];
    
    CCMenuItem *menuItemStore = [CCMenuItemImage itemFromNormalImage:@"Store.png" selectedImage:@"Store.png" target:self selector:@selector(storeButtonAction)];
    
    CCMenu *menuStore = [CCMenu menuWithItems:menuItemStore, nil];
    [self addChild:menuStore];
    
    CCMenuItem *menuItemHint = [CCMenuItemImage itemFromNormalImage:@"Hint.png" selectedImage:@"Hint.png" target:self selector:@selector(hintButtonAction)];
    
    CCMenu *menuHint = [CCMenu menuWithItems:menuItemHint, nil];
    [self addChild:menuHint];
    
    if([UIScreen mainScreen].bounds.size.height<500) {
        
        menuPlay.position=ccp(170, 140);
        menuStore.position=ccp(270, 105);
        menuHint.position=ccp(95, 90);
    }
    else{
        menuPlay.position=ccp(170, 140);
        menuStore.position=ccp(270, 105);
        menuHint.position=ccp(95, 90);
    }
    
    //---------------------------------------
    //Connect with Facebook
    
    BOOL FBConnected = [[NSUserDefaults standardUserDefaults] boolForKey:FacebookConnected];
    if (FBConnected==NO) {
        self.connectWithFB=[CCMenuItemImage itemFromNormalImage:@"connect.png" selectedImage:@"connect.png" target:self selector:@selector(connectwithFacebook:)];
        
        self.connectWithFB=[CCMenu menuWithItems:self.connectWithFB, nil];
        self.connectWithFB.position=ccp(165, 30);
        [self addChild:self.connectWithFB];
    }
}
*/



#pragma mark-
-(void)connectwithFacebook{
    
    NSLog(@"connect with facebook button clicked.");
     [[NSNotificationCenter defaultCenter]postNotificationName:kReachabilityChangedNotification object:nil];
    BOOL connect=[[NSUserDefaults standardUserDefaults]boolForKey:@"NetworkStatus"];
    if(connect)
    {
        self.connectWithFB.visible=NO;
        self.inviteFriend.visible=YES;
        
    AppDelegate * appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    
    //[appDelegate openSessionWithAllowLoginUI:1];
        [appDelegate openSessionWithLoginUI:8 withParams:nil];
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(hideFacebookButton:) name:@"hideaction" object:nil];
       
        //[[NSUserDefaults standardUserDefaults]setBool:YES forKey:@"clearLevel"];
       // [[NSUserDefaults standardUserDefaults]synchronize];
        
    }
    else{
        self.connectWithFB.visible=YES;
        UIAlertView *alert =[[UIAlertView alloc] initWithTitle:@"There is no Internet Connection in your device" message:@"Check Internet ConnectionFirst" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
        return;
    }
   

}

-(void)hideFacebookButton:(id)sender{
    self.connectWithFB.visible=NO;
    self.inviteFriend.visible=YES;
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"hideaction" object:nil];
}

-(void) makeTransition
{
    [self unschedule:@selector(makeTransition)];
	[[CCDirector sharedDirector] replaceScene:[CCTransitionFade transitionWithDuration:1.0 scene:[GameMain scene] withColor:ccWHITE]];
}

-(void)playButtonAction {
    
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
     [[NSNotificationCenter defaultCenter]postNotificationName:kReachabilityChangedNotification object:nil];
    BOOL connect=[[NSUserDefaults standardUserDefaults]boolForKey:@"NetworkStatus"];
    if(connect)
    {
        [viewHost1 removeFromSuperview];
//    rootViewController = (UIViewController*)[(AppDelegate*)[[UIApplication sharedApplication] delegate] getRootViewController];
//    adf = [[AdMobFullScreenViewController alloc]init];
//    [rootViewController presentViewController:adf animated:YES completion:nil];
    }
    
    BOOL fbconnect=[[NSUserDefaults standardUserDefaults]boolForKey:FacebookConnected];
   // NSLog(@"Fb connect %hhd",fbconnect);
    if (playButton) {
        playButton=NO;
        [self performSelector:@selector(LevelSelectionMethod) withObject:nil afterDelay:2];
    }
    
    
    
}
-(void)LevelSelectionMethod{
    
    LevelSelectionScene *obj = [[LevelSelectionScene alloc]init];
    [self addChild:obj];

}

-(void)storeButtonAction {
    
    
    
   // AppDelegate *appdelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
   //[appdelegate storyPostwithDictionary:nil];
   // return;
    Store *storeObj = [[Store alloc]init];
    [self addChild:storeObj];
     
    
    /*AppDelegate * appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    RootViewController *viewCntrler = (RootViewController*)[appDelegate getRootViewController];
    CGRect frame = [UIScreen mainScreen].bounds;
    FriendsViewController *fbFrnds = [[FriendsViewController alloc] initWithHeaderTitle:@"Ask Life"];//WithNibName:@"FriendsViewController" bundle:nil];
    fbFrnds.view.frame = CGRectMake(0, 0, frame.size.height, 0);;
    
    //fbFrnds.headerTitle = @"Ask Life";
    [UIView animateWithDuration:1 animations:^{
        
        fbFrnds.view.frame = CGRectMake(0, 0, frame.size.height, frame.size.width);
        [viewCntrler presentViewController:fbFrnds animated:YES completion:nil];
        //[viewCntrler.view addSubview:fbFrnds.view];
    }];*/
}

-(void)hintButtonAction {
    
    //AppDelegate *appdelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
   // [appdelegate openSessionWithLoginUI:8 withParams:nil];
   // return;
    HintSprite *hint = [[HintSprite alloc]init];
    [self addChild:hint];
    /*
    NSString *access_token = @"CAAKNl5K9AUsBAMZAhkrLu8pWjZB5yhs8jUC8Hhd80ZBlit3aH6XdU1HW3ebj8Xg9J0PxVTUgHVMAZCj0bWXeIPqzqs3rs0QJUbG4iAR7GwhTWcYbnKoFXnvfLKPGbZAxIOsApVZCac8HKpVZC7jNCv5lbkMca7jWjwllsoLFYlgRZAo5aZCowuV9545usOA3CWZAAQ6iDC4B1gbSaoLsn363MeOwXZA7RT2Dd20bAykRtpWRwZDZD";
    
    
    
    AppDelegate * appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    
   
    NSString *title = [NSString stringWithFormat:@"new highscore"];
    NSString *description = [NSString stringWithFormat:@"set new highscore in level 2"];
    
    NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:@"highscore",FacebookType,title,FacebookTitle,description,FacebookDescription,@"set",FacebookActionType, nil];
    if (FBSession.activeSession.isOpen) {
        
        [appDelegate storyPostwithDictionary:dict];
    }
    else{
        
        [appDelegate openSessionWithLoginUI:8 withParams:dict];
    }
    */
}

- (void) dealloc
{
	[super dealloc];
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}
@end
