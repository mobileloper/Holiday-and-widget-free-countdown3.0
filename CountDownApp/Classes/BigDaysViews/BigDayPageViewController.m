//
//  BigDayPageViewController.m
//  CountDownApp
//
//  Created by Administrator on 6/21/13.
//  Copyright (c) 2013 Ariel. All rights reserved.
//

#import "BigDayPageViewController.h"
#import "AppDelegate.h"
#import "BDCommon.h"

@interface BigDayPageViewController ()
@property (nonatomic, strong) GADInterstitial * interstitial;
@end

@implementation BigDayPageViewController

@synthesize bgImageView;
@synthesize dateFlipView;
@synthesize flipBgImageView;
@synthesize lblName;
@synthesize lblDays;
@synthesize lblHours;
@synthesize lblMins;
@synthesize lblSecs;

@synthesize nDayIndex;
@synthesize dicDayInfo;
@synthesize targetDate;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    if (IS_IPAD == YES)
        self = [super initWithNibName:@"BigDayPageViewController_iPad" bundle:nibBundleOrNil];
    else if (IS_IPHONE_5)
        self = [super initWithNibName:@"BigDayPageViewController_iPhone5" bundle:nibBundleOrNil];
    else
        self = [super initWithNibName:@"BigDayPageViewController" bundle:nibBundleOrNil];
    
    if (self) {
        // Custom initialization
        dateFlipView = [[JDDateCountdownFlipView alloc] initWithType:1];
        [dateFlipView setFlipNumberType:1];
        [dateFlipView setUserInteractionEnabled:NO];
        //[dateFlipView setFrame:];
        [dateFlipView setAutoresizingMask:UIViewAutoresizingNone];
        [self.view addSubview:dateFlipView];

    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    lblHours.text = NSLocalizedString(@"HOURS", nil);
    lblDays.text = NSLocalizedString(@"DAYS", nil);
    lblMins.text = NSLocalizedString(@"MINS", nil);
    lblSecs.text = NSLocalizedString(@"SECS", nil);
    
    if (IS_IPAD == YES)
    {
        [lblName setFont:[UIFont fontWithName:@"MyriadPro-Semibold" size:42]];
        lblHours.font = [UIFont fontWithName:FONT_BOLD size:23.0];
        lblDays.font = [UIFont fontWithName:FONT_BOLD size:23.0];
        lblMins.font = [UIFont fontWithName:FONT_BOLD size:23.0];
        lblSecs.font = [UIFont fontWithName:FONT_BOLD size:23.0];
    }
    else
    {
        [lblName setFont:[UIFont fontWithName:@"MyriadPro-Semibold" size:27]];
        lblHours.font = SMALL_LABEL_FONT;
        lblDays.font = SMALL_LABEL_FONT;
        lblMins.font = SMALL_LABEL_FONT;
        lblSecs.font = SMALL_LABEL_FONT;
    }
    

}

- (void)adViewDidReceiveAd:(GADBannerView *)bannerView {
    bannerView.hidden = NO;
}

- (void)adView:(GADBannerView *)adView didFailToReceiveAdWithError:(GADRequestError *)error {
}

-(void) viewWillLayoutSubviews
{
    GADBannerView *bannerView = [[GADBannerView alloc] initWithAdSize:kGADAdSizeSmartBannerPortrait];
    bannerView.delegate = self;
    bannerView.adUnitID = @"ca-app-pub-3919550248819664/9287413230";
    bannerView.rootViewController = self;
    
    [self.view addSubview:bannerView];
    //bannerView.hidden = YES;
    
    GADRequest *request = [GADRequest request];
    [bannerView loadRequest:request];
    [self loadGoogleAdsFull];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)initFlipView
{
    NSUserDefaults *archive = [NSUserDefaults standardUserDefaults];
    NSData *data = [archive objectForKey:[NSString stringWithFormat:@"dayinfo_%d", nDayIndex]];
    if (data) {
        dicDayInfo = [NSKeyedUnarchiver unarchiveObjectWithData:data];
        if (dicDayInfo) {
            lblName.text = [dicDayInfo objectForKey:@"name"];

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
            //targetDate = [dicDayInfo objectForKey:@"targetdatetime"];

            if (targetDate) {
                [self.dateFlipView setTargetDate:targetDate];
            }

            UIImage * image = [UIImage imageWithData:[dicDayInfo objectForKey:@"imagedata"]];
            if (image)
                bgImageView.image = image;
            NSString *strOriginX = [dicDayInfo objectForKey:@"counter_x"];
            NSString *strOriginY = [dicDayInfo objectForKey:@"counter_y"];
            if (strOriginX != nil && strOriginY != nil) {
                CGRect rt = flipBgImageView.frame;
                rt.origin.x = [strOriginX floatValue];
                rt.origin.y = [strOriginY floatValue];

                flipBgImageView.frame = rt;
            }
        }
    }
    
    [self setCounterAndNameFrame];
}

- (void)setCounterAndNameFrame
{
    CGRect rt = flipBgImageView.frame;
    if (IS_IPAD == YES)
    {
        [dateFlipView setFrame:CGRectMake(rt.origin.x + 22, rt.origin.y + 100, rt.size.width - 50, rt.size.height / 4 )];
        lblName.frame = CGRectMake(rt.origin.x + 10, rt.origin.y + 25, rt.size.width - 20, 48);
        
        lblDays.frame = CGRectMake(rt.origin.x + 85, rt.origin.y + 174, 72, 36);
        lblHours.frame = CGRectMake(rt.origin.x + 222, rt.origin.y + 174, 96, 36);
        lblMins.frame = CGRectMake(rt.origin.x + 334, rt.origin.y + 174, 72, 36);
        lblSecs.frame = CGRectMake(rt.origin.x + 435, rt.origin.y + 174, 72, 36);
    }
    else
    {
        [dateFlipView setFrame:CGRectMake(rt.origin.x + 5, rt.origin.y + 45, rt.size.width - 10, rt.size.height / 4 )];
        lblName.frame = CGRectMake(rt.origin.x + 10, rt.origin.y + 5, rt.size.width - 20, 35);
        
        lblDays.frame = CGRectMake(rt.origin.x + 35, rt.origin.y + 84, 45, 25);
        lblHours.frame = CGRectMake(rt.origin.x + 112, rt.origin.y + 84, 50, 25);
        lblMins.frame = CGRectMake(rt.origin.x + 170, rt.origin.y + 84, 45, 25);
        lblSecs.frame = CGRectMake(rt.origin.x + 228, rt.origin.y + 84, 45, 25);
    }
}

- (void) loadGoogleAdsFull {
    self.interstitial = [[GADInterstitial alloc] initWithAdUnitID:@"ca-app-pub-3919550248819664/1764146437"];
    self.interstitial.delegate = self;
    GADRequest *request = [GADRequest request];
    request.testDevices = @[ kGADSimulatorID ];
    [self.interstitial loadRequest:request];
}

- (void) interstitialDidReceiveAd:(GADInterstitial *)ad
{
    NSUserDefaults * settings = [NSUserDefaults standardUserDefaults];
    BOOL isLanuched = [settings boolForKey:@"launched"];
    if (!isLanuched)
    {
        [settings setBool:YES forKey:@"launched"];
        [settings synchronize];
        return;
    }
    
    if ([self.interstitial isReady]) {
        [self.interstitial presentFromRootViewController:self];
    }
}

@end
