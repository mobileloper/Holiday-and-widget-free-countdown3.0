//
//  PurchaseManager.h
//  CountDownApp
//
//  Created by ALIAD on 4/3/13.
//  Copyright (c) 2013 Ariel. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PurchaseManager : NSObject

@property (nonatomic, strong) NSMutableArray *arrayPurchase;

+ (PurchaseManager*)sharedInstance;
+ (void)destoryInstance;

- (void)initialize;

- (void)setPurchaseInfo:(NSMutableArray*)purchaseInfo;

@end
