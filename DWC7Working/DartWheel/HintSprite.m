//
//  HintSprite.m
//  DartWheel
//
//  Created by GBS-ios on 7/9/14.
//
//

#import "HintSprite.h"

@implementation HintSprite


-(id)init{
    
    if (self = [super init]) {
        
       CGSize ws = [CCDirector sharedDirector].winSize;
        CCSprite *spriteStore;
        CCSprite *spriteHint;
        if ([UIScreen mainScreen].bounds.size.height>500) {
            
            spriteStore = [CCSprite spriteWithFile:@"bgblankiPhone.png"];
            
        }
        else {
            spriteStore = [CCSprite spriteWithFile:@"bgblank.png"];
        }
        
        spriteHint = [CCSprite spriteWithFile:@"hintboard.png"];
        
        spriteStore.position = ccp(ws.width/2, ws.height/2);
        spriteHint.position = ccp(ws.width/2, ws.height/1.7);
        [self addChild:spriteStore z:-1];
        [self addChild:spriteHint];
        
        
        CCMenuItem *menuItemBack = [CCMenuItemImage itemFromNormalImage:@"backLevel.png" selectedImage:@"backLevel.png" target:self selector:@selector(back:)];
        
        CCMenu *menuBack = [CCMenu menuWithItems: menuItemBack, nil];
        menuBack.position = ccp(40, ws.height-35);
        [menuBack alignItemsHorizontally];
        [self addChild:menuBack z:100];
    }
    return self;
}
-(void)back:(id)sender {
    
    [[CCDirector sharedDirector] replaceScene:[CCTransitionFade transitionWithDuration:1.0 scene:[IntroLayer scene]]];
}

@end
