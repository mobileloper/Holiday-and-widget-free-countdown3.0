//
//  AppDelegate.h
//  CountDownApp
//
//  Created by Eagle on 10/31/12.
//  Copyright (c) 2012 Ariel. All rights reserved.
//  com.guyvan.countdownapp
//  com.prosellersworlddev.holidaycountdown

#import <UIKit/UIKit.h>
#import "JBTabBarController.h"
#import "JBTabBar.h"
#import "BigDaysViewController.h"

#import <GoogleMobileAds/GoogleMobileAds.h>

#define IS_IPHONE_5 (fabs((double)[[UIScreen mainScreen] bounds].size.height - (double)568) < 50)

#define IS_IPAD [UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPad

#define IS_IOS7UP [[UIDevice currentDevice].systemVersion floatValue] >= 7.0

extern NSLocale *DEVICE_LOCALE;
extern NSLocale *ENGLISH_LOCALE;
BOOL isOnFullScreen;

@interface AppDelegate : UIResponder <UIApplicationDelegate, JBTabBarControllerDelegate, UIAlertViewDelegate, GADInterstitialDelegate>
{
    BOOL bSameViewController;
}

@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic) JBTabBarController *viewController;
@property (strong, nonatomic) NSMutableArray* imagesType0;
@property (strong, nonatomic) NSMutableArray* imagesType1;
@property (strong, nonatomic) NSMutableArray* imagesMinusType0;
@property (strong, nonatomic) NSMutableArray* imagesMinusType1;
@property (strong, nonatomic) UIAlertView *theAlertView;
@property (strong, nonatomic) UIColor *defaultTintColor;
@property (strong, nonatomic) NSString *fullScreenBannerShow;
@property (retain, nonatomic) NSString *booladmov;
@property (retain, nonatomic) NSString *badmob;

- (NSDate*)correctDate:(NSString*)dateString;
- (void)purchasePremiumVersion;

@end

#define APP_DELEGATE    ((AppDelegate*)[[UIApplication sharedApplication] delegate])