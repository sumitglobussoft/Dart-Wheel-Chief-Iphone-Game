//
//  GamePauseScene.h
//  JungleFruitRun
//
//  Created by Sumit Ghosh on 09/09/13.
//  Copyright 2013 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "CCLayer.h"
#import "AdMobViewController.h"
#import "AdMobFullScreenViewController.h"

//@class ActionScene;
//@class ActionLayer;

@interface GamePauseLayer : CCLayer{
    CCMenuItemLabel *resumeMenuItem;
    CCMenuItemLabel *labelMenuItem;
    //AdMobViewController * adm;
   // UIView * viewHost1;
    AdMobFullScreenViewController *adf;
    UIViewController *rootViewController;
}
//+(CCScene *) scene;
@end
@interface GamePauseScene : CCScene {
    GamePauseLayer *layer;
}

@end


