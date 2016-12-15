//
//  BigDaysViewController.m
//  CountDownApp
//
//  Created by Dmitri on 11/1/14.
//  Copyright (c) 2012 Ariel. All rights reserved.
//

#import "BigDaysViewController.h"
#import "AppDelegate.h"
#import "BigDaysTableCell.h"
#import "BigDaysDetailsViewController.h"
#import "BDCommon.h"

@interface BigDaysViewController ()

@end

@implementation BigDaysViewController

@synthesize daysTable;
@synthesize lblBigDays;

@synthesize bannerView;
@synthesize adView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    if (IS_IPAD == YES)
        self = [super initWithNibName:@"BigDaysViewController_iPad" bundle:nibBundleOrNil];
    else
        self = [super initWithNibName:@"BigDaysViewController" bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return [super preferredStatusBarStyle];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 7.0)
        [self setNeedsStatusBarAppearanceUpdate];
    
    [self.navigationController setNavigationBarHidden:YES animated:NO];
    
    lblBigDays.text = NSLocalizedString(@"Countdowns", nil);
    if (IS_IPAD == YES)
        lblBigDays.font = [UIFont fontWithName:FONT_BOLD size:38.0];
    else
        lblBigDays.font = [UIFont fontWithName:FONT_BOLD size:30.0];
    
    if ([[NSUserDefaults standardUserDefaults] boolForKey:kFULLVERSION] == NO)
    {
        self.adView = [[RevMobAds session] bannerView];
        adView.delegate = self;
        [adView loadAd];
    }
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(hideRevmobAds) name:kNOTIFICATION_FULLVERSION object:nil];
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];

}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewDidAppear:(BOOL)animated{

    if (([interstitial_ isReady] == YES) && ([APP_DELEGATE.fullScreenBannerShow isEqualToString:@"1"])) {
        [interstitial_ presentFromRootViewController:self];
        APP_DELEGATE.fullScreenBannerShow = @"0";
    }else{
        
        interstitial_ = [[GADInterstitial alloc] initWithAdUnitID:@"ca-app-pub-3919550248819664/1764146437"];
        interstitial_.delegate = self;

        GADRequest *request = [GADRequest request];
        request.testDevices = @[ kGADSimulatorID ];
        [interstitial_ loadRequest:request];
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    APP_DELEGATE.viewController.tabBar.alpha = 1.0;
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationSlide];
    
    [super viewWillAppear:animated];
    
    [self sortDataByDate];
    
    [daysTable reloadData];
    
    isOnFullScreen = NO;
    
    [self hideRevmobAds];
}

//- (void)viewWillLayoutSubviews
//{
//    [super viewWillLayoutSubviews];
//    
//    if (IS_IOS7UP)
//    {
//        CGRect frame = self.view.frame;
//        frame.origin.y = 20;
//        self.view.frame = frame;
//    }
//}
//
//- (void)viewDidAppear:(BOOL)animated
//{
//    [super viewDidAppear:animated];
//    
//    if (IS_IOS7UP)
//    {
//        CGRect frame = self.view.frame;
//        frame.origin.y = 20;
//        self.view.frame = frame;
//    }
//}

- (void)hideRevmobAds
{
    if ([[NSUserDefaults standardUserDefaults] boolForKey:kFULLVERSION])
        bannerView.hidden = YES;
}

- (void)doViewWillAppear: (NSNotification *)notif
{
    [self sortDataByDate];
    
    [daysTable reloadData];
}

- (IBAction)onPlus:(id)sender
{
    BOOL isPurchased = [[NSUserDefaults standardUserDefaults] boolForKey:kFULLVERSION];
    if (isPurchased == NO)
    {
        [APP_DELEGATE purchasePremiumVersion];
        
        return;
    }
    
    [APP_DELEGATE.viewController setSelectedIndex:1];
}

- (void)sortDataByDate
{
    NSUserDefaults *archive = [NSUserDefaults standardUserDefaults];
    NSString *strCount = [archive objectForKey:@"dayscount"];
    int nCount = 0;
    if (strCount) {
        nCount = [strCount intValue];
    }
    
    NSMutableArray *bigdays = [NSMutableArray array];
    for (int i = 0; i < nCount; i++)
    {
        NSString *key = [NSString stringWithFormat:@"dayinfo_%d", i];
        NSData *data = [archive objectForKey:key];
        [bigdays addObject:data];
        [archive removeObjectForKey:key];
    }
    
    NSArray *sortBigDays = [self sortArrayByDate:bigdays];
    for (int i = 0; i < nCount; i++)
    {
        NSString *key = [NSString stringWithFormat:@"dayinfo_%d", i];
        [archive setObject:[sortBigDays objectAtIndex:i] forKey:key];
    }
}

- (NSArray*)sortArrayByDate:(NSArray*)array
{
    NSComparisonResult (^sortBlock)(id,id) = ^(id obj1, id obj2){
        NSMutableDictionary *dict1 = [NSKeyedUnarchiver unarchiveObjectWithData:obj1];
        NSMutableDictionary *dict2 = [NSKeyedUnarchiver unarchiveObjectWithData:obj2];
        
        NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
        [dateFormat setDateFormat:@"MMM dd, yyyy hh:mm a"];
        
        NSString *strDate1 = [dict1 objectForKey:@"targetdate"];
        NSString *strTime1 = [dict1 objectForKey:@"targettime"];
        
        NSDate *date1 = [dateFormat dateFromString:[NSString stringWithFormat:@"%@ %@", strDate1, strTime1]];
        
        NSString *strDate2 = [dict2 objectForKey:@"targetdate"];
        NSString *strTime2 = [dict2 objectForKey:@"targettime"];
        
        NSDate *date2 = [dateFormat dateFromString:[NSString stringWithFormat:@"%@ %@", strDate2, strTime2]];
        
        if (date1 == nil)
        {
            dateFormat.locale = ENGLISH_LOCALE;
            NSString *dateString = [NSString stringWithFormat:@"%@ %@", strDate1, strTime1];
            date1 = [dateFormat dateFromString:dateString];
            if (date1 == nil)
                date1 = [APP_DELEGATE correctDate:dateString];
        }
        
        if (date2 == nil)
        {
            dateFormat.locale = ENGLISH_LOCALE;
            NSString *dateString = [NSString stringWithFormat:@"%@ %@", strDate2, strTime2];
            date2 = [dateFormat dateFromString:dateString];
            if (date2 == nil)
                date2 = [APP_DELEGATE correctDate:dateString];
        }
        
        return [date1 compare:date2];
    };
    
    NSArray *sortArray = (NSArray*)[array sortedArrayUsingComparator:sortBlock];
    return sortArray;
}

- (UIImage *)imageWithImage:(UIImage *)image scaledToSize:(CGSize)newSize {
    //UIGraphicsBeginImageContext(newSize);
    UIGraphicsBeginImageContextWithOptions(newSize, NO, 0.0);
    [image drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

#pragma mark -
#pragma mark UITableViewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSUserDefaults *archive = [NSUserDefaults standardUserDefaults];
    NSString *strCount = [archive objectForKey:@"dayscount"];
    int nCount = 0;
    if (strCount) {
        nCount = [strCount intValue];
    }
    return nCount;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *CellIdentifier = [NSString stringWithFormat:@"Cell_%d_%d", indexPath.section, indexPath.row];
    
    BigDaysTableCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        if (IS_IPAD)
            cell = [[[NSBundle mainBundle] loadNibNamed:@"BigDaysTableCell_iPad" owner:nil options:nil] objectAtIndex:0];
        else
            cell = [[[NSBundle mainBundle] loadNibNamed:@"BigDaysTableCell" owner:nil options:nil] objectAtIndex:0];
        [cell initFlipView];
    }
    
    if (IS_IPAD == YES)
    {
        if (indexPath.row % 2) {
            [cell.bgImageView setImage:[UIImage imageNamed:@"daystablecell_bg1_ipad.png"]];
        }
        else {
            [cell.bgImageView setImage:[UIImage imageNamed:@"daystablecell_bg1_ipad.png"]];
        }
    }
    else
    {
        if (indexPath.row % 2) {
            [cell.bgImageView setImage:[UIImage imageNamed:@"daystablecell_bg1.png"]];
        }
        else {
            [cell.bgImageView setImage:[UIImage imageNamed:@"daystablecell_bg1.png"]];
        }
    }
    
    NSUserDefaults *archive = [NSUserDefaults standardUserDefaults];
    NSData *data = [archive objectForKey:[NSString stringWithFormat:@"dayinfo_%d", indexPath.row]];
    if (data) {
        NSMutableDictionary *dayinfo = [NSKeyedUnarchiver unarchiveObjectWithData:data];
        if (dayinfo) {
            cell.titleLabel.text = [dayinfo objectForKey:@"name"];
            
            NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
            
            NSString *strDate = [dayinfo objectForKey:@"targetdate"];
            NSString *strTime = [dayinfo objectForKey:@"targettime"];
            
            [dateFormat setDateFormat:@"MMM dd, yyyy hh:mm a"];
            
            NSDate *date = [dateFormat dateFromString:[NSString stringWithFormat:@"%@ %@", strDate, strTime]];
            NSLocale *currentLocale = dateFormat.locale;
            if (date == nil)
            {
                dateFormat.locale = ENGLISH_LOCALE;
                NSString *stringDate = [NSString stringWithFormat:@"%@ %@", strDate, strTime];
                date = [dateFormat dateFromString:stringDate];
                if (date == nil)
                    date = [APP_DELEGATE correctDate:stringDate];
            }
            
            [cell.flipView setTargetDate:date];
            
            [dateFormat setDateStyle:NSDateFormatterMediumStyle];
            [dateFormat setDateFormat:@"MMM dd, yyyy"];
            //dateFormat.locale = DEVICE_LOCALE;
            dateFormat.locale = currentLocale;
            cell.dateLabel.text = [dateFormat stringFromDate:date];
            
            UIImage * image = [UIImage imageWithData:[dayinfo objectForKey:@"imagedata"]];
            if (image) {
                float fWidth = image.size.width;
                float fHeight = image.size.height;
                if (fWidth > fHeight) {
                    fWidth = 60 * fWidth / fHeight;
                    fHeight = 60;
                }
                else {
                    fHeight = 60 * fHeight / fWidth;
                    fWidth = 60;
                }
                cell.thumbImageView.image = [self imageWithImage:image scaledToSize:CGSizeMake(fWidth, fHeight)];
            }
            else {
                cell.thumbImageView.image = nil;
            }
        }
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    BigDaysDetailsViewController *viewController = [[BigDaysDetailsViewController alloc] init];
    [viewController setDayIndex:indexPath.row];
    [self.navigationController pushViewController:viewController animated:YES];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
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
