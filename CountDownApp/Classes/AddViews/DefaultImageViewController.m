//
//  DefaultImageViewController.m
//  CountDownApp
//
//  Created by Eagle on 11/15/12.
//  Copyright (c) 2012 Ariel. All rights reserved.
//

#import "DefaultImageViewController.h"
#import "BDCommon.h"

@interface DefaultImageViewController ()

@end

@implementation DefaultImageViewController

@synthesize addViewController;
@synthesize lblImage;
@synthesize btnBack;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    if ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPad)
        self = [super initWithNibName:@"DefaultImageViewController_iPad" bundle:nibBundleOrNil];
    else
        self = [super initWithNibName:@"DefaultImageViewController" bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    if ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPad)
    {
        lblImage.font = TITLE_FONT_IPAD;
        
        btnBack.contentVerticalAlignment = UIControlContentVerticalAlignmentTop;
        btnBack.titleLabel.font = SMALL_BUTTON_FONT_IPAD;
        btnBack.titleEdgeInsets = UIEdgeInsetsMake(8.5, 10.0, 0, 0);
    }
    else
    {
        lblImage.font = TITLE_FONT;
        
        btnBack.titleLabel.font = SMALL_BUTTON_FONT;
        btnBack.contentVerticalAlignment = UIControlContentVerticalAlignmentTop;
        btnBack.titleEdgeInsets = UIEdgeInsetsMake(9.5, 8, 0, 0);
    }
    
    lblImage.text = NSLocalizedString(@"Images", nil);
    [btnBack setTitle:NSLocalizedString(@"Back", nil) forState:UIControlStateNormal];
    
    isTabBar = NO;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)onSelectImage:(UIButton *)sender
{
    NSString *strImageName = [NSString stringWithFormat:@"default%d.jpg", sender.tag];
    UIImage *image = [UIImage imageNamed:strImageName];
    NSData *imageData = nil;
    if (image) {
        imageData = UIImageJPEGRepresentation(image, 0);
    }
    [addViewController.dicDayInfo setObject:imageData forKey:@"imagedata"];
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)onBack:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

@end
