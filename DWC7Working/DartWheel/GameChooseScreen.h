//
//  GameChooseScreen.h
//  DartWheel
//
//  Created by tang on 12-7-22.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "CCSprite.h"
#import "cocos2d.h"
#import "AdMobViewController.h"
#import "AdMobFullScreenViewController.h"
#import  <Chartboost/Chartboost.h>


@interface GameChooseScreen : CCSprite{
    CCSprite *background;
    id gm;
    AdMobViewController *adm ;
    UIView *viewHost1;
    CCMenu *m1,*m2,*m3;
    CCMenuItem *menu1,*menu2,*menu3;
    AdMobFullScreenViewController * adf;
    UIViewController *  rootViewController;
    
}
-(void) m1Click;
-(void) m2Click;
-(void) m3Click;
@property(nonatomic,retain) CCSprite *background;
@property(nonatomic,retain) CCMenu *m1,*m2,*m3;
@property(nonatomic,retain) CCMenuItem *menu1,*menu2,*menu3;
@property(nonatomic,retain) id gm;

@end
