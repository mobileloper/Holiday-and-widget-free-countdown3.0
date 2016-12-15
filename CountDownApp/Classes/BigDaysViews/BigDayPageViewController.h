//
//  BigDayPageViewController.h
//  CountDownApp
//
//  Created by Administrator on 6/21/13.
//  Copyright (c) 2013 Ariel. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JDDateCountdownFlipView.h"
#import "AppDelegate.h"
#import <GoogleMobileAds/GoogleMobileAds.h>

@interface BigDayPageViewController : UIViewController<GADBannerViewDelegate, GADInterstitialDelegate>

@property (nonatomic, strong) IBOutlet UIImageView *bgImageView;
@property (nonatomic, strong) IBOutlet UIImageView *flipBgImageView;
@property (nonatomic, strong) IBOutlet UILabel *lblName;
@property (nonatomic, strong) IBOutlet UILabel *lblDays;
@property (nonatomic, strong) IBOutlet UILabel *lblHours;
@property (nonatomic, strong) IBOutlet UILabel *lblMins;
@property (nonatomic, strong) IBOutlet UILabel *lblSecs;

@property (nonatomic, strong) JDDateCountdownFlipView *dateFlipView;
@property (nonatomic, assign) NSInteger nDayIndex;
@property (nonatomic, strong) NSMutableDictionary *dicDayInfo;
@property (nonatomic, strong) NSDate *targetDate;

- (void)initFlipView;

@end
