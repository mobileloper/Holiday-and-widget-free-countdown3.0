//
//  PurchaseImageViewController.m
//  CountDownApp
//
//  Created by Felton on 4/5/13.
//  Copyright (c) 2013 Ariel. All rights reserved.
//

#import "PurchaseImageViewController.h"
#import "PurchaseManager.h"
#import "BDCommon.h"
#import "AppDelegate.h"
#import "DeviceUtility.h"

@interface PurchaseImageViewController ()

@end

@implementation PurchaseImageViewController

@synthesize lblTitle;
@synthesize scrImages;
@synthesize addViewController;
@synthesize purchaseIndex;
@synthesize btnBack;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    if (IS_IPAD == YES)
        self = [super initWithNibName:@"PurchaseImageViewController_iPad" bundle:nibBundleOrNil];
    else
        self = [super initWithNibName:@"PurchaseImageViewController" bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self configButtons];
    
    NSMutableArray *arrayPurchase = [PurchaseManager sharedInstance].arrayPurchase;
    NSMutableDictionary *item = [arrayPurchase objectAtIndex:purchaseIndex];
    lblTitle.text = NSLocalizedString([item objectForKey:@"title"], nil);
    [btnBack setTitle:NSLocalizedString(@"Back", nil) forState:UIControlStateNormal];
    btnBack.contentVerticalAlignment = UIControlContentVerticalAlignmentTop;
    
    if (IS_IPAD == YES)
    {
        lblTitle.font = TITLE_FONT_IPAD;
        btnBack.titleLabel.font = SMALL_BUTTON_FONT_IPAD;
        btnBack.titleEdgeInsets = UIEdgeInsetsMake(8.5, 10.0, 0, 0);
    }
    else
    {
        lblTitle.font = TITLE_FONT;
        btnBack.titleLabel.font = SMALL_BUTTON_FONT;
        btnBack.titleEdgeInsets = UIEdgeInsetsMake(9.0, 8.0, 0, 0);
    }
    
    isTabBar = NO;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UIImage *)imageForIndex:(NSString *)index imagePrefix:(NSString *)imagePrefix thumb:(BOOL)isThumb
{
    NSString *deviceName = [DeviceUtility modelName];
    NSString *thumbPart = isThumb ? @"Thumb":@"Full";
    NSString *extension = isThumb ? @"png":@"jpg";
    
    
    if (isThumb)
    {
        deviceName = @"iPhone4";
    }
    
    if (!isThumb && [imagePrefix isEqualToString:@"Holidays"] && [deviceName isEqualToString:@"iPhone4"])
    {
        deviceName = @"iPhone5";
    }
    
    NSString *fileName = [NSString stringWithFormat:@"%@ %@-%@-%@.%@", imagePrefix, deviceName, thumbPart, index, extension];
    
    UIImage *image = [UIImage imageNamed:fileName];
    return image;
}

- (void)configButtons
{
    NSMutableDictionary *item = [[PurchaseManager sharedInstance].arrayPurchase objectAtIndex:purchaseIndex];
    NSString *imagePrefix = [item objectForKey:@"title"];
    for (int i = 0; i < 32; i++) {
        /*
        UIButton *button = (UIButton*)[self.view viewWithTag:i + 100];
        if ([button isKindOfClass:[UIButton class]] == NO)
            continue;
        */
        
        int row = i % 4, col = i / 4;
        UIImageView *imageBG = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bgimageiap.png"]];
        if (IS_IPAD == YES)
            imageBG.frame = CGRectMake(-3 + row * (158 + 22), col * (200 + 17), 164, 205);
        else
            imageBG.frame = CGRectMake(-3 + row * 79, col * 100, 80, 100);
        [scrImages addSubview:imageBG];
        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        if (IS_IPAD == YES)
            button.frame = CGRectMake(row * (158 + 22), col * (200 + 17), 158, 200);
        else
            button.frame = CGRectMake(0 + row * 79, 2 + col * 100, 74, 95);
        button.tag = i + 100;
        [button addTarget:self action:@selector(onSelectImage:) forControlEvents:UIControlEventTouchUpInside];
        [scrImages addSubview:button];
        
        NSString *index = [NSString stringWithFormat:@"%d", i + 1];
        if (i < 9)
            index = [NSString stringWithFormat:@"0%d", i + 1];

        UIImage *image;
        image = [self imageForIndex:index imagePrefix:imagePrefix thumb:YES];
        
        [button setBackgroundImage:image forState:UIControlStateNormal];
    }
    
    if (IS_IPAD == YES)
        scrImages.contentSize = CGSizeMake(0, 8 * (200 + 17));
    else
        scrImages.contentSize = CGSizeMake(312, 8 * 100);
}

- (IBAction)onBack:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)onSelectImage:(UIButton *)sender
{
    NSMutableDictionary *item = [[PurchaseManager sharedInstance].arrayPurchase objectAtIndex:purchaseIndex];
    NSString *imagePrefix = [item objectForKey:@"title"];
    NSString *index = [NSString stringWithFormat:@"%d", (int)(sender.tag - 100 + 1)];
    UIImage *image = [self imageForIndex:index imagePrefix:imagePrefix thumb:NO];
    
    NSData *imageData = nil;
    
    if (image)
    {
        imageData = UIImageJPEGRepresentation(image, 0);
    }
    
    [addViewController.dicDayInfo setObject:imageData forKey:@"imagedata"];
    [self.navigationController popViewControllerAnimated:YES];
}

@end
