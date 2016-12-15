//
//  FeedbackViewController.m
//  CountDownApp
//
//  Created by Dmitri on 11/1/14.
//  Copyright (c) 2012 Ariel. All rights reserved.
//

#import "FeedbackViewController.h"
#import "AppDelegate.h"
#import "Flurry.h"
#import "BDCommon.h"

@interface FeedbackViewController ()

@end

@implementation FeedbackViewController

@synthesize lblFeedback;
@synthesize lblSupport;
@synthesize btnFriends;
@synthesize btnRate;
@synthesize btnReport;

@synthesize bannerView;
@synthesize adView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    if (IS_IPAD == YES)
        self = [super initWithNibName:@"FeedbackViewController_iPad" bundle:nibBundleOrNil];
    else
        self = [super initWithNibName:@"FeedbackViewController" bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self.navigationController setNavigationBarHidden:YES animated:NO];
    
    if (IS_IPAD)
    {
        lblFeedback.font = TITLE_FONT_IPAD;
        lblSupport.font = MIDDLE_LABEL_FONT_IPAD;
        
        btnRate.titleLabel.font = MIDDLE_BUTTON_FONT_IPAD;
        btnRate.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        btnRate.titleEdgeInsets = UIEdgeInsetsMake(12, 27, 0, 0);
        
        btnFriends.titleLabel.font = MIDDLE_BUTTON_FONT_IPAD;
        btnFriends.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        btnFriends.titleEdgeInsets = UIEdgeInsetsMake(12, 27, 0, 0);
        
        btnReport.titleLabel.font = MIDDLE_BUTTON_FONT_IPAD;
        btnReport.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        btnReport.titleEdgeInsets = UIEdgeInsetsMake(12, 27, 0, 0);
    }
    else
    {
        lblFeedback.font = TITLE_FONT;
        lblSupport.font = MIDDLE_LABEL_FONT;
        
        btnRate.titleLabel.font = MIDDLE_BUTTON_FONT;
        btnRate.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        btnRate.titleEdgeInsets = UIEdgeInsetsMake(9, 9, 0, 0);
        
        btnFriends.titleLabel.font = MIDDLE_BUTTON_FONT;
        btnFriends.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        btnFriends.titleEdgeInsets = UIEdgeInsetsMake(9, 9, 0, 0);
        
        btnReport.titleLabel.font = MIDDLE_BUTTON_FONT;
        btnReport.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        btnReport.titleEdgeInsets = UIEdgeInsetsMake(9, 9, 0, 0);
    }
    
    lblFeedback.text = NSLocalizedString(@"Feedback", nil);
    lblSupport.text = NSLocalizedString(@"Support", nil);
    
    [btnRate setTitle:NSLocalizedString(@"Rate this App", nil) forState:UIControlStateNormal];
    [btnFriends setTitle:NSLocalizedString(@"Tell Your Friends About this App", nil) forState:UIControlStateNormal];
    [btnReport setTitle:NSLocalizedString(@"Report a Problem", nil) forState:UIControlStateNormal];
    
    if ([[NSUserDefaults standardUserDefaults] boolForKey:kFULLVERSION] == NO)
    {
        self.adView = [[RevMobAds session] bannerView];
        adView.delegate = self;
        [adView loadAd];
    }
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(hideRevmobAds) name:kNOTIFICATION_FULLVERSION object:nil];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    isOnFullScreen = NO;
    
    [self hideRevmobAds];
}

- (void)hideRevmobAds
{
    if ([[NSUserDefaults standardUserDefaults] boolForKey:kFULLVERSION])
        bannerView.hidden = YES;
}


-(void)viewDidAppear:(BOOL)animated{

    APP_DELEGATE.fullScreenBannerShow = @"0";
    
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)onRate:(id)sender
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Do you enjoy using Holiday and Vacation Countdown?", nil)
                                                    message:NSLocalizedString(@"If you do, please take the time to give us a nice review or rating\nIt really helps us a lot!\n=)", nil)
                                                   delegate:self
                                          cancelButtonTitle:NSLocalizedString(@"No Thanks", nil)
                                          otherButtonTitles:NSLocalizedString(@"Rate Now!", nil), nil];
    [alert show];
}

- (void)gotoReviews
{
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?id=669398769&pageNumber=0&sortOrdering=1&type=Purple+Software&mt=8"]];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == alertView.firstOtherButtonIndex) {
        
        [self gotoReviews];
        
        [Flurry logEvent:@"Rate_App"];
    }
    else if (buttonIndex != alertView.cancelButtonIndex) {
        
    }
}

- (IBAction)onTellFriends:(id)sender
{
    MFMailComposeViewController *controller = [[MFMailComposeViewController alloc] init];
    
    if (controller) {
        controller.mailComposeDelegate = self;
        [controller setSubject:NSLocalizedString(@"Check out this app", nil)];
        
        NSString *strBody = [NSString stringWithFormat:NSLocalizedString(@"Hey,<br/><br/>I just downloaded \"Holiday and Vacation Countdown\" on my %@!<br/><br/>It's a great app that helps you Countdown your Holidays, Vactions, Trips or ...!<br/><br/>You can download it from the app store:<a href=\"https://itunes.apple.com/us/app/holiday-vacation-countdown/id669398769?ls=1&mt=8\">https://itunes.apple.com/us/app/holiday-vacation-countdown/id669398769?ls=1&mt=8</a>", nil), [[UIDevice currentDevice] model]];
        
        [controller setMessageBody:strBody isHTML:YES];
        //[controller setBccRecipients:[NSArray arrayWithObjects:@"guy.outsourcing@gmail.com", nil]];
        //[controller setCcRecipients:[NSArray arrayWithObjects:@"guy.outsourcing@gmail.com", nil]];
        
        [APP_DELEGATE.viewController presentModalViewController:controller animated:YES];
    }
    
    [Flurry logEvent:@"Tell Friends"];
}

- (void) mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error
{
    if (result == MFMailComposeResultSent) {
        NSLog(@"Sent!");
    }
    [APP_DELEGATE.viewController dismissModalViewControllerAnimated:YES];
}

- (IBAction)onReport:(id)sender
{
    MFMailComposeViewController *controller = [[MFMailComposeViewController alloc] init];
    
    if (controller) {
        controller.mailComposeDelegate = self;
        [controller setToRecipients:[NSArray arrayWithObjects:@"info@bigday-countdown.com", nil]];
        [controller setSubject:NSLocalizedString(@"Bug Report Holiday Countdown", nil)];
        
        //[controller setBccRecipients:[NSArray arrayWithObjects:@"guy.outsourcing@gmail.com", nil]];
        //[controller setCcRecipients:[NSArray arrayWithObjects:@"guy.outsourcing@gmail.com", nil]];
        
        [APP_DELEGATE.viewController presentModalViewController:controller animated:YES];
    }
    
    [Flurry logEvent:@"Report"];
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

@end
