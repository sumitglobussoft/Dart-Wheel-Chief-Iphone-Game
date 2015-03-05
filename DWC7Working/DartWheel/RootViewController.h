//
//  RootViewController.h
//  DartWheel
//
//  Created by tang on 12-7-21.
//  Copyright __MyCompanyName__ 2012年. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <RevMobAds/RevMobAds.h>
#import <FacebookSDK/FacebookSDK.h>
#import "AdMobViewController.h"


typedef enum _bannerType
{
    kBanner_Portrait_Top,
    kBanner_Portrait_Bottom,
    kBanner_Landscape_Top,
    kBanner_Landscape_Bottom,
}CocosBannerType;

@interface RootViewController : UIViewController {

}
@property (nonatomic, strong) RevMobBannerView *rev_BannerView;
@property(nonatomic) CocosBannerType mBannerType;


@property (nonatomic, strong) NSString *senderID;
@property (nonatomic, retain) UIView *displayRequestView;
@property (nonatomic, retain) UIView *containerView;
@property (nonatomic, retain) UILabel *nameLabel;
@property (nonatomic, retain) UILabel *messageLabel;
@property (nonatomic, retain) UIButton *sendButton;
@property (nonatomic, retain) UIButton *cancelButton;

@property (nonatomic, retain) NSString *senderName;
@property (nonatomic, retain) NSString *currentUserName;

-(id) init;
-(void) createAddBannerView;
-(void) displayBannerView:(BOOL)display;
@end
