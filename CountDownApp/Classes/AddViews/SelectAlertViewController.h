//
//  SelectAlertViewController.h
//  CountDownApp
//
//  Created by Eagle on 11/21/12.
//  Copyright (c) 2012 Ariel. All rights reserved.
//

#import "BaseViewController.h"
#import "AlertSettingViewController.h"

@interface SelectAlertViewController : BaseViewController <UIPickerViewDataSource, UIPickerViewDelegate>
{
    int nAlertIndex;
}

@property (nonatomic, strong) AlertSettingViewController *settingViewController;

- (void) setAlertIndex:(int)nIndex;

@property (nonatomic, strong) IBOutlet UILabel *lblAlert;
//@property (nonatomic, strong) IBOutlet RCSwitch *rcSwitch;
@property (nonatomic, strong) IBOutlet UIPickerView *timePickerView;

@property (nonatomic, strong) IBOutlet UIButton *btnBack;
@property (nonatomic, strong) IBOutlet UIButton *btnDone;
@property (nonatomic, strong) IBOutlet UIButton *btnRemind;
@property (nonatomic, strong) IBOutlet UILabel *lblTitle;

- (IBAction)onBack:(id)sender;
- (IBAction)onDone:(id)sender;

@end
