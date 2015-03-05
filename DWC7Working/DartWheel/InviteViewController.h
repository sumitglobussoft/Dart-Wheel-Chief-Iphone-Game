//
//  InviteViewController.h
//  DartWheel
//
//  Created by Sumit Ghosh on 29/11/14.
//
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import "SBJson.h"
#import <FacebookSDK/FacebookSDK.h>

@protocol InviteViewControllerDelegate <NSObject>

-(void) updatePurchaseScene:(BOOL)value;

@end

@interface InviteViewController : UIViewController<UITableViewDataSource, UITableViewDelegate, AppDelegateDelegate>

@property (nonatomic, unsafe_unretained) id <InviteViewControllerDelegate> delegate;
@property (nonatomic, retain) UIView *headerView;
@property (nonatomic, retain) NSArray *friendListArray;
@property (nonatomic, retain) NSMutableArray *selectedFriendsArray;
@property (nonatomic, retain) NSDictionary *paramDict;
@property (nonatomic, assign) CGRect frame;
@property (nonatomic, strong) NSString *headerTitle;
@property (nonatomic, assign) BOOL isLifeRequest;
@property (nonatomic, strong) UITableView *listTableView;

-(void) updateFriendsView;
-(id)initWithHeaderTitle:(NSString *)headerTitle;



@end
