//
//  PopupViewController.m
//  LoveCountdown
//
//  //  Created by Dmitri on 2/1/15.
//  Copyright (c) 2013 Ariel. All rights reserved.
//

#import "PopupViewController.h"
#import "ActivityIndicator.h"
#import "BDCommon.h"
#import "PurchaseManager.h"
#import "AppDelegate.h"

@interface PopupViewController ()

@end

@implementation PopupViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    if (IS_IPHONE_5) {
        self = [super initWithNibName:@"PopupViewController5" bundle:nibBundleOrNil];
    }
    else {
        self = [super initWithNibName:@"PopupViewController" bundle:nibBundleOrNil];
    }
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)dealloc
{
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)showScreen:(UIView*)parentView
{
    if (parentView == nil)
        return;
    
    self.view.alpha = 0.0f;
    CGRect frame = self.view.frame;
    frame.origin.y = [UIScreen mainScreen].bounds.size.height;
    self.view.frame = frame;
    [parentView addSubview:self.view];
    [UIView animateWithDuration:0.3 animations:^
     {
         self.view.alpha = 1.0f;
         CGRect frame = self.view.frame;
         frame.origin.y = 0;
         self.view.frame = frame;
     }];
}

- (void)hideScreen
{
    [UIView beginAnimations:@"HIDE" context:nil];
    [UIView setAnimationDuration:0.3f];
    [UIView setAnimationDidStopSelector:@selector(didEndAnimation)];
    [UIView setAnimationDelegate:self];
    
    self.view.alpha = 0.0f;
    CGRect frame = self.view.frame;
    frame.origin.y = [UIScreen mainScreen].bounds.size.height;
    self.view.frame = frame;
    
    [UIView commitAnimations];
}

#pragma mark - IBAction
- (IBAction)onYesPlease:(id)sender
{
    [InAppPurchaseObserver sharedObserver].delegate = self;
    [[InAppPurchaseObserver sharedObserver] requestPurchaseWithProductIndentifier:@"HC_FULLVERSIONF"];
    
    [[ActivityIndicator currentIndicator] displayActivity:NSLocalizedString(@"Purchasing...", nil) isLock:YES];
    
    isProcessingPurchase = YES;
}

- (IBAction)onRestore:(id)sender
{
    [InAppPurchaseObserver sharedObserver].delegate = self;
    [[InAppPurchaseObserver sharedObserver] restorePurchase];
    
    [[ActivityIndicator currentIndicator] displayActivity:NSLocalizedString(@"Restoring...", nil) isLock:YES];
    
    isProcessingPurchase = YES;
}

- (IBAction)onNoThanks:(id)sender
{
    //[self hideScreen];
    [self dismissModalViewControllerAnimated:YES];
}

#pragma mark - InAppPurchaseObserverDelegate
- (void)didFinishPurchaseResult:(BOOL)status error:(NSError *)error
{
    [[ActivityIndicator currentIndicator] hide];
    
    if (isProcessingPurchase == NO)
        return;
    
    isProcessingPurchase = NO;
    if (status == YES)
    {
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:kFULLVERSION];
        
        NSString *message = [NSString stringWithFormat:@"%@ %@", NSLocalizedString(@"Purchase was successful.", nil), NSLocalizedString(@"Thank you.", nil)];
        [[[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Success", nil) message:message delegate:nil cancelButtonTitle:NSLocalizedString(@"OK", nil) otherButtonTitles:nil, nil] show];
        
        [[NSNotificationCenter defaultCenter] postNotificationName:kNOTIFICATION_FULLVERSION object:nil];
        
        [self performSelector:@selector(onNoThanks:) withObject:nil afterDelay:0.3];
    }
    else
    {
        NSString *message = [NSString stringWithFormat:@"%@ %@", NSLocalizedString(@"Purchase failed.", nil), NSLocalizedString(@"Please try again.", nil)];
        [[[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Failed", nil) message:message delegate:self cancelButtonTitle:NSLocalizedString(@"OK", nil) otherButtonTitles:nil, nil] show];
    }
}

- (void)didFinishRestore:(BOOL)status queue:(SKPaymentQueue*)queue error:(NSError*)error
{
    [[ActivityIndicator currentIndicator] hide];
    
    if (isProcessingPurchase == NO)
        return;
    isProcessingPurchase = NO;
    
    if (status == YES)
    {
        NSMutableArray *arrayPurchases = [[PurchaseManager sharedInstance] arrayPurchase];
        NSArray *transactions = queue.transactions;
        for (SKPaymentTransaction *transaction in transactions)
        {
            NSString *product = transaction.payment.productIdentifier;
            if ([product isEqualToString:@"HC_ALL_IMAGESF"])
            {
                NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
                [userDefault setBool:YES forKey:@"LOCKED_ALL"];
                [userDefault synchronize];
                
                continue;
            }
            else if ([product isEqualToString:@"HC_FULLVERSIONF"])
            {
                NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
                [userDefault setBool:YES forKey:kFULLVERSION];
                [userDefault synchronize];
                
                [[NSNotificationCenter defaultCenter] postNotificationName:kNOTIFICATION_FULLVERSION object:nil];
                
                [self performSelector:@selector(onNoThanks:) withObject:nil afterDelay:0.3];
                
                continue;
            }
            
            for (int i = 0; i < arrayPurchases.count; i++)
            {
                NSMutableDictionary *item = [arrayPurchases objectAtIndex:i];
                NSString *identifier = [item objectForKey:@"product"];
                if ([product isEqualToString:identifier])
                {
                    [item setObject:[NSNumber numberWithBool:YES] forKey:@"purchase"];
                    [arrayPurchases replaceObjectAtIndex:i withObject:item];
                    [[PurchaseManager sharedInstance] setPurchaseInfo:arrayPurchases];
                    break;
                }
            }
        }
        
        NSString *message = [NSString stringWithFormat:@"%@ %@", NSLocalizedString(@"Restore was successful.", nil), NSLocalizedString(@"Thank you.", nil)];
        [[[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Success", nil) message:message delegate:nil cancelButtonTitle:NSLocalizedString(@"OK", nil) otherButtonTitles:nil, nil] show];
        
        //[[SKPaymentQueue defaultQueue] removeTransactionObserver:self];
        
        [self.navigationController popViewControllerAnimated:YES];
    }
    else
    {
        NSString *message = [NSString stringWithFormat:@"%@ %@", NSLocalizedString(@"Restore failed.", nil), NSLocalizedString(@"Please try again.", nil)];
        [[[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Failed", nil) message:message delegate:nil cancelButtonTitle:NSLocalizedString(@"OK", nil) otherButtonTitles:nil, nil] show];
    }
}

@end
