//
//  MoreAppsTableCell.h
//  CountDownApp
//
//  Created by Eagle on 11/30/12.
//  Copyright (c) 2012 Ariel. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MoreAppsTableCell : UITableViewCell

@property (nonatomic, strong) IBOutlet UIImageView *imgBg;
@property (nonatomic, strong) IBOutlet UIImageView *imgIcon;
@property (nonatomic, strong) IBOutlet UILabel *lblName;
@property (nonatomic, strong) IBOutlet UILabel *lblFeature;

@end
