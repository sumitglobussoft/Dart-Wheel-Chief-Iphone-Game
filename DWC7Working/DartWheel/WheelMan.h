//
//  WheelSkinny.h
//  DartWheel
//
//  Created by tang on 12-7-21.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "CCSprite.h"
#import "cocos2d.h"

@interface WheelMan : CCSprite {
    
    CCSprite *wheelImage,*wheel,*man,*head;
    
    int theGID,totalTargetsNum,currentLevel,fixY,fixX,overturnProbability,direction;
    
    double rotateSpeed,speedUp,currentSpeed, radius,targetRadius,speedPlus;
    
    NSMutableArray *targetPosArr,*targetArr,*dartsArr,*dartsInWheelArr;
    
    UIImage *manUIImage;
    
    id gameMain;
    CCSprite *ouchFace1,*ouchFace2,*ouchFace3;
    int count;
}

-(void) playOuch:(int) theID;

-(BOOL) tryLevelUp:(double)delay;

-(void) stop;

-(void) removeAllDatrts:(BOOL)vb;

-(void) hideTargetWithTarget:(CCSprite *) tar;

-(int) getScoreLevel:(CGPoint)theDartPoint;

-(id) initWithTheGuyID:(int)theGuyID;

-(void) addTargets:(int)theID;

-(BOOL) isHitMan:(CGPoint) dartPoint;

-(BOOL) isMissed:(CGPoint)dartPoint;

-(CCSprite*) createWheelImage:(int)theID;

- (UIImage *) renderUIImageFromSprite :(CCSprite *)sprite;

@property(nonatomic,retain) CCSprite *wheel,*wheelImage,*head,*man,*ouchFace1,*ouchFace2,*ouchFace3;

@property(nonatomic,retain) id gameMain;

@property(nonatomic,retain) NSMutableArray *targetPosArr,*targetArr,*dartsInWheelArr;

@property(nonatomic,assign) int theGID,totalTargetsNum,fixY,fixX,currentLevel,overturnProbability,direction,random,timeStamp ;

@property(nonatomic,assign) double rotateSpeed,speedUp,currentSpeed,radius,targetRadius,speedPlus;

@property(nonatomic,retain) UIImage *manUIImage;

@end
