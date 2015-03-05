//
//  Dart.m
//  DartWheel
//
//  Created by tang on 12-7-24.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "Dart.h"
#import "cocos2d.h"
#import "GameMain.h"
@implementation Dart

@synthesize state,clipsArr,hitMovie,cache,targetX,targetY,shootMovie,oriFrame,xinDart,missMovie,missRotateSpeed,gravity,vx,vy,life;

@synthesize endLifeFallParent,theColorID,gameMain;


-(id) initWithColorID:(int) colorID preloadOriginalFrame:(BOOL) plof mayHasMissAction:(BOOL)mhma
{
    //initialization
	if( (self=[super init])) {
        self.theColorID=colorID;
        self.missRotateSpeed=4;
        self.vy=3;
        self.gravity=0.3;
        self.life=4;
        count=0;
        
       
       
        if (plof) {
             
            id ofSprite=[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:[NSString stringWithFormat:@"dart%i0010.png",colorID]];
            NSMutableArray *ofArr=[[NSMutableArray alloc]init];
            [ofArr addObject:ofSprite];
            id ofObj=[CCAnimation animationWithFrames:ofArr delay:0];
            id ofMovie=[CCAnimate actionWithAnimation:ofObj restoreOriginalFrame:YES];
            [self runAction:ofMovie];
        }
        
        if (mhma) {
           
            id missSprite=[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName: [NSString stringWithFormat:@"dart%i0016.png",colorID]];
            NSMutableArray *missArr=[[NSMutableArray alloc]init];
            [missArr addObject:missSprite];
            id missObj=[CCAnimation animationWithFrames:missArr delay:0];
            self.missMovie=[CCAnimate actionWithAnimation:missObj restoreOriginalFrame:NO];
        }
        
        //create animation 
           
        NSMutableArray *hitArr=[NSMutableArray array];
        
        for (int i=10; i<=15; i++) {
            
            NSString *hitSpriteStr;
            if(i<10){
                hitSpriteStr=[NSString stringWithFormat:@"dart%i000%i.png",colorID,i];
                
            }else{
                hitSpriteStr=[NSString stringWithFormat:@"dart%i00%i.png",colorID,i];
            }
            id hitSprite=[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:hitSpriteStr];
            [hitArr addObject:hitSprite];
        }
        
        id animObj=[CCAnimation animationWithFrames:hitArr delay:0.02];
        
        self.hitMovie=[CCAnimate actionWithAnimation:animObj restoreOriginalFrame:NO];
        
        NSMutableArray *shootArr=[NSMutableArray array];
        
        for (int i=1; i<=9; i++) {
            
            NSString *shootSpriteStr;
            if(i<10){
                shootSpriteStr=[NSString stringWithFormat:@"dart%i000%i.png",colorID,i];
                
            }else{
                shootSpriteStr=[NSString stringWithFormat:@"dart%i00%i.png",colorID,i];
            }
            id hitSprite=[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:shootSpriteStr];
            [shootArr addObject:hitSprite];
        }
        
        id shootArrAnimObj=[CCAnimation animationWithFrames:shootArr delay:0.02];
        
        self.shootMovie=[CCAnimate actionWithAnimation:shootArrAnimObj restoreOriginalFrame:NO];
    }
    return self;
}

//fall dart (delay)

-(void) startTime:(double) dtime{

    self.xinDart=[[Dart alloc]initWithColorID:theColorID preloadOriginalFrame:NO mayHasMissAction:YES];
    [self.xinDart playMissAction];
    [self schedule:@selector(fallXinDartInEndLifeFallParent) interval:self.life];
}
//stop fall
-(void) stopTime{
    [self unschedule:@selector(fallXinDartInEndLifeFallParent)];
}

//fall a dart when time over 
-(void) fallXinDartInEndLifeFallParent{
    if (self.parent&&self.parent.parent&&!self.xinDart) {
        [self removeFromParentAndCleanup:YES];
        [self stopTime];
        return;
    }
    [self unschedule:_cmd];
    CGPoint parentPoint=[self convertToWorldSpaceAR:self.endLifeFallParent.position];
    self.xinDart.position=ccp(parentPoint.x,parentPoint.y);
    self.xinDart.rotation=self.rotation+self.parent.rotation;
    if(self.missMovie)
    {
        [self.xinDart runAction:self.missMovie];
    }
    [self.endLifeFallParent addChild:self.xinDart];
    
    [self.xinDart fall];
    [((GameMain*)self.gameMain).wheel.dartsInWheelArr removeObjectAtIndex:0];
    [self removeFromParentAndCleanup:YES];
}
//fall a dart "manually"
-(void) fallXinDartInEndLifeFallParentManual{
    if (self.parent&&self.parent.parent&&!self.xinDart) {
        [self stopTime];
        [self removeFromParentAndCleanup:YES];
        return;
    }
    [self stopTime];
    CGPoint parentPoint=[self convertToWorldSpaceAR:self.endLifeFallParent.position];
    self.xinDart.position=ccp(parentPoint.x,parentPoint.y);
    self.xinDart.rotation=self.rotation+self.parent.rotation;
    if(self.missMovie)
    {
    [self.xinDart runAction:self.missMovie];
    }
    [self.endLifeFallParent addChild:self.xinDart];
    
    [self.xinDart fall];
    
    [self removeFromParentAndCleanup:YES];
}

//fall dart animation 

-(void)fall{
    [self playMissAction];
    
    [self schedule:@selector(fallLoop) interval:1/60];
}
//fall dart animation loop
-(void) fallLoop{
    self.rotation+=self.missRotateSpeed;
    
    double goY=self.position.y+self.vy;
    self.position=ccp(self.position.x,goY);
    
    if(self.missRotateSpeed<=2){
        self.missRotateSpeed=2;
    }
    self.vy-=self.gravity;
    
    if (self.position.y<-100) {
        [self removeFromParentAndCleanup:YES];
        [self unschedule:@selector(fallLoop)];
    }
}

//play fishtailing
-(void)playHitAction{
     
    CCCallFunc *cccf=[CCCallFunc actionWithTarget:self selector:@selector(hitMovieCompleted)];
    CCSequence * seq=[CCSequence actions:self.hitMovie,cccf, nil];
    [self runAction:seq];
}
//play shooting animation
-(void) playShootAction{
    CCCallFunc *cccf=[CCCallFunc actionWithTarget:self selector:@selector(shootMovieCompleted)];
    CCSequence * seq=[CCSequence actions:self.shootMovie,cccf, nil];
    [self runAction:seq];
}

//play missed animatin 

-(void) playMissAction{
    
    CCCallFunc *cccf=[CCCallFunc actionWithTarget:self selector:@selector(missMovieCompleted)];
    CCSequence * seq=[CCSequence actions:self.missMovie,cccf, nil];
    [self runAction:seq];
}

//selectors

-(void)shootMovieCompleted{
    self.state=1;
}

-(void)hitMovieCompleted{
    [self startTime:self.life];
}

-(void)missMovieCompleted{
    
}

// on "dealloc" you need to release all your retained objects
- (void) dealloc
{
	 	
	// don't forget to call "super dealloc"
    [self.hitMovie release];
    [self.missMovie release];
    [self.shootMovie release];
    
	[super dealloc];
}

@end
