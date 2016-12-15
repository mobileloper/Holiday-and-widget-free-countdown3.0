//
//  AppDelegate.m
//  CountDownApp
//
//  Created by Eagle on 10/31/12.
//  Copyright (c) 2012 Ariel. All rights reserved.
//

#import "AppDelegate.h"
#import "BigDaysViewController.h"
#import "AddDaysViewController.h"
#import "FeedbackViewController.h"
#import "MoreAppsViewController.h"
#import "Flurry.h"
#import "PopupViewController.h"
#import "BDCommon.h"
#import <Parse/Parse.h>
#import "AdManager.h"
#import "AdsViewController.h"
#import "AdConsts.h"

#import "FacebookFacade.h"


NSLocale *DEVICE_LOCALE;
NSLocale *ENGLISH_LOCALE;

@interface AppDelegate()

@property (nonatomic, strong) GADInterstitial * interstitial;

@end

@implementation AppDelegate

@synthesize viewController;
@synthesize imagesType0;
@synthesize imagesType1;
@synthesize imagesMinusType0;
@synthesize imagesMinusType1;
@synthesize theAlertView;
@synthesize fullScreenBannerShow;
@synthesize booladmov;
@synthesize badmob;
- (NSDate*)correctDate:(NSString*)dateString
{
    NSArray *locals = [NSLocale preferredLanguages];
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"MMM dd, yyyy hh:mm a"];
    for (NSString *identifier in locals)
    {
        NSLocale *locale = [[NSLocale alloc] initWithLocaleIdentifier:identifier];
        dateFormat.locale = locale;
        NSDate *date = [dateFormat dateFromString:dateString];
        if (date)
            return date;
    }
    
    return nil;
}

- (void)purchasePremiumVersion
{
    PopupViewController *controller = [[PopupViewController alloc] init];
    [viewController presentModalViewController:controller animated:YES];
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
//    NSError *error;
//    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
//    NSString *documentsDirectory = [paths objectAtIndex:0];
//    NSString *path = [documentsDirectory stringByAppendingPathComponent:@"AdmovList.plist"];
//    NSFileManager *fileManager = [NSFileManager defaultManager];
//    if (![fileManager fileExistsAtPath:path]) {
//        NSString *bundle = [[NSBundle mainBundle] pathForResource:@"AdmovList" ofType:@"plist"];
//        [fileManager copyItemAtPath:bundle toPath:path error:&error];
//    }
//    NSMutableDictionary *savedStock = [[NSMutableDictionary alloc] initWithContentsOfFile:path];
//    
//    badmob = [savedStock objectForKey:@"boolAdmov"];
    
    fullScreenBannerShow = @"0";
    
    [Parse setApplicationId:@"0yTln2uX0LNZndQpwwAUJxRFKFbAS7N2EJEcKYBZ"
                  clientKey:@"NZXYE260omEGdOmH0hHLmhWBSPTCmIUCzBKrlPfh"];
    
    [AdManager sharedInstace];
    
    if (IS_IOS7UP)
    {
        self.defaultTintColor = [[UIView appearance] tintColor];
        [[UIView appearance] setTintColor:[UIColor blueColor]];
    }
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    
    [Flurry startSession:@"YTXBSXBZ478YRGNX97WY"];
    [Flurry setCrashReportingEnabled:YES];
    [RevMobAds startSessionWithAppID:@"51d53ced45ec2d9586000014"];
    
    NSArray *locals = [NSLocale preferredLanguages];
    NSString *identifier = [locals objectAtIndex:0];
    DEVICE_LOCALE = [[NSLocale alloc] initWithLocaleIdentifier:identifier];
    ENGLISH_LOCALE = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US"];
    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
    
    //[[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"LOCKED_ALL"];
    
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:kFULLVERSION];
    
    [self prepareOnFirstTime];
    
    //Number Images Load
    [self loadNumberImages];
    
    // Override point for customization after application launch.
    //self.window.backgroundColor = [UIColor whiteColor];
    
    JBTabBarController* tabBarController = [[JBTabBarController alloc] init];
    tabBarController.delegate = self;
    
    UINavigationController* bigDaysNavController;
    BigDaysViewController* bigDaysViewController = [[BigDaysViewController alloc] init];
    bigDaysNavController = [[UINavigationController alloc] initWithRootViewController:bigDaysViewController];
    bigDaysNavController.tabBarItem.tag = 0;
    bigDaysNavController.navigationBarHidden = YES;
    
    AddDaysViewController* addDaysViewController = [[AddDaysViewController alloc] init];
    [addDaysViewController setDayIndex:-1];
    UINavigationController* addDaysNavController = [[UINavigationController alloc] initWithRootViewController:addDaysViewController];
    addDaysNavController.tabBarItem.tag = 1;
    addDaysNavController.navigationBarHidden = YES;
    
    FeedbackViewController* feedbackViewController = [[FeedbackViewController alloc] init];
    UINavigationController* feedbackNavController = [[UINavigationController alloc] initWithRootViewController:feedbackViewController];
    feedbackNavController.tabBarItem.tag = 2;
    feedbackNavController.navigationBarHidden = YES;
    
    MoreAppsViewController* moreAppsViewController = [[MoreAppsViewController alloc] init];
    UINavigationController* moreAppsNavController = [[UINavigationController alloc] initWithRootViewController:moreAppsViewController];
    moreAppsNavController.tabBarItem.tag = 3;
    moreAppsNavController.navigationBarHidden = YES;
    bigDaysNavController.tabBarItem.title = [NSLocalizedString(@"Countdown", nil) uppercaseString];
    addDaysNavController.tabBarItem.title = [NSLocalizedString(@"Add", nil) uppercaseString];
    feedbackNavController.tabBarItem.title = [NSLocalizedString(@"Feedback", nil) uppercaseString];
    moreAppsNavController.tabBarItem.title = [NSLocalizedString(@"More", nil) uppercaseString];
    tabBarController.viewControllers = [NSMutableArray arrayWithObjects:bigDaysNavController, addDaysNavController, feedbackNavController, moreAppsNavController, nil];
    
    float height = self.window.frame.size.height;
    tabBarController.tabBar.frame = CGRectMake(0, height - 48, self.window.frame.size.width, 48);
    //NSLog(@"%@", NSStringFromCGRect(tabBarController.tabBar.frame));
    
    tabBarController.tabBar.layoutStrategy = JBTabBarLayoutStrategyBlockBased;
    tabBarController.tabBar.layoutBlock = ^(JBTab *tab, NSUInteger index, NSUInteger numberOfTabs) {
        if (index == 0)
        {
            if (IS_IPAD == YES)
                tab.frame = CGRectMake(224, 0, 80, 48);
            else
                tab.frame = CGRectMake(0, 0, 80, 48);
            [tab setImage:[UIImage imageNamed:@"bigday_normal"] selected:NO];
            [tab setImage:[UIImage imageNamed:@"bigday_selected"] selected:YES];
        }
        else if (index == 1)
        {
            if (IS_IPAD == YES)
                tab.frame = CGRectMake(304, 0, 80, 48);
            else
                tab.frame = CGRectMake(80, 0, 80, 48);
            [tab setImage:[UIImage imageNamed:@"add_normal"] selected:NO];
            [tab setImage:[UIImage imageNamed:@"add_selected"] selected:YES];
        }
        else if (index == 2)
        {
            if (IS_IPAD == YES)
                tab.frame = CGRectMake(384, 0, 80, 48);
            else
                tab.frame = CGRectMake(160, 0, 80, 48);
            [tab setImage:[UIImage imageNamed:@"feedback_normal"] selected:NO];
            [tab setImage:[UIImage imageNamed:@"feedback_selected"] selected:YES];
            [tab.superview bringSubviewToFront:tab];
        }
        else if (index == 3)
        {
            if (IS_IPAD == YES)
                tab.frame = CGRectMake(464, 0, 80, 48);
            else
                tab.frame = CGRectMake(240, 0, 80, 48);
            [tab setImage:[UIImage imageNamed:@"more_normal"] selected:NO];
            [tab setImage:[UIImage imageNamed:@"more_selected"] selected:YES];
        }
    };
    
    [tabBarController setSelectedIndex:0];
    
    self.viewController = tabBarController;
    
    UINavigationController* wrapper = [[UINavigationController alloc] initWithRootViewController: self.viewController];
    //[wrapper setNavigationBarHidden:YES animated:NO];
    self.viewController.navigationController.navigationBarHidden = YES;
    
    self.window.rootViewController = wrapper;//self.viewController;
    
    [self.window makeKeyAndVisible];
    
    [tabBarController setSelectedIndex:1];
    [tabBarController setSelectedIndex:0];
    
    UILocalNotification *localNotif = [launchOptions objectForKey:UIApplicationLaunchOptionsLocalNotificationKey];
    if (localNotif) {
        //NSLog(@"didFinishLaunchingWithOptions");
        [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
        [self setLocalNotifications];
    }
    
    //[self loadGoogleAdsFull];
    
    return YES;
}


- (void)prepareOnFirstTime
{
    NSUserDefaults *archive = [NSUserDefaults standardUserDefaults];
    NSString *strFirst = [archive objectForKey:@"firstrun"];
    if (strFirst == nil) {
        
        NSMutableDictionary *dicDayInfo = [NSMutableDictionary dictionary];
        
        //Name
        [dicDayInfo setObject:@"Weekend Paris" forKey:@"name"];
        
        //Repeat
        [dicDayInfo setObject:@"on" forKey:@"repeat"];
        [dicDayInfo setObject:@"2" forKey:@"repeatterm"];
        [dicDayInfo setObject:@"Years" forKey:@"repeatunit"];
        //[dicDayInfo setObject:@"off" forKey:@"alert"];
        
        [dicDayInfo setObject:@"1" forKey:@"alertterm0"];
        [dicDayInfo setObject:@"Months" forKey:@"alertunit0"];
        [dicDayInfo setObject:@"on" forKey:@"alertonoff0"];
        
        [dicDayInfo setObject:@"4" forKey:@"alertterm1"];
        [dicDayInfo setObject:@"Days" forKey:@"alertunit1"];
        [dicDayInfo setObject:@"on" forKey:@"alertonoff1"];
        
        [dicDayInfo setObject:@"8" forKey:@"alertterm2"];
        [dicDayInfo setObject:@"Hours" forKey:@"alertunit2"];
        [dicDayInfo setObject:@"on" forKey:@"alertonoff2"];
        
        [dicDayInfo setObject:@"10" forKey:@"alertterm3"];
        [dicDayInfo setObject:@"Mins" forKey:@"alertunit3"];
        [dicDayInfo setObject:@"on" forKey:@"alertonoff3"];
        
        [dicDayInfo setObject:@"0" forKey:@"alertterm4"];
        [dicDayInfo setObject:@"Mins" forKey:@"alertunit4"];
        [dicDayInfo setObject:@"off" forKey:@"alertonoff4"];
        
        //ImageData
        UIImage *image = [UIImage imageNamed:@"default0.jpg"];
        NSData *imageData = nil;
        if (image) {
            imageData = UIImageJPEGRepresentation(image, 0);
        }
        [dicDayInfo setObject:imageData forKey:@"imagedata"];
        
        //Target Date and Time
        NSDateComponents *comps = [[NSDateComponents alloc] init];
        [comps setDay:16];
        [comps setMonth:5];
        [comps setYear:2013];
        [comps setHour:12];
        [comps setMinute:0];
        [comps setSecond:0];
        NSDate *date = [[NSCalendar currentCalendar] dateFromComponents:comps];
        
        NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
        dateFormat.locale = ENGLISH_LOCALE;
        //dateFormat.locale = DEVICE_LOCALE;
        [dateFormat setDateFormat:@"MMM dd, yyyy"];
        [dicDayInfo setObject:[dateFormat stringFromDate:date] forKey:@"targetdate"];
        [dateFormat setDateFormat:@"hh:mm a"];
        [dicDayInfo setObject:[dateFormat stringFromDate:date] forKey:@"targettime"];
        
        [dicDayInfo setObject:date forKey:@"targetdatetime"];

        //Add new Day
        [archive setObject:@"1" forKey:@"dayscount"];
        
        NSData *data = [NSKeyedArchiver archivedDataWithRootObject:dicDayInfo];
        [archive setObject:data forKey:[NSString stringWithFormat:@"dayinfo_%d", 0]];
        
        [archive setObject:@"no" forKey:@"firstrun"];
        [archive synchronize];
        
        [self setLocalNotifications];
    }
}

- (UIImage *)imageWithImage:(UIImage *)image scaledToSize:(CGSize)newSize {
    //UIGraphicsBeginImageContext(newSize);
    UIGraphicsBeginImageContextWithOptions(newSize, NO, 0.0);
    [image drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

- (void)loadNumberImages
{
    NSMutableArray* filenames = [NSMutableArray arrayWithCapacity: 10];
	for (int i = 0; i < 10; i++) {
		[filenames addObject: [NSString stringWithFormat: @"JDFlipNumberView.bundle/%d.png", i]];
	}
	
	self.imagesType0 = [NSMutableArray arrayWithCapacity: [filenames count]*2];
    self.imagesType1 = [NSMutableArray arrayWithCapacity: [filenames count]*2];
    
	// create bottom and top images
	for (int i = 0; i < 2; i++)
	{
		for (NSString* filename in filenames)
		{
			UIImage* image	= [UIImage imageNamed: [NSString stringWithFormat: @"%@", filename]];
            
            if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
                image = [self imageWithImage:image scaledToSize:CGSizeMake(21, 42)];
            }
            else {
                image = [self imageWithImage:image scaledToSize:CGSizeMake(14, 28)];
            }
            
            CGSize size		= CGSizeMake(image.size.width, image.size.height/2);
            CGFloat yPoint	= (i==0) ? 0.0 : -size.height;
            
            if (!image) {
                //NSLog(@"DIDNT FIND IMAGE: %@", filename);
                return;
            }
            
            UIGraphicsBeginImageContextWithOptions(size, NO, [UIScreen mainScreen].scale);
            [image drawAtPoint:CGPointMake(0.0,yPoint)];
            UIImage *top = UIGraphicsGetImageFromCurrentImageContext();
            [self.imagesType0 addObject: top];
            UIGraphicsEndImageContext();
            
            
            if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
                image = [self imageWithImage:image scaledToSize:CGSizeMake(32, 64)];
            }
            else {
                image = [self imageWithImage:image scaledToSize:CGSizeMake(18, 36)];
            }
            
            size = CGSizeMake(image.size.width, image.size.height/2);
            yPoint = (i==0) ? 0.0 : -size.height;
            
            if (!image) {
                //NSLog(@"DIDNT FIND IMAGE: %@", filename);
                return;
            }
            
            UIGraphicsBeginImageContextWithOptions(size, NO, [UIScreen mainScreen].scale);
            [image drawAtPoint:CGPointMake(0.0,yPoint)];
            top = UIGraphicsGetImageFromCurrentImageContext();
            [self.imagesType1 addObject: top];
            UIGraphicsEndImageContext();
		}
	}
    
    [filenames removeAllObjects];
    filenames = [NSMutableArray arrayWithCapacity: 10];
	for (int i = 0; i < 10; i++) {
		[filenames addObject: [NSString stringWithFormat: @"JDFlipNumberView.bundle/0%d.png", i]];
	}
	
	self.imagesMinusType0 = [NSMutableArray arrayWithCapacity: [filenames count]*2];
    self.imagesMinusType1 = [NSMutableArray arrayWithCapacity: [filenames count]*2];
    
	// create bottom and top images
	for (int i = 0; i < 2; i++)
	{
		for (NSString* filename in filenames)
		{
			UIImage* image	= [UIImage imageNamed: [NSString stringWithFormat: @"%@", filename]];
            
            if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
                image = [self imageWithImage:image scaledToSize:CGSizeMake(21, 42)];
            }
            else {
                image = [self imageWithImage:image scaledToSize:CGSizeMake(14, 28)];
            }
            
            CGSize size		= CGSizeMake(image.size.width, image.size.height/2);
            CGFloat yPoint	= (i==0) ? 0.0 : -size.height;
            
            if (!image) {
                //NSLog(@"DIDNT FIND IMAGE: %@", filename);
                return;
            }
            
            UIGraphicsBeginImageContextWithOptions(size, NO, [UIScreen mainScreen].scale);
            [image drawAtPoint:CGPointMake(0.0,yPoint)];
            UIImage *top = UIGraphicsGetImageFromCurrentImageContext();
            [self.imagesMinusType0 addObject: top];
            UIGraphicsEndImageContext();
            
            
            if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
                image = [self imageWithImage:image scaledToSize:CGSizeMake(32, 64)];
            }
            else {
                image = [self imageWithImage:image scaledToSize:CGSizeMake(18, 36)];
            }
            
            size = CGSizeMake(image.size.width, image.size.height/2);
            yPoint = (i==0) ? 0.0 : -size.height;
            
            if (!image) {
                //NSLog(@"DIDNT FIND IMAGE: %@", filename);
                return;
            }
            
            UIGraphicsBeginImageContextWithOptions(size, NO, [UIScreen mainScreen].scale);
            [image drawAtPoint:CGPointMake(0.0,yPoint)];
            top = UIGraphicsGetImageFromCurrentImageContext();
            [self.imagesMinusType1 addObject: top];
            UIGraphicsEndImageContext();
		}
	}
}

- (BOOL)tabBarController:(JBTabBarController *)tabBarController shouldSelectViewController:(UIViewController *)curviewController
{
    if (curviewController == self.viewController.selectedViewController) {
        bSameViewController = YES;
    }
    else {
        bSameViewController = NO;
    }
    
    BOOL isPurchased = [[NSUserDefaults standardUserDefaults] boolForKey:kFULLVERSION];
    if (isPurchased == NO)
    {
        BOOL isNeedShow = NO;
        if ([curviewController isKindOfClass:[AddDaysViewController class]] == YES)
            isNeedShow = YES;
        else if ([curviewController isKindOfClass:[UINavigationController class]] == YES)
        {
            UINavigationController *ncontroller = (UINavigationController*)curviewController;
            if (ncontroller.tabBarItem.tag == 1)
                isNeedShow = YES;
        }
        
        if (isNeedShow == YES)
        {
            [self purchasePremiumVersion];
            
            return NO;
        }
    }
    
    return YES;
}

- (void)tabBarController:(JBTabBarController*)tabBarController didSelectViewController:(UIViewController*)curviewController
{
    if (bSameViewController) {
        [((UINavigationController*)curviewController) popToRootViewControllerAnimated:YES];
    }
}

- (void)setLocalNotifications
{
    [[UIApplication sharedApplication] cancelAllLocalNotifications];
    
    NSUserDefaults *archive = [NSUserDefaults standardUserDefaults];
    NSString *strCount = [archive objectForKey:@"dayscount"];
    int nCount = 0;
    if (strCount) {
        nCount = [strCount intValue];
    }
    if (nCount <= 0) {
        return;
    }
    
    UILocalNotification *notification;
    
    for (int i = 0; i < nCount; ++i) {
        NSData *data = [archive objectForKey:[NSString stringWithFormat:@"dayinfo_%d", i]];
        NSMutableDictionary *dayinfo = [NSKeyedUnarchiver unarchiveObjectWithData:data];
        
        NSString *strDate = [dayinfo objectForKey:@"targetdate"];
        NSString *strTime = [dayinfo objectForKey:@"targettime"];
        
        if (strDate && strTime) {
            NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
            //dateFormat.locale = DEVICE_LOCALE;
            [dateFormat setDateFormat:@"MMM dd, yyyy hh:mm a"];
            
            NSDate *date = [dateFormat dateFromString:[NSString stringWithFormat:@"%@ %@", strDate, strTime]];
            if (date == nil)
            {
                dateFormat.locale = ENGLISH_LOCALE;
                NSString *stringDate = [NSString stringWithFormat:@"%@ %@", strDate, strTime];
                date = [dateFormat dateFromString:stringDate];
                if (date == nil)
                    date = [APP_DELEGATE correctDate:stringDate];
            }
            //date = [dayinfo objectForKey:@"targetdatetime"];

            NSDate *currentDate = [NSDate date];
            
            if ([date compare:currentDate] == NSOrderedDescending) {
                NSDate *alertDate = nil;
                
                for (int j = 0; j < 5; ++j) {
                    NSString *strValue = [dayinfo objectForKey:[NSString stringWithFormat:@"alertonoff%d", j]];
                    if ([strValue isEqualToString:@"on"]) {
                        NSString *strTerm = [dayinfo objectForKey:[NSString stringWithFormat:@"alertterm%d", j]];
                        NSString *strUnit = [dayinfo objectForKey:[NSString stringWithFormat:@"alertunit%d", j]];
                        
                        NSString *strTime = [NSString stringWithFormat:@"%@ %@", strTerm, strUnit];
                        BOOL bExist = NO;
                        
                        for (int k = 0; k < j; ++k) {
                            NSString *strTermBefore = [dayinfo objectForKey:[NSString stringWithFormat:@"alertterm%d", k]];
                            NSString *strUnitBefore = [dayinfo objectForKey:[NSString stringWithFormat:@"alertunit%d", k]];
                            
                            NSString *strTimeBefore = [NSString stringWithFormat:@"%@ %@", strTermBefore, strUnitBefore];
                            
                            if ([strTime isEqualToString:strTimeBefore]) {
                                bExist = YES;
                                break;
                            }
                        }
                        
                        if (!bExist && ![strTerm isEqualToString:@"0"])
                        {
                            
                            alertDate = [self getAlertDate:date AlertTerm:strTerm AlertUnit:strUnit];
                            
                            if ([alertDate compare:currentDate] == NSOrderedDescending) {
                                notification = [UILocalNotification new];
                                notification.fireDate = alertDate;
                                notification.alertBody = [NSString stringWithFormat:@"%@ is coming in %@ %@!", [dayinfo objectForKey:@"name"], strTerm, strUnit];
                                notification.applicationIconBadgeNumber = [UIApplication sharedApplication].applicationIconBadgeNumber + 1;
                                notification.soundName = UILocalNotificationDefaultSoundName;
                                notification.alertAction = @"View";
                                notification.repeatInterval = 0;
                                
                                NSMutableDictionary *infoDict = [NSMutableDictionary dictionary];
                                [infoDict setObject:[NSString stringWithFormat:@"dayinfo_%d", i] forKey:@"dayinfo_index"];
                                [infoDict setObject:[NSString stringWithFormat:@"%d", j] forKey:@"alert_index"];
                                notification.userInfo = infoDict;
                                
                                [[UIApplication sharedApplication] scheduleLocalNotification:notification];
                            }
                            
                        }
                        
                    }
                }
                
                notification = [UILocalNotification new];
                notification.fireDate = date;
                notification.alertBody = [NSString stringWithFormat:@"%@!", [dayinfo objectForKey:@"name"]];
                notification.applicationIconBadgeNumber = [UIApplication sharedApplication].applicationIconBadgeNumber + 1;
                notification.soundName = UILocalNotificationDefaultSoundName;
                notification.hasAction = NO;
                //notification.alertAction = @"View";
                notification.repeatInterval = 0;
                
                NSMutableDictionary *infoDict = [NSMutableDictionary dictionary];
                [infoDict setObject:[NSString stringWithFormat:@"dayinfo_%d", i] forKey:@"dayinfo_index"];
                [infoDict setObject:@"-1" forKey:@"alert_index"];
                notification.userInfo = infoDict;
                
                [[UIApplication sharedApplication] scheduleLocalNotification:notification];
                
            }
            else {
                NSString *strRepeat = [dayinfo objectForKey:@"repeat"];
                if ([strRepeat isEqualToString:@"on"]) {
                    NSString *strTerm = [dayinfo objectForKey:@"repeatterm"];
                    NSString *strUnit = [dayinfo objectForKey:@"repeatunit"];
                    
                    while ([date compare:currentDate] != NSOrderedDescending) {
                        date = [self getRepeatDate:date RepeatTerm:strTerm RepeatUnit:strUnit];
                    }
                    
                    [dateFormat setDateFormat:@"MMM dd, yyyy"];
                    [dayinfo setObject:[dateFormat stringFromDate:date] forKey:@"targetdate"];
                    [dateFormat setDateFormat:@"hh:mm a"];
                    [dayinfo setObject:[dateFormat stringFromDate:date] forKey:@"targettime"];
                    
                    [dayinfo setObject:date forKey:@"targetdatetime"];


                    [archive setObject:[NSKeyedArchiver archivedDataWithRootObject:dayinfo] forKey:[NSString stringWithFormat:@"dayinfo_%d", i]];
                    [archive synchronize];
                    
                    NSDate *alertDate = nil;
                    
                    for (int j = 0; j < 5; ++j) {
                        NSString *strValue = [dayinfo objectForKey:[NSString stringWithFormat:@"alertonoff%d", j]];
                        if ([strValue isEqualToString:@"on"]) {
                            NSString *strTerm = [dayinfo objectForKey:[NSString stringWithFormat:@"alertterm%d", j]];
                            NSString *strUnit = [dayinfo objectForKey:[NSString stringWithFormat:@"alertunit%d", j]];
                            
                            NSString *strTime = [NSString stringWithFormat:@"%@ %@", strTerm, strUnit];
                            BOOL bExist = NO;
                            
                            for (int k = 0; k < j; ++k) {
                                NSString *strTermBefore = [dayinfo objectForKey:[NSString stringWithFormat:@"alertterm%d", k]];
                                NSString *strUnitBefore = [dayinfo objectForKey:[NSString stringWithFormat:@"alertunit%d", k]];
                                
                                NSString *strTimeBefore = [NSString stringWithFormat:@"%@ %@", strTermBefore, strUnitBefore];
                                
                                if ([strTime isEqualToString:strTimeBefore]) {
                                    bExist = YES;
                                    break;
                                }
                            }
                            
                            if (!bExist && ![strTerm isEqualToString:@"0"])
                            {
                                
                                alertDate = [self getAlertDate:date AlertTerm:strTerm AlertUnit:strUnit];
                                
                                if ([alertDate compare:currentDate] == NSOrderedDescending) {
                                    notification = [UILocalNotification new];
                                    notification.fireDate = alertDate;
                                    notification.alertBody = [NSString stringWithFormat:@"%@ is coming in %@ %@!", [dayinfo objectForKey:@"name"], strTerm, strUnit];
                                    notification.applicationIconBadgeNumber = [UIApplication sharedApplication].applicationIconBadgeNumber + 1;
                                    notification.soundName = UILocalNotificationDefaultSoundName;
                                    notification.alertAction = @"View";
                                    notification.repeatInterval = 0;
                                    
                                    NSMutableDictionary *infoDict = [NSMutableDictionary dictionary];
                                    [infoDict setObject:[NSString stringWithFormat:@"dayinfo_%d", i] forKey:@"dayinfo_index"];
                                    [infoDict setObject:[NSString stringWithFormat:@"%d", j] forKey:@"alert_index"];
                                    notification.userInfo = infoDict;
                                    
                                    [[UIApplication sharedApplication] scheduleLocalNotification:notification];
                                }
                                
                            }
                            
                        }
                    }
                    
                    notification = [UILocalNotification new];
                    notification.fireDate = date;
                    notification.alertBody = [NSString stringWithFormat:@"%@!", [dayinfo objectForKey:@"name"]];
                    notification.applicationIconBadgeNumber = [UIApplication sharedApplication].applicationIconBadgeNumber + 1;
                    notification.soundName = UILocalNotificationDefaultSoundName;
                    notification.hasAction = NO;
                    //notification.alertAction = @"View";
                    notification.repeatInterval = 0;
                    
                    NSMutableDictionary *infoDict = [NSMutableDictionary dictionary];
                    [infoDict setObject:[NSString stringWithFormat:@"%d", i] forKey:@"dayinfo_index"];
                    [infoDict setObject:@"-1" forKey:@"alert_index"];
                    notification.userInfo = infoDict;
                    
                    [[UIApplication sharedApplication] scheduleLocalNotification:notification];
                }
            }
            
        }
    }
}

- (NSDate *) getAlertDate:(NSDate *)targetDate AlertTerm:(NSString *)strTerm AlertUnit:(NSString *)strUnit
{
    NSDate *alertDate = nil;
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *dateComponents = [NSDateComponents new];
    
    if ([strUnit isEqualToString:@"Secs"]) {
        [dateComponents setSecond:-strTerm.intValue];
    }
    else if ([strUnit isEqualToString:@"Mins"]) {
        [dateComponents setMinute:-strTerm.intValue];
    }
    else if ([strUnit isEqualToString:@"Hours"]) {
        [dateComponents setHour:-strTerm.intValue];
    }
    else if ([strUnit isEqualToString:@"Days"]) {
        [dateComponents setDay:-strTerm.intValue];
    }
    else if ([strUnit isEqualToString:@"Months"]) {
        [dateComponents setMonth:-strTerm.intValue];
    }
    else if ([strUnit isEqualToString:@"Years"]) {
        [dateComponents setYear:-strTerm.intValue];
    }
    
    alertDate = [gregorian dateByAddingComponents:dateComponents toDate:targetDate options:0];
    
    return alertDate;
}

- (NSDate *) getRepeatDate:(NSDate *)targetDate RepeatTerm:(NSString *)strTerm RepeatUnit:(NSString *)strUnit
{
    NSDate *alertDate = nil;
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *dateComponents = [NSDateComponents new];
    
    if ([strUnit isEqualToString:@"Secs"]) {
        [dateComponents setSecond:strTerm.intValue];
    }
    else if ([strUnit isEqualToString:@"Mins"]) {
        [dateComponents setMinute:strTerm.intValue];
    }
    else if ([strUnit isEqualToString:@"Hours"]) {
        [dateComponents setHour:strTerm.intValue];
    }
    else if ([strUnit isEqualToString:@"Days"]) {
        [dateComponents setDay:strTerm.intValue];
    }
    else if ([strUnit isEqualToString:@"Months"]) {
        [dateComponents setMonth:strTerm.intValue];
    }
    else if ([strUnit isEqualToString:@"Years"]) {
        [dateComponents setYear:strTerm.intValue];
    }
    
    alertDate = [gregorian dateByAddingComponents:dateComponents toDate:targetDate options:0];
    
    return alertDate;
}

- (void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification
{
    //NSLog(@"didReceiveLocalNotification");
    
    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
    
    //NSDictionary *dic = notification.userInfo;
    if (theAlertView) {
        [theAlertView dismissWithClickedButtonIndex:1 animated:YES];
    }
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:notification.alertBody delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alert show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
    [self setLocalNotifications];
    [[NSNotificationCenter defaultCenter] postNotificationName:UIApplicationWillEnterForegroundNotification object:self];
    theAlertView = nil;
    
    if (alertView.tag == 100) {
        //NSLog(@"Notification View");
    }
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    if ([UIApplication sharedApplication].applicationIconBadgeNumber) {
        [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
        [self setLocalNotifications];
        
    }
    
    //NSLog(@"applicationWillEnterForeground");
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    [[NSNotificationCenter defaultCenter] postNotificationName:kNOTIFICATION_DIDFOREGROUND object:nil];
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    [[[FacebookFacade sharedInstance] activeSession] handleDidBecomeActive];

    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    [AdManager didOpenApplication];
    
    if ([AdManager canPresentAd])
    {
        [[AdManager sharedInstace] bannerWithBlock:^{
            [[NSNotificationCenter defaultCenter] addObserver:self
                                                     selector:@selector(didCancelBanner)
                                                         name:kCloseBannerTouchedNotification
                                                       object:nil];
            
            [[NSNotificationCenter defaultCenter] addObserver:self
                                                     selector:@selector(didTouchBanner)
                                                         name:kBannerTouchedNotification
                                                       object:nil];
            
            
            dispatch_async(dispatch_get_main_queue(), ^{
                AdsViewController *adsViewController = [[AdsViewController alloc] init];
                
                [self.window.rootViewController presentViewController:adsViewController
                                                             animated:YES
                                                           completion:^{
                                                               NSLog(@"Done");
                                                           }];
            });
        }];
    }
    
    if ([AdManager canPresentRatePopup])
    {
        [[AdManager sharedInstace] showRatePopup:nil];
    }    
}

- (void)didCancelBanner
{
    [self.window.rootViewController dismissViewControllerAnimated:YES
                                                       completion:nil];
}

- (void)didTouchBanner
{
    [self.window.rootViewController dismissViewControllerAnimated:YES
                                                       completion:nil];
    
}

- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url {
    NSLog(@"application handleOpenURL: %@",url);
    FBSession *session = [[FacebookFacade sharedInstance] activeSession];
    if (session) {
        return [session handleOpenURL:url];
    }

    return YES;
}

- (BOOL)application:(UIApplication*)application openURL:(NSURL*)url sourceApplication:(NSString*)sourceApplication annotation:(id)annotation {
    if (!url) {
        return NO;
    }
    NSLog(@"application handleOpenURL: %@",url);

    BOOL urlHandled = [[FacebookFacade sharedInstance] handleOpenURL:url andSourceApplication:sourceApplication];
    if(!urlHandled) {
        urlHandled = [[FacebookFacade sharedInstance] handleOpenURL:url];
    }

    return YES;
}

- (void)applicationWillTerminate:(UIApplication *)application {
    [[FacebookFacade sharedInstance] closeAndClearCache:YES];
}

/*
- (void) loadGoogleAdsFull {
    self.interstitial = [[GADInterstitial alloc] initWithAdUnitID:@"ca-app-pub-3919550248819664/1764146437"];
    self.interstitial.delegate = self;
    GADRequest *request = [GADRequest request];
    request.testDevices = @[ kGADSimulatorID ];
    [self.interstitial loadRequest:request];
}

- (void) interstitialDidReceiveAd:(GADInterstitial *)ad
{
    if ([self.interstitial isReady]) {
        [self.interstitial presentFromRootViewController:self.viewController];
    }
}
*/

@end
