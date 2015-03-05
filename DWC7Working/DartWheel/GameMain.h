//
//  HelloWorldLayer.h
//  DartWheel
//
//  Created by tang on 12-7-21.
//  Copyright __MyCompanyName__ 2012年. All rights reserved.
//


// When you import this file, you import all the cocos2d classes
#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "GameChooseScreen.h"
#import "WheelMan.h"
#import "Dart.h"
#import "GameOverScreen.h"
#import "KeychainItemWrapper.h"
#import "GameMain.h"
#import "AppDelegate.h"
#import <Chartboost/Chartboost.h>
#import <Chartboost/CBNewsfeed.h>


// HelloWorldLayer
@interface GameMain : CCLayerColor<AppDelegateDelegate,UIAlertViewDelegate,ChartboostDelegate>
{
    CCSprite *background,*gameCMC;
    WheelMan *wheel;
    BOOL gameIsOver;
    CCSpriteFrameCache *spriteCache;
    BOOL  failVideo,firstTimeChartBoost;
    NSMutableArray *dartArr,*dartsInWheelArr;
    
    CGSize stageSize;
    UIViewController *rootViewController;
    BOOL musicIsOn,dartIsReady,delegateNo;
    
    CCMenuItem *soundOnItem,*soundOffItem;
    CCMenu *soundOnMenu,*soundOffMenu;
    
    CCSprite *runTimeUICMC,*greatBonus,*bullseyeBonus;
    
    int removeDartsNum,life,currentChoosedVictimID,bullseye;
    
    CCSprite *spriteLifes;
   
    id lifesAction;
    
    CCLabelTTF *lifeBML,*levelBML,*scoreText;
    CCMenu *backButton;
    CCMenuItem *backButtonItem;
    
    GameOverScreen *gameOverScreen;
    
    CCSprite *dartsCMC;
    
    double score;
    int count;
    
    // Rajeev
    
    int limitTime,currentLevel;
    
    NSUserDefaults *userDefault;
    int mainLife;
    KeychainItemWrapper *wrapperLife;
    
    CGSize windowSize;
    AdMobViewController *adm ;
    UIView *viewHost1;
    GameMain *gm;
}

// returns a CCScene that contains the HelloWorldLayer as the only child

-(id) init:(int)victimId;
+(CCScene *) scene;
-(void) missOneDart;
-(void) loop;
-(void) showAndReSetLifeSprites;
-(void) hideLifeSprites;
-(void) playDartFill;
-(void) playSnd:(NSString *) snd;
-(void) playBGM;
-(void) muteMusicClicked;
-(void) addDartToWheel:(int) theX y:(int) theY rotation:(double) theRotation oldDart:(Dart*)od newDart:(Dart *)nd;
-(void) shoot:(CGPoint )point;
-(void) newGame:(int)theGuy;
-(void) showGameOver;
-(void) updateLevelText;
-(void)unLoadGame;
@property(nonatomic,retain)  CCSprite *dartsCMC,*greatBonus,*bullseyeBonus;
@property(nonatomic,retain)  CCLabelTTF *lifeBML,*levelBML,*scoreText;
@property(nonatomic,retain)  CCSprite *background,*gameCMC,*runTimeUICMC,*spriteLifes;
@property(nonatomic,retain)  CCMenuItem *soundOnItem,*soundOffItem;
@property(nonatomic,retain)  CCMenu *soundOnMenu,*soundOffMenu;
@property(nonatomic,retain)  GameOverScreen *gameOverScreen;
@property(nonatomic,retain)  WheelMan *wheel;

@property(nonatomic,assign) BOOL gameIsOver,musicIsOn,dartIsReady,gameOverBannerCheck,videoWatched;

@property(nonatomic,assign) CGSize stageSize;

@property(nonatomic,retain) CCSpriteFrameCache *spriteCache;

@property(nonatomic,retain) NSMutableArray *dartArr,*dartsInWheelArr;

@property(nonatomic,assign) int removeDartsNum,life,numberofDarts,currentChoosedVictimID,bullseye,count, theTime,darts;

@property(nonatomic,retain) id lifesAction;

@property(nonatomic,assign) double score;
@property(nonatomic,strong) CCMenuItem *pauseBtn;
//@property(nonatomic,strong) CCLabelBMFont *lblTime;
@property(nonatomic,strong) CCLabelTTF *lblTime,*lblDarts;

@property(nonatomic,assign) BOOL checkLevelClear;
@property(nonatomic,strong) CCLabelTTF *labelLife;
@property(nonatomic,strong) CCMenu *menuResume;
@property(nonatomic,strong) CCMenu *menuHomePage;
@property(nonatomic,strong) CCMenuItemImage *imageResume, *imageMainPage;
@property(nonatomic,assign) id lifeOverLayer;

@property (nonatomic, retain) UIView *displayRequestView;
@property (nonatomic, retain) UIView *containerView;
@property (nonatomic, retain) UILabel *nameLabel;
@property (nonatomic, retain) UILabel *messageLabel;
@property (nonatomic, retain) UIButton *sendButton;
@property (nonatomic, retain) UIButton *cancelButton;

@end
