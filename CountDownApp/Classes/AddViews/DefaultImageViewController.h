//
//  DefaultImageViewController.h
//  CountDownApp
//
//  Created by Eagle on 11/15/12.
//  Copyright (c) 2012 Ariel. All rights reserved.
//

#import "BaseViewController.h"
#import "AddDaysViewController.h"

@interface DefaultImageViewController : BaseViewController

@property (nonatomic, strong) AddDaysViewController *addViewController;
@property (nonatomic, strong) IBOutlet UILabel *lblImage;
@property (nonatomic, strong) IBOutlet UIButton *btnBack;

- (IBAction)onSelectImage:(UIButton *)sender;
- (IBAction)onBack:(id)sender;

@end
