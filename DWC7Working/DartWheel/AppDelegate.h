//
//  AppDelegate.h
//  DartWheel
//
//  Created by tang on 12-7-21.
//  Copyright __MyCompanyName__ 2012年. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <FacebookSDK/FacebookSDK.h>
#import <RevMobAds/RevMobAds.h>
#import <Chartboost/Chartboost.h>
#import "MBProgressHUD.h"
#import <sqlite3.h>

@class RootViewController;


@protocol AppDelegateDelegate <NSObject>


-(void)displayFacebookFriendsList;
-(void) hideFacebookFriendsList;
@end


@interface AppDelegate : NSObject <UIApplicationDelegate, RevMobAdsDelegate,ChartboostDelegate> {
	UIWindow			*window;
	RootViewController	*viewController;
    
   // NSString * accessToken;
    MBProgressHUD * HUD;
    FBFrictionlessRecipientCache* ms_friendCache;
    NSNumber * lnumber;
    int theTime;
    sqlite3 *_databaseHandle;
    NSMutableArray * localData;
    BOOL master;
  
}
@property (nonatomic, strong) id <AppDelegateDelegate> delegate;

@property (nonatomic, strong) RootViewController	*viewController;

@property (nonatomic, strong) NSString *accessToken;
@property (nonatomic, assign) NSInteger CurrentValue;
@property (nonatomic, retain) UIWindow *window;
@property(nonatomic) BOOL lifeOver,videoWatched,unableLoadVideo,failVideo,delegateNo;
-(UIViewController *) getRootViewController;

@property (nonatomic, strong) NSDictionary *openGraphDict;

@property(nonatomic,strong)NSMutableString * friendsList;
 @property(nonatomic,assign)int friendsCount;
@property(nonatomic,strong)UIView * displayRequestView,*containerView;
@property(nonatomic,strong)UILabel * messageLabel;
@property(nonatomic,strong)UIButton  *cancelButton,* sendButton;

- (BOOL)openSessionWithAllowLoginUI:(NSInteger)isLoginReq;

-(BOOL) openSessionWithLoginUI:(NSInteger)value withParams: (NSDictionary *)dict;
-(void) shareOnFacebookWithParams:(NSDictionary *)params;

-(void) sendRequestToFriends:(NSMutableString *)params;

-(void) storyPostwithDictionary:(NSDictionary *)dict;

-(void)shareLevelCompletionStory:(NSDictionary *)dict;
-(void)shareBeatStoryWithParams:(NSDictionary *)params;
-(void) showHUDLoadingView:(NSString *)strTitle;
-(void) hideHUDLoadingView;
-(void)showToastMessage:(NSString *)message;
+(AppDelegate *)sharedAppDelegate;


@end
