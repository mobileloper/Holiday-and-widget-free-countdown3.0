//
//  FeedbackViewController.h
//  CountDownApp
//
//  Created by Dmitri on 11/1/14.
//  Copyright (c) 2012 Ariel. All rights reserved.
//

#import "BaseViewController.h"
#import <MessageUI/MFMailComposeViewController.h>
#import <RevMobAds/RevMobAds.h>

@interface FeedbackViewController : BaseViewController <MFMailComposeViewControllerDelegate, UIAlertViewDelegate, RevMobAdsDelegate>

@property (nonatomic, strong) IBOutlet UILabel *lblFeedback;
@property (nonatomic, strong) IBOutlet UILabel *lblSupport;
@property (nonatomic, strong) IBOutlet UIButton *btnRate;
@property (nonatomic, strong) IBOutlet UIButton *btnFriends;
@property (nonatomic, strong) IBOutlet UIButton *btnReport;

@property (nonatomic, strong) IBOutlet UIView *bannerView;
@property (nonatomic, strong) RevMobBannerView *adView;

- (IBAction)onRate:(id)sender;
- (IBAction)onTellFriends:(id)sender;
- (IBAction)onReport:(id)sender;

@end
