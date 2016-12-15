//
//  BigDaysDetailsViewController.m
//  CountDownApp
//
//  Created by Eagle on 11/3/12.
//  Copyright (c) 2012 Ariel. All rights reserved.
//

#import "BigDaysDetailsViewController.h"
#import "AddDaysViewController.h"
#import "AppDelegate.h"
#import "SHKActivityIndicator.h"
#import <Twitter/TWTweetComposeViewController.h>
#import "Flurry.h"
#import "BDCommon.h"
#import "BigDayPageViewController.h"

#import "FacebookFacade.h"
#import "MBProgressHUD.h"
#import "AppManager.h"

typedef void (^SimpleCallBack)();

#define SLIDE_WIDTH         ([UIScreen mainScreen].bounds.size.width + 4)
#define SLIDE_OFFSET        2

@interface BigDaysDetailsViewController ()
@property (strong, nonatomic) MBProgressHUD *downloadProgressHud;
@property (strong, nonatomic) FacebookFacade *facebookFacade;
@end

@implementation BigDaysDetailsViewController

@synthesize dragdropImageView;

@synthesize btnEdit;
@synthesize btnInfo;
@synthesize btnShare;

@synthesize shareView;
@synthesize infoView;

@synthesize infodateFlipView;
@synthesize infoflipBgImageView;
@synthesize infolblName;
@synthesize targetDate;
@synthesize tapGesture;

@synthesize dicDayInfo;

@synthesize lblInfoDays;
@synthesize lblInfoHours;
@synthesize lblInfoMins;
@synthesize lblInfoSecs;
@synthesize lblTapToDrag;
@synthesize btnClose;

//For Share
@synthesize btnSaveImage;
@synthesize btnSendMail;
@synthesize btnSendSMS;
@synthesize btnFacebook;
@synthesize btnTwitter;
@synthesize btnCancel;

//For Slide
@synthesize scrBigDays;
@synthesize pageSlider;
@synthesize arrayPageViews;
@synthesize leftSwipeGesture;

@synthesize bannerView;
@synthesize adView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    if (IS_IPAD == YES)
        self = [super initWithNibName:@"BigDaysDetailsViewController_iPad" bundle:nibBundleOrNil];
    else if (IS_IPHONE_5)
        self = [super initWithNibName:@"BigDaysDetailsViewController_iphone5" bundle:nibBundleOrNil];
    else
        self = [super initWithNibName:@"BigDaysDetailsViewController" bundle:nibBundleOrNil];
    
    if (self) {
        
        infodateFlipView = [[JDDateCountdownFlipView alloc] initWithType:1];
        [infodateFlipView setFlipNumberType:1];
        [infodateFlipView setUserInteractionEnabled:NO];
        //[dateFlipView setFrame:];
        //[self.infoView addSubview:infodateFlipView];
        [infodateFlipView setAutoresizingMask:UIViewAutoresizingNone];
        [self.infoflipBgImageView addSubview:infodateFlipView];
        [self.infolblName removeFromSuperview];
        [self.infoflipBgImageView addSubview:self.infolblName];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.navigationController setNavigationBarHidden:YES animated:NO];
    // SHOW FIRST OPEN THIS PAGE
    if ([[NSUserDefaults standardUserDefaults] boolForKey:kWELCOME] == NO)
    {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Welcome to Holiday Countdown" message:@"Tap the Edit button to set up your countdown" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alertView show];
        
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:kWELCOME];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    [infoflipBgImageView addTarget:self action:@selector(imageTouch:withEvent:) forControlEvents:UIControlEventTouchDown];
    [infoflipBgImageView addTarget:self action:@selector(imageMoved:withEvent:) forControlEvents:UIControlEventTouchDragInside];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(doViewWillAppear:) name:UIApplicationWillEnterForegroundNotification object:nil];
    
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(processForeground) name:kNOTIFICATION_DIDFOREGROUND object:nil];
    
    lblInfoHours.text = NSLocalizedString(@"HOURS", nil);
    lblInfoDays.text = NSLocalizedString(@"DAYS", nil);
    lblInfoMins.text = NSLocalizedString(@"MINS", nil);
    lblInfoSecs.text = NSLocalizedString(@"SECS", nil);
    
    lblTapToDrag.text = NSLocalizedString(@"Tap to drag counter", nil);
    [btnClose setTitle:NSLocalizedString(@"Close", nil) forState:UIControlStateNormal];
    btnClose.contentVerticalAlignment = UIControlContentVerticalAlignmentTop;
    
    [btnEdit setTitle:NSLocalizedString(@"Edit", nil) forState:UIControlStateNormal];
    btnEdit.contentVerticalAlignment = UIControlContentVerticalAlignmentTop;
    
    [btnSaveImage setTitle:NSLocalizedString(@"Save Image", nil) forState:UIControlStateNormal];
    btnSaveImage.contentVerticalAlignment = UIControlContentVerticalAlignmentTop;
    btnSaveImage.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    
    [btnSendMail setTitle:NSLocalizedString(@"Send eMail", nil) forState:UIControlStateNormal];
    btnSendMail.contentVerticalAlignment = UIControlContentVerticalAlignmentTop;
    btnSendMail.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    
    [btnSendSMS setTitle:NSLocalizedString(@"Send SMS", nil) forState:UIControlStateNormal];
    btnSendSMS.contentVerticalAlignment = UIControlContentVerticalAlignmentTop;
    btnSendSMS.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    
    [btnFacebook setTitle:NSLocalizedString(@"Facebook", nil) forState:UIControlStateNormal];
    btnFacebook.contentVerticalAlignment = UIControlContentVerticalAlignmentTop;
    btnFacebook.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    
    [btnTwitter setTitle:NSLocalizedString(@"Twitter", nil) forState:UIControlStateNormal];
    btnTwitter.contentVerticalAlignment = UIControlContentVerticalAlignmentTop;
    btnTwitter.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    
    [btnCancel setTitle:NSLocalizedString(@"Cancel", nil) forState:UIControlStateNormal];
    btnCancel.contentVerticalAlignment = UIControlContentVerticalAlignmentTop;
    btnCancel.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    if (IS_IPAD == YES)
    {
        [infolblName setFont:[UIFont fontWithName:@"MyriadPro-Semibold" size:42]];
        
        lblInfoHours.font = [UIFont fontWithName:FONT_BOLD size:23.0];;
        lblInfoDays.font = [UIFont fontWithName:FONT_BOLD size:23.0];;
        lblInfoMins.font = [UIFont fontWithName:FONT_BOLD size:23.0];;
        lblInfoSecs.font = [UIFont fontWithName:FONT_BOLD size:23.0];;
        
        lblTapToDrag.font = [UIFont fontWithName:FONT_BOLD size:32.0];
        
        btnClose.titleEdgeInsets = UIEdgeInsetsMake(38, 0, 0, 0);
        btnClose.titleLabel.font = SMALL_LABEL_FONT;
        
        btnEdit.titleLabel.font = MIDDLE_BUTTON_FONT_IPAD;
        btnEdit.titleEdgeInsets = UIEdgeInsetsMake(18, 0, 0, 0);
        
        btnSaveImage.titleLabel.font = LARGE_BUTTON_BOLDFONT_IPAD;
        btnSaveImage.titleEdgeInsets = UIEdgeInsetsMake(22.0, 17, 0, 0);
        
        btnSendMail.titleLabel.font = LARGE_BUTTON_BOLDFONT_IPAD;
        btnSendMail.titleEdgeInsets = UIEdgeInsetsMake(22.0, 17, 0, 0);
        
        btnSendSMS.titleLabel.font = LARGE_BUTTON_BOLDFONT_IPAD;
        btnSendSMS.titleEdgeInsets = UIEdgeInsetsMake(22.0, 17, 0, 0);
        
        btnFacebook.titleLabel.font = LARGE_BUTTON_BOLDFONT_IPAD;
        btnFacebook.titleEdgeInsets = UIEdgeInsetsMake(22.0, 17, 0, 0);
        
        btnTwitter.titleLabel.font = LARGE_BUTTON_BOLDFONT_IPAD;
        btnTwitter.titleEdgeInsets = UIEdgeInsetsMake(26.0, 17, 0, 0);
        
        btnCancel.titleLabel.font = LARGE_BUTTON_BOLDFONT_IPAD;
        btnCancel.titleEdgeInsets = UIEdgeInsetsMake(26.0, 0, 0, 0);
    }
    else
    {
        [infolblName setFont:[UIFont fontWithName:@"MyriadPro-Semibold" size:27]];
        
        lblInfoHours.font = SMALL_LABEL_FONT;
        lblInfoDays.font = SMALL_LABEL_FONT;
        lblInfoMins.font = SMALL_LABEL_FONT;
        lblInfoSecs.font = SMALL_LABEL_FONT;
        
        lblTapToDrag.font = [UIFont fontWithName:FONT_BOLD size:16.0];
        
        btnClose.titleEdgeInsets = UIEdgeInsetsMake(30, 0, 0, 0);
        btnClose.titleLabel.font = SMALL_LABEL_FONT;
        
        btnEdit.titleLabel.font = SMALL_BUTTON_FONT;
        btnEdit.titleEdgeInsets = UIEdgeInsetsMake(9.5, 0, 0, 0);
        
        btnSaveImage.titleLabel.font = LARGE_BUTTON_BOLDFONT;
        btnSaveImage.titleEdgeInsets = UIEdgeInsetsMake(11.0, 17, 0, 0);
        
        btnSendMail.titleLabel.font = LARGE_BUTTON_BOLDFONT;
        btnSendMail.titleEdgeInsets = UIEdgeInsetsMake(11.0, 17, 0, 0);
        
        btnSendSMS.titleLabel.font = LARGE_BUTTON_BOLDFONT;
        btnSendSMS.titleEdgeInsets = UIEdgeInsetsMake(11.0, 17, 0, 0);
        
        btnFacebook.titleLabel.font = LARGE_BUTTON_BOLDFONT;
        btnFacebook.titleEdgeInsets = UIEdgeInsetsMake(11.0, 17, 0, 0);
        
        btnTwitter.titleLabel.font = LARGE_BUTTON_BOLDFONT;
        btnTwitter.titleEdgeInsets = UIEdgeInsetsMake(11.0, 17, 0, 0);
        
        btnCancel.titleLabel.font = LARGE_BUTTON_BOLDFONT;
        btnCancel.titleEdgeInsets = UIEdgeInsetsMake(13.0, 0, 0, 0);
    }
    
    tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapGesture:)];
    tapGesture.delegate = self;
    [self.view addGestureRecognizer:tapGesture];
    
    leftSwipeGesture = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipeGesture:)];
    leftSwipeGesture.delegate = self;
    leftSwipeGesture.direction = UISwipeGestureRecognizerDirectionRight;
    
    [self.infoflipBgImageView addSubview:infodateFlipView];
    
    arrayScrollLogs = [[NSMutableArray alloc] init];
    
    if ([[NSUserDefaults standardUserDefaults] boolForKey:kFULLVERSION] == NO)
    {
        self.adView = [[RevMobAds session] bannerView];
        adView.delegate = self;
        [adView loadAd];
    }
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(hideRevmobAds) name:kNOTIFICATION_FULLVERSION object:nil];
    
    isTabBar = NO;
    
    if (IS_IOS7UP)
    {
        CGRect frame = btnInfo.frame;
        frame.origin.y += 20;
        btnInfo.frame = frame;
        
        frame = btnEdit.frame;
        frame.origin.y += 20;
        btnEdit.frame = frame;
        
        frame = btnShare.frame;
        frame.origin.y += 20;
        btnShare.frame = frame;
    }
}

- (void)configBigDays
{
    [scrBigDays removeGestureRecognizer:leftSwipeGesture];
    
    if (arrayPageViews == nil)
        self.arrayPageViews = [NSMutableArray array];
    else
        [arrayPageViews removeAllObjects];
    
    for (UIView *view in scrBigDays.subviews)
        [view removeFromSuperview];
    
    NSUserDefaults *archive = [NSUserDefaults standardUserDefaults];
    NSString *strCount = [archive objectForKey:@"dayscount"];
    int nCount = 0;
    if (strCount)
        nCount = [strCount intValue];
    
    int pageIndex = nDayIndex / 10;
    int pageFrom = pageIndex * 10;
    int pageTo = pageIndex * 10 + 10;
    if (pageTo > nCount)
        pageTo = pageFrom + nCount % 10;
    for (int i = pageFrom; i < pageTo; i++)
    {
        BigDayPageViewController *controller;
        controller = [[BigDayPageViewController alloc] init];
        controller.nDayIndex = i;
        CGRect frame = controller.view.frame;
        frame.origin.x = SLIDE_OFFSET + (i - pageFrom) * SLIDE_WIDTH;
        frame.size.width = [UIScreen mainScreen].bounds.size.width;
        if (IS_IOS7UP)
            frame.size.height = [UIScreen mainScreen].bounds.size.height;
        else
            frame.size.height = [UIScreen mainScreen].bounds.size.height - 20;
        controller.view.frame = frame;
        [controller initFlipView];
        [scrBigDays addSubview:controller.view];
        [arrayPageViews addObject:controller];
        
        if (i == nDayIndex)
        {
            self.dicDayInfo = controller.dicDayInfo;
            nScrollIndex = i - pageFrom;
            self.targetDate = controller.targetDate;
        }
    }
    pageSlider.numberOfPages = pageTo - pageFrom;
    pageSlider.currentPage = nScrollIndex;
    
    CGSize contentsize = scrBigDays.contentSize;
    contentsize.width = (pageTo - pageFrom) * SLIDE_WIDTH;
    scrBigDays.contentSize = contentsize;
    
    scrBigDays.contentOffset = CGPointMake(SLIDE_WIDTH * nScrollIndex, 0);
    
    if (pageSlider.numberOfPages == 1)
    {
        CGSize contentsize = scrBigDays.contentSize;
        contentsize.width = (pageTo - pageFrom) * SLIDE_WIDTH + 1;
        scrBigDays.contentSize = contentsize;
        
        //[scrBigDays addGestureRecognizer:leftSwipeGesture];
    }
}

- (void)handleTapGesture:(UITapGestureRecognizer*)gestureRecognizer
{
    if (isInScrolling)
    {
        return;
    }
    
    if ([[NSUserDefaults standardUserDefaults] boolForKey:kFULLVERSION] == NO)
        return;
    
    CGRect frame = pageSlider.frame;
    if (btnInfo.alpha == 1.0)
    {
        frame.origin.y = [UIScreen mainScreen].bounds.size.height - 20 - frame.size.height;
        
    }
    else
    {
        frame.origin.y = [UIScreen mainScreen].bounds.size.height - 20 - frame.size.height - APP_DELEGATE.viewController.tabBar.frame.size.height;
    }
    pageSlider.frame = frame;
    pageSlider.alpha = 0.0;
    
    
    [UIView animateWithDuration:0.1 animations:^
     {
         pageSlider.alpha = 1.0;
         if (btnInfo.alpha == 1.0)
         {
             btnInfo.alpha = 0.0;
             btnEdit.alpha = 0.0;
             btnShare.alpha = 0.0;
             
             APP_DELEGATE.viewController.tabBar.alpha = 0.0;

         }
         else
         {
             btnInfo.alpha = 1.0;
             btnEdit.alpha = 1.0;
             btnShare.alpha = 1.0;
             
             APP_DELEGATE.viewController.tabBar.alpha = 1.0;

         }
     } completion:^(BOOL finished){
         if (btnInfo.alpha == 0.0)
         {
             [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationSlide];
         }
         else
         {
             [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationSlide];
         }
     }];
}

- (void)handleSwipeGesture:(UISwipeGestureRecognizer*)gestureRecognizer
{
    if (nDayIndex == 0)
        return;
    
    nDayIndex -= 1;
    isSwipeGesture = YES;
    
    [self configBigDays];
}

- (IBAction)imageTouch:(id)sender withEvent:(UIEvent *)event
{
    touchPoint = [[[event allTouches] anyObject] locationInView:self.infoView];
}

- (IBAction)imageMoved:(id)sender withEvent:(UIEvent *)event
{
    CGPoint point = [[[event allTouches] anyObject] locationInView:self.infoView];
    
    CGRect rt = infoflipBgImageView.frame;
    rt.origin.x += (point.x - touchPoint.x);
    rt.origin.y += (point.y - touchPoint.y);
    if (rt.origin.x < dragdropImageView.frame.origin.x + 10) {
        rt.origin.x = dragdropImageView.frame.origin.x + 10;
    }
    else if (rt.origin.x > dragdropImageView.frame.origin.x + dragdropImageView.frame.size.width - 10 - rt.size.width) {
        rt.origin.x = dragdropImageView.frame.origin.x + dragdropImageView.frame.size.width - 10 - rt.size.width;
    }
    
    if (rt.origin.y < dragdropImageView.frame.origin.y + 15) {
        rt.origin.y = dragdropImageView.frame.origin.y + 15;
    }
    else if (rt.origin.y > dragdropImageView.frame.origin.y + dragdropImageView.frame.size.height - 32 - rt.size.height) {
        rt.origin.y = dragdropImageView.frame.origin.y + dragdropImageView.frame.size.height - 32 - rt.size.height;
    }
    
    infoflipBgImageView.frame = rt;
    int pageIndex = pageSlider.currentPage;
    BigDayPageViewController *controller = [arrayPageViews objectAtIndex:pageIndex];
    controller.flipBgImageView.frame = rt;
    
    [self setCounterAndNameFrame];
    touchPoint = point;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated
{
    [self initViewWillAppear];
    
    [super viewWillAppear:animated];
    
    isOnFullScreen = YES;
    
    [self hideRevmobAds];
    
    [self hideStatusBar];
}

- (void)hideRevmobAds
{
    if ([[NSUserDefaults standardUserDefaults] boolForKey:kFULLVERSION])
        bannerView.hidden = YES;
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    isOnFullScreen = YES;
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    isOnFullScreen = NO;
}

- (void)doViewWillAppear: (NSNotification *)notif
{
    [self initViewWillAppear];
}

- (void)processForeground
{
    if (isOnFullScreen == YES)
        [self performSelector:@selector(hideStatusBar) withObject:nil afterDelay:0.2];
}

- (void)hideStatusBar
{
    if ([[NSUserDefaults standardUserDefaults] boolForKey:kFULLVERSION] == NO)
        return;
    
    CGRect frame = self.navigationController.view.frame;
    if (IS_IOS7UP)
        frame.size.height = [UIScreen mainScreen].bounds.size.height;
    else
        frame.size.height = [UIScreen mainScreen].bounds.size.height - 20;
    self.navigationController.view.frame = frame;
    
    frame = pageSlider.frame;
    frame.origin.y = [UIScreen mainScreen].bounds.size.height - 20 - frame.size.height;
    pageSlider.frame = frame;
    
    btnInfo.alpha = 0.0;
    btnEdit.alpha = 0.0;
    btnShare.alpha = 0.0;
    
    frame = self.viewContents.frame;
    
    APP_DELEGATE.viewController.tabBar.alpha = 0.0;
    [[UIApplication sharedApplication] setStatusBarHidden:YES];
}

- (void)initViewWillAppear
{
    // Page Control
    [self configBigDays];
    
    NSUserDefaults *archive = [NSUserDefaults standardUserDefaults];
    NSData *data = [archive objectForKey:[NSString stringWithFormat:@"dayinfo_%d", nDayIndex]];
    if (data) {
        dicDayInfo = [NSKeyedUnarchiver unarchiveObjectWithData:data];
        if (dicDayInfo) {
            infolblName.text = [dicDayInfo objectForKey:@"name"];
            
            NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
            
            NSString *strDate = [dicDayInfo objectForKey:@"targetdate"];
            NSString *strTime = [dicDayInfo objectForKey:@"targettime"];
            
            [dateFormat setDateFormat:@"MMM dd, yyyy hh:mm a"];
            
            NSString *stringDate = [NSString stringWithFormat:@"%@ %@", strDate, strTime];
            targetDate = [dateFormat dateFromString:stringDate];
            if (targetDate == nil)
            {
                dateFormat.locale = ENGLISH_LOCALE;
                NSString *stringDate = [NSString stringWithFormat:@"%@ %@", strDate, strTime];
                targetDate = [dateFormat dateFromString:stringDate];
                if (targetDate == nil)
                    targetDate = [APP_DELEGATE correctDate:stringDate];
            }
            targetDate = [dicDayInfo objectForKey:@"targetdatetime"];
            
            if (targetDate)
                [self.infodateFlipView setTargetDate:targetDate];
            
            NSString *strOriginX = [dicDayInfo objectForKey:@"counter_x"];
            NSString *strOriginY = [dicDayInfo objectForKey:@"counter_y"];
            if (strOriginX != nil && strOriginY != nil) {
                CGRect rt = infoflipBgImageView.frame;
                rt.origin.x = [strOriginX floatValue];
                rt.origin.y = [strOriginY floatValue];
                
                if (rt.origin.x < dragdropImageView.frame.origin.x + 10) {
                    rt.origin.x = dragdropImageView.frame.origin.x + 10;
                }
                else if (rt.origin.x > dragdropImageView.frame.origin.x + dragdropImageView.frame.size.width - 10 - rt.size.width) {
                    rt.origin.x = dragdropImageView.frame.origin.x + dragdropImageView.frame.size.width - 10 - rt.size.width;
                }
                
                if (rt.origin.y < dragdropImageView.frame.origin.y + 15) {
                    rt.origin.y = dragdropImageView.frame.origin.y + 15;
                }
                else if (rt.origin.y > dragdropImageView.frame.origin.y + dragdropImageView.frame.size.height - 32 - rt.size.height) {
                    rt.origin.y = dragdropImageView.frame.origin.y + dragdropImageView.frame.size.height - 32 - rt.size.height;
                }
                
                infoflipBgImageView.frame = rt;
            }
        }
    }
    
    [self setCounterAndNameFrame];
    
    if (isOnFullScreen)
        [self hideStatusBar];
}

- (void)setCounterAndNameFrame
{
    BigDayPageViewController *bigday = [arrayPageViews objectAtIndex:pageSlider.currentPage];
    CGRect rt = bigday.flipBgImageView.frame;
    if (IS_IPAD == YES)
    {
        [bigday.dateFlipView setFrame:CGRectMake(rt.origin.x + 22, rt.origin.y + 100, rt.size.width - 50, rt.size.height / 4 )];
        bigday.lblName.frame = CGRectMake(rt.origin.x + 10, rt.origin.y + 25, rt.size.width - 20, 48);
        bigday.lblDays.frame = CGRectMake(rt.origin.x + 85, rt.origin.y + 174, 72, 36);
        bigday.lblHours.frame = CGRectMake(rt.origin.x + 222, rt.origin.y + 174, 96, 36);
        bigday.lblMins.frame = CGRectMake(rt.origin.x + 334, rt.origin.y + 174, 72, 36);
        bigday.lblSecs.frame = CGRectMake(rt.origin.x + 435, rt.origin.y + 174, 72, 36);
        
        infolblName.text = bigday.lblName.text;
        [infodateFlipView setTargetDate:bigday.targetDate];
        rt = bigday.flipBgImageView.frame;
        infoflipBgImageView.frame = rt;
        [infodateFlipView setFrame:CGRectMake(20, 100, rt.size.width - 50, rt.size.height / 4 )];
        //[infodateFlipView setFrame:CGRectMake(5 + rt.origin.x, 45 + rt.origin.y, rt.size.width - 10, rt.size.height / 4 )];
        infolblName.frame = CGRectMake(10 + rt.origin.x, 25 + rt.origin.y, rt.size.width - 20, 48);
        lblInfoDays.frame = CGRectMake(rt.origin.x + 85, rt.origin.y + 174, 72, 36);
        lblInfoHours.frame = CGRectMake(rt.origin.x + 222, rt.origin.y + 174, 96, 36);
        lblInfoMins.frame = CGRectMake(rt.origin.x + 334, rt.origin.y + 174, 72, 36);
        lblInfoSecs.frame = CGRectMake(rt.origin.x + 435, rt.origin.y + 174, 72, 36);
    }
    else
    {
        [bigday.dateFlipView setFrame:CGRectMake(rt.origin.x + 5, rt.origin.y + 45, rt.size.width - 10, rt.size.height / 4 )];
        bigday.lblName.frame = CGRectMake(rt.origin.x + 10, rt.origin.y + 5, rt.size.width - 20, 35);
        bigday.lblDays.frame = CGRectMake(rt.origin.x + 35, rt.origin.y + 84, 45, 25);
        bigday.lblHours.frame = CGRectMake(rt.origin.x + 112, rt.origin.y + 84, 50, 25);
        bigday.lblMins.frame = CGRectMake(rt.origin.x + 170, rt.origin.y + 84, 45, 25);
        bigday.lblSecs.frame = CGRectMake(rt.origin.x + 228, rt.origin.y + 84, 45, 25);
        
        infolblName.text = bigday.lblName.text;
        [infodateFlipView setTargetDate:bigday.targetDate];
        rt = bigday.flipBgImageView.frame;
        infoflipBgImageView.frame = rt;
        [infodateFlipView setFrame:CGRectMake(5, 45, rt.size.width - 10, rt.size.height / 4 )];
        //[infodateFlipView setFrame:CGRectMake(5 + rt.origin.x, 45 + rt.origin.y, rt.size.width - 10, rt.size.height / 4 )];
        infolblName.frame = CGRectMake(10 + rt.origin.x, 6 + rt.origin.y, rt.size.width - 20, 35);
        lblInfoDays.frame = CGRectMake(rt.origin.x + 35, rt.origin.y + 84, 45, 25);
        lblInfoHours.frame = CGRectMake(rt.origin.x + 112, rt.origin.y + 84, 50, 25);
        lblInfoMins.frame = CGRectMake(rt.origin.x + 170, rt.origin.y + 84, 45, 25);
        lblInfoSecs.frame = CGRectMake(rt.origin.x + 228, rt.origin.y + 84, 45, 25);
    }
}

- (void)setDayIndex:(int)nIndex
{
    nDayIndex = nIndex;
}

- (IBAction)onEditInfo:(id)sender
{
    AddDaysViewController *viewController = [AddDaysViewController new];
    viewController.dicDayInfo = self.dicDayInfo;
    [viewController setDayIndex:nDayIndex];
    [self.navigationController pushViewController:viewController animated:YES];
    
    [Flurry logEvent:@"BigDay_Edit"];
}

- (IBAction)onCancelInfo:(id)sender
{
    BigDayPageViewController *bigday = [arrayPageViews objectAtIndex:pageSlider.currentPage];
    bigday.flipBgImageView.frame = infoflipBgImageView.frame;
    [dicDayInfo setObject:[NSString stringWithFormat:@"%f", bigday.flipBgImageView.frame.origin.x] forKey:@"counter_x"];
    [dicDayInfo setObject:[NSString stringWithFormat:@"%f", bigday.flipBgImageView.frame.origin.y] forKey:@"counter_y"];
    [self setCounterAndNameFrame];
    NSUserDefaults *archive = [NSUserDefaults standardUserDefaults];
    if (nDayIndex >= 0) {
        //Modify Day Info
        NSData *data = [NSKeyedArchiver archivedDataWithRootObject:dicDayInfo];
        [archive setObject:data forKey:[NSString stringWithFormat:@"dayinfo_%d", nDayIndex]];
        
        [archive synchronize];
    }
    
    [UIView beginAnimations:@"CancelInfoView" context:nil];
    [UIView setAnimationDuration:0.75];
    
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDidStopSelector:@selector(animationDidStop:finished:context:)];
    
    CGRect rctFrame = self.infoView.frame;
    rctFrame.origin = CGPointMake(0, 800);
    self.infoView.frame = rctFrame;
    
    [UIView commitAnimations];
}

- (void)animationDidStop:(NSString *)animationID finished:(NSNumber *)finished context:(void *)context
{
    if ([animationID isEqualToString:@"CancelShareView"]) {
        [shareView removeFromSuperview];
    }
    else if ([animationID isEqualToString:@"CancelInfoView"]) {
        [infoView removeFromSuperview];
        
        if (targetDate) {
            BigDayPageViewController *bigday = [arrayPageViews objectAtIndex:pageSlider.currentPage];
            [bigday.dateFlipView setTargetDate:targetDate];
            [self.infodateFlipView setTargetDate:targetDate];
        }
    }
}

- (IBAction)onShare:(id)sender
{
    CGRect rctFrame = self.shareView.frame;
    rctFrame.origin = CGPointMake(0, 800);
    self.shareView.frame = rctFrame;
    [APP_DELEGATE.viewController.view addSubview:self.shareView];
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.75];
    
    rctFrame.origin = CGPointMake(0, 0);
    self.shareView.frame = rctFrame;
    
    [UIView commitAnimations];
}

- (IBAction)onInfo:(id)sender
{
    [self setCounterAndNameFrame];
    
    CGRect rctFrame = self.infoView.frame;
    rctFrame.origin = CGPointMake(0, 800);
    self.infoView.frame = rctFrame;
    [APP_DELEGATE.viewController.view addSubview:self.infoView];
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.75];
    
    rctFrame.origin = CGPointMake(0, 0);
    self.infoView.frame = rctFrame;
    
    [UIView commitAnimations];
    
    if (targetDate) {
        //[self.dateFlipView setTargetDate:targetDate];
        [self.infodateFlipView setTargetDate:targetDate];
    }
}

- (IBAction)onSaveImage:(id)sender
{
    [self saveImageToPhotosAlbum];
    [Flurry logEvent:@"BigDay_Save_Image"];
}

- (void) saveImageToPhotosAlbum
{
    btnInfo.hidden = YES;
    btnEdit.hidden = YES;
    btnShare.hidden = YES;
    
    UIGraphicsBeginImageContext(self.view.bounds.size);
    [self.view.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *viewImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    UIImageWriteToSavedPhotosAlbum(viewImage, nil, nil, nil);
    
    btnInfo.hidden = NO;
    btnEdit.hidden = NO;
    btnShare.hidden = NO;
    [self showMessage:@"Saved to camera roll." title:@""];
}

- (IBAction)onSendEmail:(id)sender
{
    MFMailComposeViewController *controller = [[MFMailComposeViewController alloc] init];
    
    if (controller) {
        controller.mailComposeDelegate = self;
        
        BigDayPageViewController *bigday = [arrayPageViews objectAtIndex:pageSlider.currentPage];
        [controller setSubject:bigday.lblName.text];
        
        btnInfo.hidden = YES;
        btnEdit.hidden = YES;
        btnShare.hidden = YES;
        pageSlider.hidden = YES;
        
        UIGraphicsBeginImageContext(self.view.bounds.size);
        [self.view.layer renderInContext:UIGraphicsGetCurrentContext()];
        UIImage *viewImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        
        btnInfo.hidden = NO;
        btnEdit.hidden = NO;
        btnShare.hidden = NO;
        pageSlider.hidden = NO;
        
        NSData *imageData = UIImagePNGRepresentation(viewImage);
        [controller addAttachmentData:imageData mimeType:@"image/png" fileName:bigday.lblName.text];
        
        NSString *strBody = [NSString stringWithFormat:@"%@ is coming in %d days, %d hours, %d minutes, %d seconds!", bigday.lblName.text, bigday.dateFlipView.mFlipNumberViewDay.intValue, bigday.dateFlipView.mFlipNumberViewHour.intValue, bigday.dateFlipView.mFlipNumberViewMinute.intValue, bigday.dateFlipView.mFlipNumberViewSecond.intValue];
        [controller setMessageBody:strBody isHTML:NO];
        
        if (IS_IOS7UP)
        {
            [[UIView appearance] setTintColor:APP_DELEGATE.defaultTintColor];
        }
        
        [APP_DELEGATE.viewController presentModalViewController:controller animated:YES];
    }
    
    [Flurry logEvent:@"BigDay_Send_Email"];
}

- (void) mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error
{
    if (result == MFMailComposeResultSent) {
        //NSLog(@"Sent!");
        [Flurry logEvent:@"BigDay_Email_Sent"];
    }
    [APP_DELEGATE.viewController dismissModalViewControllerAnimated:YES];
}

- (IBAction)onSendSMS:(id)sender
{
    MFMessageComposeViewController *controller = [[MFMessageComposeViewController alloc] init];
    if ([MFMessageComposeViewController canSendText]) {
        BigDayPageViewController *bigday = [arrayPageViews objectAtIndex:pageSlider.currentPage];
        NSString *strBody = [NSString stringWithFormat:@"%@ is coming in %d days, %d hours, %d minutes, %d seconds!", bigday.lblName.text, bigday.dateFlipView.mFlipNumberViewDay.intValue, bigday.dateFlipView.mFlipNumberViewHour.intValue, bigday.dateFlipView.mFlipNumberViewMinute.intValue, bigday.dateFlipView.mFlipNumberViewSecond.intValue];
        controller.body = strBody;
        controller.messageComposeDelegate = self;
        
        [APP_DELEGATE.viewController presentModalViewController:controller animated:YES];
    }
    
    [Flurry logEvent:@"BigDay_Send_SMS"];
}

- (void) messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult)result
{
    if (result == MessageComposeResultSent) {
        //NSLog(@"Sent!");
        [Flurry logEvent:@"BigDay_SMS_Sent"];
    }
    [APP_DELEGATE.viewController dismissModalViewControllerAnimated:YES];
}

- (IBAction)onFacebook:(id)sender {
    [self onCancelShare:nil
        completionBlock:^{
            if (![AppManager sharedInstance].isLoginFromSocial) {
                NSLog(@"[AppManager sharedInstance].isLoginFromSocial:%d",[AppManager sharedInstance].isLoginFromSocial);
                UIAlertView *facebookNotify =  [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Facebook authentication", nil)
                                                                          message:NSLocalizedString(@"For this actions you should login to Facebook", nil)
                                                                         delegate:self
                                                                cancelButtonTitle:NSLocalizedString(@"Cancel", nil)
                                                                otherButtonTitles:NSLocalizedString(@"Login", nil), nil];
                facebookNotify.tag = 200;
                [facebookNotify show];
            } else {
                [self facebookLoginHandler];
            }
        }];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (alertView.tag == 200) {
        if (buttonIndex == 1) {
            [self facebookLoginHandler];
        }
    } else {
        NSLog(@"Cancel Facebook Login");
    }
}

- (void)facebookLoginHandler {
    [Flurry logEvent:@"BigDay_Facebook"];
    self.downloadProgressHud.labelText = @"Posting...";
    self.downloadProgressHud.detailsLabelText = @"";
    [self.downloadProgressHud show:YES];
    [self.facebookFacade openSessionWithCompletionHandler:^{
        if ([self.facebookFacade isSessionOpen]) {
            [self.facebookFacade startRequestForMeWithCompletionHandler:^(id result, NSError *error) {
                NSLog(@"result:%@",result);
                NSLog(@"error:%@",error);
                if (!error) {
                    btnInfo.hidden = YES;
                    btnEdit.hidden = YES;
                    btnShare.hidden = YES;
                    self.downloadProgressHud.hidden = YES;
                    UIGraphicsBeginImageContext(self.view.bounds.size);
                    [self.view.layer renderInContext:UIGraphicsGetCurrentContext()];
                    UIImage *viewImage = UIGraphicsGetImageFromCurrentImageContext();
                    UIGraphicsEndImageContext();
                    self.downloadProgressHud.hidden = NO;

                    btnInfo.hidden = NO;
                    btnEdit.hidden = NO;
                    btnShare.hidden = NO;

                    BigDayPageViewController *bigday = [arrayPageViews objectAtIndex:pageSlider.currentPage];
                    NSString *strBody = [NSString stringWithFormat:@"%@ is coming in %d days, %d hours, %d minutes, %d seconds!",
                                         bigday.lblName.text,
                                         bigday.dateFlipView.mFlipNumberViewDay.intValue,
                                         bigday.dateFlipView.mFlipNumberViewHour.intValue,
                                         bigday.dateFlipView.mFlipNumberViewMinute.intValue,
                                         bigday.dateFlipView.mFlipNumberViewSecond.intValue];

                    NSLog(@"strBody:%@",strBody);

                    [AppManager sharedInstance].isLoginFromSocial = YES;
                    [[AppManager sharedInstance] saveLogin];

                    [Flurry logEvent:@"BigDay_Facebook_Login_Success"];
                    [self.facebookFacade postOpenGraphStoryWithImage:viewImage
                                                           withTitle:strBody
                                                     completionBlock:^{
                                                         self.downloadProgressHud.detailsLabelText = NSLocalizedStringFromTable(@"Your Holiday has been posted successfully.", @"Strings", @"");
                                                         [self.downloadProgressHud hide:YES afterDelay:3];
                                                         [Flurry logEvent:@"BigDay_Facebook_Posted"];
                                                     }
                                                     andFailureBlock:^{
                                                         self.downloadProgressHud.detailsLabelText = NSLocalizedStringFromTable(@"Failed posting your Holiday.", @"Strings", @"");
                                                         [self.downloadProgressHud hide:YES afterDelay:3];                                                                 [Flurry logEvent:@"BigDay_Facebook_Post_Failed"];
                                                     }];
                }
            }];
        }
    } andFailureBlock:^{
        self.downloadProgressHud.detailsLabelText = NSLocalizedStringFromTable(@"Facebook Login Failed.", @"Strings", @"");
        [self.downloadProgressHud hide:YES afterDelay:3];
        [Flurry logEvent:@"BigDay_Facebook_Login_Failed"];
    }];
}

- (IBAction)onCancelShare:(id)sender {
    [self onCancelShare:sender completionBlock:^{
        NSLog(@"cancel");
    }];
}

- (void)onCancelShare:(id)sender
      completionBlock:(SimpleCallBack)completion {
    [UIView animateWithDuration:0.75
                          delay:0
                        options:UIViewAnimationOptionTransitionCurlDown
                     animations:^{
                         CGRect rctFrame = self.shareView.frame;
                         rctFrame.origin = CGPointMake(0, 800);
                         self.shareView.frame = rctFrame;
                     } completion:^(BOOL finished) {
                         [self.shareView removeFromSuperview];
                         BLOCK_SAFE_RUN(completion);
                     }];
}

- (void) showMessage:(NSString *) message title:(NSString *) title {
    UIAlertView * alert = [[UIAlertView alloc] initWithTitle: title message: message delegate: nil cancelButtonTitle:NSLocalizedString(@"OK", nil) otherButtonTitles: nil];
    [alert show];
}

- (IBAction)onTwitter:(id)sender {
    if ([TWTweetComposeViewController canSendTweet]) {
        TWTweetComposeViewController *controller = [[TWTweetComposeViewController alloc] init];
        
        btnInfo.hidden = YES;
        btnEdit.hidden = YES;
        btnShare.hidden = YES;
        
        UIGraphicsBeginImageContext(self.view.bounds.size);
        [self.view.layer renderInContext:UIGraphicsGetCurrentContext()];
        UIImage *viewImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        
        btnInfo.hidden = NO;
        btnEdit.hidden = NO;
        btnShare.hidden = NO;
        
        BigDayPageViewController *bigday = [arrayPageViews objectAtIndex:pageSlider.currentPage];
        NSString *strBody = [NSString stringWithFormat:@"%@ is coming in %d days, %d hours, %d minutes, %d seconds!", bigday.lblName.text, bigday.dateFlipView.mFlipNumberViewDay.intValue, bigday.dateFlipView.mFlipNumberViewHour.intValue, bigday.dateFlipView.mFlipNumberViewMinute.intValue, bigday.dateFlipView.mFlipNumberViewSecond.intValue];
        
        [controller setInitialText:strBody];
        [controller addImage:viewImage];
        //Adding URL
        NSURL *url = [NSURL URLWithString:@"http://www.bigday-countdown.com"];
        [controller addURL:url];
        
        [controller setCompletionHandler:^(TWTweetComposeViewControllerResult result) {
            
            [APP_DELEGATE.viewController dismissModalViewControllerAnimated:YES];
        }];
        
        [APP_DELEGATE.viewController presentModalViewController:controller animated:YES];
    }
    else {
        // Show Alert View When The Application Cannot Send Tweets
        NSString *message = @"The application cannot send a tweet at the moment. This is because it cannot reach Twitter or you don't have a Twitter account associated with this device.";
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Oops" message:message delegate:nil cancelButtonTitle:@"Dismiss" otherButtonTitles:nil];
        [alertView show];
    }
    
    [Flurry logEvent:@"BigDay_Twitter"];
}

- (IBAction)onSlidePage:(id)sender
{
    int index = nDayIndex / 10;
    nDayIndex = index * 10 + pageSlider.currentPage;
    nScrollIndex = pageSlider.currentPage;
    
    BigDayPageViewController *bigday = [arrayPageViews objectAtIndex:index];
    self.dicDayInfo = bigday.dicDayInfo;
    [scrBigDays setContentOffset:CGPointMake(SLIDE_WIDTH * pageSlider.currentPage, 0) animated:YES];
    nDayIndex = bigday.nDayIndex;
    self.targetDate = bigday.targetDate;
}

#pragma mark - UIGestureRecognizerDelegate
- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
{
    return YES;
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    return YES;
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    if ([touch.view isKindOfClass:[UIControl class]])
        return NO;
    
    return YES;
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    isInScrolling = YES;
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if (!decelerate)
    {
        isInScrolling = NO;
        if (isSwipeGesture == YES)
        {
            isSwipeGesture = NO;
            return;
        }
        
        [self didScrollForPage];
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    isInScrolling = NO;
    if (isSwipeGesture == YES)
    {
        isSwipeGesture = NO;
        return;
    }

    [self didScrollForPage];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    NSLog(@"Y ================================== %.2f", scrollView.contentOffset.x);
    [arrayScrollLogs addObject:[NSNumber numberWithFloat:scrollView.contentOffset.x]];
    if (arrayScrollLogs.count >= 4)
        [arrayScrollLogs removeObjectAtIndex:0];
}

- (void)didScrollForPage
{
    CGPoint contentOffset = scrBigDays.contentOffset;
    int index = contentOffset.x / SLIDE_WIDTH;
    pageSlider.currentPage = index;
    if ((index == 0 || index == 9) && nScrollIndex == index)
    {
        if (nDayIndex == 0)
            return;
        
        BOOL isNeedNext = NO;
        if (index == 0)
        {
            for (int i = 0; i < arrayScrollLogs.count; i++)
            {
                float offset = [[arrayScrollLogs objectAtIndex:i] floatValue];
                if (offset == contentOffset.x)
                    continue;
                if (offset < 0)
                {
                    isNeedNext = YES;
                    break;
                }
                else
                    isNeedNext = NO;
            }
            if (isNeedNext)
                nDayIndex -= 1;
        }
        else
        {
            for (int i = 0; i < arrayScrollLogs.count; i++)
            {
                float offset = [[arrayScrollLogs objectAtIndex:i] floatValue];
                if (offset == contentOffset.x)
                    continue;
                if (offset > SLIDE_WIDTH * 9)
                {
                    isNeedNext = YES;
                    break;
                }
                else
                    isNeedNext = NO;
            }
            if (isNeedNext)
            {
                nDayIndex += 1;
                NSUserDefaults *archive = [NSUserDefaults standardUserDefaults];
                NSString *strCount = [archive objectForKey:@"dayscount"];
                int nCount = 0;
                if (strCount)
                    nCount = [strCount intValue];
                if (nDayIndex == nCount)
                {
                    nDayIndex -= 1;
                    return;
                }
            }
        }
        
        if (isNeedNext == YES)
            [self configBigDays];
    }
    else
    {
        nScrollIndex = index;
        
        BigDayPageViewController *bigday = [arrayPageViews objectAtIndex:pageSlider.currentPage];
        self.dicDayInfo = bigday.dicDayInfo;
        [self setDayIndex:bigday.nDayIndex];
        self.targetDate = bigday.targetDate;
    }
    
    [arrayScrollLogs removeAllObjects];
}

#pragma mark - RevMobAdsDelegate
- (void)revmobAdDidFailWithError:(NSError *)error
{
    
}

- (void)revmobAdDidReceive
{
    [adView removeFromSuperview];
    
    adView.frame = bannerView.bounds;
    [bannerView addSubview:adView];
}

- (void)revmobAdDisplayed
{
    
}

- (void)revmobUserClickedInTheAd
{
    
}

- (FacebookFacade *)facebookFacade {
    if (!_facebookFacade) {
        _facebookFacade = [FacebookFacade sharedInstance];
    }
    return _facebookFacade;
}

- (MBProgressHUD *)downloadProgressHud {
    if (!_downloadProgressHud) {
        _downloadProgressHud = [[MBProgressHUD alloc] initWithView:self.view];
        [self.view addSubview:_downloadProgressHud];
        _downloadProgressHud.labelText = @"Posting...";
        _downloadProgressHud.mode = MBProgressHUDModeIndeterminate;
    }
    return _downloadProgressHud;
}

@end
