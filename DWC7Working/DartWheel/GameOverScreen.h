//
//  GameOverScreen.h
//  DartWheel
//
//  Created by tang on 12-7-28.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "CCSprite.h"
#import "cocos2d.h"
#import <Parse/Parse.h>
#import <RevMobAds/RevMobAds.h>
#import "AppDelegate.h"
#import "LevelSelectionScene.h"
#import "GameState.h"
#import "Reachability.h"
#import "AdMobViewController.h"
#import  "AdMobFullScreenViewController.h"
#import <Chartboost/Chartboost.h>
#import <sqlite3.h>
#import "WheelMan.h"


@class GameMain;

@interface GameOverScreen : CCSprite<ChartboostDelegate,UIAlertViewDelegate>{
    CCSprite *background;
    
    CCSprite *pasp1,*pasp2,*cvsp1,*cvsp2;
    CCMenuItem *playAgainMI,*chooseVictimMI;
    CCMenu *playAgainButton,*chooseVictimButton,*levelcomplete;
    CCLabelTTF *text1,*text2,*text3,*text4;
    id gameMain;
    GameMain *gm;
    WheelMan * wheelman;
    
    NSUserDefaults *userDefault;
    int totalScore;
    BOOL isNewHighScore;
    AppDelegate * appDelegate;
    
    BOOL if_beated,if_completed;
     sqlite3 *_databaseHandle;
    
    UIViewController *rootViewControl,*rootViewController;
    AdMobViewController *adm;
    AdMobFullScreenViewController *adf;
    UIView * viewHost1;
    NSString *beated_fbID;
}
-(void)setScore;
@property (nonatomic,retain) CCSprite *background;

@property (nonatomic,retain) CCSprite *pasp1,*pasp2,*cvsp1,*cvsp2;
@property (nonatomic,retain) CCMenuItem *playAgainMI,*chooseVictimMI;
@property (nonatomic,retain) CCMenu *playAgainButton,*chooseVictimButton,* nextScrnButton;
@property (nonatomic,retain) CCLabelTTF *text1,*text2,*text3,*text4;
@property (nonatomic,retain) id gameMain,wheel;
@property (nonatomic,retain) CCSprite *matchScore,*LevelScore,*score,*toTalscore;
@property(nonatomic,retain) CCMenu *menuBack;
@property(nonatomic,strong) UIView * topview,*bottomview1,*backgroundView;
@property(nonatomic,strong) UIButton * play, *cancel;
@property(nonatomic,strong)UILabel *level1;

//Rajeev

//@property(nonatomic,retain) GameMain* gm;
@property(nonatomic,retain) CCMenu *playButton,*menuBack1;
@property(nonatomic,retain) CCLabelTTF *scoreText,*lifeBML;

@property(nonatomic,retain) CCMenuItemImage *shareOnFb;
//@property(nonatomic,retain) CCMenuItemImage *shareOnTwitter;
@property(nonatomic,retain)CCMenuItemToggle *toggle;
@property(nonatomic,retain) CCMenu *shareButtons;
@property(nonatomic,retain) NSString *levelCompletionText;
@property(nonatomic,retain) CCMenuItem *playMI,*LevelCompletion;
@property(nonatomic,assign) id lifeOverLayer;

@property(assign) int levelCount;
@property(nonatomic,retain) NSMutableArray *mutArrScores;
@property(assign) BOOL checkLevelClear;
@property(nonatomic, retain) CCSprite *spriteBackground;
@property(nonatomic, retain) CCMenuItemImage *playNextLevel;
//@property(nonatomic, retain) CCLabelTTF *lblPOsition;
//@property(nonatomic, retain) CCLabelTTF *lblHeader;
@property(nonatomic, retain) NSString *lblFbFirstName;

//@property(nonatomic, retain) CCLabelTTF *lblFbBeatFrnd;

@property(nonatomic,retain)UILabel * lblPOsition,* lblHeader,*lblFbBeatFrnd,*lblNewScore;

@property(nonatomic, retain) CCMenu *menuNextLevel;
//------
@property(nonatomic,retain) NSString *strPostMessage;
@property(nonatomic,strong)UIScrollView * scrollView;

@property (nonatomic, assign) NSInteger levelScore;
@property (nonatomic, assign) NSInteger currentLevel,num;
@property (nonatomic, retain) CCMenuItemImage *shareBtnImage;
-(void) saveScoreToParse:(NSInteger)score forLevel:(NSInteger)level;

@end
