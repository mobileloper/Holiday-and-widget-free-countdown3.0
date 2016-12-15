//
//  SelectAlertViewController.m
//  CountDownApp
//
//  Created by Eagle on 11/21/12.
//  Copyright (c) 2012 Ariel. All rights reserved.
//

#import "SelectAlertViewController.h"
#import "AppDelegate.h"
#import "BDCommon.h"

@interface SelectAlertViewController ()

@end

@implementation SelectAlertViewController

@synthesize settingViewController;
@synthesize lblAlert;
@synthesize timePickerView;
//@synthesize rcSwitch;

@synthesize btnBack;
@synthesize btnDone;
@synthesize btnRemind;
@synthesize lblTitle;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    if (IS_IPAD == YES)
        self = [super initWithNibName:@"SelectAlertViewController_iPad" bundle:nibBundleOrNil];
    else
        self = [super initWithNibName:@"SelectAlertViewController" bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    NSString * strTime;
    switch (nAlertIndex) {
        case 0:
            strTime = settingViewController.lblAlert0.text;
            //[rcSwitch setOn:settingViewController.rcSwitch0.isOn];
            break;
        case 1:
            strTime = settingViewController.lblAlert1.text;
            //[rcSwitch setOn:settingViewController.rcSwitch1.isOn];
            break;
        case 2:
            strTime = settingViewController.lblAlert2.text;
            //[rcSwitch setOn:settingViewController.rcSwitch2.isOn];
            break;
        case 3:
            strTime = settingViewController.lblAlert3.text;
            //[rcSwitch setOn:settingViewController.rcSwitch3.isOn];
            break;
        case 4:
            strTime = settingViewController.lblAlert4.text;
            //[rcSwitch setOn:settingViewController.rcSwitch4.isOn];
            break;
        default:
            break;
    }
    NSRange range = [strTime rangeOfString:@" "];
    NSString *strTerm = [strTime substringToIndex:range.location];
    if (strTerm) {
        int nSelected = [strTerm intValue];
        [timePickerView selectRow:(nSelected) inComponent:0 animated:NO];
    }
    NSString *strUnit = [strTime substringFromIndex:range.location + 1];
    if (strUnit) {
        int nSelected = 0;
        if ([strUnit isEqualToString:@"Secs"]) {
            nSelected = 0;
        }
        else if ([strUnit isEqualToString:@"Mins"]) {
            nSelected = 1;
        }
        else if ([strUnit isEqualToString:@"Hours"]) {
            nSelected = 2;
        }
        else if ([strUnit isEqualToString:@"Days"]) {
            nSelected = 3;
        }
        else if ([strUnit isEqualToString:@"Months"]) {
            nSelected = 4;
        }
        else if ([strUnit isEqualToString:@"Years"]) {
            nSelected = 5;
        }
        [timePickerView selectRow:nSelected inComponent:1 animated:NO];
    }
    
    lblAlert.text = [NSString stringWithFormat:@"%@ %@", strTerm, NSLocalizedString(strUnit, nil)];
    
    [btnBack setTitle:NSLocalizedString(@"Back", nil) forState:UIControlStateNormal];
    btnBack.contentVerticalAlignment = UIControlContentVerticalAlignmentTop;
    
    [btnDone setTitle:NSLocalizedString(@"Done", nil) forState:UIControlStateNormal];
    btnDone.contentVerticalAlignment = UIControlContentVerticalAlignmentTop;
    
    lblTitle.text = NSLocalizedString(@"Alert", nil);
    
    [btnRemind setTitle:NSLocalizedString(@"Remind Before", nil) forState:UIControlStateNormal];
    btnRemind.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    if (IS_IPAD == YES)
    {
        lblAlert.font = MIDDLE_LABEL_FONT_IPAD;
        
        btnBack.titleLabel.font = SMALL_BUTTON_FONT_IPAD;
        btnBack.titleEdgeInsets = UIEdgeInsetsMake(8.5, 10.0, 0, 0);
        
        btnDone.titleLabel.font = SMALL_BUTTON_FONT_IPAD;
        btnDone.titleEdgeInsets = UIEdgeInsetsMake(9, 3, 0, 0);
        
        lblTitle.font = TITLE_FONT_IPAD;
        
        btnRemind.titleLabel.font = MIDDLE_BUTTON_FONT_IPAD;
        btnRemind.titleEdgeInsets = UIEdgeInsetsMake(12, 25, 0, 0);
    }
    else
    {
        lblAlert.font = MIDDLE_LABEL_FONT;
        
        btnBack.titleLabel.font = SMALL_BUTTON_FONT;
        btnBack.titleEdgeInsets = UIEdgeInsetsMake(9.5, 8, 0, 0);
        
        btnDone.titleLabel.font = SMALL_BUTTON_FONT;
        btnDone.titleEdgeInsets = UIEdgeInsetsMake(9.5, 2, 0, 0);
        
        lblTitle.font = TITLE_FONT;
        
        btnRemind.titleLabel.font = MIDDLE_BUTTON_FONT;
        btnRemind.titleEdgeInsets = UIEdgeInsetsMake(9.5, 9, 0, 0);
    }
    
    isTabBar = NO;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) setAlertIndex:(int)nIndex
{
    nAlertIndex = nIndex;
}

- (IBAction)onBack:(id)sender
{
    switch (nAlertIndex) {
        case 0:
            [settingViewController.rcSwitch0 setOn:NO];
            break;
        case 1:
            [settingViewController.rcSwitch1 setOn:NO];
            break;
        case 2:
            [settingViewController.rcSwitch2 setOn:NO];
            break;
        case 3:
            [settingViewController.rcSwitch3 setOn:NO];
            break;
        case 4:
            [settingViewController.rcSwitch4 setOn:NO];
            break;
        default:
            break;
    }
    [APP_DELEGATE.viewController.navigationController popViewControllerAnimated:YES];
}

- (IBAction)onDone:(id)sender
{
    int nSelected = [timePickerView selectedRowInComponent:0];
    NSString *strTerm = [NSString stringWithFormat:@"%d", nSelected];
    
    nSelected = [timePickerView selectedRowInComponent:1];
    NSString *strUnit;
    switch (nSelected) {
        case 0:
            strUnit = @"Secs";
            break;
        case 1:
            strUnit = @"Mins";
            break;
        case 2:
            strUnit = @"Hours";
            break;
        case 3:
            strUnit = @"Days";
            break;
        case 4:
            strUnit = @"Months";
            break;
        case 5:
            strUnit = @"Years";
            break;
        default:
            break;
    }
    
    switch (nAlertIndex) {
        case 0:
            settingViewController.lblAlert0.text = [NSString stringWithFormat:@"%@ %@", strTerm, NSLocalizedString(strUnit, nil)];
            //[settingViewController.rcSwitch0 setOn:rcSwitch.isOn];
            break;
        case 1:
            settingViewController.lblAlert1.text = [NSString stringWithFormat:@"%@ %@", strTerm, NSLocalizedString(strUnit, nil)];
            //[settingViewController.rcSwitch1 setOn:rcSwitch.isOn];
            break;
        case 2:
            settingViewController.lblAlert2.text = [NSString stringWithFormat:@"%@ %@", strTerm, NSLocalizedString(strUnit, nil)];
            //[settingViewController.rcSwitch2 setOn:rcSwitch.isOn];
            break;
        case 3:
            settingViewController.lblAlert3.text = [NSString stringWithFormat:@"%@ %@", strTerm, NSLocalizedString(strUnit, nil)];
            //[settingViewController.rcSwitch3 setOn:rcSwitch.isOn];
            break;
        case 4:
            settingViewController.lblAlert4.text = [NSString stringWithFormat:@"%@ %@", strTerm, NSLocalizedString(strUnit, nil)];
            //[settingViewController.rcSwitch4 setOn:rcSwitch.isOn];
            break;
        default:
            break;
    }
    [APP_DELEGATE.viewController.navigationController popViewControllerAnimated:YES];
}

// returns the number of 'columns' to display.
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 2;
}

// returns the # of rows in each component..
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    if (component == 0) {
        return 61;
    }
    else {
        return 6;
    }
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    if (component == 0) {
        return [NSString stringWithFormat:@"%d", row];
    }
    else {
        NSString *strUnit;
        switch (row) {
            case 0:
                strUnit = @"Seconds";
                break;
            case 1:
                strUnit = @"Minutes";
                break;
            case 2:
                strUnit = @"Hours";
                break;
            case 3:
                strUnit = @"Days";
                break;
            case 4:
                strUnit = @"Months";
                break;
            case 5:
                strUnit = @"Years";
                break;
            default:
                break;
        }
        return NSLocalizedString(strUnit, nil);
    }
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    int nSelected = [pickerView selectedRowInComponent:0];
    NSString *strTerm = [NSString stringWithFormat:@"%d", nSelected];
    
    nSelected = [pickerView selectedRowInComponent:1];
    NSString *strUnit;
    switch (nSelected) {
        case 0:
            strUnit = @"Secs";
            break;
        case 1:
            strUnit = @"Mins";
            break;
        case 2:
            strUnit = @"Hours";
            break;
        case 3:
            strUnit = @"Days";
            break;
        case 4:
            strUnit = @"Months";
            break;
        case 5:
            strUnit = @"Years";
            break;
        default:
            break;
    }
    
    lblAlert.text = [NSString stringWithFormat:@"%@ %@", strTerm, NSLocalizedString(strUnit, nil)];
}

@end
