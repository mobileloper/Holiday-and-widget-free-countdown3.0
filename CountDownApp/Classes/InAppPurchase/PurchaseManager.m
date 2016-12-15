//
//  PurchaseManager.m
//  CountDownApp
//
//  Created by ALIAD on 4/3/13.
//  Copyright (c) 2013 Ariel. All rights reserved.
//

#import "PurchaseManager.h"

static PurchaseManager *instance;

@implementation PurchaseManager

@synthesize arrayPurchase;

+ (PurchaseManager*)sharedInstance
{
    if (instance == nil)
    {
        instance = [[PurchaseManager alloc] init];
        
        [instance initialize];
    }
    
    return instance;
}

+ (void)destoryInstance
{
    instance = nil;
}


- (void)initialize
{
    NSString *infopath = [[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex:0] stringByAppendingPathComponent:@"purinfo.plist"];
    arrayPurchase = [[NSMutableArray alloc] initWithContentsOfFile:infopath];
    if (arrayPurchase == nil)
    {
        NSString *respath = [[NSBundle mainBundle] pathForResource:@"purchaseinfo" ofType:@"plist"];
        NSMutableDictionary *rootitem = [NSMutableDictionary dictionaryWithContentsOfFile:respath];
        arrayPurchase = [[NSMutableArray alloc] initWithArray:[rootitem objectForKey:@"Images"]];
    }
}

- (void)saveInfo
{
    NSString *infopath = [[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex:0] stringByAppendingPathComponent:@"purinfo.plist"];
    [arrayPurchase writeToFile:infopath atomically:YES];
}

- (void)setPurchaseInfo:(NSMutableArray*)purchaseInfo
{
    self.arrayPurchase = purchaseInfo;
    
    [self saveInfo];
}

@end
