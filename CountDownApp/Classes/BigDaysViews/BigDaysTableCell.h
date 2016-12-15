//
//  BigDaysTableCell.h
//  CountDownApp
//
//  Created by Eagle on 11/2/12.
//  Copyright (c) 2012 Ariel. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JDDateCountdownFlipView.h"

@interface BigDaysTableCell : UITableViewCell

@property (nonatomic, strong) IBOutlet UILabel *titleLabel;
@property (nonatomic, strong) IBOutlet UILabel *dateLabel;
@property (nonatomic, strong) IBOutlet UIImageView *thumbImageView;
@property (nonatomic, strong) IBOutlet UIImageView *bgImageView;
@property (nonatomic, strong) JDDateCountdownFlipView *flipView;

@property (nonatomic, strong) IBOutlet UILabel *lblDays;
@property (nonatomic, strong) IBOutlet UILabel *lblHours;
@property (nonatomic, strong) IBOutlet UILabel *lblMins;
@property (nonatomic, strong) IBOutlet UILabel *lblSecs;

- (void) initFlipView;

@end
