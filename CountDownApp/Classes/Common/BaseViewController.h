//
//  BaseViewController.h
//  CountDownApp
//
//  //  Created by Dmitri on 12/1/14.
//  Copyright (c) 2013 Ariel. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BaseViewController : UIViewController
{
    BOOL isTabBar;
}

@property (nonatomic, retain) IBOutlet UIView *viewContents;

@end
