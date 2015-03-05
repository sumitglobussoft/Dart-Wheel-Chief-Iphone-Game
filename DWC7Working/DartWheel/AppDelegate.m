//
//  AppDelegate.m
//  DartWheel
//
//  Created by tang on 12-7-21.
//  Copyright __MyCompanyName__ 2012年. All rights reserved.
//

#import "cocos2d.h"
#import "AppDelegate.h"
#import "GameConfig.h"
#import "IntroLayer.h"
#import "RootViewController.h"
#import <Parse/Parse.h>
#import "Json/SBJson.h"

#import "GameMain.h"
#import "Flurry.h"


#define APP_HANDLED_URL @"App_Handel_Url"
#define ShareToFacebook @"FacebookShare"
#define RequestTOFacebook @"LifeRequest"
#define ReceiveNotification @"REceiveNotification"

@implementation AppDelegate

@synthesize window, viewController,accessToken;

-(UIViewController *) getRootViewController{
   
       
  
    return viewController;
}

- (void) removeStartupFlicker
{
	//
	// THIS CODE REMOVES THE STARTUP FLICKER
	//
	// Uncomment the following code if you Application only supports landscape mode
	//
#if GAME_AUTOROTATION == kGameAutorotationUIViewController

//	CC_ENABLE_DEFAULT_GL_STATES();
//	CCDirector *director = [CCDirector sharedDirector];
//	CGSize size = [director winSize];
//	CCSprite *sprite = [CCSprite spriteWithFile:@"Default.png"];
//	sprite.position = ccp(size.width/2, size.height/2);
//	sprite.rotation = -90;
//	[sprite visit];
//	[[director openGLView] swapBuffers];
//	CC_ENABLE_DEFAULT_GL_STATES();
	
#endif // GAME_AUTOROTATION == kGameAutorotationUIViewController	
}

#pragma mark -
-(void)revmobSessionIsStarted {
    NSLog(@"[RevMob Sample App] Session is started.");
    [viewController createAddBannerView];
}

- (void)revmobSessionNotStartedWithError:(NSError *)error {
    NSLog(@"[RevMob Sample App] Session failed to start: %@", error);
}

- (void)revmobAdDidFailWithError:(NSError *)error {
}




- (void) applicationDidFinishLaunching:(UIApplication*)application
{
    //[FBSession.activeSession closeAndClearTokenInformation];
	// Init the window
    
    [FBAppEvents activateApp];
   //
    /******************** PFinstallation **************/
    /*[08/12/14 1:08:09 pm] Biswatma Nayak (Android): appid-WBqLj07UwL1LjmEl9RgGgiGsifD1H71jyYEdCQdz
     [08/12/14 1:08:15 pm] Biswatma Nayak (Android): key-3yJODWluY6378XiZS1uvKUR2Ftdy0Acl8yXtWcEL*/
    
   // [Parse setApplicationId:@"99Obn81mXX7ddVrdqv04QC2Gk3I4NDh0pEhLAH3d" clientKey:@"OJQexWH2WiPySk5QWXTe8JRXVpsfr5py9CoKlVEQ"];
    /*************/
  //Sir live
    [Parse setApplicationId:@"WBqLj07UwL1LjmEl9RgGgiGsifD1H71jyYEdCQdz" clientKey:@"3yJODWluY6378XiZS1uvKUR2Ftdy0Acl8yXtWcEL"];
	CCDirector *director = [CCDirector sharedDirector];

    PFInstallation *currentInstallation = [PFInstallation currentInstallation];
    //    [currentInstallation addUniqueObject:str forKey:@"channels"];
    
    [currentInstallation saveInBackground];

    //Flurry code live

    [Flurry startSession:@"CVCXRZ5NDBWBKQYSB5SJ"];
    
  
   [[UIApplication sharedApplication] registerForRemoteNotificationTypes:UIRemoteNotificationTypeBadge|
     UIRemoteNotificationTypeAlert|
     UIRemoteNotificationTypeSound];

    
  
    /******************* Chart Boost code **************/
    //54870c31c909a668589390f5
    //b5d7759d477fc9f7ded8b5b9b37890dbb08ff309
    //[Chartboost startWithAppId:@"547da25643150f4c6d83fa59"
          //        appSignature:@"914219c3e2b38e75508f3b2c4f994ac90ba035ef"
            //          delegate:self];
    
   
    //[Chartboost showRewardedVideo:CBLocationGameOver];
       //[Chartboost showRewardedVideo:CBLocationStartup];
    //    [Chartboost showMoreApps:CBLocationStartup];
    
   // [Chartboost startWithAppId:@"54a6a79804b0160e56ced5fa"
          //        appSignature:@"8e3ae764dbe498705c7cf82d053ebccf8f1f61d4"
            //          delegate:self];
    // [Chartboost startWithAppId:@"54a389eb04b0160de64d7caf" appSignature:@"b7b6bc07c09c0590f92c8b43a751c576a71ca494" delegate:self];
    
	window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    
	NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    BOOL checkFirstRun = [userDefault boolForKey:@"firstrun"];
    BOOL FBConnected = [userDefault boolForKey:FacebookConnected];
    
    if (!checkFirstRun && !FBConnected) {
        [userDefault setObject:@"0" forKey:@"currentDate"];
        [userDefault setBool:YES forKey:@"firstrun"];
        [userDefault setInteger:5 forKey:@"life"];
        [userDefault setInteger:15 forKey:@"darts"];
        [userDefault synchronize];
       // self.failVideo=NO;
       // self.delegateNo=YES;
        //self.videoWatched=YES;
       [FBAppEvents logEvent:FBAppEventNameActivatedApp];
        [self saveinSqlite];
    }
    
    
    
    [self reacheability];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(reacheability) name:kReachabilityChangedNotification object:nil];
    
    //[RevMobAds startSessionWithAppID:@"53c52b51ad2c5fb0060406f5" andDelegate:self];
   // [RevMobAds startSessionWithAppID:@"538d65cb52b173b1066a4c29" andDelegate:self];
   // [RevMobAds session].testingMode=RevMobAdsTestingModeWithAds;
    
    [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationNone];
	// Try to use CADisplayLink director
	// if it fails (SDK < 3.1) use the default director
	if( ! [CCDirector setDirectorType:kCCDirectorTypeDisplayLink] )
		[CCDirector setDirectorType:kCCDirectorTypeDefault];
	
    //[Parse setApplicationId:@"EIRAbJWiTrANkX5CoqJQDlTSxJCR3uHlUDIPZAMd" clientKey:@"QBap4D3gtajlr4LdMpbvFC34irNROU8X5TGk0KhJ"];
    
    //==
   //sir [Parse setApplicationId:@"vppPB7YTkacpAV4IAKDxkIqtPrIuQ6rcsq64bjbd" clientKey:@"H5EShVkcAcBp7S2OV63yZA8QvcdZcF9QxVWgBo8o"];
	
    
	// Init the View Controller
	viewController = [[RootViewController alloc] initWithNibName:nil bundle:nil];
	viewController.wantsFullScreenLayout = YES;
	
	//
	// Create the EAGLView manually
	//  1. Create a RGB565 format. Alternative: RGBA8
	//	2. depth format of 0 bit. Use 16 or 24 bit for 3d effects, like CCPageTurnTransition
	//
	//
	EAGLView *glView = [EAGLView viewWithFrame:[window bounds]
								   pixelFormat:kEAGLColorFormatRGBA8	// kEAGLColorFormatRGB565 kEAGLColorFormatRGBA8
								   depthFormat:0						// GL_DEPTH_COMPONENT16_OES
						];
	
	// attach the openglView to the director
	[director setOpenGLView:glView];
	
//	// Enables High Res mode (Retina Display) on iPhone 4 and maintains low res on all other devices
    if( ! [director enableRetinaDisplay:YES] )
      CCLOG(@"Retina Display Not supported");
	  
	//
	// VERY IMPORTANT:
	// If the rotation is going to be controlled by a UIViewController
	// then the device orientation should be "Portrait".
	//
	// IMPORTANT:
	// By default, this template only supports Landscape orientations.
	// Edit the RootViewController.m file to edit the supported orientations.
	//
#if GAME_AUTOROTATION == kGameAutorotationUIViewController
	[director setDeviceOrientation:kCCDeviceOrientationPortrait];
#else
	[director setDeviceOrientation:kCCDeviceOrientationLandscapeLeft];
#endif
	
	[director setAnimationInterval:1.0/60];
	[director setDisplayFPS:NO];
	
	
	// make the OpenGLView a child of the view controller
	[viewController setView:glView];
	
	// make the View Controller a child of the main window
	[window addSubview: viewController.view];
	
	[window makeKeyAndVisible];
	
	// Default texture format for PNG/BMP/TIFF/JPEG/GIF images
	// It can be RGBA8888, RGBA4444, RGB5_A1, RGB565
	// You can change anytime.
	[CCTexture2D setDefaultAlphaPixelFormat:kCCTexture2DPixelFormat_RGBA8888];

	
	// Removes the startup flicker
	[self removeStartupFlicker];
	[glView setMultipleTouchEnabled:YES];
	// Run the intro Scene
	[[CCDirector sharedDirector] runWithScene: [IntroLayer scene]];
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    
    UILocalNotification * localNotification=[[UILocalNotification alloc]init];
    //localNotification.userInfo=userInfo;
    localNotification.soundName = UILocalNotificationDefaultSoundName;
    localNotification.alertBody=[userInfo objectForKey:@"alert"];
    localNotification.fireDate = [NSDate date];
    [[UIApplication sharedApplication] scheduleLocalNotification:localNotification];
    
    int type;
    NSString * message;
    
    NSLog(@"userInfo %@",[userInfo objectForKey:@"type"]);
    //New Update
    if ([[userInfo objectForKey:@"Type"] isEqualToString:@"3"]) {
        type=3;
        message=[userInfo objectForKey:@"Message"];
    }//contest of  getting gold star
    else if([[userInfo objectForKey:@"Type"] isEqualToString:@"2"]){
        type=2;
        message=[userInfo objectForKey:@"Message"];
    }
    else{
        type=1;
        message=[userInfo objectForKey:@"Message"];
    }
    [self newPushNotification:type message:message];
}

-(void)newPushNotification:(int)type message:(NSString *)msg{
    
    if (!self.displayRequestView) {
        self.displayRequestView = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
        self.displayRequestView.backgroundColor = [UIColor blackColor];
        self.displayRequestView.alpha = 1.0f;
        [window addSubview:self.displayRequestView];
        
        self.containerView = [[UIView alloc] initWithFrame:CGRectMake(15, 30, 284, 278)];
        self.containerView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"Score.png"]];
        [self.displayRequestView addSubview:self.containerView];
        
        self.messageLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 30, 250, 120)];
        self.messageLabel.text=msg;
        self.messageLabel.textColor = [UIColor blackColor];
        self.messageLabel.textAlignment = NSTextAlignmentCenter;
        self.messageLabel.numberOfLines = 0;
        self.messageLabel.lineBreakMode = NSLineBreakByCharWrapping;
        [self.containerView addSubview:self.messageLabel];
        self.sendButton = [UIButton buttonWithType:UIButtonTypeCustom];
        if (type==3) {
            self.sendButton.tag=3;
            [self.sendButton setTitle:@"Update" forState:UIControlStateNormal];
        }
        else if (type==2)
        {
            self.sendButton.tag=2;
            [self.sendButton setTitle:@"Continue" forState:UIControlStateNormal];
        }
        else{
            self.sendButton.tag=1;
            [self.sendButton setTitle:@"OK" forState:UIControlStateNormal];
        }
     
        //=
        
        self.sendButton.frame = CGRectMake(100, 190, 100, 45);
        self.sendButton.titleLabel.textColor = [UIColor whiteColor];
        self.sendButton.backgroundColor=[UIColor greenColor];
        //        [self.sendButton setTitle:@"Send" forState:UIControlStateNormal];
       // [self.sendButton setBackgroundImage:[UIImage imageNamed:@"send.png"] forState:UIControlStateNormal];
        self.sendButton.layer.cornerRadius=4.0;
        self.sendButton.clipsToBounds=YES;
        [self.sendButton addTarget:self action:@selector(sendButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        [self.containerView addSubview:self.sendButton];
        

    }
    self.displayRequestView.hidden=NO;
}

-(void)sendButtonClicked:(id)sender{
    NSLog(@"sender tag %d",[sender tag]);
    if ([sender tag]==3) {
        NSLog(@"Update ");
    
        [[UIApplication sharedApplication]openURL:[NSURL URLWithString:@"https://itunes.apple.com/app/id892026202"]];
    }
    if ([sender tag]==2) {
        NSLog(@"Contest URL");
        [[UIApplication sharedApplication]openURL:[NSURL URLWithString:@"https://itunes.apple.com/app/id892026202"]];
    }
    self.displayRequestView.hidden=YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
	[[CCDirector sharedDirector] pause];
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
//    BOOL checkBackground=[[NSUserDefaults standardUserDefaults]boolForKey:@"background"];
//    if (checkBackground==YES) {
//        [[CCDirector sharedDirector] pause];
//        [[NSUserDefaults standardUserDefaults]setBool:NO forKey:@"background"];
//        [[NSUserDefaults standardUserDefaults]synchronize];
//    }
//    else{
    [self reacheability];
        [[CCDirector sharedDirector] resume];
    //}
}

- (void)applicationDidReceiveMemoryWarning:(UIApplication *)application {
	[[CCDirector sharedDirector] purgeCachedData];
}

-(void) applicationDidEnterBackground:(UIApplication*)application {
	[[CCDirector sharedDirector] stopAnimation];
    [[NSUserDefaults standardUserDefaults]setBool:YES forKey:@"background"];
    [[NSUserDefaults standardUserDefaults]synchronize];
    //[FBSession.activeSession closeAndClearTokenInformation];
}

-(void) applicationWillEnterForeground:(UIApplication*)application {
//    BOOL checkBackground=[[NSUserDefaults standardUserDefaults]boolForKey:@"background"];
//    if (checkBackground==YES) {
//        [[CCDirector sharedDirector] stopAnimation];
//    }
    //else{
     [[CCDirector sharedDirector] startAnimation];
   // }
	
    [[NSNotificationCenter defaultCenter] postNotificationName:@"TimerNotification" object:nil];
}

- (void)applicationWillTerminate:(UIApplication *)application {
	CCDirector *director = [CCDirector sharedDirector];
	
	[[director openGLView] removeFromSuperview];
	
	[viewController release];
	
	[window release];
	
	[director end];	
}

- (void)applicationSignificantTimeChange:(UIApplication *)application {
	[[CCDirector sharedDirector] setNextDeltaTimeZero:YES];
}

- (void)dealloc {
	[[CCDirector sharedDirector] end];
	[window release];
	[super dealloc];
}


#pragma mark -
- (void) closeSession {
    [FBSession.activeSession closeAndClearTokenInformation];
}


-(BOOL) openSessionWithLoginUI:(NSInteger)value withParams: (NSDictionary *)dict{
    [self retriveFromSQL];
    NSArray *permissions = [[NSArray alloc] initWithObjects:@"public_profile",@"user_friends",@"publish_actions", nil];
    
   // NSArray *permissions = [[NSArray alloc] initWithObjects:@"public_profile",@"user_friends",@"publish_actions", nil];
    FBSession *session = [[FBSession alloc] initWithPermissions:permissions];
    // Set the active session
    [FBSession setActiveSession:session];
    ms_friendCache = NULL;
    
    [session openWithBehavior:FBSessionLoginBehaviorWithNoFallbackToWebView
            completionHandler:^(FBSession *session,
                                FBSessionState status,
                                NSError *error) {
                
            if (error==nil) {
                    //[NSThread detachNewThreadSelector:@selector(fetchFacebookGameFriends) toTarget:self withObject:nil];
                FBAccessTokenData *tokenData= session.accessTokenData;
                
//                if (!tokenData.accessToken) {
//                    self.accessToken =[[NSUserDefaults standardUserDefaults]objectForKey:@"accessToken"];
//                }
//                else{
                    self.accessToken = tokenData.accessToken;
//                }
                NSLog(@"AccessToken1with params==%@",self.accessToken);
                
                [[NSUserDefaults standardUserDefaults] setObject:self.accessToken forKey:@"accessToken"];
                
                
                
                //self.accessToken = tokenData.accessToken;
                NSLog(@"AccessToken==%@",self.accessToken);
               
               // [[NSUserDefaults standardUserDefaults] setObject:self.accessToken forKey:@"accessToken"];
                
                    
               
                
                if (value==1) {
                   // [self storyPostwithDictionary:self.openGraphDict];
                    [self shareOnFacebookWithParams:dict];
                }
                else if (value == 2){
                    
                    [self shareBeatStoryWithParams:dict];
                    
                   // [self sendRequestToFriends:dict];
                }
              
                else if(value == 3)
                {
                    [self storyPostwithDictionary:dict];
                }
                
                else if (value==5){
                
                    [self sendRequestToFriends:nil];
                }
                
                else{
                    NSLog(@"Unknown Value");
                }
                
                
            if(value == 8){
                    
                
                [FBRequestConnection
                     startForMeWithCompletionHandler:^(FBRequestConnection *connection,id<FBGraphUser> user,NSError *error){
                         
                         
                         NSString *userInfo = @"";
                         userInfo = [userInfo
                                     stringByAppendingString:
                                     [NSString stringWithFormat:@"Name: %@\n\n",
                                      [user objectForKey:@"id"]]];
                         NSLog(@"userinfo = %@",userInfo);
                         NSLog(@"Name = %@",user.name);
                         NSArray *ary=[userInfo componentsSeparatedByString:@":"];
                         if([ary count]>1){
                             userInfo=[ary objectAtIndex:1];
                             userInfo=[userInfo stringByReplacingOccurrencesOfString:@" " withString:@""];
                             userInfo=[userInfo stringByReplacingOccurrencesOfString:@"\n" withString:@""];
                             NSLog(@"sender id=%@",userInfo);
                         
                         
                         
                         
                         
                         NSString *userName = [NSString stringWithFormat:@"%@",[user objectForKey:@"name"]];
                         NSString *userID = [NSString stringWithFormat:@"%@",[user objectForKey:@"id"]];
                         

                             if (!self.accessToken) {
                                 [[NSUserDefaults standardUserDefaults] setBool:NO forKey :FacebookConnected];
                                 [[NSNotificationCenter defaultCenter]postNotificationName:@"LogginFail" object:nil userInfo:nil];

                             }
                             else{
                                  [[NSNotificationCenter defaultCenter]postNotificationName:@"LogginSuccess" object:nil userInfo:nil];
                                 [self fetchFacebookGameFriends:self.accessToken];
                                 
                         [[NSUserDefaults standardUserDefaults] setBool:YES forKey :FacebookConnected];
                         [[NSUserDefaults standardUserDefaults] setObject:userID forKey:ConnectedFacebookUserID];
                         [[NSUserDefaults standardUserDefaults] setObject:userName  forKey:@"ConnectedFacebookUserName"];
                         [[NSUserDefaults standardUserDefaults]synchronize];
                         NSString * fbID=[[NSUserDefaults standardUserDefaults]objectForKey:ConnectedFacebookUserID];
                         PFInstallation *currentInstallation = [PFInstallation currentInstallation];
                         [currentInstallation setObject:fbID forKey:@"PlayerFacebookID"] ;
                         [currentInstallation saveInBackground];
                                 [self synchronize];
                                // [self leveClearMethod];

                         }
                         }
                         
                    
                     }];
                
            }
                }
                else{
                    
                    NSLog(@"Session not open==%@",error);
                }
                
                // Respond to session state changes,
                // ex: updating the view
            }];
    
    return YES;
}

-(void)leveClearMethod{
    NSString * connectfbId=[[NSUserDefaults standardUserDefaults] objectForKey:ConnectedFacebookUserID];
    
  /*  PFQuery * query=[PFQuery queryWithClassName:ParseScoreTableName];
    [query whereKey:@"PlayerFacebookID" equalTo:connectfbId];
    [query orderByDescending:@"Level"];
    [query getFirstObjectInBackgroundWithBlock:^(PFObject *object, NSError *error) {
        if (object) {
             lnumber=object[@"Level"];
            int level=[lnumber intValue];;
            level=level+1;
            [[NSUserDefaults standardUserDefaults]setInteger:level forKey:@"levelClear"];
            [[NSUserDefaults standardUserDefaults]synchronize];
        }
      
    }];*/
    PFQuery * query=[PFQuery queryWithClassName:ParseScoreTableName];
    [query whereKey:@"PlayerFacebookID" equalTo:connectfbId];
    [query orderByDescending:@"Level"];
    PFObject * obj=[query getFirstObject];
            lnumber=obj[@"Level"];
            int level=[lnumber intValue];
            level=level+1;
            [[NSUserDefaults standardUserDefaults]setInteger:level forKey:@"levelClear"];
            [[NSUserDefaults standardUserDefaults]synchronize];
}

#pragma mark -
-(void) shareOnFacebookWithParams:(NSDictionary *)params{
   // if (self.openGraphDict != nil) {
    //    [self storyPostwithDictionary:self.openGraphDict];
   // }
    [FBWebDialogs presentFeedDialogModallyWithSession:nil parameters:params handler:^(FBWebDialogResult result, NSURL *resultUrl, NSError *error){
        
        if (error) {
            NSLog(@"Error to post on facebook = %@", [error localizedDescription]);
        }
        else{
            
            [[NSNotificationCenter defaultCenter] removeObserver:self name:ShareToFacebook object:nil];
            
            //NSLog(@"result==%u",result);
            //NSLog(@"Url==%@",resultUrl);
            if (result == FBWebDialogResultDialogNotCompleted) {
                NSLog(@"Error to post on facebook = %@", [error localizedDescription]);
                NSLog(@"User cancel Request");
            }//End Result Check
            else{
                NSString *sss= [NSString stringWithFormat:@"%@",resultUrl];
                if ([sss rangeOfString:@"post_id"].location == NSNotFound) {
                    NSLog(@"User Cancel Share");
                }
                else{
                    NSLog(@"posted on wall");
                    if (self.lifeOver==YES) {
                        int life=[[NSUserDefaults standardUserDefaults]integerForKey:@"life"];
                        
                        if (life<=0) {
                            life=5;
                            [[NSUserDefaults standardUserDefaults]setInteger:life forKey:@"life"];
                            [[NSUserDefaults standardUserDefaults]synchronize];
                            self.lifeOver=NO;
                            
                            UIAlertView *view = [[UIAlertView alloc]initWithTitle:@"You got 5 Lives! Enjoy the game" message:@"" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles: nil];
                            [view show];
                            [[NSNotificationCenter defaultCenter]postNotificationName:@"gotFiveLives" object:nil];
                        }
                    }
                }
            }//End Else Block Result Check
        }
    }];
}


/*-(void) sendRequestToFriends:(NSDictionary *)params{
    
    if (!ms_friendCache) {
        ms_friendCache = [[FBFrictionlessRecipientCache alloc] init];
    }
    if (self.openGraphDict != nil) {
        [self storyPostwithDictionary:self.openGraphDict];
    }
    [ms_friendCache prefetchAndCacheForSession:nil];
    
    NSString *title = [NSString stringWithFormat:@"%@",[params objectForKey:@"Title"]];
    NSString *message = [NSString stringWithFormat:@"%@",[params objectForKey:@"message"]];
    
    [FBWebDialogs presentRequestsDialogModallyWithSession:nil message:message title:title parameters:params handler:^(FBWebDialogResult result, NSURL *url, NSError *error){
        if (error) {
            // Case A: Error launching the dialog or sending request.
            NSLog(@"Error sending request.==%@",[error localizedDescription]);
        } else {
            NSLog(@"Result url==%@",url);
            //===============================================
            
            //On Cancel
            // Result url==fbconnect://success?error_code=4201&error_message=User+canceled+the+Dialog+flow
            
            //On Send
            //Result url==fbconnect://success?request=532786970172029&to%5B0%5D=100004995941963
            //===========================================================
            if (result == FBWebDialogResultDialogNotCompleted) {
                // Case B: User clicked the "x" icon
                NSLog(@"User canceled request.");
            } else {
                
                NSLog(@"Request Sent.");
                if (self.delegate  != nil && [self.delegate respondsToSelector:@selector(hideFacebookFriendsList)]) {
                    [self.delegate hideFacebookFriendsList];
                }
            }//End Else Block
            
        }//End else block error check
    }friendCache:ms_friendCache];*/
    
    /*
    [FBWebDialogs presentRequestsDialogModallyWithSession:nil message:@"Live Request Test" title:@"Live Request" parameters:params handler:^(FBWebDialogResult result, NSURL *url, NSError *error){
        if (error) {
            // Case A: Error launching the dialog or sending request.
            NSLog(@"Error sending request.==%@",[error localizedDescription]);
        } else {
            NSLog(@"Result url==%@",url);
            //==========================================================
            
            //On Cancel
            // Result url==fbconnect://success?error_code=4201&error_message=User+canceled+the+Dialog+flow
            
            //On Send
            //Result url==fbconnect://success?request=532786970172029&to%5B0%5D=100004995941963
            //===========================================================
            if (result == FBWebDialogResultDialogNotCompleted) {
                // Case B: User clicked the "x" icon
                NSLog(@"User canceled request.");
            } else {
                
                NSLog(@"Request Sent.");
            }//End Else Block
        }//End else block error check
    }friendCache:ms_friendCache];
    */
    
    
//}

- (void)application:(UIApplication *)application
didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    
    if (application.applicationIconBadgeNumber != 0) {
        application.applicationIconBadgeNumber = 0;
    }
    
    // Store the deviceToken in the current Installation and save it to Parse.
    PFInstallation *currentInstallation = [PFInstallation currentInstallation];
    [currentInstallation setDeviceTokenFromData:deviceToken];
    [currentInstallation saveInBackground];
    NSLog(@"Device Token %@",deviceToken);
    BOOL fbCheck = [[NSUserDefaults standardUserDefaults] boolForKey:FacebookConnected];
    NSString *fbID = [[NSUserDefaults standardUserDefaults] objectForKey:ConnectedFacebookUserID];
    
    if (fbCheck==YES ) {
       PFInstallation *currentInstallation = [PFInstallation currentInstallation];
        [currentInstallation setObject:fbID forKey:@"PlayerFacebookID"] ;
       [currentInstallation saveInBackground];
        
    }
    
    
}

/*- (BOOL)openSessionWithAllowLoginUI:(NSInteger)isLoginReq{
    
    self.CurrentValue = isLoginReq;
    NSArray *permissions = [[NSArray alloc] initWithObjects:@"public_profile",@"email",@"status_update",@"user_photos",@"user_birthday",@"user_about_me",@"user_friends",@"photo_upload",@"read_friendlists", nil];
    
    FBSession *session = [[FBSession alloc] initWithPermissions:permissions];
    // Set the active session
    [FBSession setActiveSession:session];
    
    [session openWithBehavior:FBSessionLoginBehaviorWithNoFallbackToWebView
            completionHandler:^(FBSession *session,
                                FBSessionState status,
                                NSError *error) {
                
                if (error==nil) {
                    //[NSThread detachNewThreadSelector:@selector(fetchFacebookGameFriends) toTarget:self withObject:nil];
                    FBAccessTokenData *tokenData= session.accessTokenData;
                    if (!tokenData.accessToken) {
                        self.accessToken =[[NSUserDefaults standardUserDefaults]objectForKey:@"accessToken"];
                    }
                    else{
                        self.accessToken = tokenData.accessToken;
                    }
                    NSLog(@"levelClear==%@",self.accessToken);
                    
                    [[NSUserDefaults standardUserDefaults] setObject:self.accessToken forKey:@"accessToken"];
                    
                    [self fetchFacebookGameFriends:self.accessToken];
                    
                    [FBRequestConnection
                     startForMeWithCompletionHandler:^(FBRequestConnection *connection,id<FBGraphUser> user,NSError *error){
                         
                         NSString *userInfo = @"";
                         userInfo = [userInfo
                                     stringByAppendingString:
                                     [NSString stringWithFormat:@"Name: %@\n\n",
                                      [user objectForKey:@"id"]]];
                         NSLog(@"userinfo = %@",userInfo);
                         NSLog(@"Name = %@",user.name);
                         NSArray *ary=[userInfo componentsSeparatedByString:@":"];
                         if([ary count]>1){
                             userInfo=[ary objectAtIndex:1];
                             userInfo=[userInfo stringByReplacingOccurrencesOfString:@" " withString:@""];
                             userInfo=[userInfo stringByReplacingOccurrencesOfString:@"\n" withString:@""];
                             NSLog(@"sender id=%@",userInfo);
                             
                          //   NSString *userID = [NSString stringWithFormat:@"%@",[user objectForKey:@"id"]];
                             
                             BOOL fbconnect=[[NSUserDefaults standardUserDefaults]boolForKey:FacebookConnected];
                             if (fbconnect) {
                                 [[NSUserDefaults standardUserDefaults] setBool:NO forKey :FacebookConnected];
                                 [[NSUserDefaults standardUserDefaults]synchronize];
                             }
                             else{
                             
                             NSString *userName = [NSString stringWithFormat:@"%@",[user objectForKey:@"name"]];
                             
                             [[NSUserDefaults standardUserDefaults] setBool:YES forKey:FacebookConnected];
                             [[NSUserDefaults standardUserDefaults] setObject:userInfo forKey:ConnectedFacebookUserID];
                             [[NSUserDefaults standardUserDefaults] setObject:userName  forKey:@"ConnectedFacebookUserName"];
                             [[NSUserDefaults standardUserDefaults]synchronize];
                         }
                         }
                         BOOL fbCheck = [[NSUserDefaults standardUserDefaults] boolForKey:FacebookConnected];
                         NSString *fbID = [[NSUserDefaults standardUserDefaults] objectForKey:ConnectedFacebookUserID];
                         
                         if (fbCheck==YES ) {
                             PFInstallation *currentInstallation = [PFInstallation currentInstallation];
                             [currentInstallation setObject:fbID forKey:@"PlayerFacebookID"] ;
                             [currentInstallation saveInBackground];
                             
                         }

                     }];
                    
                    // [self retriveAllfriends];
                }
                else{
                    
                    NSLog(@"Session not open==%@",error);
                }
                
                // Respond to session state changes,
                // ex: updating the view
            }];
    return YES;
}*/
/*-(void) fetchFacebookGameFriends:(NSString *)accessToken{
    NSString *query =
    @"SELECT uid, name, pic_small FROM user WHERE is_app_user = 1 and uid IN "
    @"(SELECT uid2 FROM friend WHERE uid1 = me() )";
    
    NSDictionary *queryParam = @{ @"q": query, @"access_token":self.accessToken };
    // Make the API request that uses FQL
    [FBRequestConnection startWithGraphPath:@"/fql"parameters:queryParam HTTPMethod:@"GET"completionHandler:^(FBRequestConnection *connection,id result,NSError *error) {
        if (error) {
            NSLog(@"Error: %@", [error localizedDescription]);
        }
        else {
            // NSLog(@"Result: %@", result);
            
            NSArray *friendInfo = (NSArray *) result[@"data"];
            
            //            NSLog(@"Array Count==%lu",(unsigned long)[friendInfo count]);
            //
            //            NSLog(@"\n\nArray==%@",friendInfo);
            
            NSMutableArray *frndsarray = [[NSMutableArray alloc] init];
            NSMutableArray *frndNamearray=[[NSMutableArray alloc] init];
            for (int i =0; i<friendInfo.count; i++) {
                NSDictionary *dict = [friendInfo objectAtIndex:i];
                NSString *fbID = [NSString stringWithFormat:@"%@",[dict objectForKey:@"uid"]];
                
                NSLog(@"#################");
                NSLog(@"fbid is %@",fbID);
                NSLog(@"#################");
                
                NSString *fbName =[NSString stringWithFormat:@"%@",[dict objectForKey:@"name"]];
                [frndsarray addObject:fbID];
                [frndNamearray addObject:fbName];
                
            }//End For Loop
            [[NSUserDefaults standardUserDefaults] setObject:frndsarray forKey:FacebookGameFrindes];
            [[NSUserDefaults standardUserDefaults]synchronize];
            [[NSUserDefaults standardUserDefaults]setObject:frndNamearray forKey:@"name1"];
            [[NSUserDefaults standardUserDefaults]synchronize];
            
            
           
            FBRequest *friendRequest = [FBRequest requestForGraphPath:@"me/invitable_friends?fields=name,picture,id"];
            
            [friendRequest startWithCompletionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
                NSArray *invite_friendInfo = (NSArray *) result[@"data"];
                
                 //                NSLog(@"Array Count==%lu",(unsigned long)[invite_friendInfo count]);
                //                NSLog(@"ARRAY = %@",invite_friendInfo);
               //========================
                if (error) {
                    NSLog(@"Error = %@",error);
                    return ;
                }
                NSMutableArray *inviteFrndsAry = [[NSMutableArray alloc] init];
                
                for (int i =0; i<invite_friendInfo.count; i++) {
                    NSDictionary *dict = [invite_friendInfo objectAtIndex:i];
                    NSMutableDictionary *aDict = [[NSMutableDictionary alloc] init];
                    
                    NSString *aid = [NSString stringWithFormat:@"%@",[dict objectForKey:@"id"]];
                    //NSLog(@"aid = %@",aid);
                    [aDict setObject:aid forKey:@"uid"];
                    NSString *name = [NSString stringWithFormat:@"%@",[dict objectForKey:@"name"]];
                    [aDict setObject:name forKey:@"name"];
                    NSDictionary *secDict = [[dict objectForKey:@"picture"] objectForKey:@"data"];
                    NSString *picUrl = [NSString stringWithFormat:@"%@",[secDict objectForKey:@"url"]];
                    [aDict setObject:picUrl forKey:@"pic_small"];
                    
                    [inviteFrndsAry addObject:aDict];
                }
                
                [[NSUserDefaults standardUserDefaults] setObject:inviteFrndsAry forKey:FacebookInviteFriends];
                
                NSArray *allFrndsArray = [friendInfo arrayByAddingObjectsFromArray:inviteFrndsAry];
                NSLog(@"All Friends Array = %@",allFrndsArray);
                [[NSUserDefaults standardUserDefaults] setObject:allFrndsArray forKey:FacebookAllFriends];
            
                NSMutableArray *tagbl_FrndAry=[[NSMutableArray alloc] init];
                [FBRequestConnection startWithGraphPath:@"/me/taggable_friends"
                                             parameters:nil
                                             HTTPMethod:@"GET"
                                      completionHandler:^(
                                                          FBRequestConnection *connection,
                                                          id result,
                                                          NSError *error
                                                          ) {
                                          NSArray *arr=[result valueForKey:@"data"];
                                          
                                          for (NSDictionary *dict in arr) {
                                              
                                              NSMutableDictionary *aDict = [[NSMutableDictionary alloc] init];
                                              
                                              NSString *aid = [NSString stringWithFormat:@"%@",[dict objectForKey:@"id"]];
                                              //NSLog(@"aid = %@",aid);
                                              [aDict setObject:aid forKey:@"uid"];
                                              NSString *name = [NSString stringWithFormat:@"%@",[dict objectForKey:@"name"]];
                                              [aDict setObject:name forKey:@"name"];
                                              NSDictionary *secDict = [[dict objectForKey:@"picture"] objectForKey:@"data"];
                                              NSString *picUrl = [NSString stringWithFormat:@"%@",[secDict objectForKey:@"url"]];
                                              [aDict setObject:picUrl forKey:@"pic_small"];
                                              
                                              [tagbl_FrndAry addObject:aDict];
                                              
                                              if (tagbl_FrndAry.count==arr.count) {
                                                  [[AppDelegate sharedAppDelegate]hideHUDLoadingView];
                                              }
                                              
                                          }
                                          
                                          [[NSUserDefaults standardUserDefaults] setObject:tagbl_FrndAry forKey:FacebookAllFriends];
                                      }];
                
                [[NSUserDefaults standardUserDefaults] setObject:tagbl_FrndAry forKey:FacebookAllFriends];
                NSLog(@"All Friends Array = %@",tagbl_FrndAry);
                if (self.delegate!=nil && [self.delegate respondsToSelector:@selector(displayFacebookFriendsList)]) {
                    
                    [self.delegate displayFacebookFriendsList];
                }
          
            }];
            
            
        }
        
   // }];
}*/

-(void) fetchFacebookGameFriends:(NSString *)accessToken{
    NSString *query =
    @"SELECT uid, name, pic_small FROM user WHERE is_app_user = 1 and uid IN "
    @"(SELECT uid2 FROM friend WHERE uid1 = me() )";
    
    NSDictionary *queryParam = @{ @"q": query, @"access_token":accessToken };
    // Make the API request that uses FQL
    [FBRequestConnection startWithGraphPath:@"/fql"parameters:queryParam HTTPMethod:@"GET"completionHandler:^(FBRequestConnection *connection,id result,NSError *error) {
        if (error) {
            NSLog(@"Error: %@", [error localizedDescription]);
        }
        else {
            // NSLog(@"Result: %@", result);
            
            NSArray *friendInfo = (NSArray *) result[@"data"];
            
            NSLog(@"Array Count==%lu",(unsigned long)[friendInfo count]);
            
            NSLog(@"\n\nArray==%@",friendInfo);
            
            NSMutableArray *frndsarray = [[NSMutableArray alloc] init];
            NSMutableArray *frndNamearray=[[NSMutableArray alloc] init];
            for (int i =0; i<friendInfo.count; i++) {
                NSDictionary *dict = [friendInfo objectAtIndex:i];
                NSString *fbID = [NSString stringWithFormat:@"%@",[dict objectForKey:@"uid"]];
                NSString *fbName =[NSString stringWithFormat:@"%@",[dict objectForKey:@"name"]];
                [frndsarray addObject:fbID];
                [frndNamearray addObject:fbName];
                
            }//End For Loop
            
            [[NSUserDefaults standardUserDefaults] setObject:frndsarray forKey:FacebookGameFrindes];
            [[NSUserDefaults standardUserDefaults]synchronize];
            [[NSUserDefaults standardUserDefaults]setObject:frndNamearray forKey:@"name"];
            [[NSUserDefaults standardUserDefaults]synchronize];
            
            FBRequest *friendRequest = [FBRequest requestForGraphPath:@"me/invitable_friends?fields=name,picture,id"];
            
            [friendRequest startWithCompletionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
                NSArray *invite_friendInfo = (NSArray *) result[@"data"];
                
                //                NSLog(@"Array Count==%lu",(unsigned long)[invite_friendInfo count]);
                //                NSLog(@"ARRAY = %@",invite_friendInfo);
                //========================
                NSMutableArray *inviteFrndsAry = [[NSMutableArray alloc] init];
                
                for (int i =0; i<invite_friendInfo.count; i++) {
                    NSDictionary *dict = [invite_friendInfo objectAtIndex:i];
                    NSMutableDictionary *aDict = [[NSMutableDictionary alloc] init];
                    
                    NSString *aid = [NSString stringWithFormat:@"%@",[dict objectForKey:@"id"]];
                    //NSLog(@"aid = %@",aid);
                    [aDict setObject:aid forKey:@"uid"];
                    NSString *name = [NSString stringWithFormat:@"%@",[dict objectForKey:@"name"]];
                    [aDict setObject:name forKey:@"name"];
                    NSDictionary *secDict = [[dict objectForKey:@"picture"] objectForKey:@"data"];
                    NSString *picUrl = [NSString stringWithFormat:@"%@",[secDict objectForKey:@"url"]];
                    [aDict setObject:picUrl forKey:@"pic_small"];
                    
                    [inviteFrndsAry addObject:aDict];
                }
                
                [[NSUserDefaults standardUserDefaults] setObject:inviteFrndsAry forKey:FacebookInviteFriends];
                
                NSArray *allFrndsArray = [friendInfo arrayByAddingObjectsFromArray:inviteFrndsAry];
                NSLog(@"All Friends Array = %@",allFrndsArray);
                NSMutableArray *tagbl_FrndAry=[[NSMutableArray alloc] init];
                [FBRequestConnection startWithGraphPath:@"/me/taggable_friends"
                                             parameters:nil
                                             HTTPMethod:@"GET"
                                      completionHandler:^(
                                                          FBRequestConnection *connection,
                                                          id result,
                                                          NSError *error
                                                          ) {
                                          NSArray *arr=[result valueForKey:@"data"];
                                          
                                          for (NSDictionary *dict in arr) {
                                              
                                              NSMutableDictionary *aDict = [[NSMutableDictionary alloc] init];
                                              
                                              NSString *aid = [NSString stringWithFormat:@"%@",[dict objectForKey:@"id"]];
                                              //NSLog(@"aid = %@",aid);
                                              [aDict setObject:aid forKey:@"uid"];
                                              NSString *name = [NSString stringWithFormat:@"%@",[dict objectForKey:@"name"]];
                                              [aDict setObject:name forKey:@"name"];
                                              NSDictionary *secDict = [[dict objectForKey:@"picture"] objectForKey:@"data"];
                                              NSString *picUrl = [NSString stringWithFormat:@"%@",[secDict objectForKey:@"url"]];
                                              [aDict setObject:picUrl forKey:@"pic_small"];
                                              
                                              [tagbl_FrndAry addObject:aDict];
                                              
                                              if (tagbl_FrndAry.count==arr.count) {
                                                  [[AppDelegate sharedAppDelegate]hideHUDLoadingView];
                                              }
                                              
                                          }
                                          
                                          [[NSUserDefaults standardUserDefaults] setObject:tagbl_FrndAry forKey:FacebookAllFriends];
                                      }];
                
                [[NSUserDefaults standardUserDefaults] setObject:tagbl_FrndAry forKey:FacebookAllFriends];
                NSLog(@"All Friends Array = %@",tagbl_FrndAry);
//                if (self.delegate!=nil && [self.delegate respondsToSelector:@selector(displayFacebookFriendsList)]) {
//                    
//                    [self.delegate displayFacebookFriendsList];
//                }
            }];
            
        }
    }];
}

- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation {
    // attempt to extract a token from the url
    //return [FBSession.activeSession handleOpenURL:url];
    
    
    /*
    NSString *openUrl = [NSString stringWithFormat:@"%@",url];
    
    NSArray *tempAry = [openUrl componentsSeparatedByString:@"&"];
    if (tempAry.count>1) {
        NSString *tempString = [tempAry objectAtIndex:0];
        NSArray *tokenAry = [tempString componentsSeparatedByString:@"="];
        if (tokenAry.count>1) {
            NSString *fbaccessToken = [tokenAry objectAtIndex:1];
            self.accessToken = fbaccessToken;
            NSLog(@"Access Token -==-=- %@",self.accessToken);
            
        }
    }
    if ([openUrl rangeOfString:@"authorize"].location != NSNotFound) {
        
        if (self.CurrentValue == 1) {
            //[[NSNotificationCenter defaultCenter] postNotificationName:ShareToFacebook object:nil];
            return YES;
        }
        else if (self.CurrentValue == 2) {
            //[[NSNotificationCenter defaultCenter] postNotificationName:RequestTOFacebook object:nil];
            return YES;
        }
        else if (self.CurrentValue == 3) {
           // [[NSNotificationCenter defaultCenter] postNotificationName:ReceiveNotification object:nil];
            }
        else{
            NSLog(@"Unknown");
        }
    }
    */
    NSLog(@"Open Url == %@",url);
    NSLog(@"Source Application == %@",sourceApplication);
    // attempt to extract a token from the url
    
    [FBAppCall handleOpenURL:url sourceApplication:sourceApplication fallbackHandler:^(FBAppCall *call) {
        self.accessToken = call.accessTokenData.accessToken;
        [[NSUserDefaults standardUserDefaults] setObject:self.accessToken forKey:@"Facebook Access Token"];
        NSLog(@"Access Token = %@",call.accessTokenData.accessToken);
        NSLog(@"App Link Data = %@",call.appLinkData);
        NSLog(@"call == %@",call);
        if (call.appLinkData && call.appLinkData.targetURL) {
            
            //[self openSessionWithLoginUI:8 withParams:nil];
            [[NSNotificationCenter defaultCenter] postNotificationName:FacebookRequestNotification object:call.appLinkData.targetURL];
        }
        
    }];
    return YES;
}
- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url {
    NSLog(@"Url== %@", url);
    
    NSLog(@"url is %@",url);
    NSString *check = [url absoluteString];
    
    NSString *substring = @"access_token";
    
    NSRange textRange = [check rangeOfString:substring];
    
    if(textRange.location != NSNotFound){
        //Does contain the substring
        NSLog(@"contains the string");
                 [[NSNotificationCenter defaultCenter] postNotificationName:@"hideaction" object:nil];
    }else{
        //Does not contain the substring
        NSLog(@"does not contain string");

    }
    return [FBSession.activeSession handleOpenURL:url];
    
    
}

-(void) retriveAppFriends{
    
    NSString *query =
    @"SELECT uid, name, pic_small FROM user WHERE is_app_user = 1 and uid IN "
    @"(SELECT uid2 FROM friend WHERE uid1 = me() )";
    
    
    NSDictionary *queryParam = @{ @"q": query };
    // Make the API request that uses FQL
    [FBRequestConnection startWithGraphPath:@"/fql"parameters:queryParam HTTPMethod:@"GET"completionHandler:^(FBRequestConnection *connection,id result,NSError *error) {
        if (error) {
            NSLog(@"Error: %@", [error localizedDescription]);
        }
        else {
            // NSLog(@"Result: %@", result);
            
            NSArray *friendInfo = (NSArray *) result[@"data"];
            
            NSLog(@"Array Count==%lu",(unsigned long)[friendInfo count]);
            
            NSLog(@"\n\nArray==%@",friendInfo);
            
            
        }
    }];
}

-(void) shareBeatStoryWithParams:(NSDictionary *)params{
    
    
    [FBWebDialogs presentFeedDialogModallyWithSession:nil parameters:params handler:^(FBWebDialogResult result,NSURL *resultUrl, NSError *error){
        
        if (error) {
            NSLog(@"Error to post on facebook = %@", [error localizedDescription]);
        }
        else{
            
            
            if (result == FBWebDialogResultDialogNotCompleted) {
                NSLog(@"Error to post on facebook = %@", [error localizedDescription]);
                NSLog(@"User cancel Request");
            }//End Result Check
            else{
                NSString *sss= [NSString stringWithFormat:@"%@",resultUrl];
                if ([sss rangeOfString:@"post_id"].location == NSNotFound) {
                    NSLog(@"User Cancel Share");
                }
                else{
                    
                    NSLog(@"posted on wall");
                }
            }//End Else Block Result Check
        }
    }];
}


-(void) sendRequestToFriends:(NSMutableString *)params{
    
    //    NSMutableString *taggedFriend=[params valueForKey:@"tags"];
    //    NSInteger count=[[params valueForKey:@"count"] integerValue];
    if (params==nil) {
        params= self.friendsList;
    }
    [[AppDelegate sharedAppDelegate]showHUDLoadingView:@""];
    NSMutableDictionary<FBGraphObject> *object =
    [FBGraphObject openGraphObjectForPostWithType:@"dartwheelchief:life"
                                            title:@""
                                            image:@"http://i.imgur.com/zhNdgpi.png?1"
                                            //image:@"fbstaging://graph.facebook.com/staging_resources/MDExNDUzNzA0OTM0OTAyODEwOjQxMjYzOTIzOA=="
                                              url:@"https://itunes.apple.com/app/id892026202"
                                      description:@"Hi Friends, Please join me in Dart Wheel Chief. Select from 3 funny characters and try to avoid them with your darts hitting on the targets. Lets see who can get a bulls eye!. "];
    //self.strPostMessage = [NSString stringWithFormat:@"Yeah I just earned 5 live's in Dart Wheel Chief game. Its to addictive just have a try once and I bet you too feel the same what I felt. "];
    
    NSMutableDictionary<FBGraphObject> *action = [FBGraphObject openGraphActionForPost];
    action[@"tags"]=params;
    action[@"life"]=object;
    
    
    [FBRequestConnection startForPostWithGraphPath:@"me/dartwheelchief:request"
                                       graphObject:action
                                 completionHandler:^(FBRequestConnection *connection,
                                                     id result,
                                                     NSError *error) {
                                     [[AppDelegate sharedAppDelegate]hideHUDLoadingView ];
                                     
                                     if (!error) {
                                         [[NSUserDefaults standardUserDefaults]setInteger:(self.friendsCount/2) forKey:@"life"];
                                         //                         [[NSUserDefaults standardUserDefaults]setInteger:1 forKey:@"life"];
                                         
                                         [[NSNotificationCenter defaultCenter] postNotificationName:@"postSuccess" object:nil];
                                     }else{
                                         NSLog(@"error %@",error.description);
                                         [[AppDelegate sharedAppDelegate]showToastMessage:@"Error on posting to facebook.Please try again"];
                                         
                                     }
                                     // handle the result
                                 }];
    
}

/*
#pragma mark -

#pragma mark-  chart boost delegate methods


- (BOOL)shouldDisplayRewardedVideo:(CBLocation)location{
    
    NSLog(@"here1");
    self.videoWatched=NO;
    return YES;
}

- (void)didDisplayRewardedVideo:(CBLocation)location{
    NSLog(@"here2");
}

- (void)didCacheRewardedVideo:(CBLocation)location{
    NSLog(@"here3");
    
}

- (void)didFailToLoadRewardedVideo:(CBLocation)location
                         withError:(CBLoadError)error{
    NSLog(@"here4");
//    [[CCDirector sharedDirector] popScene];
//    [[CCDirector sharedDirector] resume];
   // int darts=(int)[[NSUserDefaults standardUserDefaults]integerForKey:@"darts"];
   // if (darts<=0 || darts&& self.unableLoadVideo==NO) {
       // UIAlertView * alert=[[UIAlertView alloc]initWithTitle:@"Unable to load video" message:@"continue playing without internet connection." delegate:nil cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
       // [alert show];
        self.videoWatched=YES;
    
       // self.unableLoadVideo=YES;
   // }
}

- (void)didDismissRewardedVideo:(CBLocation)location{
    NSLog(@"here5");
}

- (void)didCloseRewardedVideo:(CBLocation)location{
    NSLog(@"here6");
    [[CCDirector sharedDirector] popScene];
    [[CCDirector sharedDirector] resume];
    if(self.videoWatched==YES)
    {
        self.videoWatched=YES;
    }
    else{
        self.videoWatched=NO;
    }
    /* if ([GameState sharedState].levelNumber<=10) {
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
/*}

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
        if ([GameState sharedState].levelNumber<=10) {
            reward=13;
            
        }
        else if ([GameState sharedState].levelNumber>10 &&[GameState sharedState].levelNumber<=30){
            reward=23;
        }
        else{
            reward=27;
        }
        [[NSUserDefaults standardUserDefaults]setInteger:reward forKey:@"darts"];
        [[NSUserDefaults standardUserDefaults]synchronize];
    //}
    NSLog(@"watched");
    self.videoWatched=YES;
    
    
}

*/

-(void) storyPostwithDictionary:(NSDictionary *)dict{
    
    //http://www.screencast.com/t/S0YR7HvL4L
    
    
    NSString *description = [NSString stringWithFormat:@"%@",[dict objectForKey:FacebookDescription]];
    NSString *title = [NSString stringWithFormat:@"%@",[dict objectForKey:FacebookTitle]];
    
    NSString *type = [NSString stringWithFormat:@"%@",[dict objectForKey:FacebookType]];
    
    NSString *actionType = [NSString stringWithFormat:@"/me/dartwheelchief:%@",[dict objectForKey:FacebookActionType]];
    NSLog(@"Type = %@", type);
    NSLog(@"Action  =%@",actionType);
    
//    UIImage *image = [UIImage imageNamed:@"sdp.png"];
//    [FBRequestConnection startForUploadStagingResourceWithImage:image completionHandler:^(FBRequestConnection *connection, id result, NSError *error){
//    
//     if (error) {
//     NSLog(@"Error = %@",error);
//     }
//     else{
//      NSLog(@"Result = %@",result);
    //fbstaging://graph.facebook.com/staging_resources/MDExNDQyNjIzMzQyNjc3NjM2OjUxMDY4MTkwNg==
    
    id<FBGraphObject> object =
    //[FBGraphObject openGraphObjectForPostWithType:[NSString stringWithFormat:@"dartwheelchief:%@",type] title:title image:@"http://www.screencast.com/t/cXsYyrN75vZ" url:@"http://www.globusgames.com/" description:description];
    //[FBGraphObject openGraphObjectForPostWithType:[NSString stringWithFormat:@"dartwheelchief:%@",type] title:title image:@"http://i.imgur.com/zhNdgpi.png?1" url:@"http://www.globusgames.com/" description:description];
    [FBGraphObject openGraphObjectForPostWithType:[NSString stringWithFormat:@"dartwheelchief:%@",type] title:title image:@"http://i.imgur.com/zhNdgpi.png?1" url:nil description:description];
    
    id<FBOpenGraphAction> action = (id<FBOpenGraphAction>)[FBGraphObject graphObject];
    [action setObject:object forKey:type];
    
    // create action referencing user owned object
    [FBRequestConnection startForPostWithGraphPath:actionType graphObject:action completionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
        if(!error) {
           NSLog(@"OG story posted, story id: %@", [result objectForKey:@"id"]);
           /* [[[UIAlertView alloc] initWithTitle:@"OG story posted" message:@"Check your Facebook profile or activity log to see the story."
                                       delegate:self
                              cancelButtonTitle:@"OK!"
                              otherButtonTitles:nil] show];*/
        } else {
            // An error occurred
            NSLog(@"Encountered an error posting to Open Graph: %@", error);
        }
    }];
//     }
//     }];
   
    
}


-(void) shareLevelCompletionStory:(NSDictionary *)dict{
    
    NSString *description = [NSString stringWithFormat:@"%@",[dict objectForKey:@"description"]];
    NSString *title = [NSString stringWithFormat:@"Level Completed"];
    
    
    UIImage *image = [UIImage imageNamed:@"512X512.png"];
    
    [FBRequestConnection startForUploadStagingResourceWithImage:image completionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
        
        if (error) {
            NSLog(@"Error = %@",error);
        }
        else{
            
            id<FBGraphObject> object =
            [FBGraphObject openGraphObjectForPostWithType:@"dartwheelchief:level" title:title image:[result objectForKey:@"uri"] url:nil description:description];
            
            id<FBOpenGraphAction> action = (id<FBOpenGraphAction>)[FBGraphObject graphObject];
            [action setObject:object forKey:@"level"];
            [FBRequestConnection startForPostWithGraphPath:@"/me/dartwheelchief:complete" graphObject:action completionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
                if(!error) {
                    NSLog(@"OG story posted, story id: %@", [result
                    objectForKey:@"id"]);
                    /*[[[UIAlertView alloc] initWithTitle:@"OG story posted" message:@"Check your Facebook profile or activity log to see the story."
                                               delegate:self
                                      cancelButtonTitle:@"OK!"
                                      otherButtonTitles:nil] show];*/
                } else {
                    // An error occurred
                    NSLog(@"Encountered an error posting to Open Graph: %@", error);
                }
            }];
        }
    }];
    
    // Create an object
    
}

#pragma Reacheability


-(void)reacheability
{
    NSLog(@"Rechability");
    Reachability *reachability = [Reachability reachabilityForInternetConnection];
    [reachability startNotifier];
    
    NetworkStatus status = [reachability currentReachabilityStatus];
    BOOL networkStatus = NO;
    if(status == NotReachable)
    {
        NSLog(@"stringgk////");
        networkStatus = NO;
    }
    else if (status == ReachableViaWiFi)
    {
        NSLog(@"reachable");
        networkStatus = YES;
        
    }
    else if (status == ReachableViaWWAN)
    {
        //3G
        networkStatus = YES;
        
    }
    else
    {
        networkStatus = NO;
    }
    // Do any additional setup after loading the view.
    
    [[NSUserDefaults standardUserDefaults] setBool:networkStatus forKey:@"NetworkStatus"];
    [[NSUserDefaults standardUserDefaults]synchronize];
}
#pragma mark- data base creation
#pragma mark Sqlite DB and Retrive--

-(void)saveinSqlite
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    
    NSLog(@"%@",paths);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *databasePath = [documentsDirectory stringByAppendingPathComponent:@"GameScoreDb.sqlite"];
    //NSLog(@"%@",paths);
    // Check to see if the database file already exists
    
    
    /*if (databaseAlreadyExists == YES) {
     return;
     }*/
    
    // Open the database and store the handle as a data member
    if (sqlite3_open([databasePath UTF8String], &_databaseHandle) == SQLITE_OK)
    {
        // Create the database if it doesn't yet exists in the file system
        
        
        // Create the PERSON table
        const char *sqlStatement = "CREATE TABLE  GameScoreFinal (ID INTEGER PRIMARY KEY AUTOINCREMENT, Level TEXT, Score TEXT,PlayerFbId TEXT,Name TEXT,BullsEye TEXT)";
       
        char *error;
        if (sqlite3_exec(_databaseHandle, sqlStatement, NULL, NULL, &error) == SQLITE_OK)
        {
            NSLog(@"table created");
            // Create the ADDRESS table with foreign key to the PERSON table
            
            NSLog(@"Database and tables created.");
        }
        else
        {
            NSLog(@"````Error: %s", error);
        }
    }
    
    
}

-(void)synchronize
{
   
    
    PFQuery * queryUser=[PFQuery queryWithClassName:ParseScoreTableName];
    NSLog(@"Connected fb user id %@",[[NSUserDefaults standardUserDefaults] objectForKey:ConnectedFacebookUserID]);
    [queryUser whereKey:@"PlayerFacebookID" equalTo:[[NSUserDefaults standardUserDefaults] objectForKey:ConnectedFacebookUserID]];
    [queryUser orderByDescending:@"Level"];
    dispatch_async(dispatch_get_global_queue(0,0),^{
        NSArray *temp=[queryUser findObjects];
        if([temp count]>0)
        {
            //if data is present
            for(int i=0;i<[temp count];i++)
            {
                
                PFObject * objUserData=[temp objectAtIndex:i];
                for(int j=0;j<[localData count];j++)//Local data for loop
                {
                    
                    NSDictionary * localtemp=[localData objectAtIndex:j];
                    [localtemp objectForKey:@"Score"];
                    if([objUserData[@"Level"] integerValue]==[[localtemp objectForKey:@"Level"] integerValue])
                    {
                        
                        if([objUserData[@"Score"] integerValue]<[[localtemp objectForKey:@"Score"] integerValue])
                        {
                            objUserData[@"Score"]=[NSNumber numberWithInt:[[localtemp objectForKey:@"Score"] intValue]];
                           
                         
                            
                            [objUserData saveInBackground];
                        }//if
                        [localData removeObjectAtIndex:j];
                    }//if
                                        
                }//for Local data for loop
            }//for  main loop
            for (int i=0; i<[localData count]; i++) {
                NSDictionary * localtemp=[localData objectAtIndex:i];
                 PFObject * objNewData=[PFObject objectWithClassName:ParseScoreTableName];
                objNewData[@"Level"]=[NSNumber numberWithInt:[[localtemp objectForKey:@"Level"] intValue]];
                objNewData[@"Score"]=[NSNumber numberWithInt:[[localtemp objectForKey:@"Score"] intValue]];
                objNewData[@"PlayerFacebookID"]=[[NSUserDefaults standardUserDefaults]objectForKey:ConnectedFacebookUserID];
                NSString * name=[localtemp objectForKey:@"Name"];
                objNewData[@"Name"]=name;
                objNewData[@"BullsEye"]=[localtemp objectForKey:@"Bulls"];
               // [objNewData saveInBackground];
                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
                    [objNewData saveEventually:^(BOOL succeed, NSError *error){
                        
                        if (succeed) {
                            NSLog(@"Save to Parse");
                            
                            //[self retriveFriendsScore:level andScore:score];
                        }
                        if (error) {
                            NSLog(@"Error to Save == %@",error.localizedDescription);
                        }
                    }];
                });
            }//Parse closed
            
            //check highest level
            if([localData count]>0)
            {
                NSDictionary * localtemp=[localData objectAtIndex:0];
                PFObject * objUserData=[temp objectAtIndex:0];
                if([objUserData[@"Level"] integerValue]>
                   [[localtemp objectForKey:@"Level"] integerValue])
                {
                    [[NSUserDefaults standardUserDefaults] setInteger:([objUserData[@"Level"] intValue]+1)forKey:@"levelClear"];
                }
                else
                {
                    [[NSUserDefaults standardUserDefaults] setInteger:([[localtemp objectForKey:@"Level"] integerValue]+1)forKey:@"levelClear"];
                }
            }
            else
            {//if local data is not there make parse data highest.
                PFObject * objUserData=[temp objectAtIndex:0];
                [[NSUserDefaults standardUserDefaults] setInteger:([objUserData[@"Level"] intValue]+1)forKey:@"levelClear"];
            }
            
            
        }//if
        else
        {
            //if data is not there
            if(master)
            {
                for(int i=0;i<[localData count];i++)
                {
                    PFObject * objUserData=[PFObject objectWithClassName:@"GameScore"];
                    //-------------------
                    NSDictionary * localtemp=[localData objectAtIndex:i];
                    ;
                    [localtemp objectForKey:@"Score"];
                    objUserData[@"Level"]=[NSNumber numberWithInt:[[localtemp objectForKey:@"Level"] intValue]];
                    objUserData[@"Score"]=[NSNumber numberWithInt:[[localtemp objectForKey:@"Score"] intValue]];
                    objUserData[@"PlayerFacebookID"]=[[NSUserDefaults standardUserDefaults]objectForKey:ConnectedFacebookUserID];
                    objUserData[@"BullsEye"]=[NSNumber numberWithInt:[[localtemp objectForKey:@"Bulls"] intValue]];
                    
                    NSString * name=[localtemp objectForKey:@"Name"];
                    if ([name  isEqualToString:@"(null)"]) {
                         objUserData[@"Name"]=[[NSUserDefaults standardUserDefaults]objectForKey:@"ConnectedFacebookUserName"];
                    }
                    else
                    {
                        objUserData[@"Name"]=[NSString stringWithFormat:@"%@",[localtemp objectForKey:@"Name"]];
                    }
                    //----------------------
                    BOOL result=[objUserData save];
                    NSLog(@"result %d",result);
                }
                [self deleteLocalDataBase];
            }
            else
            {
                //if not master
                [[NSUserDefaults standardUserDefaults] setInteger:1 forKey:@"levelClear"];
            }
        }
        
    });
    [self deleteLocalDataBase];
    NSLog(@"Local Data %@",[[NSUserDefaults standardUserDefaults]objectForKey:@"LocalScoredDictionary"]);
    
}

-(void)deleteLocalDataBase
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSLog(@"-------%@",paths);
    sqlite3_stmt *stmt=nil;
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *databasePath = [documentsDirectory stringByAppendingPathComponent:@"GameScoreDb.sqlite"];
    
    const char *sql = "Delete from GameScoreFinal";
    
    
    if(sqlite3_open([databasePath UTF8String], &_databaseHandle)!=SQLITE_OK)
        NSLog(@"error to open");
    if(sqlite3_prepare_v2(_databaseHandle, sql, -1, &stmt, NULL)!=SQLITE_OK)
    {
        NSLog(@"error to prepare");
        NSLog(@"%s Prepare failure '%s' (%1d)", __FUNCTION__, sqlite3_errmsg(_databaseHandle), sqlite3_errcode(_databaseHandle));
        
        
    }
    if(sqlite3_step(stmt)==SQLITE_DONE)
    {
        NSLog(@"Delete successfully");
    }
    else
    {
        NSLog(@"Delete not successfully");
        
    }
    sqlite3_finalize(stmt);
    sqlite3_close(_databaseHandle);
    
    
}

-(void)retriveFromSQL
{
    localData=[[NSMutableArray alloc]init];
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    
    NSLog(@"%@",paths);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *databasePath = [documentsDirectory stringByAppendingPathComponent:@"GameScoreDb.sqlite"];
    NSLog(@"Connected fb user id %@",[[NSUserDefaults standardUserDefaults] objectForKey:ConnectedFacebookUserID]);
    
    // Check to see if the database file already exists
    NSString * connectedFBid=[[NSUserDefaults standardUserDefaults] objectForKey:ConnectedFacebookUserID];
    NSString *query = [NSString stringWithFormat:@"select * from GameScoreFinal where PlayerFbId = \"%@\" ORDER BY Level Desc",connectedFBid];
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
            char *playerFbid = (char *) sqlite3_column_text(stmt,3);
            char * name=(char *)sqlite3_column_text(stmt,4);
            char * bullsEye=(char *) sqlite3_column_text(stmt, 5);
            NSString *strLevel= [NSString  stringWithUTF8String:level];
            
            NSString *strScore  = [NSString stringWithUTF8String:score];
            NSString *playerFBid  = [NSString stringWithUTF8String:playerFbid];
            NSString * Name=[NSString stringWithUTF8String:name];
            NSString * bulls=[NSString stringWithUTF8String:bullsEye];
            NSLog(@"player FB ID %@",playerFBid);
            if([playerFBid isEqualToString:@"Master"])
            {
                master=TRUE;
            }
            NSLog(@"Level %@ and Score %@ ",strLevel,strScore);
            NSString * keyLevel=strLevel;
            NSString * keyScore=strScore;
            NSMutableDictionary * temp=[[NSMutableDictionary alloc]init];
            [temp setObject:keyLevel forKey:@"Level"];
            [temp setObject:keyScore forKey:@"Score"];
            [temp setObject:playerFBid forKey:@"PlayerFbID"];
            [temp setObject:Name forKey:@"Name"];
            [temp setObject:bulls forKey:@"Bulls"];
            [localData addObject:temp];
        }
    }
    @catch(NSException *e)
    {
        NSLog(@"%@",e);
    }
    
    
}


#pragma mark -
#pragma mark - Loading View mbprogresshud

-(void) showHUDLoadingView:(NSString *)strTitle
{
    HUD = [[MBProgressHUD alloc] initWithView:self.window];
    [self.window addSubview:HUD];
    //HUD.delegate = self;
    //HUD.labelText = [strTitle isEqualToString:@""] ? @"Loading...":strTitle;
    HUD.detailsLabelText=[strTitle isEqualToString:@""] ? @"Loading...":strTitle;
    [HUD show:YES];
}

-(void) hideHUDLoadingView
{
    [HUD removeFromSuperview];
}

-(void)showToastMessage:(NSString *)message
{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.window
                                              animated:YES];
    
    // Configure for text only and offset down
    hud.mode = MBProgressHUDModeText;
    hud.detailsLabelText = message;
    hud.margin = 10.f;
    hud.yOffset = 130.f;
    hud.removeFromSuperViewOnHide = YES;
    [hud hide:YES afterDelay:2.0];
}

+(AppDelegate *)sharedAppDelegate
{
    return (AppDelegate *)[[UIApplication sharedApplication] delegate];
}

#pragma mark -

#pragma mark-  chart boost delegate methods
/*
- (void)didCloseInterstitial:(CBLocation)location
{
    NSLog(@"Interstial add");
   
    [[NSNotificationCenter defaultCenter] postNotificationName:@"sharePopUp" object:nil];
    //[self sharePopUp];
    
}


- (BOOL)shouldDisplayRewardedVideo:(CBLocation)location{
    
    NSLog(@"here1");
    self.videoWatched=NO;
    self.failVideo=NO;
    return YES;
}

- (void)didDisplayRewardedVideo:(CBLocation)location{
    NSLog(@"here2");
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
        [[NSUserDefaults standardUserDefaults]setInteger:reward forKey:@"darts"];
        [[NSUserDefaults standardUserDefaults]synchronize];
        [[NSNotificationCenter defaultCenter]postNotificationName:@"updatelblDarts" object:nil];
        //[self.lblDarts  setString:[NSString stringWithFormat:@"Darts : %i",reward]];
       // [[NSUserDefaults standardUserDefaults]setInteger:reward forKey:@"darts"];
       // [[NSUserDefaults standardUserDefaults]synchronize];
        // [[CCDirector sharedDirector]resume];
        if (theTime==20) {
            theTime=20;
        }
        else{
            [[NSUserDefaults standardUserDefaults]setInteger:theTime forKey:@"theTime"];
            [[NSUserDefaults standardUserDefaults]synchronize];
            [[NSNotificationCenter defaultCenter]postNotificationName:@"TheTime" object:nil];
          theTime=(int)[[NSUserDefaults standardUserDefaults]integerForKey:@"theTime"];
        }//[self schedule:@selector(loop) interval:1/30];
        //[self schedule:@selector(updateTimeDisplay) interval:1];
        
    }
    
    
}

- (void)didFailToLoadRewardedVideo:(CBLocation)location
                         withError:(CBLoadError)error{
    NSLog(@"here4");
    self.failVideo=YES;*/
    /* not required  if(self.videoWatched==YES)
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
/*}

- (void)didDismissRewardedVideo:(CBLocation)location{
    NSLog(@"here5");
}

- (void)didCloseRewardedVideo:(CBLocation)location{
    NSLog(@"here6");
    //
    if(self.videoWatched==YES)
    {
        self.videoWatched=YES;
        // int darts=[[NSUserDefaults standardUserDefaults]integerForKey:@"darts"];
        [[CCDirector sharedDirector]resume];
        // theTime=(int)[[NSUserDefaults standardUserDefaults]integerForKey:@"theTime"];
        // [self schedule:@selector(loop) interval:1/30];
        // [self schedule:@selector(updateTimeDisplay) interval:1];
    }
    else{
        self.videoWatched=NO;
        [[CCDirector sharedDirector]resume];
        int life1=(int)[[NSUserDefaults standardUserDefaults]integerForKey:@"life"];
        life1--;
        [[NSUserDefaults standardUserDefaults]setInteger:life1 forKey:@"life"];
        [[NSUserDefaults standardUserDefaults]synchronize];
        [Chartboost showInterstitial:CBLocationStartup];
        [[NSNotificationCenter defaultCenter]postNotificationName:@"showgameOver" object:nil];
        //[self showGameOver];
        
        
    }
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
    self.failVideo=NO;
    self.delegateNo=NO;
    if ([GameState sharedState].levelNumber<=10) {
        reward=15;
        
    }
    else if ([GameState sharedState].levelNumber>10 &&[GameState sharedState].levelNumber<=30){
        reward=25;
    }
    else{
        reward=30;
    }
    [[NSUserDefaults standardUserDefaults]setInteger:reward forKey:@"darts"];
    [[NSUserDefaults standardUserDefaults]synchronize];
    [[NSNotificationCenter defaultCenter]postNotificationName:@"updatelblDarts" object:nil];
    //[self.lblDarts  setString:[NSString stringWithFormat:@"Darts : %i",reward]];
   
    //}
    NSLog(@"watched");
    self.videoWatched=YES;
    
    
}*/




@end
