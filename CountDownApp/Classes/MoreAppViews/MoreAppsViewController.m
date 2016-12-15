//
//  MoreAppsViewController.m
//  CountDownApp
//
//  Created by Dmitri on 11/1/14.
//  Copyright (c) 2012 Ariel. All rights reserved.
//

#import "MoreAppsViewController.h"
#import "MoreAppsTableCell.h"
#import "XMLMoreAppsParser.h"
#import <QuartzCore/QuartzCore.h>
#import "Flurry.h"
#import "AppDelegate.h"
#import "BDCommon.h"

@interface MoreAppsViewController ()

@end

@implementation MoreAppsViewController

@synthesize appsTableView;
@synthesize activityIndicator;
@synthesize arrayApps;
@synthesize internetReachable, isInternetActive;

@synthesize imageTableBg0;
@synthesize imageTableBg1;
@synthesize lblMoreApps;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    if (IS_IPAD == YES)
        self = [super initWithNibName:@"MoreAppsViewController_iPad" bundle:nibBundleOrNil];
    else
        self = [super initWithNibName:@"MoreAppsViewController" bundle:nibBundleOrNil];
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
    
    activityIndicator.hidden = NO;
    [activityIndicator startAnimating];
    imageTableBg0 = [UIImage imageNamed:@"more_app_tablecell_bg0.png"];
    imageTableBg1 = [UIImage imageNamed:@"more_app_tablecell_bg1.png"];
    
    self.internetReachable = [AReachability reachabilityForInternetConnection];
	[self.internetReachable startNotifier];
    
    if ([self checkNetworkStatus]) {
        [NSThread detachNewThreadSelector:@selector(actionRefresh) toTarget:self withObject:nil];
    }
    else {
        [activityIndicator stopAnimating];
        activityIndicator.hidden = YES;
    }
    
    if (IS_IPAD)
        lblMoreApps.font = TITLE_FONT_IPAD;
    else
        lblMoreApps.font = TITLE_FONT;
    lblMoreApps.text = NSLocalizedString(@"More Apps", nil);
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    isOnFullScreen = NO;
}

-(void)viewDidAppear:(BOOL)animated{
    
    APP_DELEGATE.fullScreenBannerShow = @"0";
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)actionRefresh
{
    @autoreleasepool {
        XMLMoreAppsParser *xmlparser = [[XMLMoreAppsParser alloc] init];
        self.arrayApps = xmlparser.arrayApps;
        [self performSelectorOnMainThread:@selector(actionReload) withObject:nil waitUntilDone:NO];
    }
}

- (void)actionReload
{
    [activityIndicator stopAnimating];
    activityIndicator.hidden = YES;
    [appsTableView reloadData];
}

#pragma mark -
#pragma mark UITableViewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    int nCount = 0;
    if (self.arrayApps) {
        nCount = self.arrayApps.count;
        nCount = (nCount >=1) ? nCount - 1 : nCount;
    }
    return nCount;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *CellIdentifier = [NSString stringWithFormat:@"Cell_%d_%d", indexPath.section, indexPath.row];
    
    MoreAppsTableCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        if (IS_IPAD == YES)
        {
            cell = [[[NSBundle mainBundle] loadNibNamed:@"MoreAppsTableCell_iPad" owner:nil options:nil] objectAtIndex:0];
            [cell.lblName setFont:[UIFont fontWithName:@"MyriadPro-Black" size:25]];
            [cell.lblFeature setFont:[UIFont fontWithName:@"MyriadPro-Regular" size:23]];
        }
        else
        {
            cell = [[[NSBundle mainBundle] loadNibNamed:@"MoreAppsTableCell" owner:nil options:nil] objectAtIndex:0];
            [cell.lblName setFont:[UIFont fontWithName:@"MyriadPro-Black" size:16]];
            [cell.lblFeature setFont:[UIFont fontWithName:@"MyriadPro-Regular" size:15]];
        }
        cell.imgIcon.layer.masksToBounds = YES;
        cell.imgIcon.layer.cornerRadius = 8;
        // cell.imgIcon.layer.borderWidth=1;
    }
    
    if (indexPath.row % 2) {
        [cell.imgBg setImage:imageTableBg1];
    }
    else {
        [cell.imgBg setImage:imageTableBg0];
        [cell.lblFeature setTextColor:[UIColor whiteColor]];
        [cell.lblName setTextColor:[UIColor whiteColor]];
    }
    
    NSMutableDictionary *appData = [self.arrayApps objectAtIndex:indexPath.row];
    if (appData) {
        cell.lblName.text = [appData objectForKey:@"name"];
        cell.lblFeature.text = [appData objectForKey:@"feature"];
        
        NSData *imageData = [appData objectForKey:@"imageData"];
        if (imageData) {
            cell.imgIcon.image = [UIImage imageWithData:imageData];
        }
        else {
            NSDictionary *dicParameter = [NSDictionary dictionaryWithObjectsAndKeys:cell, @"cell",
                                          [NSString stringWithFormat:@"%d", indexPath.row], @"index", nil];
            [NSThread detachNewThreadSelector:@selector(setImageToCell:) toTarget:self withObject:dicParameter];
        }
    }
    
    return cell;
}

- (UIImage *)imageWithImage:(UIImage *)image scaledToSize:(CGSize)newSize {
    //UIGraphicsBeginImageContext(newSize);
    UIGraphicsBeginImageContextWithOptions(newSize, NO, 0.0);
    [image drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

- (void)setImageToCell:(NSDictionary *)dicParameter
{
    @autoreleasepool {
        MoreAppsTableCell *cell = [dicParameter objectForKey:@"cell"];
        NSString *strIndex = [dicParameter objectForKey:@"index"];
        
        if (cell == nil || strIndex == nil) {
            return;
        }
        
        NSMutableDictionary *appData = [self.arrayApps objectAtIndex:strIndex.intValue];
        
        NSString *imageUrl = [[appData objectForKey:@"icon_link"] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        NSData *datImage = [NSData dataWithContentsOfURL:[NSURL URLWithString:imageUrl]];
        if (datImage) {
            UIImage *image = [self imageWithImage:[UIImage imageWithData:datImage] scaledToSize:CGSizeMake(140, 140)];
            
            datImage = UIImageJPEGRepresentation(image, 0);
            
            [appData setObject:datImage forKey:@"imageData"];
            [cell.imgIcon performSelectorOnMainThread:@selector(setImage:) withObject:image waitUntilDone:NO];
            //[self performSelectorOnMainThread:@selector(setImageToCell:) withObject:dicParameter waitUntilDone:NO];
        }
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	if (IS_IPAD == YES)
        return 100;
    else
        return 60;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSMutableDictionary *appData = [self.arrayApps objectAtIndex:indexPath.row];
    NSString *strLink = [appData objectForKey:@"link"];
    //NSLog(@"%@", strLink);
    
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:strLink]];
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    [Flurry logEvent:@"More Apps Select"];
}

- (BOOL)checkNetworkStatus
{
	NetworkStatus internetStatus = [self.internetReachable currentReachabilityStatus];
	switch (internetStatus) {
		case NotReachable:
			self.isInternetActive = NO;
			break;
            
		case ReachableViaWiFi:
			self.isInternetActive = YES;
			break;
            
		case ReachableViaWWAN:
			self.isInternetActive = YES;
			break;
	}
	
	if (self.isInternetActive == NO) {
		UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"" message:@"No internet available." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
		[alertView show];
        
	} else {
        // [[NSNotificationCenter defaultCenter] removeObserver:self name:kReachabilityChangedNotification object:nil];
    }
    return self.isInternetActive;
}

@end
