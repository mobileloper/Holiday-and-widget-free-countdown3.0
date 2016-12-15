//
//  AdManager.h
//  HolidayCountdown
//
//  Created by Pasha Tunyk on 10/13/14.
//  Copyright (c) 2014 Ariel. All rights reserved.
//

#import <Foundation/Foundation.h>
@class PFObject;

@interface AdManager : NSObject
@property (nonatomic, strong) PFObject *adObject;

+ (instancetype)sharedInstace;
+ (BOOL)canPresentAd;

- (void)bannerWithBlock:(void (^)(void))block;

- (UIImage *)adImage;
- (CGRect)dismissButtonFrameInView:(UIView *)parentView;
- (NSString *)applicationUrl;

- (void)didOpenBannerUrl;
- (void)didCancelBanner;

+ (void)didOpenApplication;
- (void)showRatePopup:(id)sender;
+ (BOOL) canPresentRatePopup;
+ (void)userDidPressRateButton;
@end