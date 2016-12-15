//
//  AdManager.m
//  HolidayCountdown
//
//  Created by Pasha Tunyk on 10/13/14.
//  Copyright (c) 2014 Ariel. All rights reserved.
//

#import "AdManager.h"
#import <Parse/Parse.h>

#define kDismissButton                                  @"dismissButton"
#define kApplicationId                                  @"applicationId"
#define kBannerPath                                     @"path"
#define kParseName                                      @"Banner"
#define kApplicationUrl                                 @"applicationUrl"
#define kAppId                                          @"appid"

#define kNumberOfShows                                  @"numberOfShows"

#define kRateShows                                      @"rateShows"
#define kBannerShows                                    @"bannerShows"
#define kShowPopupAfterRate                             @"ShowPopupAfterRate"

#import "UIDevice-Hardware.h"

@implementation AdManager
+ (instancetype)sharedInstace
{
    static dispatch_once_t onceQueue;
    static AdManager *adManager = nil;
    
    dispatch_once(&onceQueue, ^{
        adManager = [[self alloc] init];

    });
    return adManager;
}

+ (BOOL)canPresentAd
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    
    NSString *bannerShows = [userDefaults objectForKey:kBannerShows];

    BOOL result = NO;
    
    if (!result)
    {
        [[AdManager sharedInstace] bannerWithBlock:nil];
    }
    
    if (bannerShows)
    {
         NSLog(@"%d / %d = %d", [AdManager numberOfShows], bannerShows.intValue, [AdManager numberOfShows] % bannerShows.intValue);
        
        int koef = [AdManager numberOfShows] % bannerShows.intValue;
        
        if (!koef)
        {
            result = YES;
        }
    }
    
    return result;
}

- (void)bannerWithBlock:(void (^)(void))block
{
    PFQuery *query = [PFQuery queryWithClassName:kParseName];
    
    [query selectKeys:@[[AdManager keyForCurrentDevice], kDismissButton, kApplicationUrl, kApplicationId, kRateShows, kBannerShows, kShowPopupAfterRate]];

    NSString *bundleId = [[NSBundle mainBundle] bundleIdentifier];
    [query whereKey:kAppId equalTo:bundleId];
    
    [query getFirstObjectInBackgroundWithBlock:^(PFObject *object, NSError *error) {
        if (!error)
        {
            self.adObject = object;
            
            [[NSUserDefaults standardUserDefaults] setObject:self.adObject[kBannerShows] forKey:kBannerShows];
            [[NSUserDefaults standardUserDefaults] setObject:self.adObject[kRateShows] forKey:kRateShows];
            
            PFFile *image = (PFFile *)object[[AdManager keyForCurrentDevice]];
            NSString *documentsFolder = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
            NSString *fileName = [NSString stringWithFormat:@"%@/%@", documentsFolder, image.name];
            
            if ([[NSFileManager defaultManager] fileExistsAtPath:fileName])
            {
                if (block)
                {
                    block();
                    return;
                }
            }
            
            
            [image getDataInBackgroundWithBlock:^(NSData *data, NSError *error) {
                [data writeToFile:fileName
                       atomically:YES];
                
                [[NSUserDefaults standardUserDefaults] setObject:fileName
                                                          forKey:kBannerPath];
                
                if (block)
                {
                    block();
                }
            }];
        }
    }];
}

- (UIImage *)adImage
{
    NSString *path = [[NSUserDefaults standardUserDefaults] objectForKey:kBannerPath];
    return [UIImage imageWithContentsOfFile:path];
}

+ (NSString *)keyForCurrentDevice
{
    return [AdManager modelName];
}

+ (NSString *)modelName
{
    
    NSString *modelIdentifier = [[UIDevice currentDevice] modelIdentifier];
    
    // iPhone http://theiphonewiki.com/wiki/IPhone
    
    if ([modelIdentifier isEqualToString:@"iPhone1,1"])    return @"iphone4";
    if ([modelIdentifier isEqualToString:@"iPhone1,2"])    return @"iphone4";
    if ([modelIdentifier isEqualToString:@"iPhone2,1"])    return @"iphone4";
    if ([modelIdentifier isEqualToString:@"iPhone3,1"])    return @"iphone4";
    if ([modelIdentifier isEqualToString:@"iPhone3,2"])    return @"iphone4";
    if ([modelIdentifier isEqualToString:@"iPhone3,3"])    return @"iphone4";
    if ([modelIdentifier isEqualToString:@"iPhone4,1"])    return @"iphone4";
    if ([modelIdentifier isEqualToString:@"iPhone5,1"])    return @"iphone5";
    if ([modelIdentifier isEqualToString:@"iPhone5,2"])    return @"iphone5";
    if ([modelIdentifier isEqualToString:@"iPhone5,3"])    return @"iphone5";
    if ([modelIdentifier isEqualToString:@"iPhone5,4"])    return @"iphone5";
    if ([modelIdentifier isEqualToString:@"iPhone6,1"])    return @"iphone5";
    if ([modelIdentifier isEqualToString:@"iPhone6,2"])    return @"iphone5";
    if ([modelIdentifier isEqualToString:@"iPhone7,1"])    return @"iphone6";
    if ([modelIdentifier isEqualToString:@"iPhone7,2"])    return @"iphone6plus";
    
    // iPad http://theiphonewiki.com/wiki/IPad
    
    if ([modelIdentifier isEqualToString:@"iPad1,1"])      return @"ipad";
    if ([modelIdentifier isEqualToString:@"iPad2,1"])      return @"ipad";
    if ([modelIdentifier isEqualToString:@"iPad2,2"])      return @"ipad";
    if ([modelIdentifier isEqualToString:@"iPad2,3"])      return @"ipad";
    if ([modelIdentifier isEqualToString:@"iPad2,4"])      return @"ipad";
    if ([modelIdentifier isEqualToString:@"iPad3,1"])      return @"ipad";
    if ([modelIdentifier isEqualToString:@"iPad3,2"])      return @"ipad";
    if ([modelIdentifier isEqualToString:@"iPad3,3"])      return @"ipad";
    if ([modelIdentifier isEqualToString:@"iPad3,4"])      return @"ipad";
    if ([modelIdentifier isEqualToString:@"iPad3,5"])      return @"ipad";
    if ([modelIdentifier isEqualToString:@"iPad3,6"])      return @"ipad";
    
    if ([modelIdentifier isEqualToString:@"iPad4,1"])      return @"ipad";
    if ([modelIdentifier isEqualToString:@"iPad4,2"])      return @"ipad";
    
    // iPad Mini http://theiphonewiki.com/wiki/IPad_mini
    
    if ([modelIdentifier isEqualToString:@"iPad2,5"])      return @"ipad";
    if ([modelIdentifier isEqualToString:@"iPad2,6"])      return @"ipad";
    if ([modelIdentifier isEqualToString:@"iPad2,7"])      return @"ipad";
    if ([modelIdentifier isEqualToString:@"iPad4,4"])      return @"ipad";
    if ([modelIdentifier isEqualToString:@"iPad4,5"])      return @"ipad";
    
    // iPod http://theiphonewiki.com/wiki/IPod
    
    if ([modelIdentifier isEqualToString:@"iPod1,1"])      return @"iphone5";
    if ([modelIdentifier isEqualToString:@"iPod2,1"])      return @"iphone5";
    if ([modelIdentifier isEqualToString:@"iPod3,1"])      return @"iphone5";
    if ([modelIdentifier isEqualToString:@"iPod4,1"])      return @"iphone5";
    if ([modelIdentifier isEqualToString:@"iPod5,1"])      return @"iphone5";
    
    // Simulator
    if ([modelIdentifier hasSuffix:@"86"] || [modelIdentifier isEqual:@"x86_64"])
    {
        BOOL smallerScreen = ([[UIScreen mainScreen] bounds].size.width < 768.0);
        return (smallerScreen ? @"iphone5" : @"ipad");
    }
    
    return modelIdentifier;
}

- (CGRect)dismissButtonFrameInView:(UIView *)parentView
{
    CGRect frame;
    
    NSString *frameString = self.adObject[kDismissButton];
    NSArray *components = [frameString componentsSeparatedByString:@","];
    
    frame.origin.x = [self valueForComponent:[components[0] floatValue]
                  inParentViewComponentValue:parentView.frame.size.width];
    
    frame.origin.y = [self valueForComponent:[components[1] floatValue]
                  inParentViewComponentValue:parentView.frame.size.height];
    
    frame.size.width = [components[2] floatValue];
    frame.size.height = [components[3] floatValue];
    
    return frame;
}

- (NSString *)applicationUrl
{
    return self.adObject[kApplicationUrl];
}

- (CGFloat)valueForComponent:(CGFloat)component inParentViewComponentValue:(CGFloat )value
{
    if (component >=0)
    {
        return component;
    }
    else
    {
        return (value + component);
    }
}

- (void)didOpenBannerUrl
{
    
}

- (void)didCancelBanner
{
    
}

+ (void)didOpenApplication
{
    NSString *number = [[NSUserDefaults standardUserDefaults] objectForKey:kNumberOfShows];
    
    if (!number || !number.length)
    {
        [[NSUserDefaults standardUserDefaults] setObject:@"0" forKey:kNumberOfShows];
    }
    else
    {
        NSInteger newValue = [[[NSUserDefaults standardUserDefaults] objectForKey:kNumberOfShows] integerValue];
        newValue++;
        [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%ld", (long)newValue]
                                                  forKey:kNumberOfShows];
    }
    
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (int)numberOfShows
{
    return [[[NSUserDefaults standardUserDefaults] objectForKey:kNumberOfShows] intValue];
}

+ (BOOL) canPresentRatePopup
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    
    NSString *bannerShows = [userDefaults objectForKey:kRateShows];
    
    BOOL result = NO;
    
    if (bannerShows)
    {
        NSLog(@"%d / %d = %d", [AdManager numberOfShows], bannerShows.intValue, [AdManager numberOfShows] % bannerShows.intValue);
        
        int koef = [AdManager numberOfShows] % bannerShows.intValue;
        
        if (!koef)
        {
            result = YES;
        }
    }
    
    return result;
   
}

- (void)showRatePopup:(id)sender
{
    BOOL showPopUpAfterRate = [self.adObject[kShowPopupAfterRate] boolValue];

    if (!showPopUpAfterRate && [AdManager isUserPressedRateButton])
    {
        return;
    }
    
    
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
        [AdManager userDidPressRateButton];
    }
}

+ (void)userDidPressRateButton
{
    [[NSUserDefaults standardUserDefaults] setBool:YES
                                            forKey:kShowPopupAfterRate];
}

+ (BOOL)isUserPressedRateButton
{
    NSLog(@"%d", [[NSUserDefaults standardUserDefaults] boolForKey:kShowPopupAfterRate]);
    BOOL result = [[NSUserDefaults standardUserDefaults] boolForKey:kShowPopupAfterRate];
    return result;
}
@end
