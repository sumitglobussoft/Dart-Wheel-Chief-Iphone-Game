//
//  AdMobFullScreenViewController.m
//  CaveRunMowgli
//
//  Created by Sumit on 18/11/14.
//
//

#import "AdMobFullScreenViewController.h"

@interface AdMobFullScreenViewController ()

@end

@implementation AdMobFullScreenViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
   self.interstitial = [self createAndLoadInterstitial];
}

- (GADInterstitial *)createAndLoadInterstitial {
    GADInterstitial *interstitial = [[GADInterstitial alloc] init];
    interstitial.adUnitID = @"ca-app-pub-4722099521556590/4105472067";
    interstitial.delegate = self;
    GADRequest *request = [GADRequest request];
    request.testDevices = [NSArray arrayWithObjects:GAD_SIMULATOR_ID,@"TheIDAppearingInLogs",nil];
    [interstitial loadRequest:request];
    return interstitial;
}


- (void)interstitialDidDismissScreen:(GADInterstitial *)interstitial {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark --------delegate methods
#pragma mark ===========

- (void)interstitialDidReceiveAd:(GADInterstitial *)interstitial {
    NSLog(@"add received");
   
        if ([self.interstitial isReady]) {
            NSLog(@"inside");
            [self.interstitial presentFromRootViewController:self];
        }
}

@end
