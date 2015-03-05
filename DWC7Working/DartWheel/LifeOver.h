//
//  LifeOver.h
//  BowHunting
//
//  Created by Sumit Ghosh on 26/03/14.
//  Copyright (c) 2014 tang. All rights reserved.
//

#import "CCSprite.h"
#import "CCLayer.h"
#import "cocos2d.h"
#import "Store.h"
#import <FacebookSDK/FacebookSDK.h>
#import <RevMobAds/RevMobAds.h>
#import "AppDelegate.h"
#import "AdMobViewController.h"
#import "AdMobFullScreenViewController.h"
#import <Chartboost/Chartboost.h>

@interface LifeOver : CCSprite<AppDelegateDelegate,ChartboostDelegate,UIAlertViewDelegate> {
    
    int min;
    int sec;
    int remTime;
    NSUserDefaults *userDefault;
    AdMobViewController *adm;
    AdMobFullScreenViewController *adf;
    UIView *viewHost1;
    UIViewController *rootViewController;
    int totalScore;
    BOOL failToLoadFSAdd;
}

@property(nonatomic,retain) CCLabelTTF *lblNextLifeTime;
@property(nonatomic,retain) CCLabelTTF *timeText;
@property(nonatomic,retain) CCLabelTTF *lblMoreLifeNow;
@property(nonatomic,retain) CCMenu *menuAskFrnd,* menuShare;
@property(nonatomic,retain) CCMenu *menuMoreLife;
@property(nonatomic,retain) CCMenu *menuBack;
@property(nonatomic,assign) id storeLayer;
@property(nonatomic,retain) NSString *strPostMessage;

@end
