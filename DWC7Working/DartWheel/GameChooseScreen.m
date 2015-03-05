//
//  GameChooseScreen.m
//  DartWheel
//
//  Created by tang on 12-7-22.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "GameChooseScreen.h"
#import "cocos2d.h"
#import "GameMain.h"
#import "LevelSelectionScene.h"

@implementation GameChooseScreen

@synthesize background,gm,menu1,menu2,menu3,m1,m2,m3;

-(id) init
{
    if( (self=[super init])) {
        //create background
        
//        for(NSString* family in [UIFont familyNames]) {
//           NSLog(@"%@", family);
//            for(NSString* name in [UIFont fontNamesForFamilyName: family]) {
//                NSLog(@"  %@", name);
//            }
//        }
        //*********Admob banner
//        adm = [[AdMobViewController alloc]init];
//                adm.frame =CGRectMake(0, 0, 320, 50);
//                viewHost1 = adm.view;
//        [[[CCDirector sharedDirector] openGLView] addSubview:viewHost1];
        
              
//          [[CCDirector sharedDirector] pause];
        
        
       // [self performSelector:@selector(randomTimeScheduler) withObject:self afterDelay:5];

//        NSString *test = [[NSUserDefaults standardUserDefaults]objectForKey:@"transition"];
//        
//        if ([test isEqualToString:@"yes"])  {
//            [[CCDirector sharedDirector]resume];
//        }
        
        

        
        if ([UIScreen mainScreen].bounds.size.height>500) {
             self.background=[CCSprite spriteWithFile:@"choosescreeniPhone5.png"];
        }
        else {
             self.background=[CCSprite spriteWithFile:@"chooseScreen.png"];
        }
       
        self.background.anchorPoint=ccp(0,0);
        [self addChild:self.background];
        
        //create buttons
        self.menu1=[CCMenuItemImage itemFromNormalImage:@"skinny.png"  selectedImage:@"skinny.png" target:self selector:@selector(m1Click)];
        
        self.menu2=[CCMenuItemImage itemFromNormalImage:@"Fatty.png"  selectedImage:@"Fatty.png" target:self selector:@selector(m2Click)];
        
        self.menu3=[CCMenuItemImage itemFromNormalImage:@"Newguy.png"  selectedImage:@"Newguy.png" target:self selector:@selector(m3Click)];
        
        self.m1=[CCMenu menuWithItems:self.menu1, nil];
        self.m2=[CCMenu menuWithItems:self.menu2, nil];
        self.m3=[CCMenu menuWithItems:self.menu3, nil];
    
        if ([UIScreen mainScreen].bounds.size.height>500) {
            self.m1.position=ccp(140,380);
            self.m2.position=ccp(110,280);
            self.m3.position=ccp(160,220);
        }
        else {
            self.m1.position=ccp(140,340);
            self.m2.position=ccp(110,240);
            self.m3.position=ccp(160,180);
        }
       
        //set position and add buttons to screen
        [self addChild:self.m1];
        [self addChild:self.m2];
        [self addChild:self.m3];
    }
    
    return self;
}
-(void)randomTimeScheduler{
      [rootViewController presentViewController:adf animated:YES completion:nil];
}


// button handller
-(void) m1Click{
    self.visible=NO;
 
  /*  RevMobFullscreen *ad = [[RevMobAds session] fullscreen]; // you must retain this object
    [ad loadWithSuccessHandler:^(RevMobFullscreen *fs) {
        [fs showAd];
        //NSLog(@"Ad loaded Revmob");
        [[CCDirector sharedDirector] pause];
    } andLoadFailHandler:^(RevMobFullscreen *fs, NSError *error) {
        NSLog(@"Ad error Revmob: %@",error);
    } onClickHandler:^{
        //NSLog(@"Ad clicked Revmob");
    } onCloseHandler:^{
        //NSLog(@"Ad closed Revmob");
        [[CCDirector sharedDirector] resume];
    }];*/
   // [viewHost1 removeFromSuperview];
    
    gm = [[GameMain alloc]init:1];
    [GameState sharedState].victimId=1;
   // int life=(int)[[NSUserDefaults standardUserDefaults]integerForKey:@"life"];
    [[CCDirector sharedDirector] replaceScene:[CCTransitionFade transitionWithDuration:0.5 scene:gm withColor:ccWHITE]];
}

-(void) m2Click{
    self.visible=NO;
     //[viewHost1 removeFromSuperview];
    /*RevMobFullscreen *ad = [[RevMobAds session] fullscreen]; // you must retain this object
    [ad loadWithSuccessHandler:^(RevMobFullscreen *fs) {
        [fs showAd];
        //NSLog(@"Ad loaded Revmob");
        [[CCDirector sharedDirector] pause];
    } andLoadFailHandler:^(RevMobFullscreen *fs, NSError *error) {
        NSLog(@"Ad error Revmob: %@",error);
    } onClickHandler:^{
        //NSLog(@"Ad clicked Revmob");
    } onCloseHandler:^{
        //NSLog(@"Ad closed Revmob");
        [[CCDirector sharedDirector] resume];
    }];*/
    
    gm = [[GameMain alloc]init:2];
    [GameState sharedState].victimId=2;
    [[CCDirector sharedDirector] replaceScene:[CCTransitionFade transitionWithDuration:0.5 scene:gm withColor:ccWHITE]];
}

-(void) m3Click{
     //[viewHost1 removeFromSuperview];
   /* RevMobFullscreen *ad = [[RevMobAds session] fullscreen]; // you must retain this object
    [ad loadWithSuccessHandler:^(RevMobFullscreen *fs) {
        [fs showAd];
        //NSLog(@"Ad loaded Revmob");
        [[CCDirector sharedDirector] pause];
    } andLoadFailHandler:^(RevMobFullscreen *fs, NSError *error) {
        NSLog(@"Ad error Revmob: %@",error);
    } onClickHandler:^{
        //NSLog(@"Ad clicked Revmob");
    } onCloseHandler:^{
        //NSLog(@"Ad closed Revmob");
        [[CCDirector sharedDirector] resume];
    }];*/
    
    self.visible=NO;
    gm = [[GameMain alloc]init:3];
    [GameState sharedState].victimId=3;
    [[CCDirector sharedDirector] replaceScene:[CCTransitionFade transitionWithDuration:0.5 scene:gm withColor:ccWHITE]];
}

- (void) dealloc
{
    [self.menu1 release];
    [self.menu2 release];
    [self.menu3 release];
    [self.m1 release];
    [self.m2 release];
    [self.m3 release];
    [self.background release];
    [super dealloc];
}
@end
