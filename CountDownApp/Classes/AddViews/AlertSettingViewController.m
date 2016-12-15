//
//  AlertSettingViewController.m
//  CountDownApp
//
//  Created by Eagle on 11/21/12.
//  Copyright (c) 2012 Ariel. All rights reserved.
//

#import "AlertSettingViewController.h"
#import "AppDelegate.h"
#import "SelectAlertViewController.h"
#import "BDCommon.h"

@interface AlertSettingViewController ()

@end

@implementation AlertSettingViewController

@synthesize addViewController;

@synthesize lblAlert0;
@synthesize lblAlert1;
@synthesize lblAlert2;
@synthesize lblAlert3;
@synthesize lblAlert4;

@synthesize rcSwitch0;
@synthesize rcSwitch1;
@synthesize rcSwitch2;
@synthesize rcSwitch3;
@synthesize rcSwitch4;

@synthesize lblTitle;
@synthesize btnBack;
@synthesize btnDone;
@synthesize btnAlert0;
@synthesize btnAlert1;
@synthesize btnAlert2;
@synthesize btnAlert3;
@synthesize btnAlert4;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    if (IS_IPAD == YES)
        self = [super initWithNibName:@"AlertSettingViewController_iPad" bundle:nibBundleOrNil];
    else
        self = [super initWithNibName:@"AlertSettingViewController" bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    if (addViewController != nil && addViewController.dicDayInfo != nil) {
        NSString *strOn = nil;
        lblAlert0.text = [NSString stringWithFormat:@"%@ %@", [addViewController.dicDayInfo objectForKey:@"alertterm0"], NSLocalizedString([addViewController.dicDayInfo objectForKey:@"alertunit0"], nil)];
        strOn = [addViewController.dicDayInfo objectForKey:@"alertonoff0"];
        if (strOn && [strOn isEqualToString:@"on"]) {
            [rcSwitch0 setOn:YES action:NO];
        }
        else {
            [rcSwitch0 setOn:NO action:NO];
        }
        
        lblAlert1.text = [NSString stringWithFormat:@"%@ %@", [addViewController.dicDayInfo objectForKey:@"alertterm1"], NSLocalizedString([addViewController.dicDayInfo objectForKey:@"alertunit1"], nil)];
        strOn = [addViewController.dicDayInfo objectForKey:@"alertonoff1"];
        if (strOn && [strOn isEqualToString:@"on"]) {
            [rcSwitch1 setOn:YES action:NO];
        }
        else {
            [rcSwitch1 setOn:NO action:NO];
        }
        
        lblAlert2.text = [NSString stringWithFormat:@"%@ %@", [addViewController.dicDayInfo objectForKey:@"alertterm2"], NSLocalizedString([addViewController.dicDayInfo objectForKey:@"alertunit2"], nil)];
        strOn = [addViewController.dicDayInfo objectForKey:@"alertonoff2"];
        if (strOn && [strOn isEqualToString:@"on"]) {
            [rcSwitch2 setOn:YES action:NO];
        }
        else {
            [rcSwitch2 setOn:NO action:NO];
        }
        
        lblAlert3.text = [NSString stringWithFormat:@"%@ %@", [addViewController.dicDayInfo objectForKey:@"alertterm3"], NSLocalizedString([addViewController.dicDayInfo objectForKey:@"alertunit3"], nil)];
        strOn = [addViewController.dicDayInfo objectForKey:@"alertonoff3"];
        if (strOn && [strOn isEqualToString:@"on"]) {
            [rcSwitch3 setOn:YES action:NO];
        }
        else {
            [rcSwitch3 setOn:NO action:NO];
        }
        
        lblAlert4.text = [NSString stringWithFormat:@"%@ %@", [addViewController.dicDayInfo objectForKey:@"alertterm4"], NSLocalizedString([addViewController.dicDayInfo objectForKey:@"alertunit4"], nil)];
        strOn = [addViewController.dicDayInfo objectForKey:@"alertonoff4"];
        if (strOn && [strOn isEqualToString:@"on"]) {
            [rcSwitch4 setOn:YES action:NO];
        }
        else {
            [rcSwitch4 setOn:NO action:NO];
        }
    }
    
    lblTitle.text = NSLocalizedString(@"Alert", nil);
    
    [btnBack setTitle:NSLocalizedString(@"Back", nil) forState:UIControlStateNormal];
    btnBack.contentVerticalAlignment = UIControlContentVerticalAlignmentTop;
    
    [btnDone setTitle:NSLocalizedString(@"Done", nil) forState:UIControlStateNormal];
    btnDone.contentVerticalAlignment = UIControlContentVerticalAlignmentTop;
    
    for (int i = 0; i <= 5; i++)
    {
        UILabel *label = (UILabel*)[self.view viewWithTag:1000 + i];
        label.text = NSLocalizedString(@"On", nil);
        
        label = (UILabel*)[self.view viewWithTag:2000 + i];
        label.text = NSLocalizedString(@"Off", nil);
        
        UIButton *button = (UIButton*)[self.view viewWithTag:100 + i];
        [button setTitle:NSLocalizedString(@"Remind Before", nil) forState:UIControlStateNormal];
        button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    }
    
    if (IS_IPAD == YES)
    {
        lblTitle.font = TITLE_FONT_IPAD;
        
        btnBack.titleLabel.font = SMALL_BUTTON_FONT_IPAD;
        btnBack.titleEdgeInsets = UIEdgeInsetsMake(8.5, 10.0, 0, 0);
        
        btnDone.titleLabel.font = SMALL_BUTTON_FONT_IPAD;
        btnDone.titleEdgeInsets = UIEdgeInsetsMake(9, 3, 0, 0);
        
        for (int i = 0; i <= 5; i++)
        {
            UILabel *label = (UILabel*)[self.view viewWithTag:1000 + i];
            label.text = NSLocalizedString(@"On", nil);
            label.font = [UIFont fontWithName:FONT_SEMIBOLD size:25.0];
            
            label = (UILabel*)[self.view viewWithTag:2000 + i];
            label.text = NSLocalizedString(@"Off", nil);
            label.font = [UIFont fontWithName:FONT_SEMIBOLD size:25.0];
            
            label = (UILabel*)[self.view viewWithTag:200 + i];
            label.font = [UIFont fontWithName:FONT_SEMIBOLD size:30.0];
            
            UIButton *button = (UIButton*)[self.view viewWithTag:100 + i];
            [button setTitle:NSLocalizedString(@"Remind Before", nil) forState:UIControlStateNormal];
            button.titleLabel.font = MIDDLE_BUTTON_FONT_IPAD;
            button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
            button.titleEdgeInsets = UIEdgeInsetsMake(12, 25, 0, 0);
        }
    }
    else
    {
        lblTitle.font = TITLE_FONT;
        
        btnBack.titleLabel.font = SMALL_BUTTON_FONT;
        btnBack.titleEdgeInsets = UIEdgeInsetsMake(9.5, 8, 0, 0);
        
        btnDone.titleLabel.font = SMALL_BUTTON_FONT;
        btnDone.titleEdgeInsets = UIEdgeInsetsMake(9.5, 2, 0, 0);
        
        for (int i = 0; i <= 5; i++)
        {
            UILabel *label = (UILabel*)[self.view viewWithTag:1000 + i];
            label.font = [UIFont fontWithName:FONT_SEMIBOLD size:13.0];
            
            label = (UILabel*)[self.view viewWithTag:2000 + i];
            label.font = [UIFont fontWithName:FONT_SEMIBOLD size:13.0];
            
            label = (UILabel*)[self.view viewWithTag:200 + i];
            label.font = [UIFont fontWithName:FONT_SEMIBOLD size:15.0];
            
            UIButton *button = (UIButton*)[self.view viewWithTag:100 + i];
            button.titleLabel.font = MIDDLE_BUTTON_FONT;
            button.titleEdgeInsets = UIEdgeInsetsMake(8, 6, 0, 0);
        }
    }
    
    isTabBar = NO;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)onSwitchOn:(RCSwitch *)sender
{
    if (sender.isOn) {
        SelectAlertViewController *viewController = [SelectAlertViewController new];
        viewController.settingViewController = self;
        [viewController setAlertIndex:sender.tag];
        [APP_DELEGATE.viewController.navigationController pushViewController:viewController animated:YES];
    }
}

- (IBAction)onBack:(id)sender
{
    [APP_DELEGATE.viewController.navigationController popViewControllerAnimated:YES];
}

- (IBAction)onDone:(id)sender
{
    if (addViewController != nil && addViewController.dicDayInfo != nil) {
        NSRange range = [lblAlert0.text rangeOfString:@" "];
        NSString *strTerm = [lblAlert0.text substringToIndex:range.location];
        NSString *strUnit = [lblAlert0.text substringFromIndex:range.location + 1];
        
        [addViewController.dicDayInfo setObject:strTerm forKey:@"alertterm0"];
        [addViewController.dicDayInfo setObject:strUnit forKey:@"alertunit0"];
        if (rcSwitch0.isOn) {
            [addViewController.dicDayInfo setObject:@"on" forKey:@"alertonoff0"];
        }
        else {
            [addViewController.dicDayInfo setObject:@"off" forKey:@"alertonoff0"];
        }
        
        range = [lblAlert1.text rangeOfString:@" "];
        strTerm = [lblAlert1.text substringToIndex:range.location];
        strUnit = [lblAlert1.text substringFromIndex:range.location + 1];
        
        [addViewController.dicDayInfo setObject:strTerm forKey:@"alertterm1"];
        [addViewController.dicDayInfo setObject:strUnit forKey:@"alertunit1"];
        if (rcSwitch1.isOn) {
            [addViewController.dicDayInfo setObject:@"on" forKey:@"alertonoff1"];
        }
        else {
            [addViewController.dicDayInfo setObject:@"off" forKey:@"alertonoff1"];
        }
        
        range = [lblAlert2.text rangeOfString:@" "];
        strTerm = [lblAlert2.text substringToIndex:range.location];
        strUnit = [lblAlert2.text substringFromIndex:range.location + 1];
        
        [addViewController.dicDayInfo setObject:strTerm forKey:@"alertterm2"];
        [addViewController.dicDayInfo setObject:strUnit forKey:@"alertunit2"];
        if (rcSwitch2.isOn) {
            [addViewController.dicDayInfo setObject:@"on" forKey:@"alertonoff2"];
        }
        else {
            [addViewController.dicDayInfo setObject:@"off" forKey:@"alertonoff2"];
        }
        
        range = [lblAlert3.text rangeOfString:@" "];
        strTerm = [lblAlert3.text substringToIndex:range.location];
        strUnit = [lblAlert3.text substringFromIndex:range.location + 1];
        
        [addViewController.dicDayInfo setObject:strTerm forKey:@"alertterm3"];
        [addViewController.dicDayInfo setObject:strUnit forKey:@"alertunit3"];
        if (rcSwitch3.isOn) {
            [addViewController.dicDayInfo setObject:@"on" forKey:@"alertonoff3"];
        }
        else {
            [addViewController.dicDayInfo setObject:@"off" forKey:@"alertonoff3"];
        }
        
        range = [lblAlert4.text rangeOfString:@" "];
        strTerm = [lblAlert4.text substringToIndex:range.location];
        strUnit = [lblAlert4.text substringFromIndex:range.location + 1];
        
        [addViewController.dicDayInfo setObject:strTerm forKey:@"alertterm4"];
        [addViewController.dicDayInfo setObject:strUnit forKey:@"alertunit4"];
        if (rcSwitch4.isOn) {
            [addViewController.dicDayInfo setObject:@"on" forKey:@"alertonoff4"];
        }
        else {
            [addViewController.dicDayInfo setObject:@"off" forKey:@"alertonoff4"];
        }
        
    }
    [APP_DELEGATE.viewController.navigationController popViewControllerAnimated:YES];
}

- (IBAction)onAlertSetting:(UIButton *)sender
{
    SelectAlertViewController *viewController = [SelectAlertViewController new];
    viewController.settingViewController = self;
    [viewController setAlertIndex:sender.tag];
    [APP_DELEGATE.viewController.navigationController pushViewController:viewController animated:YES];
}

@end
