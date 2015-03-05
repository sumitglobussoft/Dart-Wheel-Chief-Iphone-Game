//
//  GamePauseScene.m
//  JungleFruitRun
//
//  Created by Sumit Ghosh on 09/09/13.
//  Copyright 2013 __MyCompanyName__. All rights reserved.
//

#import "GamePauseScene.h"
#import "IntroLayer.h"
#import "AppDelegate.h"
#import "RootViewController.h"

@implementation GamePauseScene
- (id)init {
    if ((self = [super init])) {
        
        layer = [[[GamePauseLayer alloc] init] autorelease];
        [self addChild:layer];
    }
    return self;
}
@end

@implementation GamePauseLayer

+(CCScene *) scene
{
	// 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
	
	// 'layer' is an autorelease object.
	GamePauseLayer *layer = [GamePauseLayer node];
	
	// add layer as a child to scene
	[scene addChild: layer];
	
	// return the scene
	return scene;
}

- (id) init {
    
    if ((self = [super init])) {
         [[NSNotificationCenter defaultCenter]postNotificationName:kReachabilityChangedNotification object:nil];
        BOOL connect=[[NSUserDefaults standardUserDefaults]boolForKey:@"NetworkStatus"];
        if(connect)
        {
//            rootViewController = (UIViewController*)[(AppDelegate*)[[UIApplication sharedApplication] delegate] getRootViewController];
//            adf = [[AdMobFullScreenViewController alloc]init];
//            [rootViewController presentViewController:adf animated:YES completion:nil];
        

//            AdMobViewController *adm = [[AdMobViewController alloc]init];
//            if([UIScreen mainScreen].bounds.size.height>500)
//            {
//                adm.frame =CGRectMake(0, 520, 320, 50);
//            }
//            else{
//                adm.frame =CGRectMake(0, 430, 320, 50);
//            }
//            UIView *viewHost1 = adm.view;
//            [[[CCDirector sharedDirector] openGLView] addSubview:viewHost1];
        }
        CCSprite *background;
        
        if ([UIScreen mainScreen].bounds.size.height>500) {
            background = [CCSprite spriteWithFile:@"bgblankiPhone.png"];
        }
        else {
            background = [CCSprite spriteWithFile:@"bgblankiPhone.png"];
        }
        
        //background.position = ccp(size.width/2, size.height/2);
        background.anchorPoint=ccp(0,0);
        // add the label as a child to this Layer
        [self addChild: background];
        
        
        CGSize winSize = [CCDirector sharedDirector].winSize;
//        CCSprite *spriteSubMenu = [CCSprite spriteWithFile:@"resumebg.png"];
//        spriteSubMenu.position = ccp(winSize.width/2, winSize.height/2);
//        [self addChild:spriteSubMenu z:0];
        
        CCMenuItem *menuResume=[CCMenuItemImage itemFromNormalImage:@"menu.png" selectedImage:@"menu.png" target:self selector:@selector(loadingMenu)];
        
        CCMenuItem *menuMainMenu = [CCMenuItemImage itemFromNormalImage:@"resume.png" selectedImage:@"resume.png" target:self selector:@selector(actionResume:)];
        
       
        CCMenu  *menu1 = [CCMenu menuWithItems: menuResume, nil];
        menu1.position = ccp(winSize.width/2, winSize.height/2+40);
        [menu1 alignItemsHorizontally];
        [self addChild:menu1 z:100];
        
        CCMenu *menu2 = [CCMenu menuWithItems: menuMainMenu, nil];
        menu2.position = ccp(winSize.width/2, winSize.height/2-40);
        [menu2 alignItemsHorizontally];
        [self addChild:menu2 z:100];
    }
    return self;
}
-(void)actionResume:(id)sender{
    
    [[CCDirector sharedDirector] popScene];
}

-(void)loadingMenu {
    AppDelegate *appDelegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
    [appDelegate.viewController displayBannerView:NO];
   
    [[CCDirector sharedDirector] replaceScene:[IntroLayer scene]];
//    [[CCDirector sharedDirector] replaceScene:[GameIntro node]];
}
-(void) dealloc{
       
	[super dealloc];
}
@end