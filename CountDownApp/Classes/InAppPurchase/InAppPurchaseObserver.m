
#import "InAppPurchaseObserver.h"
#import "ActivityIndicator.h"

static InAppPurchaseObserver *observer = nil;

@implementation InAppPurchaseObserver

@synthesize delegate;
@synthesize product;

+ (InAppPurchaseObserver*)sharedObserver
{
    if (observer == nil)
        observer = [[InAppPurchaseObserver alloc] init];
    
    return observer;
}

- (void)requestPurchaseWithProductIndentifier:(NSString *)identifier {
    
	if ([SKPaymentQueue canMakePayments]) {
        
		SKProductsRequest *productRequest= [[SKProductsRequest alloc] initWithProductIdentifiers: [NSSet setWithObject: identifier]];
        
		productRequest.delegate = self;
		
        [productRequest start];
        
        isRestore = NO;
        
	} else {
        
	}
}

- (void)restorePurchase
{
    [[SKPaymentQueue defaultQueue] addTransactionObserver:self];
    
    [[SKPaymentQueue defaultQueue] restoreCompletedTransactions];
    
    isRestore = YES;
}

#pragma mark SKProductsRequest Delegate
- (void)productsRequest:(SKProductsRequest *)request didReceiveResponse:(SKProductsResponse *)response {
    
    product = nil;
    
	int count = [response.products count];
    
	if (count>0)
		self.product = [response.products objectAtIndex:0];
    
	if (!product) {
        
        if (delegate && [delegate respondsToSelector:@selector(didFinishPurchaseResult:error:)]) {
            [delegate didFinishPurchaseResult:NO error:[NSError errorWithDomain:@"NO PRODUCTS" code:0 userInfo:nil]];
        }
        
		return;
	}
    
	SKPayment *paymentRequest = [SKPayment paymentWithProduct:product];
    
	[[SKPaymentQueue defaultQueue] addTransactionObserver:self];
	
	[[SKPaymentQueue defaultQueue] addPayment:paymentRequest];
}

- (void)paymentQueue:(SKPaymentQueue *)queue updatedTransactions:(NSArray *)transactions {
    
	for(SKPaymentTransaction *transaction in transactions) {
        
		switch (transaction.transactionState) {
                
			case SKPaymentTransactionStatePurchasing:
				break;
				
			case SKPaymentTransactionStatePurchased: {
                
                if (delegate && [delegate respondsToSelector:@selector(didFinishPurchaseResult:error:)]) {
                    [delegate didFinishPurchaseResult:YES error:nil];
                }
                
                [[SKPaymentQueue defaultQueue] finishTransaction: transaction];
                
				break;
            }
                
			case SKPaymentTransactionStateRestored:
				// Verified that user has already paid for this item.
                
                if (delegate && [delegate respondsToSelector:@selector(didFinishRestore:queue:error:)] && isRestore == NO) {
                    [delegate didFinishPurchaseResult:YES error:nil];
                }
                
                [[SKPaymentQueue defaultQueue] finishTransaction: transaction];
                
				break;
				
			case SKPaymentTransactionStateFailed:
				NSLog(@"%@, %d", transaction.error.description, transaction.error.code);
				if (transaction.error.code != SKErrorPaymentCancelled) {
					// A transaction error occurred, so notify user.
				}
                if (isRestore == NO)
                {
                    if (delegate && [delegate respondsToSelector:@selector(didFinishPurchaseResult:error:)]) {
                        [delegate didFinishPurchaseResult:NO error:[NSError errorWithDomain:@"Purchase Fail!" code:0 userInfo:nil]];
                    }
                }
                else
                {
                    if (delegate && [delegate respondsToSelector:@selector(didFinishRestore:queue:error:)]) {
                        [delegate didFinishRestore:NO queue:queue error:[NSError errorWithDomain:@"Purchase Fail!" code:0 userInfo:nil]];
                    }
                }
                
                [[SKPaymentQueue defaultQueue] finishTransaction: transaction];
                
				break;
                
            default:
                break;
		}
	}
}

- (void)paymentQueue:(SKPaymentQueue *)queue removedTransactions:(NSArray *)transactions
{
    [[ActivityIndicator currentIndicator] hide];
}

- (void)paymentQueue:(SKPaymentQueue *)queue restoreCompletedTransactionsFailedWithError:(NSError *)error
{
    if (delegate && [delegate respondsToSelector:@selector(didFinishRestore:queue:error:)]) {
        [delegate didFinishRestore:NO queue:queue error:error];
    }
}

- (void)paymentQueueRestoreCompletedTransactionsFinished:(SKPaymentQueue *)queue
{
    if (delegate && [delegate respondsToSelector:@selector(didFinishRestore:queue:error:)]) {
        [delegate didFinishRestore:YES queue:queue error:nil];
    }
}

- (void)paymentQueue:(SKPaymentQueue *)queue updatedDownloads:(NSArray *)downloads
{
    [[ActivityIndicator currentIndicator] hide];
}

@end
