//
//  PurchaseViewController.m
//  CountDownApp
//
//  Created by ALIAD on 4/3/13.
//  Copyright (c) 2013 Ariel. All rights reserved.
//

#import "PurchaseViewController.h"
#import "PurchaseManager.h"
#import "InAppPurchaseObserver.h"
#import "ActivityIndicator.h"
#import "BDCommon.h"
#import "AppDelegate.h"

@interface PurchaseViewController () <InAppPurchaseObserverDelegate>
{
    BOOL isProcessPurchase;
    BOOL isUnlockAll;
}

@end

@implementation PurchaseViewController

@synthesize lblTitle;
@synthesize lblName;
@synthesize lblUnlock;
@synthesize purchaseIndex;
@synthesize viewUnlockAll;
@synthesize imgIcon;
@synthesize btnRestoreAll;
@synthesize btnBack;
@synthesize btnUnlockAll;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    if (IS_IPAD)
        self = [super initWithNibName:@"PurchaseViewController_iPad" bundle:nibBundleOrNil];
    else
        self = [super initWithNibName:@"PurchaseViewController" bundle:nibBundleOrNil];
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
    [btnRestoreAll setTitle:NSLocalizedString(@"Restore", nil) forState:UIControlStateNormal];
    btnRestoreAll.contentVerticalAlignment = UIControlContentVerticalAlignmentTop;
    
    [btnBack setTitle:NSLocalizedString(@"Back", nil) forState:UIControlStateNormal];
    btnBack.contentVerticalAlignment = UIControlContentVerticalAlignmentTop;
    
    [btnUnlockAll setTitle:NSLocalizedString(@"Unlock All Images", nil) forState:UIControlStateNormal];
    btnUnlockAll.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    if (IS_IPAD == YES)
    {
        lblTitle.font = TITLE_FONT_IPAD;
        lblName.font = [UIFont fontWithName:@"MyriadPro-Semibold" size:32];
        lblUnlock.font = [UIFont fontWithName:@"MyriadPro-Regular" size:24];
        
        btnRestoreAll.titleLabel.font = SMALL_BUTTON_FONT_IPAD;
        btnRestoreAll.titleEdgeInsets = UIEdgeInsetsMake(8.5, 3.0, 0, 0);
        
        btnBack.titleLabel.font = SMALL_BUTTON_FONT_IPAD;
        btnBack.titleEdgeInsets = UIEdgeInsetsMake(8.5, 10.0, 0, 0);
        
        btnUnlockAll.titleLabel.font = MIDDLE_BUTTON_FONT_IPAD;
        btnUnlockAll.titleEdgeInsets = UIEdgeInsetsMake(12, 80, 0, 0);
    }
    else
    {
        lblTitle.font = TITLE_FONT;
        lblName.font = [UIFont fontWithName:@"MyriadPro-Semibold" size:20];
        lblUnlock.font = [UIFont fontWithName:@"MyriadPro-Regular" size:14];
        
        btnRestoreAll.titleLabel.font = SMALL_BUTTON_FONT;
        btnRestoreAll.titleEdgeInsets = UIEdgeInsetsMake(8.5, 2, 0, 0);
        
        btnBack.titleLabel.font = SMALL_BUTTON_FONT;
        btnBack.titleEdgeInsets = UIEdgeInsetsMake(9.0, 8, 0, 0);
        
        btnUnlockAll.titleLabel.font = MIDDLE_BUTTON_FONT;
        btnUnlockAll.titleEdgeInsets = UIEdgeInsetsMake(12, 50, 0, 0);
    }
    
    NSMutableArray *arrayPurchase = [PurchaseManager sharedInstance].arrayPurchase;
    NSMutableDictionary *item = [arrayPurchase objectAtIndex:purchaseIndex];
    lblTitle.text = NSLocalizedString([item objectForKey:@"title"], nil);
    lblName.text = NSLocalizedString([item objectForKey:@"title"], nil);
    if ([[item objectForKey:@"purchase"] boolValue] == NO){
        lblUnlock.text = [NSString stringWithFormat:@"%@ %@", NSLocalizedString(@"Unlock", nil), NSLocalizedString([item objectForKey:@"title"], nil)];
    }else{
        lblUnlock.hidden = YES;
    }

    imgIcon.image = [UIImage imageNamed:[item objectForKey:@"icon"]];
    
    BOOL isPurchase = YES;
    for (int i = 0; i < arrayPurchase.count; i++)
    {
        NSMutableDictionary *item = [arrayPurchase objectAtIndex:i];
        if ([[item objectForKey:@"purchase"] boolValue] == NO)
        {
            isPurchase = NO;
            break;
        }
    }
    
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    if ([userDefault boolForKey:@"LOCKED_ALL"] == YES && isPurchase == NO){
        viewUnlockAll.hidden = YES;
    }
    
    isTabBar = NO;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)initObserver
{
    
}

- (IBAction)onBack:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)onUnlockAll:(id)sender
{
    //Purchase this image item HC_ALL_IMAGES
    [InAppPurchaseObserver sharedObserver].delegate = self;
    [[InAppPurchaseObserver sharedObserver] requestPurchaseWithProductIndentifier:@"HC_ALL_IMAGESF"];
    
    [[ActivityIndicator currentIndicator] displayActivity:NSLocalizedString(@"Purchasing...", nil) isLock:YES];
    
    isProcessPurchase = YES;
    isUnlockAll = YES;
}

- (IBAction)onUnlock:(id)sender
{
    //Purchase all images
    NSMutableDictionary *item = [[PurchaseManager sharedInstance].arrayPurchase objectAtIndex:purchaseIndex];
    NSString *identifier = [item objectForKey:@"product"];
    
    [InAppPurchaseObserver sharedObserver].delegate = self;
    [[InAppPurchaseObserver sharedObserver] requestPurchaseWithProductIndentifier:identifier];
    
    [[ActivityIndicator currentIndicator] displayActivity:NSLocalizedString(@"Purchasing...", nil) isLock:YES];
    
    isProcessPurchase = YES;
    isUnlockAll = NO;
}

- (IBAction)onRestore:(id)sender
{

    [InAppPurchaseObserver sharedObserver].delegate = self;
    [[InAppPurchaseObserver sharedObserver] restorePurchase];
    
    [[ActivityIndicator currentIndicator] displayActivity:NSLocalizedString(@"Restoring...", nil) isLock:YES];
    
    isProcessPurchase = YES;
    
}

#pragma mark - InAppPurchaseObserverDelegate
- (void)didFinishPurchaseResult:(BOOL)status error:(NSError *)error
{
    [[ActivityIndicator currentIndicator] hide];
    
    if (isProcessPurchase == NO)
        return;
    
    isProcessPurchase = NO;
    if (status == YES)
    {
        if (isUnlockAll == YES)
        {
            NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
            [userDefault setBool:YES forKey:@"LOCKED_ALL"];
            [userDefault synchronize];
        }
        else
        {
            NSMutableArray *arrayPurchase = [PurchaseManager sharedInstance].arrayPurchase;
            NSMutableDictionary *item = [arrayPurchase objectAtIndex:purchaseIndex];
            [item setObject:[NSNumber numberWithBool:YES] forKey:@"purchase"];
      //    [arrayPurchase replaceObjectAtIndex:purchaseIndex withObject:item];
            
            [[PurchaseManager sharedInstance] setPurchaseInfo:arrayPurchase];
        }
        
        NSString *message = [NSString stringWithFormat:@"%@ %@", NSLocalizedString(@"Purchase was successful.", nil), NSLocalizedString(@"Thank you.", nil)];
        [[[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Success", nil) message:message delegate:nil cancelButtonTitle:NSLocalizedString(@"OK", nil) otherButtonTitles:nil, nil] show];
        
        [self.navigationController popViewControllerAnimated:YES];
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
    
    if (isProcessPurchase == NO)
        return;
    isProcessPurchase = NO;
    
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

#pragma mark - UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    
}

@end
