//
//  Dart.h
//  DartWheel
//
//  Created by tang on 12-7-24.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "CCSprite.h"
#import "cocos2d.h"
@interface Dart : CCSprite{
    
    int state;
    
    double life;
    
    CCSprite *oriFrame;
    CCAnimate *hitMovie,*shootMovie,*missMovie;
    NSMutableArray *clipsArr;
    CCSpriteFrameCache *cache;
    
    double targetX,targetY;
     
    Dart *xinDart;
    
    double missRotateSpeed,gravity,vx,vy;
    
    CCSprite * endLifeFallParent;
    
    int theColorID;
    
    id gameMain;
    int count;
   
    
}

-(void)stopTime;
-(void) fallXinDartInEndLifeFallParentManual;
-(void) fallXinDartInEndLifeFallParent;
-(void) startTime:(double) dtime;
-(void) fall;
-(void) playMissAction;
-(void)playHitAction;
-(void) playShootAction;
-(id) initWithColorID:(int) colorID preloadOriginalFrame:(BOOL) plof mayHasMissAction:(BOOL)mhma;
@property(nonatomic,assign) int state,theColorID;
@property(nonatomic,retain) NSMutableArray *clipsArr;

@property(nonatomic,retain) CCAnimate *shootMovie,*hitMovie,*missMovie;



@property(nonatomic,retain) CCSpriteFrameCache *cache;

@property(nonatomic,assign) double targetX,targetY,missRotateSpeed,gravity,vx,vy,life;;

@property(nonatomic,retain)  CCSprite *oriFrame;

@property(nonatomic,retain) Dart *xinDart;

@property(nonatomic,retain) CCSprite * endLifeFallParent;

@property(nonatomic,retain)  id gameMain;

 

@end
