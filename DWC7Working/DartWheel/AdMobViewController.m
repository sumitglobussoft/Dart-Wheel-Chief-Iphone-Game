//
//  AdMobViewController.m
//  CaveRunMowgli
//
//  Created by Sumit on 18/11/14.
//
//

#import "AdMobViewController.h"
#import "GADBannerView.h"
#import "GADRequest.h"

@interface AdMobViewController ()

@end

@implementation AdMobViewController
@synthesize bannerView ;

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
    
//    self.bannerView = [[GADBannerView alloc] initWithAdSize:kGADAdSizeBanner];
  //  self.bannerView = [[GADBannerView alloc] initWithFrame:CGRectMake(0, self.view.bounds.size.width-40, self.view.bounds.size.height, 40)];
    self.bannerView=[[GADBannerView alloc] initWithFrame:self.frame];

    // Live not @"ca-app-pub-7073257741073458/4307824695";  ;
    self.bannerView.adUnitID = @"ca-app-pub-8534288772685657/2792302122";

   
    
    //Live
    //self.bannerView.adUnitID =@"ca-app-pub-7881880964352996/9310541262";
    
    self.bannerView.rootViewController = self;
    self.bannerView.delegate = self ;
    [self.view addSubview:self.bannerView];
    
    GADRequest *request = [GADRequest alloc] ;
    request.testDevices = [NSArray arrayWithObjects:GAD_SIMULATOR_ID,@"TheIDAppearingInLogs",nil];//
    [self.bannerView loadRequest:request];
    
}
                           
- (void) adView: (GADBannerView*) view didFailToReceiveAdWithError: (GADRequestError*) error{
    NSLog(@"did fail to receive");
}

- (void) adViewDidReceiveAd: (GADBannerView*) view{
    NSLog(@"add received");
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
