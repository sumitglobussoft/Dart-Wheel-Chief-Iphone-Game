//
//  WheelSkinny.m
//  DartWheel
//
//  Created by tang on 12-7-21.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "WheelMan.h"
#import "cocos2d.h"
#import <UIKit/UIKit.h>
#import "UIImage+ColorAtPixel.h"
#import "Dart.h"
#import "GameMain.h"
#import "GameState.h"

@implementation WheelMan

@synthesize wheel,wheelImage,theGID,targetPosArr,totalTargetsNum,head,speedUp,rotateSpeed,currentSpeed,radius,targetRadius,random,timeStamp;
@synthesize man,fixY,fixX,targetArr,manUIImage,gameMain,dartsInWheelArr,currentLevel,speedPlus,overturnProbability,direction;
@synthesize ouchFace1,ouchFace2,ouchFace3;


-(id) initWithTheGuyID:(int)theGuyID
{
	if( (self=[super init])) {
        ////////////
        //self.direction=1;
        self.overturnProbability=0;
        self.speedPlus=0.05;
        self.rotateSpeed=0.4;
        self.speedUp=0.2;
        self.currentSpeed=0;
        self.radius=168;
        timeStamp=1;
        
        
        [self findrandomValue];
        if ([GameState sharedState].levelNumber) {
            NSLog(@"New Level -=-= %i",[GameState sharedState].levelNumber);
        }
        else{
            [GameState sharedState].levelNumber=1;
        }
        
        self.theGID=theGuyID;
        NSLog(@"New guy %d",theGuyID);
        //create wheel image
        
        self.wheelImage=[self createWheelImage:theGuyID];
    
        self.wheel=[[CCSprite alloc ]init];
        self.wheel.anchorPoint=ccp(0,0);
        [self.wheel addChild:self.wheelImage];
        
        [self addChild:self.wheel];
        
        //create characters
        
        if(theGuyID==1){
            self.fixY=21;
            self.fixX=0;
            self.man=[[CCSprite alloc]  initWithSpriteFrameName:@"bodySkinny.png"];
             
            //self.man.position=ccp(self.man.position.x+self.fixX,self.man.position.y+self.fixY);
            
            self.head=[CCSprite spriteWithSpriteFrameName:@"headSkinny0001.png"];
            self.head.position=ccp(0,116);
            
            self.ouchFace1=[CCSprite spriteWithSpriteFrameName:@"headSkinny0002.png"];
            self.ouchFace2=[CCSprite spriteWithSpriteFrameName:@"headSkinny0003.png"];
            self.ouchFace3=[CCSprite spriteWithSpriteFrameName:@"headSkinny0004.png"];
        }
        
       else  if(theGuyID==2){
           self.fixY=18;
           self.fixX=0;
           self.man=[[CCSprite alloc]  initWithSpriteFrameName:@"bodyFatty.png"];
          
           //self.man.position=ccp(self.man.position.x+self.fixX,self.man.position.y+self.fixY);
         
            self.head=[CCSprite spriteWithSpriteFrameName:@"headFatty0001.png"];
            self.head.position=ccp(0,102);
           
           self.ouchFace1=[CCSprite spriteWithSpriteFrameName:@"headFatty0002.png"];
           self.ouchFace2=[CCSprite spriteWithSpriteFrameName:@"headFatty0003.png"];
           self.ouchFace3=[CCSprite spriteWithSpriteFrameName:@"headFatty0004.png"];
        }
        
        else if(theGuyID==3){
            self.fixY=21;
            self.fixX=0;
            self.man=[[CCSprite alloc]  initWithSpriteFrameName:@"bodyNewguy.png"];
          
            //self.man.position=ccp(self.man.position.x+self.fixX,self.man.position.y+self.fixY);
            
            self.head=[CCSprite spriteWithSpriteFrameName:@"headNewguy0001.png"];
            self.head.position=ccp(0,116);
            
            self.ouchFace1=[CCSprite spriteWithSpriteFrameName:@"headNewguy0002.png"];
            self.ouchFace2=[CCSprite spriteWithSpriteFrameName:@"headNewguy0003.png"];
            self.ouchFace3=[CCSprite spriteWithSpriteFrameName:@"headNewguy0004.png"];
        }
        
        self.ouchFace1.position=self.ouchFace2.position=self.ouchFace3.position=ccp(self.head.position.x,self.head.position.y);
        
        //[self.wheel addChild:self.man];
        [self.wheel addChild:self.head];
        
        self.ouchFace1.visible=self.ouchFace2.visible=self.ouchFace3.visible=NO;
        [self.wheel addChild:self.ouchFace1];
        [self.wheel addChild:self.ouchFace2];
        [self.wheel addChild:self.ouchFace3];
        
        self.manUIImage=[self renderUIImageFromSprite:self.man];
        [self addTargets:theGuyID];
        
        [self schedule:@selector(loop) interval:1/60];
        
        self.dartsInWheelArr=[[NSMutableArray alloc]init];
    }
    return self;
}

-(void)findrandomValue{
    self.random=arc4random()%2;
    NSLog(@"random %d",self.random);
}


//play ouch animation
-(void) playOuch:(int) theID{
    self.ouchFace1.visible=self.ouchFace2.visible=self.ouchFace3.visible=NO;
    if(theID==1){
        self.ouchFace1.visible=YES;
    }
    else if(theID==2){
        self.ouchFace2.visible=YES;
    }
    else if(theID==3){
        self.ouchFace3.visible=YES;
    }
    [self unschedule:@selector(stopOuch)];
    [self schedule:@selector(stopOuch) interval:1];
}
//hide ouch image
-(void)stopOuch{
    self.ouchFace1.visible=self.ouchFace2.visible=self.ouchFace3.visible=NO;
    [self unschedule:_cmd];
}
//stop rotating
-(void) stop{
    [self unschedule:@selector(ouchTime)];
    [self unschedule:@selector(loop)];
}
//remove all darts
-(void) removeAllDatrts:(BOOL)vb{
    for (int i=0; i<[self.dartsInWheelArr count]; i++) {
        Dart *dart=[self.dartsInWheelArr objectAtIndex:i];
        if(dart.parent){
            [dart fallXinDartInEndLifeFallParentManual];
            dart.xinDart.visible=vb;
        }
    }
    self.dartsInWheelArr=[[NSMutableArray alloc]init];
}

//loop , rotate wheel
-(void)loop{
   // NSLog(@"level number %d",[GameState sharedState].levelNumber);
    
    if ([GameState sharedState].levelNumber<21) {
       
         if (self.random==0){
                self.wheel.rotation-=self.currentSpeed;
          }
         else{
                self.wheel.rotation+=self.currentSpeed;
         }
    }
    if ([GameState sharedState].levelNumber>=21) {
        
                  NSLog(@"time stamp %d",timeStamp);
        
            if (timeStamp<=605) {
                self.wheel.rotation-=self.currentSpeed;
                timeStamp++;
                
            }
            else{
                self.wheel.rotation+=self.currentSpeed;
                timeStamp++;
            }
        }
    int s = [GameState sharedState].levelNumber;
    if (s<10) {
       self.currentSpeed+=(self.rotateSpeed*self.direction-self.currentSpeed)*0.05+0.01*15;
        
    }
    else if (s>11 && s<20)
    {
        self.currentSpeed+=(self.rotateSpeed*self.direction-self.currentSpeed)*0.05+0.01*20;
    }
    
    else if (s>20 && s<31){
        self.currentSpeed+=(self.rotateSpeed*self.direction-self.currentSpeed)*0.05+0.01*25;
    }
    else {
        self.currentSpeed+=(self.rotateSpeed*self.direction-self.currentSpeed)*0.05+0.01*30;
    }
    
    
 
    if ( [GameState sharedState].levelNumber % 4 == 0 )
    {
        int max=[GameState sharedState].levelNumber*10;
        if(max>200){
            //max=200;
        }
        if ( ((int)arc4random()%10000) > 10000-max) //Switch the direction during the /level. Switch more often on higher levels
        {
            self.direction *= -1; //Switch direction
            
        }
    }
}
// try level up 
-(BOOL) tryLevelUp:(double)delay{
    if(self.targetArr.count==0){
        return YES;
    }
    else
        return NO;
}

// get score level
-(int) getScoreLevel:(CGPoint)theDartPoint{
    
    int scoreLevel=0;
    int removeID=-1;
    
    for (int i=0; i<[self.targetArr count]; i++) {
        CCSprite *tar=[self.targetArr objectAtIndex:i];
        
        double dis_a=fabs(tar.position.x-theDartPoint.x);
        double dis_b=fabs(tar.position.y-theDartPoint.y);
        
        double distance=sqrt(dis_a*dis_a+dis_b*dis_b);
        //NSLog(@"Distance %f",distance);
       // NSLog(@"Scale %f",tar.scale);
        distance=round(distance);
        
        if (distance<self.targetRadius) {
            
            if(distance>27*tar.scale){
                scoreLevel=1;
            }
            else if(distance>17*tar.scale){
                scoreLevel=2;
                
            }else if(distance>6*tar.scale){
                scoreLevel= 3;
                
            }else {
                scoreLevel= 4;
            }
            removeID=i;
            
            [self hideTargetWithTarget:tar];
            break;
        }
    }
    
    if (removeID!=-1) {
        [self.targetArr removeObjectAtIndex:removeID];
    }
    return scoreLevel;
}
//hide target 
-(void) hideTargetWithTarget:(CCSprite *) tar{
    id scale0=[CCScaleTo actionWithDuration:0.2 scale:0];
    CCCallFuncND *cccfn=[CCCallFuncND actionWithTarget:self selector:@selector(hideTargetCompleted:) data:tar];
    id seq =[CCSequence actions:scale0,cccfn, nil];
    [tar runAction:seq];
}

//hide target completed 
-(void) hideTargetCompleted:(CCSprite *) tar{
    tar.visible=NO;
}

//missed or not
-(BOOL) isMissed:(CGPoint)dartPoint{
     
    double _a,_b,_c;
    _a=abs(dartPoint.x);
    _b=abs(dartPoint.y);
    _c=sqrt(_a*_a+_b*_b);
    _c=_c;
    
    if(_c>radius){
        return YES;
    }
    return NO;
}
// hit victim or not 
-(BOOL) isHitMan:(CGPoint) dartPoint{
    double scale= CC_CONTENT_SCALE_FACTOR();
   // NSLog(@"scale value==== %lf",scale);
    CGPoint newPoint=dartPoint;
    
    newPoint.x=newPoint.x*scale;
    newPoint.y=newPoint.y*scale;
    
    BOOL isHit=NO;
    
    int yy=newPoint.y;
    int newY;
   
    if(yy>=0){
        newY=self.man.contentSize.height/2*scale-yy;
    }
    else {
        newY=self.man.contentSize.height/2*scale+abs(yy);
    }
    
    CGPoint p = CGPointMake(newPoint.x+self.man.contentSize.width/2*scale+self.fixX*scale, newY+self.fixY*scale);
    
    if (p.x < 0 || p.y < 0 || p.x >= self.man.contentSize.width*scale || p.y >= self.man.contentSize.height*scale) {
        return NO;
    }
    
    UIColor *clr=[self.manUIImage colorAtPixel:p];
    CGFloat *components =(CGFloat *) (CGColorGetComponents(clr.CGColor));
    isHit=components[3]>0;

    return isHit;
}
//get UIImage from CCSprite 
- (UIImage *) renderUIImageFromSprite :(CCSprite *)sprite {
    
    int tx = sprite.contentSize.width;
    int ty = sprite.contentSize.height;
    
    CCRenderTexture *renderer	= [CCRenderTexture renderTextureWithWidth:tx height:ty];
    CGPoint oriPoint=sprite.anchorPoint;
    sprite.anchorPoint	= CGPointZero;
    
    [renderer begin];
    [sprite visit];
    [renderer end];
    sprite.anchorPoint=oriPoint;
    return [renderer getUIImageFromBuffer];
}
//create wheel image
-(CCSprite *) createWheelImage:(int)theID{
     
    NSString *str;
    if(theID==1){
        
        str=@"wheelSkinny.png";
    }
    else if(theID==2){
        str=@"wheelFatty.png";
    }
    else if(theID==3){
        str=@"wheelNewguy.png";
    }
    return [CCSprite spriteWithFile:str];
}
//add targets 
-(void) addTargets:(int)theID{
    self.targetPosArr=[[NSMutableArray alloc]init];
    self.targetArr=[[NSMutableArray alloc]init];
    if (theID==1||theID==3) {
        //Skinny 8 points
       
        [self.targetPosArr addObject:[NSValue valueWithCGPoint:CGPointMake(-119,40)]];
        [self.targetPosArr addObject:[NSValue valueWithCGPoint:CGPointMake(-125,-35)]];
        [self.targetPosArr addObject:[NSValue valueWithCGPoint:CGPointMake(-61,-6)]];
        [self.targetPosArr addObject:[NSValue valueWithCGPoint:CGPointMake(-42,-119)]];
        [self.targetPosArr addObject:[NSValue valueWithCGPoint:CGPointMake(41,-119)]];
        [self.targetPosArr addObject:[NSValue valueWithCGPoint:CGPointMake(60,-5)]];
        [self.targetPosArr addObject:[NSValue valueWithCGPoint:CGPointMake(116,41)]];
        [self.targetPosArr addObject:[NSValue valueWithCGPoint:CGPointMake(125,-35)]];
    }
    
    else if (theID==2) {
        [self.targetPosArr addObject:[NSValue valueWithCGPoint:CGPointMake(-122,60)]];
        [self.targetPosArr addObject:[NSValue valueWithCGPoint:CGPointMake(-136,0)]];
        [self.targetPosArr addObject:[NSValue valueWithCGPoint:CGPointMake(-91,-41)]];
        [self.targetPosArr addObject:[NSValue valueWithCGPoint:CGPointMake(-84,17)]];
        [self.targetPosArr addObject:[NSValue valueWithCGPoint:CGPointMake(-34,-124)]];
        [self.targetPosArr addObject:[NSValue valueWithCGPoint:CGPointMake(84,17)]];
        [self.targetPosArr addObject:[NSValue valueWithCGPoint:CGPointMake(121,60)]];
        [self.targetPosArr addObject:[NSValue valueWithCGPoint:CGPointMake(136,0)]];
        [self.targetPosArr addObject:[NSValue valueWithCGPoint:CGPointMake(91,-41)]];
        [self.targetPosArr addObject:[NSValue valueWithCGPoint:CGPointMake(34,-124)]];
    }
    
//    NSLog(@"Mut array Points -==-%@",self.targetPosArr);
    self.totalTargetsNum=(int)self.targetPosArr.count;
    
    double targetScale=1.0f;
    if(theID==2){
        targetScale=0.8f;
    }
    CCSprite *tar;
    for (int i=0; i<self.totalTargetsNum; i++) {
        
          tar=[CCSprite spriteWithFile:@"target.png"];
          tar.scale=0;
          id delay=[CCDelayTime actionWithDuration:i*0.1];
          id scaleTo=[CCScaleTo actionWithDuration:0.3 scale:targetScale];
          id seq=[CCSequence actions:delay, scaleTo,nil];
          [tar runAction:seq];
          
          CGPoint point=[[self.targetPosArr objectAtIndex:i] CGPointValue];
         
          tar.position=ccp(point.x,point.y);
        
          [self.wheel addChild:tar];
          [self.targetArr addObject:tar];
    }
    
    self.targetRadius=round(tar.contentSize.width*0.5)*targetScale;
}

// on "dealloc" you need to release all your retained objects
-(void) dealloc
{
    [self.man release];
    [self.wheel release];
    [self.manUIImage release];
    [super dealloc];
}
@end
