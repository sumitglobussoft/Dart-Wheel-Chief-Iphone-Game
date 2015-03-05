//
//  AdMobFullScreenViewController.m
//  CaveRunMowgli
//
//  Created by Sumit on 18/11/14.
//
//

#import "AdMobFullScreenViewController.h"
#import "AppDelegate.h"

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
-(id)init
{
   self.interstitial = [self createAndLoadInterstitial];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
   
}

- (GADInterstitial *)createAndLoadInterstitial {
    GADInterstitial *interstitial = [[GADInterstitial alloc] init];
    
    //Live
    //interstitial.adUnitID =interstitial.adUnitID = @"ca-app-pub-7881880964352996/1787274460";
    //  not live
    interstitial.adUnitID = @"ca-app-pub-7881880964352996/1787274460";
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
/*
- (void)interstitialDidReceiveAd:(GADInterstitial *)interstitial {
    NSLog(@"add received");
   
        if ([self.interstitial isReady]) {
            NSLog(@"inside");
            [self performSelector:@selector(doit) withObject:nil afterDelay:1];
//            [self.interstitial presentFromRootViewController:self];
//            [[NSUserDefaults standardUserDefaults]setObject:@"yes" forKey:@"transition"];
//            [[NSUserDefaults standardUserDefaults]synchronize];
        }
}

-(void)doit{
     [self.interstitial presentFromRootViewController:self];
}*/
- (void)interstitialDidReceiveAd:(GADInterstitial *)interstitial {
    //[[NSNotificationCenter defaultCenter]postNotificationName:@"loadAdd" object:nil];
    NSLog(@"add received");
    [self adMob];
    if ([interstitial isReady]) {
        NSLog(@"inside");
        
        [interstitial presentFromRootViewController:self];
        
    }
}
-(void)interstitial:(GADInterstitial *)ad didFailToReceiveAdWithError:(GADRequestError *)error
{
    
    NSLog(@"Failed to recieve Ad");
}
-(void)adMob
{
    BOOL checkInternet=[[NSUserDefaults standardUserDefaults]objectForKey:@"NetworkStatus"];
    if (checkInternet)
    {
        viewController = (UIViewController*)[(AppDelegate *)[UIApplication sharedApplication].delegate getRootViewController];
        
        viewController = (UIViewController*)[(AppDelegate *)[[UIApplication sharedApplication] delegate] getRootViewController];
        
    }
    
    [viewController presentViewController:self animated:NO completion:nil];
    
    
}


@end
