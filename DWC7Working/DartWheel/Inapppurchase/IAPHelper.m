//
//  IAPHelper.m
//  In App Rage
//
//  Created by Ray Wenderlich on 9/5/12.
//  Copyright (c) 2012 Razeware LLC. All rights reserved.
//

// 1
#import "IAPHelper.h"
#import <StoreKit/StoreKit.h>
#import "VerificationController.h"

NSString *const IAPHelperProductPurchasedNotification = @"IAPHelperProductPurchasedNotification";

// 2
@interface IAPHelper () <SKProductsRequestDelegate, SKPaymentTransactionObserver>
@end

// 3
@implementation IAPHelper {
    SKProductsRequest * _productsRequest;
    RequestProductsCompletionHandler _completionHandler;
    
    NSSet * _productIdentifiers;
    NSMutableSet * _purchasedProductIdentifiers;
}
// Step 1
- (id)initWithProductIdentifiers:(NSSet *)productIdentifiers {
    
    if ((self = [super init])) {
        
        checkRestore = NO;
        // Store product identifiers
        _productIdentifiers = productIdentifiers;
        
        // Check for previously purchased products
        _purchasedProductIdentifiers = [NSMutableSet set];
        for (NSString * productIdentifier in _productIdentifiers) {
            BOOL productPurchased = [[NSUserDefaults standardUserDefaults] boolForKey:productIdentifier];
            if (productPurchased) {
                [_purchasedProductIdentifiers addObject:productIdentifier];
                //NSLog(@"Previously purchased: %@", productIdentifier);
            } else {
                NSLog(@"Not purchased: %@", productIdentifier);
            }
        }
        
        // Add self as transaction observer
        [[SKPaymentQueue defaultQueue] addTransactionObserver:self];
    }
    return self;
}

- (void)requestProductsWithCompletionHandler:(RequestProductsCompletionHandler)completionHandler {
    
    // 1
    _completionHandler = [completionHandler copy];
    
    // 2
    _productsRequest = [[SKProductsRequest alloc] initWithProductIdentifiers:_productIdentifiers];
    _productsRequest.delegate = self;
    [_productsRequest start];
}

- (BOOL)productPurchased:(NSString *)productIdentifier {
    return [_purchasedProductIdentifiers containsObject:productIdentifier];
}

// step 3
- (void)buyProduct:(SKProduct *)product {
    
    SKPayment * payment = [SKPayment paymentWithProduct:product];
    [[SKPaymentQueue defaultQueue] addPayment:payment];
}

- (void)validateReceiptForTransaction:(SKPaymentTransaction *)transaction {
    VerificationController * verifier = [VerificationController sharedInstance];
    [verifier verifyPurchase:transaction completionHandler:^(BOOL success) {
        if (success) {
            NSLog(@"Successfully verified receipt!");
            
        } else {
            NSLog(@"Failed to validate receipt.");
            [[SKPaymentQueue defaultQueue] finishTransaction: transaction];
        }
    }];
}

#pragma mark - SKProductsRequestDelegate

// Step 2
- (void)productsRequest:(SKProductsRequest *)request didReceiveResponse:(SKProductsResponse *)response {
    
    //NSLog(@"Loaded list of products...");
    _productsRequest = nil;
    
    NSArray * skProducts = response.products;
    for (SKProduct * skProduct in skProducts) {
        NSLog(@"Found product: %@ %@ %0.2f",
              skProduct.productIdentifier,
              skProduct.localizedTitle,
              skProduct.price.floatValue);
    }
    _completionHandler(YES, skProducts);
    _completionHandler = nil;
}

- (void)request:(SKRequest *)request didFailWithError:(NSError *)error {
    
    NSLog(@"Failed to load list of products.");
    NSLog(@"Error -==- %@",error);
    _productsRequest = nil;
    
    _completionHandler(NO, nil);
    _completionHandler = nil;
    
     [[[UIAlertView alloc]initWithTitle:@"Error" message:error.localizedDescription delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil]show];
}

#pragma mark SKPaymentTransactionOBserver

// Step 4
- (void)paymentQueue:(SKPaymentQueue *)queue updatedTransactions:(NSArray *)transactions
{
    for (SKPaymentTransaction * transaction in transactions) {
        switch (transaction.transactionState)
        {
            case SKPaymentTransactionStatePurchased:
                [self completeTransaction:transaction];
                [[SKPaymentQueue defaultQueue] removeTransactionObserver:self];
                break;
            case SKPaymentTransactionStateFailed:
                [self failedTransaction:transaction];
                break;
            case SKPaymentTransactionStateRestored:
                [self restoreTransaction:transaction];
            default:
                break;
        }
    };
}

- (void)completeTransaction:(SKPaymentTransaction *)transaction {
    NSLog(@"completeTransaction...");
    
    [self validateReceiptForTransaction:transaction];
    [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
}
- (void)paymentQueue:(SKPaymentQueue *)queue removedTransactions:(NSArray *)transactions
{
    NSLog(@"Purchase removedTransactions");
    
    // Release the transaction observer since transaction is finished/removed.
    [[SKPaymentQueue defaultQueue] removeTransactionObserver:self];
}
- (void)restoreTransaction:(SKPaymentTransaction *)transaction {
    
    //NSLog(@"Transaction info = %@",transaction.description);
    //NSLog(@"restoreTransaction...");
    [self validateReceiptForTransaction:transaction];
    [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
}

- (void)failedTransaction:(SKPaymentTransaction *)transaction {
    
    NSLog(@"failedTransaction...");
    if (transaction.error.code != SKErrorPaymentCancelled)
    {
        NSLog(@"Transaction error: %@", transaction.error.localizedDescription);
        
        [[[UIAlertView alloc]initWithTitle:@"Error" message:transaction.error.localizedDescription delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil]show];
    }
    
    [[SKPaymentQueue defaultQueue] finishTransaction: transaction];
}
-(void)paymentQueue:(SKPaymentQueue *)queue restoreCompletedTransactionsFailedWithError:(NSError *)error{
    NSLog(@"Error when purchasing: %@",error);
}
- (void)provideContentForProductIdentifier:(NSString *)productIdentifier {

    
    keyChainLife = [[KeychainItemWrapper alloc] initWithIdentifier:@"elife" accessGroup:nil];
    
    if ([productIdentifier isEqualToString:@"com.globussoft.newlife"]) {
        
        int multiArrowCount = 5;
        NSString *multiArrowString = [NSString stringWithFormat:@"%i",multiArrowCount];
        [[NSUserDefaults standardUserDefaults]setInteger:multiArrowCount forKey:@"life"];
        [[NSUserDefaults standardUserDefaults]synchronize];
        [keyChainLife setObject:multiArrowString forKey:(__bridge id)kSecValueData];
    }
    
    else {
        [_purchasedProductIdentifiers addObject:productIdentifier];
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:productIdentifier];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }

    
        [[NSNotificationCenter defaultCenter] postNotificationName:IAPHelperProductPurchasedNotification object:productIdentifier userInfo:nil];
}

- (void)restoreCompletedTransactions {
    [[SKPaymentQueue defaultQueue] restoreCompletedTransactions];
}
- (void)viewWillDisappear:(BOOL)animated {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)paymentQueueRestoreCompletedTransactionsFinished:(SKPaymentQueue *)queue {
    //NSLog(@"%@",queue );
    NSLog(@"Restored Transactions are once again in Queue for purchasing %@",[queue transactions]);
    
    NSMutableArray *purchasedItemIDs = [[NSMutableArray alloc] init];
    //NSLog(@"received restored transactions: %i", queue.transactions.count);
    
    for (SKPaymentTransaction *transaction in queue.transactions) {
        NSString *productID = transaction.payment.productIdentifier;
        [purchasedItemIDs addObject:productID];
        //NSLog (@"product id is %@" , productID);
        // here put an if/then statement to write files based on previously purchased items
        // example if ([productID isEqualToString: @"youruniqueproductidentifier]){write files} else { nslog sorry}
    }
    if (queue.transactions.count == 0) {
        if (!checkRestore) {
            [[[UIAlertView alloc] initWithTitle:@"" message:@"Sorry !! No Products for Restore." delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil]show];
            checkRestore = YES;
        }
    }
}
@end