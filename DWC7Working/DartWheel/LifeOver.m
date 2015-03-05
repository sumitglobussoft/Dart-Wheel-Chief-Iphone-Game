//
//  LifeOver.m
//  BowHunting
//
//  Created by Sumit Ghosh on 26/03/14.
//  Copyright (c) 2014 tang. All rights reserved.
//

#import "LifeOver.h"
#import "IntroLayer.h"
#import "AppDelegate.h"
#import "SBJson.h"
#import <RevMobAds/RevMobAds.h>
#import <Chartboost/Chartboost.h>
#import "GameState.h"
#import "LevelSelectionScene.h"

#define RequestTOFacebook @"LifeRequest"

@implementation LifeOver
@synthesize lblNextLifeTime,timeText,menuAskFrnd,menuShare,lblMoreLifeNow,menuMoreLife,menuBack,strPostMessage;

CGSize ws;


-(id) init
{
	if( (self=[super init])) {
        
        // [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(sharePopUp) name:@"sharePopUp" object:nil];
        
      
    /*    RevMobFullscreen *ad = [[RevMobAds session] fullscreen]; // you must retain this object
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
            
            
          //  adf = [[AdMobFullScreenViewController alloc]init];

                    
            


          // not live
            [Chartboost startWithAppId:@"54d343e70d60253588bccfa9"
                          appSignature:@"b463aee174e22839018d592aad71ef42ceb44286"
                              delegate:self];
            //Live
            
            /*[Chartboost startWithAppId:@"54870c31c909a668589390f5"
                          appSignature:@"b5d7759d477fc9f7ded8b5b9b37890dbb08ff309"
                              delegate:self];
            */
            
            [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(postSuccess) name:@"postSuccess" object:nil];
            
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
        }
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(checkTimeNotification:) name:@"TimerNotification" object:nil];
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(gotFiveLives:) name:@"gotFiveLives" object:nil];
        ws=[[CCDirector sharedDirector]winSize];
        
        //create sky etc..
        

        CCSprite *sky;
        
        if ([UIScreen mainScreen].bounds.size.height>500) {
            sky=[CCSprite spriteWithFile:@"bgblankiPhone.png"];
        }
        else {
            sky=[CCSprite spriteWithFile:@"bgblank.png"];
        }
        sky.position=ccp(ws.width/2,ws.height/2);
        [self addChild:sky];
        
        CCMenuItemImage *imageNomorelives = [CCMenuItemImage  itemFromNormalImage:@"no more lives button.png" selectedImage:@"no more lives button.png"];
        imageNomorelives.position=ccp(ws.width/2,ws.height/2+90);
        [self addChild:imageNomorelives];
        
        self.lblNextLifeTime=[CCLabelTTF labelWithString:@"Time to next life" fontName:@"MetalMacabre" fontSize:20];
        self.lblNextLifeTime.color=ccRED;
        self.lblNextLifeTime.position=ccp(ws.width/2,ws.height/2+25);
        [self addChild:self.lblNextLifeTime];
        
        self.timeText=[CCLabelTTF labelWithString:[NSString stringWithFormat:@"%i: %i",min,sec] fontName:@"TerrorPro" fontSize:20];
        self.timeText.position=ccp(ws.width/2,ws.height/2-5);
        self.timeText.color=ccRED;
        
       userDefault = [NSUserDefaults standardUserDefaults];
       remTime = (int)[userDefault integerForKey:@"timeRem"];
        
        [self updateTime:remTime];
        [self addChild:self.timeText];
        
        
//        if (remTime) {
//            
//            min=remTime/60;
//            sec=remTime%60;
//            
//            if (sec<10) {
//                self.timeText=[CCLabelTTF labelWithString:[NSString stringWithFormat:@"%i: 0%i",min,sec] fontName:@"TerrorPro" fontSize:20];
//            }
//            else{
//                self.timeText=[CCLabelTTF labelWithString:[NSString stringWithFormat:@"%i: %i",min,sec] fontName:@"TerrorPro" fontSize:20];
//            }
//            self.timeText.position=ccp(ws.width/2,ws.height/2-5);
//            self.timeText.color=ccRED;
//            [self addChild:self.timeText];
//            
//            [self schedule:@selector(update) interval:1];
//        }
        
        /*CCMenuItem *menuItemAskFrnds = [CCMenuItemImage   itemFromNormalImage:@"ask friends.png" selectedImage:@"ask friends.png" target:self selector:@selector(askFrndsButtonClicked:)];
        
        menuAskFrnd = [CCMenu menuWithItems: menuItemAskFrnds, nil];
        menuAskFrnd.position = ccp(ws.width/2, 150);
        [menuAskFrnd alignItemsHorizontally];
        [self addChild:menuAskFrnd z:100];*/
        
        
        //=======================================
        
        
        CCMenuItem *menuSahreToLife = [CCMenuItemImage   itemFromNormalImage:@"refill_lives.png" selectedImage:@"refill_lives.png" target:self selector:@selector(ShareButtonAction)];
        
        menuShare = [CCMenu menuWithItems: menuSahreToLife, nil];
        menuShare.position = ccp(ws.width/2, 150);
        [menuShare alignItemsHorizontally];
        [self addChild:menuShare z:100];
        
        
        //===================================
        
        CCMenuItem *menuItemMoreLife = [CCMenuItemImage  itemFromNormalImage:@"more lives now.png" selectedImage:@"more lives now.png" target:self selector:@selector(moreLivesButtonClicked:)];
        
        menuMoreLife = [CCMenu menuWithItems: menuItemMoreLife, nil];
        menuMoreLife.position = ccp(ws.width/2, 80);
        [menuMoreLife alignItemsHorizontally];
        [self addChild:menuMoreLife z:100];
        
        CCMenuItem *menuItemBack = [CCMenuItemImage itemFromNormalImage:@"backLevel.png" selectedImage:@"backLevel.png" target:self selector:@selector(back:)];
        
        menuBack = [CCMenu menuWithItems: menuItemBack, nil];
        menuBack.position = ccp(40, ws.height-70);
        [menuBack alignItemsHorizontally];
        [self addChild:menuBack z:100];
    }
    return self;
}


#pragma mark -
-(void) checkTimeNotification:(NSNotification *)notification{
    
    NSLog(@"Notification Received");
    
    [self compareDate];
}
-(void) updateTime:(int)timeRem{
    
    remTime = timeRem;
    if (remTime) {
        
        min=remTime/60;
        sec=remTime%60;
        
        if (sec<10) {
            
            [self.timeText setString:[NSString stringWithFormat:@"%i: 0%i",min,sec]];
            
        }
        else{
            [self.timeText setString:[NSString stringWithFormat:@"%i: %i",min,sec]];
            
        }
        
        [self unschedule:@selector(update)];
        self.timeText.visible = YES;
        [self.lblNextLifeTime setString:@"Time to next life"];
        [self schedule:@selector(update) interval:1];
    }
}
- (void)update {
    
    remTime--;
    
    [[NSUserDefaults standardUserDefaults]setInteger:remTime forKey:@"timeRem"];
    [[NSUserDefaults standardUserDefaults]synchronize];
    int minute = remTime/60;
    int second = remTime%60;
    
    if (second<10) {
        [self.timeText setString:[NSString stringWithFormat:@"%i:0%i",minute,second]];
    }
    else{
        [self.timeText setString:[NSString stringWithFormat:@"%i:%i",minute,second]];
    }
    
    if (remTime==0) {
        [self unschedule:@selector(update)];
        
        int life = (int)[userDefault integerForKey:@"life"];
        
        life++;
        NSLog(@"life in timer %d",life);
        [userDefault setInteger:life forKey:@"life"];
//        [userDefault setObject:@"0" forKey:@"currentDate"];
        [userDefault synchronize];
        
        remTime=300;
        
        [self.timeText setString:[NSString stringWithFormat:@"05:00"]];
        
        if(life==5)
        {
            [self.timeText setString:@"Full Of Lives..!"];
            
        }
        
        if(life<5)
        {
        [self schedule:@selector(update) interval:1];
        }
       
//        NSString *str =[userDefault objectForKey:@"currentDate"];
//        
//        if (life<5 && [str isEqualToString:@"0"]) {
//         
//            NSDate* now = [NSDate date];
//            //NSLog(@"%@ seconds since recevedData was called last", now);
//            NSDateFormatter *df = [[NSDateFormatter alloc] init];
//            [df setDateFormat:@"dd/MM/yyyy HH:mm:ss"];
//            NSString *dateStr = [df stringFromDate:now];
//            
//            [userDefault setObject:dateStr forKey:@"currentDate"];
//        }
    }
}

#pragma mark-
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
        
        self.timeText.visible = NO;
        [self.lblNextLifeTime setString:@"Full of life"];
        
    }
}
-(void)getExtraLife :(int)aday andHour:(int)ahour andMin:(int)amin andSec:(int)asec {
    

        int hoursInMin = ahour*60;
    hoursInMin=hoursInMin+amin;
    
    int totalTime = amin*60+asec;
    
    int life = (int)[userDefault integerForKey:@"life"];
    int rem =amin%5;
    
    int remTimeforLife = rem*60+asec;
    
    remTimeforLife=300-remTimeforLife;
    
    
    if (aday>0 || hoursInMin>=25) {
        
        [userDefault setInteger:5 forKey:@"life"];
        [userDefault setObject:@"0" forKey:@"currentDate"];
        self.timeText.visible = NO;
        [self.lblNextLifeTime setString:@"Full of life"];
    }
    else if(totalTime>=300){
        //int extralife =amin/5;
        
        //life=life+extralife;
        
        if(life>=5){
            
            [userDefault setInteger:5 forKey:@"life"];
            [userDefault synchronize];
            [userDefault setObject:@"0" forKey:@"currentDate"];
            self.timeText.visible = NO;
            [self.lblNextLifeTime setString:@"Full of life"];
        }
        else{
           /* if (extralife>5) {
                extralife = 5;
            }
            [userDefault setInteger:extralife forKey:@"life"];*/
            [userDefault synchronize];
            [self updateTime:remTimeforLife];
        }
    }
    else{
        [self updateTime:remTimeforLife];
    }
    
    
}


/*
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
        
        int months = (int)[conversionInfo month];
        int days = (int)[conversionInfo day];
        int hours = (int)[conversionInfo hour];
        int minutes = (int)[conversionInfo minute];
        int seconds = (int)[conversionInfo second];
        
        NSLog(@"%d months , %d days, %d hours, %d min %d sec", months, days, hours, minutes, seconds);
        
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
    /*    [self updateTime:remTimeforLife];
        
    }
    else{
        //int extralife =min/5;
        //   NSLog(@"extralife in levelselection %d",extralife);
        [userDefault setInteger:life1 forKey:@"life"];
        [self updateTime:remTimeforLife];
    }
    [userDefault synchronize];
}
*/


#pragma mark
#pragma mark Button methods
#pragma mark ==============================================

-(void)back:(id)sender {
    [viewHost1 removeFromSuperview];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"TimerNotification" object:nil];
    [[CCDirector sharedDirector] replaceScene:[CCTransitionFade transitionWithDuration:1.0 scene:[IntroLayer scene]]];
}

/*-(void)askFrndsButtonClicked:(id)sender {
   // NSLog(@"Ask Friends Button Click");
    NSLog(@"Ask Friends Button Click");
    AppDelegate * appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    
     [[NSNotificationCenter defaultCenter]postNotificationName:kReachabilityChangedNotification object:nil];
    BOOL check = [[NSUserDefaults standardUserDefaults] boolForKey:FacebookConnected];
     BOOL connect=[[NSUserDefaults standardUserDefaults]boolForKey:@"NetworkStatus"];
    if(connect)
    {
    if (check == NO) {
        [appDelegate openSessionWithLoginUI:8 withParams:nil];
        appDelegate.delegate = self;
    }
    else{
        [self gotoFriendsView];
        }
    }
    else{
        UIAlertView *alert =[[UIAlertView alloc] initWithTitle:@"There is no Internet Connection in your device" message:@"Check Internet ConnectionFirst" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
    }

}*/


-(void) askFrndsButtonClicked{
//    if (isSuccess==1) {
//        [[AppDelegate sharedAppDelegate] showToastMessage:@"Something went wrong please try after some time."];
//        return;
//    }
    AppDelegate * appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    
    [[NSNotificationCenter defaultCenter]postNotificationName:kReachabilityChangedNotification object:nil];
    BOOL netWorkConnection=[[NSUserDefaults standardUserDefaults]boolForKey:@"NetworkStatus"];
    
    if (netWorkConnection==YES)
    {
        
        BOOL facebookConnected=[[NSUserDefaults standardUserDefaults]boolForKey:FacebookConnected];
        if (facebookConnected) {
            if (!appDelegate) {
                appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
            }
          
            [self gotoFriendsView];
          
            
        }else{
            
            UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"You have not logged in with facebook" message:@"Facebook not Connected" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
            [alert show];
            
        }
        
    }else {
        UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"Internet Not Connected" message:@"Check internet connection" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [alert show];
        
    }
}

-(void) displayFacebookFriendsList{
    [self gotoFriendsView];
}

-(void) gotoFriendsView{
    
    [[AppDelegate sharedAppDelegate]hideHUDLoadingView];
//    if (!appDelegate) {
//        appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
//        
//    }
       AppDelegate * appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    appDelegate.delegate = nil;
    RootViewController *viewCntrler = (RootViewController*)[appDelegate getRootViewController];
    CGRect frame = [UIScreen mainScreen].bounds;
    FriendsViewController *fbFrnds = [[FriendsViewController alloc] initWithHeaderTitle:@"Ask for Life"];//WithNibName:@"FriendsViewController" bundle:nil];
    fbFrnds.view.frame = CGRectMake(0, 0, frame.size.height, 0);;
    
    //fbFrnds.headerTitle = @"Ask Life";
    [UIView animateWithDuration:1 animations:^{
        
        fbFrnds.view.frame = CGRectMake(0, 0, frame.size.height, frame.size.width);
        [viewCntrler presentViewController:fbFrnds animated:YES completion:nil];
        //[viewCntrler.view addSubview:fbFrnds.view];
    }];
}

/*-(void) gotoFriendsView{
    
    AppDelegate * appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    appDelegate.delegate = nil;
    RootViewController *viewCntrler = (RootViewController*)[appDelegate getRootViewController];
    CGRect frame = [UIScreen mainScreen].bounds;
    FriendsViewController *fbFrnds = [[FriendsViewController alloc] initWithHeaderTitle:@"Ask Life"];//WithNibName:@"FriendsViewController" bundle:nil];
    fbFrnds.view.frame = CGRectMake(0, 0, frame.size.height, 0);
//    fbFrnds.isLifeRequest=YES;
    //fbFrnds.headerTitle = @"Ask Life";
    [UIView animateWithDuration:1 animations:^{
        
        fbFrnds.view.frame = CGRectMake(0, 0, frame.size.height, frame.size.width);
        [viewCntrler presentViewController:fbFrnds animated:YES completion:nil];
        //[viewCntrler.view addSubview:fbFrnds.view];
    }];
}*/

-(void)moreLivesButtonClicked:(id)sender {
    
    //[Chartboost showInterstitial:CBLocationStartup];
    self.menuAskFrnd.visible=NO;
    self.menuMoreLife.visible=NO;
    self.menuBack.visible=NO;
    self.menuShare.visible=NO;
    [viewHost1 removeFromSuperview];
    
    if(!self.storeLayer){
        self.storeLayer=[[Store alloc]init];
        [self addChild:self.storeLayer];
    }
    else{
//        ((*Strore)self.storeLayer).visible=YES;
    }
    //NSLog(@"More Lives Button Click");
}





#pragma mark
#pragma mark Send REquest to friends method
#pragma mark ==============================================
-(void)postSuccess{
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"postSuccess" object:nil];
    UIAlertView * message=[[UIAlertView alloc]initWithTitle:@"Hey,you got Lives" message:@"Enjoy the game" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
    [message show];
    [[CCDirector sharedDirector]replaceScene:[LevelSelectionScene node]];
}



-(void) sendRequestToFrnds{
    
//    int level = [userDefault integerForKey:@"level"];
    
    SBJsonWriter *jsonWriter = [SBJsonWriter new];
    NSDictionary *challenge =  [NSDictionary dictionaryWithObjectsAndKeys: [NSString stringWithFormat:@"Life Request"], @"message", nil];
    NSString *lifeReq = [jsonWriter stringWithObject:challenge];
    
    // Create a dictionary of key/value pairs which are the parameters of the dialog
    
    // 1. No additional parameters provided - enables generic Multi-friend selector
    NSMutableDictionary* params =   [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                     // 2. Optionally provide a 'to' param to direct the request at a specific user
                                     //@"286400088", @"to", // Ali
                                     // 3. Suggest friends the user may want to request, could be game context specific?
                                     //[suggestedFriends componentsJoinedByString:@","], @"suggestions",
                                     lifeReq, @"data",
                                     nil];
    
    [FBWebDialogs presentRequestsDialogModallyWithSession:nil message:@"Request for Life" title:@"Live Request" parameters:params handler:^(FBWebDialogResult result, NSURL *resultUrl, NSError *error){
        
        if (error) {
            // Case A: Error launching the dialog or sending request.
            NSLog(@"Error sending request.==%@",[error localizedDescription]);
        } else {
            
            [[NSNotificationCenter defaultCenter] removeObserver:self name:RequestTOFacebook object:nil];
          //  NSLog(@"Result url==%@",resultUrl);
            //==========================================================
            
            //On Cancel
            // Result url==fbconnect://success?error_code=4201&error_message=User+canceled+the+Dialog+flow
            
            //On Send
            //Result url==fbconnect://success?request=532786970172029&to%5B0%5D=100004995941963
            //=================================================
            if (result == FBWebDialogResultDialogNotCompleted) {
                // Case B: User clicked the "x" icon
               // NSLog(@"User canceled request.");
            } else {
                
                NSLog(@"Request Sent.");
            }//End Else Block
        }//End else block error check
    }];// end FBWebDialogs
}

-(void)dealloc {

    [super dealloc];
}
-(void)ShareButtonAction{
    [[NSNotificationCenter defaultCenter]postNotificationName:kReachabilityChangedNotification object:nil];
    BOOL connect=[[NSUserDefaults standardUserDefaults]boolForKey:@"NetworkStatus"];
    if (connect==NO) {
        UIAlertView *alert =[[UIAlertView alloc] initWithTitle:@"There is no Internet Connection in your device" message:@"Check Internet Connection First" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
        return;
    }
    else{
       
        [Chartboost showInterstitial:CBLocationStartup];
    }
   
  
    
    
}
//}
-(void)sharePopUp
{
     [self  askFrndsButtonClicked];
}
/*-(void)sharePopUp{
    NSLog(@"Facebook share Button Clicked...");
    int life=[[NSUserDefaults standardUserDefaults]integerForKey:@"life"];
    if (life<=0) {
         [[NSNotificationCenter defaultCenter]postNotificationName:kReachabilityChangedNotification object:nil];
        BOOL connect=[[NSUserDefaults standardUserDefaults]boolForKey:@"NetworkStatus"];
        if (connect==NO) {
            UIAlertView *alert =[[UIAlertView alloc] initWithTitle:@"There is no Internet Connection in your device" message:@"Check Internet Connection First" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [alert show];
            return;
        }
     
        
        self.strPostMessage = [NSString stringWithFormat:@"Hi Friends, Please join me in Dart Wheel Chief. Select from 3 funny characters and try to avoid them with your darts hitting on the targets. Lets see who can get a bulls eye!. "];
        //self.strPostMessage = [NSString stringWithFormat:@"Yeah I just earned 5 live's in Dart Wheel Chief game. Its to addictive just have a try once and I bet you too feel the same what I felt. "];
        NSLog(@"Messaga == %@",self.strPostMessage);
        NSString *strLife = [NSString stringWithFormat:@"Level %d",[GameState sharedState].levelNumber];
        
        NSMutableDictionary *params =
        [NSMutableDictionary dictionaryWithObjectsAndKeys:
         self.strPostMessage, @"description", @"", @"caption",@"https://itunes.apple.com/app/id892026202", @"link",@"Dart Wheel Chief",@"name",
         @"http://i.imgur.com/zhNdgpi.png?1",@"picture",
         nil];
        
        AppDelegate *  appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
        appDelegate.openGraphDict = nil;
        appDelegate.delegate = nil;
        appDelegate.lifeOver=YES;
        BOOL fbconnect=[[NSUserDefaults standardUserDefaults]boolForKey:FacebookConnected];
        if (fbconnect) {
            if (FBSession.activeSession.isOpen) {
                
                [appDelegate shareOnFacebookWithParams:params];
                
            }
            else{
                //         [appDelegate shareOnFacebookWithParams:params];
                // [[NSUserDefaults standardUserDefaults]setBool:NO forKey:FacebookConnected];
                // [[NSUserDefaults standardUserDefaults]synchronize];
                [appDelegate openSessionWithLoginUI:1 withParams:params];
            }
        }
        else
        {
            [appDelegate shareOnFacebookWithParams:params];
        }
        
    }

}*/

-(void)gotFiveLives:(NSNotification *)notification{
    [viewHost1 removeFromSuperview];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"TimerNotification" object:nil];
     [[NSNotificationCenter defaultCenter] removeObserver:self name:@"gotFiveLives" object:nil];
   
    [[CCDirector sharedDirector]replaceScene:[LevelSelectionScene node]];
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    if ( buttonIndex==0) {
        [[CCDirector sharedDirector]replaceScene:[IntroLayer scene]];
    }
}

- (void)didCloseInterstitial:(CBLocation)location
{
    NSLog(@"Interstial add");
      [viewHost1 removeFromSuperview];
    [self sharePopUp];
}

- (void)didFailToLoadInterstitial:(CBLocation)location
                        withError:(CBLoadError)error
{
     NSLog(@"Interstial  fail add");
    failToLoadFSAdd =YES;
    [self sharePopUp];
   
}


@end
