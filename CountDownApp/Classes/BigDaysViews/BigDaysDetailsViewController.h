//
//  BigDaysDetailsViewController.h
//  CountDownApp
//
//  Created by Eagle on 11/3/12.
//  Copyright (c) 2012 Ariel. All rights reserved.
//

#import "BaseViewController.h"
#import "../JDFlipNumberView/JDDateCountdownFlipView.h"
#import <MessageUI/MFMailComposeViewController.h>
#import <MessageUI/MFMessageComposeViewController.h>
#import <RevMobAds/RevMobAds.h>

@interface BigDaysDetailsViewController : BaseViewController <UIGestureRecognizerDelegate, MFMailComposeViewControllerDelegate, MFMessageComposeViewControllerDelegate, RevMobAdsDelegate>
{
    int nDayIndex;
    int nScrollIndex;
    CGPoint touchPoint;
    NSMutableArray *arrayScrollLogs;
    BOOL isSwipeGesture;
    BOOL isInScrolling;
}

@property (nonatomic, strong) IBOutlet UIImageView *dragdropImageView;
@property (nonatomic, strong) IBOutlet UIButton *btnInfo;
@property (nonatomic, strong) IBOutlet UIButton *btnEdit;
@property (nonatomic, strong) IBOutlet UIButton *btnShare;

@property (nonatomic, strong) IBOutlet UIView *shareView;
@property (nonatomic, strong) IBOutlet UIView *infoView;

@property (nonatomic, strong) NSMutableDictionary *dicDayInfo;

@property (nonatomic, strong) IBOutlet UIButton *infoflipBgImageView;
@property (nonatomic, strong) IBOutlet UILabel *infolblName;
@property (nonatomic, strong) JDDateCountdownFlipView *infodateFlipView;
@property (nonatomic, strong) NSDate *targetDate;
@property (nonatomic, strong) UITapGestureRecognizer *tapGesture;

@property (nonatomic, strong) IBOutlet UIView *bannerView;
@property (nonatomic, strong) RevMobBannerView *adView;

@property (nonatomic, strong) IBOutlet UILabel *lblInfoDays;
@property (nonatomic, strong) IBOutlet UILabel *lblInfoHours;
@property (nonatomic, strong) IBOutlet UILabel *lblInfoMins;
@property (nonatomic, strong) IBOutlet UILabel *lblInfoSecs;
@property (nonatomic, strong) IBOutlet UILabel *lblTapToDrag;
@property (nonatomic, strong) IBOutlet UIButton *btnClose;

// For share
@property (nonatomic, strong) IBOutlet UIButton *btnSaveImage;
@property (nonatomic, strong) IBOutlet UIButton *btnSendMail;
@property (nonatomic, strong) IBOutlet UIButton *btnSendSMS;
@property (nonatomic, strong) IBOutlet UIButton *btnFacebook;
@property (nonatomic, strong) IBOutlet UIButton *btnTwitter;
@property (nonatomic, strong) IBOutlet UIButton *btnCancel;

// For slide
@property (nonatomic, strong) IBOutlet UIScrollView *scrBigDays;
@property (nonatomic, strong) IBOutlet UIPageControl *pageSlider;
@property (nonatomic, strong) NSMutableArray *arrayPageViews;
@property (nonatomic, strong) UISwipeGestureRecognizer *leftSwipeGesture;

- (void)setDayIndex:(int)nIndex;

- (IBAction)onEditInfo:(id)sender;
- (IBAction)onShare:(id)sender;
- (IBAction)onCancelShare:(id)sender;
- (IBAction)onInfo:(id)sender;
- (IBAction)onCancelInfo:(id)sender;
- (IBAction)onSaveImage:(id)sender;
- (IBAction)onSendEmail:(id)sender;
- (IBAction)onSendSMS:(id)sender;
- (IBAction)onFacebook:(id)sender;
- (IBAction)onTwitter:(id)sender;
- (IBAction)onSlidePage:(id)sender;

@end
