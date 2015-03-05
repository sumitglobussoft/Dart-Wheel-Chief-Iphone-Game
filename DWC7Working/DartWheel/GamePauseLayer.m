//
//  GamePauseLayer.m
//  DartWheel
//
//  Created by GBS-ios on 7/9/14.
//
//

#import "GamePauseLayer.h"
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
        
        CGSize winSize = [CCDirector sharedDirector].winSize;
        CCSprite *spriteSubMenu = [CCSprite spriteWithFile:@"gameOverSky.png"];
        spriteSubMenu.position = ccp(winSize.width/2, winSize.height/2);
        [self addChild:spriteSubMenu z:0];
        
        
        
        CCMenuItem *menuResume = [CCMenuItemImage itemFromNormalImage:@"resume.png" selectedImage:@"resume.png" target:self selector:@selector(actionResume:)];
        
        CCMenuItem *menuMainMenu = [CCMenuItemImage itemFromNormalImage:@"menu.png" selectedImage:@"menu.png" target:self selector:@selector(loadingMenu)];
        
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
    //[[CCDirector sharedDirector] replaceScene:[IntroLayer node]];
    [[CCDirector sharedDirector] replaceScene:[CCTransitionFade transitionWithDuration:2.0 scene:[IntroLayer scene]]];
}
-(void) dealloc{
    
	[super dealloc];
}
@end
