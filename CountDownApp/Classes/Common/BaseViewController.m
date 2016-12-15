//
//  BaseViewController.m
//  CountDownApp
//
//  //  Created by Dmitri on 12/1/14.
//  Copyright (c) 2013 Ariel. All rights reserved.
//

#import "BaseViewController.h"

@interface BaseViewController ()

@end

@implementation BaseViewController

@synthesize viewContents;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 7.0)
        [self setNeedsStatusBarAppearanceUpdate];
    
    isTabBar = YES;
    
    self.view.backgroundColor = [UIColor blackColor];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    CGRect frame = viewContents.frame;
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 7.0)
    {
        frame.origin.y = 20;
        if (isTabBar == YES)
            frame.size.height = [UIScreen mainScreen].bounds.size.height - 20 - 49;
        else
            frame.size.height = [UIScreen mainScreen].bounds.size.height - 20;
    }
    else
        frame.origin.y = 0;
    
    viewContents.frame = frame;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

@end
