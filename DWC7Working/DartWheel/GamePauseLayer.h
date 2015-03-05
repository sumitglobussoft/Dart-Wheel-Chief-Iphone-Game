//
//  GamePauseLayer.h
//  DartWheel
//
//  Created by GBS-ios on 7/9/14.
//
//


#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "CCLayer.h"
#import "GameMain.h"


@class ActionScene;
@class ActionLayer;

@interface GamePauseLayer : CCLayer
{
    CCMenuItemLabel *resumeMenuItem;
    CCMenuItemLabel *labelMenuItem;
}
@end


@interface GamePauseScene : CCScene {
    GamePauseLayer *layer;
}


@end
