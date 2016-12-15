//
//  RepeatSelectViewController.h
//  CountDownApp
//
//  Created by Eagle on 11/16/12.
//  Copyright (c) 2012 Ariel. All rights reserved.
//

#import "BaseViewController.h"
#import "AddDaysViewController.h"
#import "../CustomizedCtrl/RCSwitch/RCSwitch.h"

@interface RepeatSelectViewController : BaseViewController <UIPickerViewDataSource, UIPickerViewDelegate>

@property (nonatomic, strong) AddDaysViewController *addViewController;

@property (nonatomic, strong) IBOutlet RCSwitch * switchRepeat;
@property (nonatomic, strong) IBOutlet UIPickerView *pickerView;

@property (nonatomic, strong) IBOutlet UILabel *lblTitle;
@property (nonatomic, strong) IBOutlet UIButton *btnBack;
@property (nonatomic, strong) IBOutlet UIButton *btnDone;
@property (nonatomic, strong) IBOutlet UIButton *btnRepeat;

@property (nonatomic, strong) IBOutlet UILabel *lblOn;
@property (nonatomic, strong) IBOutlet UILabel *lblOff;

- (IBAction)onBack:(id)sender;
- (IBAction)onDone:(id)sender;

@end
