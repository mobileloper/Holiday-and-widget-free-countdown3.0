//
//  AdsViewController.m
//  HolidayCountdown
//
//  Created by Pasha Tunyk on 10/13/14.
//  Copyright (c) 2014 Ariel. All rights reserved.
//

#import "AdsViewController.h"
#import "AdConsts.h"
#import "AdManager.h"

@interface AdsViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *bannerView;
@property (weak, nonatomic) UIButton *closeButton;
@end

@implementation AdsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.bannerView.image = [UIImage imageWithContentsOfFile:[[NSUserDefaults standardUserDefaults] objectForKey:@"path"]];
    
    [[UIApplication sharedApplication] setStatusBarHidden:YES
                                            withAnimation:UIStatusBarAnimationFade];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    self.closeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.closeButton.frame = [[AdManager sharedInstace] dismissButtonFrameInView:self.view];
    [self.closeButton addTarget:self
                         action:@selector(closeButtonPressed)
               forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:self.closeButton];

}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [[UIApplication sharedApplication] setStatusBarHidden:NO
                                            withAnimation:UIStatusBarAnimationFade];
}

- (IBAction)bannerPressed:(id)sender
{
    [[NSNotificationCenter defaultCenter] postNotificationName:kBannerTouchedNotification
                                                        object:nil];
    
    NSURL *url = [NSURL URLWithString:[[AdManager sharedInstace] applicationUrl]];
    [[UIApplication sharedApplication] openURL:url];
}

- (void)closeButtonPressed
{
    [[NSNotificationCenter defaultCenter] postNotificationName:kCloseBannerTouchedNotification
                                                        object:nil];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
