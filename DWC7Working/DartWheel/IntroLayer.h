//
//  IntroLayer.h
//  PresentStacker
//
//  Created by tang on 12-7-12.
//  Copyright __MyCompanyName__ 2012年. All rights reserved.
//


// When you import this file, you import all the cocos2d classes
#import "cocos2d.h"
#import "FriendsViewController.h"
#import "Reachability.h"
#import <RevMobAds/RevMobAds.h>
#import "AdMobViewController.h"
#import "AdMobFullScreenViewController.h"
#import "FriendsViewController.h"
#import "InviteViewController.h"
// HelloWorldLayer
@interface IntroLayer : CCLayer<UIAlertViewDelegate,AppDelegateDelegate,ChartboostDelegate>
{
AdMobViewController *adm;
    UIViewController *rootViewController;
    AdMobFullScreenViewController *adf;
    UIView *viewHost1;
    BOOL playButton;
}
@property (nonatomic, strong) CCMenuItem *connectWithFB,* inviteFriend;
@property(nonatomic,retain)CCMenuItemToggle *fbToggle;
@property(nonatomic,strong)FriendsViewController * fbFrnds;
@property(nonatomic,strong)InviteViewController * invite;
@property(nonatomic)BOOL getLevel;

// returns a CCScene that contains the HelloWorldLayer as the only child
+(CCScene *) scene;

@end
