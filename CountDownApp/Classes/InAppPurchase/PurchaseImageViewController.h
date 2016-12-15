//
//  PurchaseImageViewController.h
//  CountDownApp
//
//  Created by Felton on 4/5/13.
//  Copyright (c) 2013 Ariel. All rights reserved.
//

#import "BaseViewController.h"
#import "AddDaysViewController.h"

@interface PurchaseImageViewController : BaseViewController

@property (nonatomic, strong) IBOutlet UILabel *lblTitle;
@property (nonatomic, strong) IBOutlet UIScrollView *scrImages;
@property (nonatomic, strong) IBOutlet UIButton *btnBack;
@property (nonatomic, strong) AddDaysViewController *addViewController;
@property (nonatomic, assign) int purchaseIndex;

- (IBAction)onBack:(id)sender;
- (IBAction)onSelectImage:(UIButton *)sender;

@end
