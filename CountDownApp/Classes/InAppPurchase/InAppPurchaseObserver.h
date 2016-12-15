/* 
 
 * Reference : 
 
 Usage
 #import "InAppPurchaseObserver.h"
 
 @interface upgrades : UIViewController <InAppPurchaseObserverDelegate> {
        InAppPurchaseObserver *iAPObServer;
 }
 @end
 
 - (void)viewDidLoad {
    // Init iAP Observer
    iAPObServer = [[InAppPurchaseObserver alloc] init];
 }
 
 - (void)buyPaidVersion {
        [iAPObServer requestPurchaseWithProductIndentifier:@"PaidVersion"];
 }
 
 #pragma mark - InAppPurchaseObserver Delegate
 
 - (void)didFinishPurchaseResult:(BOOL)status error:(NSError *)error {
    if (status) nslog("Purchased!");
 }
 
*/

#import <Foundation/Foundation.h>
#import <StoreKit/StoreKit.h>

@protocol InAppPurchaseObserverDelegate;

@interface InAppPurchaseObserver:NSObject <SKPaymentTransactionObserver, SKProductsRequestDelegate> {
    BOOL isRestore;
}

@property (nonatomic, strong) id<InAppPurchaseObserverDelegate> delegate;
@property (nonatomic, strong) SKProduct *product;

+ (InAppPurchaseObserver*)sharedObserver;

- (void)requestPurchaseWithProductIndentifier:(NSString *)identifier;
- (void)restorePurchase;

@end

@protocol InAppPurchaseObserverDelegate <NSObject>

- (void)didFinishPurchaseResult:(BOOL)status error:(NSError *)error;
- (void)didFinishRestore:(BOOL)status queue:(SKPaymentQueue*)queue error:(NSError*)error;

@end