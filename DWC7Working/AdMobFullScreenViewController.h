//
//  AdMobFullScreenViewController.h
//  CaveRunMowgli
//
//  Created by Sumit on 18/11/14.
//
//

#import <UIKit/UIKit.h>
#import "GADInterstitial.h"


@interface AdMobFullScreenViewController : UIViewController<GADInterstitialDelegate>

@property(nonatomic, strong) GADInterstitial *interstitial;

@end
