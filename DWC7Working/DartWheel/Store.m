//
//  Store.m
//  BowHunting
//
//  Created by Sumit Ghosh on 09/04/14.
//  Copyright (c) 2014 tang. All rights reserved.
//

#import "Store.h"
#import "IntroLayer.h"
#import "RageIAPHelper.h"

CGSize ws;
@implementation Store

-(id) init
{
	if( (self=[super init])) {
        
        [self storeUI];
        
         [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(productPurchased:) name:IAPHelperProductPurchasedNotification object:nil];
    }
    
    return self;
}
- (void)productPurchased:(NSNotification *)notification {
    
    NSString * productIdentifier = notification.object;
    [_products enumerateObjectsUsingBlock:^(SKProduct * product, NSUInteger idx, BOOL *stop) {
        if ([product.productIdentifier isEqualToString:productIdentifier]) {
            NSLog(@"Products List -==- %@",_products);
        }
    }];
}

-(void)storeUI {
    
    NSLog(@"Click Store Button");
    
    // Background Images
    
    ws = [CCDirector sharedDirector].winSize;
    CCSprite *spriteStore;
    
    if ([UIScreen mainScreen].bounds.size.height>500) {
        
        spriteStore = [CCSprite spriteWithFile:@"bgblankiPhone.png"];
    }
    else {
        spriteStore = [CCSprite spriteWithFile:@"bgblank.png"];
    }
    
    spriteStore.position = ccp(ws.width/2, ws.height/2);
    [self addChild:spriteStore z:-1];
    
//    CCSprite *spriteStoreTitle = [CCSprite spriteWithFile:@"store tilte.png"];
//    spriteStoreTitle.position=ccp(ws.width/2, ws.height-45);
//    [self addChild:spriteStoreTitle];
    
    CCMenuItem *menuItemBack = [CCMenuItemImage itemFromNormalImage:@"backLevel.png" selectedImage:@"backLevel.png" target:self selector:@selector(back:)];
    
    CCMenu *menuBack = [CCMenu menuWithItems: menuItemBack, nil];
    menuBack.position = ccp(40, ws.height-35);
    [menuBack alignItemsHorizontally];
    [self addChild:menuBack z:100];
    
    keyChainLife = [[KeychainItemWrapper alloc] initWithIdentifier:@"elife" accessGroup:nil];
    
    // Extra Life UI
    
    CCSprite *spriteExtraLife = [CCSprite spriteWithFile:@"100_life.png"];
    spriteExtraLife.position=ccp(140, ws.height-230);
    [self addChild:spriteExtraLife];
    
    NSString *numLife = [keyChainLife objectForKey:(__bridge id)kSecAttrLabel];
    int retrievedLife = [numLife intValue];
    CCMenuItem *menuItemExtraLife;
    
    int life=[[NSUserDefaults standardUserDefaults]integerForKey:@"life"];
    
    
    if (life>0) {
        menuItemExtraLife  = [CCMenuItemImage itemFromNormalImage:@"crossbuy.png" selectedImage:@"crossbuy.png" target:self selector:@selector(crossBuyClicked)];
    }
    
    else {
        menuItemExtraLife  = [CCMenuItemImage itemFromNormalImage:@"buy.png" selectedImage:@"buy.png" target:self selector:@selector(extraLifeAction:)];
    }
    
    CCMenu *menuExtraLife = [CCMenu menuWithItems: menuItemExtraLife, nil];
    menuExtraLife.position = ccp(ws.width-80, ws.height-280);
    [menuExtraLife alignItemsHorizontally];
    [self addChild:menuExtraLife z:100];
}

#pragma mark
#pragma mark Button methods
#pragma mark ==============================================

-(void)back:(id)sender {
    [activityInd stopAnimating];

    [[CCDirector sharedDirector] replaceScene:[CCTransitionFade transitionWithDuration:1.0 scene:[IntroLayer scene]]];
}
-(void)crossBuyClicked{
    
    NSLog(@"Product is already purchased....");
    
}
-(void)extraLifeAction:(id)sender {
    
    UINavigationController *rootViewController = (UINavigationController*)[(AppDelegate*)[[UIApplication sharedApplication] delegate] getRootViewController];
    
    activityInd=[[UIActivityIndicatorView alloc]initWithFrame:CGRectMake(ws.width/2, ws.height/2, 50, 50)];
    activityInd.activityIndicatorViewStyle=UIActivityIndicatorViewStyleWhiteLarge;
    activityInd.color=[UIColor redColor];
    [rootViewController.view addSubview:activityInd];
    [activityInd startAnimating];
    
    [[RageIAPHelper sharedInstance] requestProductsWithCompletionHandler:^(BOOL success, NSArray *products) {
        NSLog(@"Products -==--= %@",products);
        if (success) {
           
            if (products.count <=0) {
                
                [[[UIAlertView alloc] initWithTitle:@"" message:@"Please check your internet connection and try again" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil] show];
            }
            else{
                SKProduct *product = products[0];
                
                NSLog(@"Buying %@...", product.productIdentifier);
                
                [[RageIAPHelper sharedInstance] buyProduct:product];
            }
        }
        [activityInd stopAnimating];
    }];
}

-(void)restoreBtnPressed:(id)sender {
    [[RageIAPHelper sharedInstance] restoreCompletedTransactions];
}

-(void)dealloc {
    
    [super dealloc];
}
@end
