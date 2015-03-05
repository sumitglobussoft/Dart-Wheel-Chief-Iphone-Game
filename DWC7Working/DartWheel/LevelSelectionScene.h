//
//  LevelSelectionScene.h
//  BowHunting
//
//  Created by Sumit Ghosh on 03/05/14.
//  Copyright (c) 2014 tang. All rights reserved.
//

#import "CCSprite.h"
#import "cocos2d.h"
#import "GameChooseScreen.h"
#import <Foundation/Foundation.h>
#import "LifeOver.h"
#import "GameState.h"
#import  <RevMobAds/RevMobAds.h>
//#import "UIImageView+WebCache.h"
#import "AdMobViewController.h"
#import "AdMobFullScreenViewController.h"
#import "IntroLayer.h"
#import "KeychainItemWrapper.h"

@interface LevelSelectionScene : CCSprite <UIScrollViewDelegate,UIAlertViewDelegate>{
    UIButton *btnLevels;
    UIButton *btnBack;
    UIViewController *rootViewController;
    UIScrollView *scrollV;
    UIButton *arrowButton;
    CCMenu *menuBack;
    CCSprite *spriteBackground;
    BOOL isNewHighScore;
    NSInteger currentSelectedLevel, currentContentOffsetHeight;
    AdMobFullScreenViewController *adf;
    NSString * levelno;
    IntroLayer * intro;
    UIActivityIndicatorView * acticity;
    AdMobViewController * adm;
    UIView *viewHost1;
     KeychainItemWrapper *wrapperLife;
    KeychainItemWrapper *keyChainLife;
    int bullseye;
}
@property(nonatomic,retain) GameChooseScreen *gameChooseScreen;
@property(nonatomic,retain) id gm;
@property(nonatomic,strong) UIView * topview,*bottomview1,*backgroundView,*friendsView;
@property(nonatomic,strong) UIButton * play, *cancel;
@property(nonatomic,strong)UIImageView * img;
@property(nonatomic,strong)UILabel *level1;
@property(nonatomic,retain) NSMutableArray *mutArrScores;
@property (nonatomic, assign) NSInteger currentLevel,life;
@property(nonatomic, retain) NSString *lblFbFirstName;
@property(nonatomic,strong)UIScrollView * scrollView,* bottomScroll;


-(id)init;
-(void)retriveBullsEye:(NSInteger)levelSelected;

@end
