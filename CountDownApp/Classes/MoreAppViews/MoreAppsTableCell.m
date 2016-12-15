//
//  MoreAppsTableCell.m
//  CountDownApp
//
//  Created by Eagle on 11/30/12.
//  Copyright (c) 2012 Ariel. All rights reserved.
//

#import "MoreAppsTableCell.h"

@implementation MoreAppsTableCell

@synthesize imgBg;
@synthesize imgIcon;
@synthesize lblFeature;
@synthesize lblName;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
