//
//  AddDaysViewController.h
//  CountDownApp
//
//  Created by Dmitri on 11/1/14.
//  Copyright (c) 2012 Ariel. All rights reserved.
//

#import "BaseViewController.h"

@interface AddDaysViewController : BaseViewController <UIAlertViewDelegate, UITextFieldDelegate>
{
    BOOL keyboardVisible;
    int nDayIndex;
    UIView *overlayView;
}

@property (nonatomic, strong) NSMutableDictionary *dicDayInfo;
@property (nonatomic, strong) NSDate *m_dayDate;
@property (nonatomic, strong) NSDate *m_timeDate;

@property (nonatomic, strong) IBOutlet UILabel *lblName;
@property (nonatomic, strong) IBOutlet UILabel *lblEditName;
@property (nonatomic, strong) IBOutlet UILabel *lblTitleName;
@property (nonatomic, strong) IBOutlet UILabel *lblDate;
@property (nonatomic, strong) IBOutlet UILabel *lblTime;
@property (nonatomic, strong) IBOutlet UIImageView *ivBg;

@property (nonatomic, strong) IBOutlet UILabel *lblRepeat;
@property (nonatomic, strong) IBOutlet UIButton *btnBack;
@property (nonatomic, strong) IBOutlet UIButton *btnDone;
@property (nonatomic, strong) IBOutlet UIButton *btnName;
@property (nonatomic, strong) IBOutlet UIButton *btnRepeat;
@property (nonatomic, strong) IBOutlet UIButton *btnAlert;
@property (nonatomic, strong) IBOutlet UIButton *btnDelete;
@property (nonatomic, strong) IBOutlet UILabel *lblButtonDate;
@property (nonatomic, strong) IBOutlet UILabel *lblButtonTime;
@property (nonatomic, strong) IBOutlet UILabel *lblButtonImage;

//Edit Name
@property (nonatomic, strong) IBOutlet UIView *viewName;
@property (nonatomic, strong) IBOutlet UITextField *tfName;
@property (nonatomic, strong) IBOutlet UIImageView *inputFieldBg;
@property (nonatomic, strong) IBOutlet UIButton *btnEditCancel;
@property (nonatomic, strong) IBOutlet UIButton *btnEditDone;

//Select Date
@property (nonatomic, strong) IBOutlet UIView *viewDate;
@property (nonatomic, strong) IBOutlet UILabel *lblSelectDate;
@property (nonatomic, strong) IBOutlet UILabel *lblSelectTime;
@property (nonatomic, strong) IBOutlet UIDatePicker *datepicker;
@property (nonatomic, strong) IBOutlet UILabel *lblDateTitle;
@property (nonatomic, strong) IBOutlet UIButton *btnDateCancel;
@property (nonatomic, strong) IBOutlet UIButton *btnDateDone;
@property (nonatomic, strong) IBOutlet UIButton *btnDateDate;
@property (nonatomic, strong) IBOutlet UIButton *btnDateTime;

//Buttons

//Name
- (IBAction)onSelectName:(id)sender;
- (IBAction)onCancelEditName:(id)sender;
- (IBAction)onDoneEditName:(id)sender;

//Date
- (IBAction)onSelectDate:(id)sender;
- (IBAction)onCancelSelectDate:(id)sender;
- (IBAction)onDoneSelectDate:(id)sender;
- (IBAction)onSetModeDate:(id)sender;
- (IBAction)onSetModeTime:(id)sender;

//Select Image
- (IBAction)onSelectImage:(id)sender;

//Select Repeat
- (IBAction)onSelectRepeat:(id)sender;

//- (IBAction) repeatChanged:(id)sender;
//Alert
//- (IBAction) alertChanged:(id)sender;
- (IBAction)onAlertSetting:(id)sender;

- (void)setDayIndex:(int)nIndex;

- (IBAction)onDoneDayInfo:(id)sender;
- (IBAction)onBackDayInfo:(id)sender;
- (IBAction)onDeleteDayInfo:(id)sender;

@end
