//
//  PurchaseViewController.h
//  CountDownApp
//
//  Created by ALIAD on 4/3/13.
//  Copyright (c) 2013 Ariel. All rights reserved.
//

#import "BaseViewController.h"

@interface PurchaseViewController : BaseViewController

@property (nonatomic, assign) int purchaseIndex;
@property (nonatomic, strong) IBOutlet UILabel *lblTitle;
@property (nonatomic, strong) IBOutlet UILabel *lblName;
@property (nonatomic, strong) IBOutlet UILabel *lblUnlock;
@property (nonatomic, strong) IBOutlet UIView *viewUnlockAll;
@property (nonatomic, strong) IBOutlet UIImageView *imgIcon;
@property (nonatomic, strong) IBOutlet UIButton *btnRestoreAll;
@property (nonatomic, strong) IBOutlet UIButton *btnBack;
@property (nonatomic, strong) IBOutlet UIButton *btnUnlockAll;

- (IBAction)onBack:(id)sender;
- (IBAction)onUnlockAll:(id)sender;
- (IBAction)onUnlock:(id)sender;
- (IBAction)onRestore:(id)sender;

@end
