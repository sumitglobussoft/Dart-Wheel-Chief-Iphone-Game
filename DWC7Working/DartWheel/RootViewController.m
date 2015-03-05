//
//  RootViewController.m
//  DartWheel
//
//  Created by tang on 12-7-21.
//  Copyright __MyCompanyName__ 2012年. All rights reserved.
//

//
// RootViewController + iAd
// If you want to support iAd, use this class as the controller of your iAd
//

#import "cocos2d.h"

#import "RootViewController.h"
#import "GameConfig.h"
#import "AppDelegate.h"
#import "SBJson.h"

@implementation RootViewController


 // The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.

 - (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
	if ((self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])) {
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(checkNotification:) name:FacebookRequestNotification object:nil];
	// Custom initialization
	}
	return self;
 }


/*
 // Implement loadView to create a view hierarchy programmatically, without using a nib.
 - (void)loadView {
 }
 */


 // Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
// - (void)viewDidLoad {
//	[super viewDidLoad];
// }

-(id) init{
    
    if (self = [super init]) {
        
        
    }
    return self;
}

#pragma mark -
-(void) checkNotification:(NSNotification *)notify{
    
    NSLog(@"Url = %@",notify.object);
    
    NSURL *targetURL = notify.object;
    
    NSRange range = [targetURL.query rangeOfString:@"notif" options:NSCaseInsensitiveSearch];
    
    // If the url's query contains 'notif', we know it's coming from a notification - let's process it
    if(targetURL.query && range.location != NSNotFound)
    {
        // Yes the incoming URL was a notification
        // ProcessIncomingRequest(targetURL, callback);
        [self processRequest:targetURL];
    }
}

-(void) processRequest:(NSURL *)targetURL{
    // Extract the notification id
    
    NSArray *pairs = [targetURL.query componentsSeparatedByString:@"&"];
    NSMutableDictionary *queryParams = [[NSMutableDictionary alloc] init];
    for (NSString *pair in pairs)
    {
        NSArray *kv = [pair componentsSeparatedByString:@"="];
        NSString *val = [[kv objectAtIndex:1]
                         stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        
        [queryParams setObject:val forKey:[kv objectAtIndex:0]];
    }
    
    NSString *requestIDsString = [queryParams objectForKey:@"request_ids"];
    NSArray *requestIDs = [requestIDsString componentsSeparatedByString:@","];
    
    NSString *accessTOken = [[NSUserDefaults standardUserDefaults]objectForKey:@"Facebook Access Token"];
    
    NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:accessTOken,@"access_token", nil];
    //NSLog(@"Request IDS == %@",requestIDs);
    // NSLog(@"At Index 0== %@",[requestIDs objectAtIndex:0]);
    // NSLog(@"Last Index == %@",[requestIDs lastObject]);
    [FBRequestConnection startWithGraphPath:[requestIDs lastObject] parameters:dict HTTPMethod:@"GET" completionHandler:^(FBRequestConnection *connection, id result, NSError *error){
        NSLog(@"Result== %@",result);
        NSLog(@"errror == %@",error);
        if (!error)
        {
            NSLog(@"Display life request UI");
            
            NSDictionary *dict = [NSDictionary dictionaryWithDictionary:result];
            NSString *message = [NSString stringWithFormat:@"%@",[dict objectForKey:@"message"]];
            NSLog(@"Message %@",message);
            if ([message isEqualToString:@"sending life request"]) {
                
                [self displayLifeRequestUI:dict];
            }
            else if([message isEqualToString:@"sending extra life"]){
                NSString *from = [[result objectForKey:@"from"] objectForKey:@"name"];
                self.senderName = from;
                //self.strSenderFbId = [[result objectForKey:@"from"] objectForKey:@"id"];
                NSString *toName = [[result objectForKey:@"to"] objectForKey:@"name"];
                self.currentUserName = toName;
               // NSString *title = [NSString stringWithFormat:@"Says thank you to %@",toName];
               // NSString *description = [NSString stringWithFormat:@"%@ got one extra life gifted by %@",from,toName];
                 NSString *title = [NSString stringWithFormat:@"Says thank you to %@",from];
                 //NSString *description = [NSString stringWithFormat:@"%@ got one extra life gifted by %@",toName,from];
                NSString *description = [NSString stringWithFormat:@"I got one extra life gifted by %@",from];
                
                NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:@"extra life",FacebookType,title,FacebookTitle,description,FacebookDescription,@"say",FacebookActionType, nil];
                AppDelegate *appDelegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
                //[appDelegate openSessionWithAllowLoginUI:1];
                if(![FBSession activeSession].isOpen)
                {
                    [appDelegate openSessionWithLoginUI:3 withParams:dict];
                    
                }
                else{
                    [appDelegate storyPostwithDictionary:dict];

                }
                    [self increaseUserLife:dict];
            }
            else{
                NSLog(@"Unknown request");
            }
        }
        else{
            
            NSLog(@"Error == %@",error.localizedDescription);
        }
    }];
}

#pragma mark -
-(void) displayLifeRequestUI:(NSDictionary *)result{
    
    NSDictionary *fromDataDict = [result objectForKey:@"from"];
    NSDictionary *toDict = [result objectForKey:@"to"];
    
    NSString *sendername = [NSString stringWithFormat:@"%@",[fromDataDict objectForKey:@"name"]];
    NSLog(@"from = %@",sendername);
    self.senderName = sendername;
    
    NSString *receiverName = [NSString stringWithFormat:@"%@",[toDict objectForKey:@"name"]];
    self.currentUserName = receiverName;
    
    
    NSString *senderID = [NSString stringWithFormat:@"%@",[fromDataDict objectForKey:@"id"]];
    self.senderID = senderID;
    NSLog(@"url == http://graph.facebook.com/%@",senderID);
//    NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://graph.facebook.com/%@",senderID]]];
//    NSString *response = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
//    NSLog(@"Response = %@",response);
    
    [self createUI:sendername];
}
-(void) createUI:(NSString *)senderName{
    if (!self.displayRequestView) {
        
        self.displayRequestView = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
        self.displayRequestView.backgroundColor = [UIColor blackColor];
        self.displayRequestView.alpha = 0.4f;
        [self.view addSubview:self.displayRequestView];
        
        self.containerView = [[UIView alloc] initWithFrame:CGRectMake(15, -300, 284, 278)];
        self.containerView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"Score.png"]];
        [self.view addSubview:self.containerView];
        
        
        self.nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 50, 250, 60)];
        self.nameLabel.textAlignment = NSTextAlignmentCenter;
        self.nameLabel.numberOfLines = 1;
        self.nameLabel.font = [UIFont fontWithName:@"TerrorPro" size:25];
        self.nameLabel.textColor = [UIColor colorWithRed:(CGFloat)132/255 green:(CGFloat)98/255 blue:(CGFloat)166/255 alpha:1.0f];
        self.nameLabel.lineBreakMode = NSLineBreakByCharWrapping;
        [self.containerView addSubview:self.nameLabel];
        
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
        [self.sendButton setBackgroundImage:[UIImage imageNamed:@"send.png"] forState:UIControlStateNormal];
        [self.sendButton addTarget:self action:@selector(sendButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        [self.containerView addSubview:self.sendButton];
    }
    
    self.nameLabel.text = [NSString stringWithFormat:@"Help %@",senderName];
    self.messageLabel.text = [NSString stringWithFormat:@"send extra life"];
    
    
    self.displayRequestView.hidden = NO;
    [UIView animateWithDuration:.3 animations:^{
        self.containerView.frame = CGRectMake(17, 65, 284, 278);
    }];
}

-(void) sendButtonClicked:(id)sender{
    
    SBJsonWriter *jsonWriter = [SBJsonWriter new];
    NSDictionary *challenge =  [NSDictionary dictionaryWithObjectsAndKeys: [NSString stringWithFormat:@"got extra life "], @"message", nil];
    NSString *lifeReq = [jsonWriter stringWithObject:challenge];
    
    // Create a dictionary of key/value pairs which are the parameters of the dialog
    
    // 1. No additional parameters provided - enables generic Multi-friend selector
    NSMutableDictionary* params =   [NSMutableDictionary dictionaryWithObjectsAndKeys:self.senderID, @"to",lifeReq, @"data",@"sending extra life",@"message",@"Send Live",@"Title",nil];
    
   // NSString *title = [NSString stringWithFormat:@"I sent extra life to %@",self.senderName];
   // NSString *des = [NSString stringWithFormat:@"Now %@ has one extra life gifted by %@",self.senderName, self.currentUserName];
    NSString *title = [NSString stringWithFormat:@"I sent extra life to %@",self.senderName];
    NSString *des = [NSString stringWithFormat:@"Now %@ has one extra life gifted by %@",self.senderName, self.currentUserName];
    NSDictionary *storyDict = [NSDictionary dictionaryWithObjectsAndKeys:@"life",FacebookType,title,FacebookTitle,des,FacebookDescription,@"send",FacebookActionType, nil];
    
    AppDelegate * appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    appDelegate.openGraphDict = storyDict;
    appDelegate.delegate = nil;
    if (!FBSession.activeSession.isOpen) {
        
        [appDelegate openSessionWithLoginUI:2 withParams:params];
    }
    else{
        [appDelegate sendRequestToFriends:params];
        //        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(sendRequestToFrnds) name:RequestTOFacebook object:nil];
        //        [appDelegate openSessionWithAllowLoginUI:2];
    }
    
    [self cancelButtonClicked:sender];
}
-(void) cancelButtonClicked:(id)sender{
    
    
    [UIView animateWithDuration:.3 animations:^{
        self.containerView.frame = CGRectMake(17, -300, 284, 278);
    }completion:^(BOOL finished){
        if (finished == YES) {
            self.displayRequestView.hidden = YES;
        }
    }];
}
#pragma mark -
-(void) increaseUserLife:(NSDictionary *)dict{
    NSLog(@"Got new life");
    
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    int life = (int)[userDefaults integerForKey:@"life"];
    int newLife;
    if (life<5) {
       newLife = life + 1;
    }
    else{
        newLife = 5;
    }
    [userDefaults setInteger:newLife forKey:@"life"];
    [userDefaults  synchronize];
    
    [[[UIAlertView alloc] initWithTitle:@"Congratulation!" message:[NSString stringWithFormat:@"You got new life"] delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil] show];
    
}
#pragma mark -
- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    [self prefersStatusBarHidden];
}

#pragma mark -

- (void)revmobAdDidReceive {
    NSLog(@"[RevMob Sample App] Ad loaded.");
}

- (void)revmobAdDidFailWithError:(NSError *)error {
    NSLog(@"[RevMob Sample App] Ad failed: %@", error);
}
- (void)revmobUserClickedInTheAd {
    NSLog(@"[RevMob Sample App] User clicked in the Ad.");
}

-(void) createAddBannerView{
     
   /* self.rev_BannerView = [[RevMobAds session] bannerView];
    
    [self.rev_BannerView loadWithSuccessHandler:^(RevMobBannerView *banner) {
        [self.rev_BannerView setFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 40)];
        self.rev_BannerView.hidden = YES;
        [self.view addSubview:banner];
        [self revmobAdDidReceive];
    } andLoadFailHandler:^(RevMobBannerView *banner, NSError *error) {
        [self revmobAdDidFailWithError:error];
    } onClickHandler:^(RevMobBannerView *banner) {
        [self revmobUserClickedInTheAd];
    }];*/
    
    BOOL connect=[[NSUserDefaults standardUserDefaults]boolForKey:@"NetworkStatus"];
    if(connect)
    {
        AdMobViewController *adm = [[AdMobViewController alloc]init];
        if([UIScreen mainScreen].bounds.size.height>500)
        {
            adm.frame =CGRectMake(0, 520, 320, 50);
        }
        else{
            adm.frame =CGRectMake(0, 430, 320, 50);
        }
        UIView *viewHost1 = adm.view;
        [[[CCDirector sharedDirector] openGLView] addSubview:viewHost1];
    }

    
    
}

-(void) displayBannerView:(BOOL)display{
    
    if (display==YES) {
        self.rev_BannerView.hidden = NO;
    }
    else{
        self.rev_BannerView.hidden = YES;
    }
}




-(BOOL) prefersStatusBarHidden{
    return YES;
}
-(void)viewDidAppear:(BOOL)animated {
    
    [super viewDidAppear:YES];
    [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationNone];
}

-(void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:YES];
    [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationNone];
}

// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
	
	//
	// There are 2 ways to support auto-rotation:
	//  - The OpenGL / cocos2d way
	//     - Faster, but doesn't rotate the UIKit objects
	//  - The ViewController way
	//    - A bit slower, but the UiKit objects are placed in the right place
	//
	
#if GAME_AUTOROTATION==kGameAutorotationNone
	//
	// EAGLView won't be autorotated.
	// Since this method should return YES in at least 1 orientation, 
	// we return YES only in the Portrait orientation
	//
	return ( interfaceOrientation == UIInterfaceOrientationPortrait );
	
#elif GAME_AUTOROTATION==kGameAutorotationCCDirector
	//
	// EAGLView will be rotated by cocos2d
	//
	// Sample: Autorotate only in landscape mode
	//
	if( interfaceOrientation == UIInterfaceOrientationLandscapeLeft ) {
		[[CCDirector sharedDirector] setDeviceOrientation: kCCDeviceOrientationLandscapeRight];
	} else if( interfaceOrientation == UIInterfaceOrientationLandscapeRight) {
		[[CCDirector sharedDirector] setDeviceOrientation: kCCDeviceOrientationLandscapeLeft];
	}
	
	// Since this method should return YES in at least 1 orientation, 
	// we return YES only in the Portrait orientation
	return ( interfaceOrientation == UIInterfaceOrientationPortrait );
	
#elif GAME_AUTOROTATION == kGameAutorotationUIViewController
	//
	// EAGLView will be rotated by the UIViewController
	//
	// Sample: Autorotate only in landscpe mode
	//
	// return YES for the supported orientations
	
	return ( UIInterfaceOrientationIsPortrait( interfaceOrientation ) );
	
#else
#error Unknown value in GAME_AUTOROTATION
	
#endif // GAME_AUTOROTATION
	
	
	// Shold not happen
	return NO;
}

//
// This callback only will be called when GAME_AUTOROTATION == kGameAutorotationUIViewController
//
#if GAME_AUTOROTATION == kGameAutorotationUIViewController
-(void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
	//
	// Assuming that the main window has the size of the screen
	// BUG: This won't work if the EAGLView is not fullscreen
	///
	CGRect screenRect = [[UIScreen mainScreen] bounds];
	CGRect rect = CGRectZero;

	
	if(toInterfaceOrientation == UIInterfaceOrientationPortrait || toInterfaceOrientation == UIInterfaceOrientationPortraitUpsideDown)		
		rect = screenRect;
	
	else if(toInterfaceOrientation == UIInterfaceOrientationLandscapeLeft || toInterfaceOrientation == UIInterfaceOrientationLandscapeRight)
		rect.size = CGSizeMake( screenRect.size.height, screenRect.size.width );
	
	CCDirector *director = [CCDirector sharedDirector];
	EAGLView *glView = [director openGLView];
	float contentScaleFactor = [director contentScaleFactor];
	
	if( contentScaleFactor != 1 ) {
		rect.size.width *= contentScaleFactor;
		rect.size.height *= contentScaleFactor;
	}
	glView.frame = rect;
}
#endif // GAME_AUTOROTATION == kGameAutorotationUIViewController

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


- (void)dealloc {
    [super dealloc];
}


@end

