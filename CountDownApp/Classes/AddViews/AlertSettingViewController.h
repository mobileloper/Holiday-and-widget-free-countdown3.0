//
//  AlertSettingViewController.h
//  CountDownApp
//
//  Created by Eagle on 11/21/12.
//  Copyright (c) 2012 Ariel. All rights reserved.
//

#import "BaseViewController.h"
#import "AddDaysViewController.h"
#import "../CustomizedCtrl/RCSwitch/RCSwitch.h"

@interface AlertSettingViewController : BaseViewController

@property (nonatomic, strong) AddDaysViewController *addViewController;

@property (nonatomic, strong) IBOutlet UILabel *lblAlert0;
@property (nonatomic, strong) IBOutlet UILabel *lblAlert1;
@property (nonatomic, strong) IBOutlet UILabel *lblAlert2;
@property (nonatomic, strong) IBOutlet UILabel *lblAlert3;
@property (nonatomic, strong) IBOutlet UILabel *lblAlert4;

@property (nonatomic, strong) IBOutlet RCSwitch *rcSwitch0;
@property (nonatomic, strong) IBOutlet RCSwitch *rcSwitch1;
@property (nonatomic, strong) IBOutlet RCSwitch *rcSwitch2;
@property (nonatomic, strong) IBOutlet RCSwitch *rcSwitch3;
@property (nonatomic, strong) IBOutlet RCSwitch *rcSwitch4;

@property (nonatomic, strong) IBOutlet UILabel *lblTitle;
@property (nonatomic, strong) IBOutlet UIButton *btnBack;
@property (nonatomic, strong) IBOutlet UIButton *btnDone;
@property (nonatomic, strong) IBOutlet UIButton *btnAlert0;
@property (nonatomic, strong) IBOutlet UIButton *btnAlert1;
@property (nonatomic, strong) IBOutlet UIButton *btnAlert2;
@property (nonatomic, strong) IBOutlet UIButton *btnAlert3;
@property (nonatomic, strong) IBOutlet UIButton *btnAlert4;

- (IBAction)onBack:(id)sender;
- (IBAction)onDone:(id)sender;

- (IBAction)onAlertSetting:(UIButton *)sender;
- (IBAction)onSwitchOn:(RCSwitch *)sender;

@end
