//
//  BigDaysViewController.h
//  CountDownApp
//
//  Created by Dmitri on 11/1/14.
//  Copyright (c) 2012 Ariel. All rights reserved.
//

#import "BaseViewController.h"
#import <RevMobAds/RevMobAds.h>

#import <GoogleMobileAds/GADInterstitial.h>


@interface BigDaysViewController : BaseViewController <UITableViewDataSource, RevMobAdsDelegate, UITableViewDelegate, GADInterstitialDelegate>{
    GADInterstitial *interstitial_;
    bool adReceived;
}

@property (nonatomic, strong) IBOutlet UITableView *daysTable;
@property (nonatomic, strong) IBOutlet UILabel *lblBigDays;

@property (nonatomic, strong) IBOutlet UIView *bannerView;
@property (nonatomic, strong) RevMobBannerView *adView;

- (IBAction)onPlus:(id)sender;

- (void)sortDataByDate;
- (NSArray*)sortArrayByDate:(NSArray*)array;

@end
