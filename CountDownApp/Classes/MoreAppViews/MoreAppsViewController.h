//
//  MoreAppsViewController.h
//  CountDownApp
//
//  Created by Dmitri on 11/1/14.
//  Copyright (c) 2012 Ariel. All rights reserved.
//

#import "BaseViewController.h"
#import "AReachability.h"

@interface MoreAppsViewController : BaseViewController <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) IBOutlet UITableView *appsTableView;
@property (nonatomic, strong) IBOutlet UIActivityIndicatorView *activityIndicator;
@property (nonatomic, strong) IBOutlet UILabel *lblMoreApps;

@property (nonatomic, strong) NSMutableArray *arrayApps;

@property (strong, nonatomic) AReachability *internetReachable;
@property (nonatomic) BOOL isInternetActive;

@property (nonatomic, strong) UIImage *imageTableBg0;
@property (nonatomic, strong) UIImage *imageTableBg1;

- (BOOL) checkNetworkStatus;

@end
