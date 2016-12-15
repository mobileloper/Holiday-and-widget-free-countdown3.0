//
//  ImageSelectViewController.m
//  CountDownApp
//
//  Created by Eagle on 11/14/12.
//  Copyright (c) 2012 Ariel. All rights reserved.
//

#import "ImageSelectViewController.h"
#import "AppDelegate.h"
#import "DefaultImageViewController.h"
#import "PurchaseManager.h"
#import "PurchaseViewController.h"
#import "PurchaseImageViewController.h"
#import "BDCommon.h"

@interface ImageSelectViewController ()

@end

@implementation ImageSelectViewController

@synthesize addViewController;
@synthesize originalImageData;
@synthesize scrIAPContents;
@synthesize lblTitle;

@synthesize btnBack;
@synthesize btnDone;
@synthesize btnDefault;
@synthesize btnPhotoAlbums;
@synthesize btnCamera;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    if (IS_IPAD == YES)
        self = [super initWithNibName:@"ImageSelectViewController_iPad" bundle:nibBundleOrNil];
    else
        self = [super initWithNibName:@"ImageSelectViewController" bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self.navigationController setNavigationBarHidden:YES animated:NO];
    originalImageData = [addViewController.dicDayInfo objectForKey:@"imagedata"];
    [self configIAPUI];
    
    lblTitle.text = NSLocalizedString(@"Images", nil);
    [btnBack setTitle:NSLocalizedString(@"Back", nil) forState:UIControlStateNormal];
    btnBack.contentVerticalAlignment = UIControlContentVerticalAlignmentTop;
    [btnDone setTitle:NSLocalizedString(@"Done", nil) forState:UIControlStateNormal];
    btnDone.contentVerticalAlignment = UIControlContentVerticalAlignmentTop;
    [btnDefault setTitle:NSLocalizedString(@"Default Images", nil) forState:UIControlStateNormal];
    btnDefault.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [btnPhotoAlbums setTitle:NSLocalizedString(@"Photo Albums", nil) forState:UIControlStateNormal];
    btnPhotoAlbums.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [btnCamera setTitle:NSLocalizedString(@"Camera", nil) forState:UIControlStateNormal];
    btnCamera.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    
    if (IS_IPAD)
    {
        lblTitle.font = TITLE_FONT_IPAD;
        
        btnBack.titleLabel.font = SMALL_BUTTON_FONT_IPAD;
        btnBack.titleEdgeInsets = UIEdgeInsetsMake(8.5, 10.0, 0, 0);
        
        btnDone.titleLabel.font = SMALL_BUTTON_FONT_IPAD;
        btnDone.titleEdgeInsets = UIEdgeInsetsMake(9, 3, 0, 0);
        
        btnDefault.titleLabel.font = MIDDLE_BUTTON_FONT_IPAD;
        btnDefault.titleEdgeInsets = UIEdgeInsetsMake(12, 25, 0, 0);
        
        btnPhotoAlbums.titleLabel.font = MIDDLE_BUTTON_FONT_IPAD;
        btnPhotoAlbums.titleEdgeInsets = UIEdgeInsetsMake(12, 25, 0, 0);
        
        btnCamera.titleLabel.font = MIDDLE_BUTTON_FONT_IPAD;
        btnCamera.titleEdgeInsets = UIEdgeInsetsMake(12, 25, 0, 0);
    }
    else
    {
        lblTitle.font = TITLE_FONT;
        
        btnBack.titleLabel.font = SMALL_BUTTON_FONT;
        btnBack.titleEdgeInsets = UIEdgeInsetsMake(9.5, 8, 0, 0);
        
        btnDone.titleLabel.font = SMALL_BUTTON_FONT;
        btnDone.titleEdgeInsets = UIEdgeInsetsMake(9.5, 2, 0, 0);
        
        btnDefault.titleLabel.font = MIDDLE_BUTTON_FONT;
        btnDefault.titleEdgeInsets = UIEdgeInsetsMake(9, 8, 0, 0);
        
        btnPhotoAlbums.titleLabel.font = MIDDLE_BUTTON_FONT;
        btnPhotoAlbums.titleEdgeInsets = UIEdgeInsetsMake(8, 8, 0, 0);
        
        btnCamera.titleLabel.font = MIDDLE_BUTTON_FONT;
        btnCamera.titleEdgeInsets = UIEdgeInsetsMake(8, 8, 0, 0);
    }
    
    isTabBar = NO;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)configIAPUI
{
    int size = 75, offset = 50;
    if (IS_IPAD == YES)
    {
        size = 161;
        offset = 100;
    }
    NSMutableArray *arrayIPAItems = [PurchaseManager sharedInstance].arrayPurchase;
    for (int i = 0; i < arrayIPAItems.count; i++) {
        int row = i / 4;
        int col = i % 4;
        NSMutableDictionary *item = [arrayIPAItems objectAtIndex:i];
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setBackgroundImage:[UIImage imageNamed:[item objectForKey:@"image"]] forState:UIControlStateNormal];
        button.tag = i;
        [button setFrame:CGRectMake(col * size, row * size, size, size)];
        [button addTarget:self action:@selector(onPurchaseImage:) forControlEvents:UIControlEventTouchUpInside];
        [scrIAPContents addSubview:button];
        
        UILabel *label = (UILabel*)[scrIAPContents viewWithTag:i + 100];
        label.text = [item objectForKey:@"title"];
    }
    
    for (int i = 0; i < arrayIPAItems.count; i++) {
        int row = i / 4;
        int col = i % 4;
        NSMutableDictionary *item = [arrayIPAItems objectAtIndex:i];
        UILabel *label = (UILabel*)[scrIAPContents viewWithTag:i + 100];
        label.text = NSLocalizedString([item objectForKey:@"title"], nil);
        label.text = [label.text uppercaseString];
        [label setFrame:CGRectMake(col * size, row * size + offset, size, size - offset)];
        label.font = [UIFont fontWithName:FONT_SEMIBOLD size:9.0];
        if (IS_IPAD == YES)
            label.font = [UIFont fontWithName:FONT_SEMIBOLD size:19.0];
        [scrIAPContents bringSubviewToFront:label];
    }
}

- (IBAction)onPurchaseImage:(id)sender
{
    UIButton *button = (UIButton*)sender;
    NSMutableArray *arrayPurchase = [PurchaseManager sharedInstance].arrayPurchase;
    NSMutableDictionary *item = [arrayPurchase objectAtIndex:button.tag];
    BOOL isPurchased = [[item objectForKey:@"purchase"] boolValue];
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    
    if ([userDefault boolForKey:@"LOCKED_ALL"] || isPurchased == YES)
    {
        PurchaseImageViewController *viewController = [[PurchaseImageViewController alloc] init];
        viewController.addViewController = self.addViewController;
        viewController.purchaseIndex = button.tag;
        [APP_DELEGATE.viewController.navigationController pushViewController:viewController animated:YES];
        return;
    }
    PurchaseViewController *viewController = [[PurchaseViewController alloc] init];
    viewController.purchaseIndex = button.tag;
    [APP_DELEGATE.viewController.navigationController pushViewController:viewController animated:YES];
}

- (IBAction)onDefaultImages:(id)sender
{
    DefaultImageViewController *viewController = [DefaultImageViewController new];
    viewController.addViewController = self.addViewController;
    [APP_DELEGATE.viewController.navigationController pushViewController:viewController animated:YES];
}

- (IBAction)onPhotoAlbums:(id)sender
{
    if (IS_IOS7UP)
        [[UIView appearance] setTintColor:APP_DELEGATE.defaultTintColor];
    
    UIImagePickerController* pController = [[UIImagePickerController alloc] init];
	pController.delegate = self;
	pController.allowsEditing = NO;
	pController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    
    if (IS_IPAD == YES)
    {
        popoverController = [[UIPopoverController alloc] initWithContentViewController:pController];
        [popoverController presentPopoverFromRect:btnPhotoAlbums.frame
                                           inView:self.view
                         permittedArrowDirections:UIPopoverArrowDirectionAny
                                         animated:YES];
    }
    else
        [self presentModalViewController: pController animated: YES];
}

- (IBAction)onCamera:(id)sender
{
    if (IS_IOS7UP)
        [[UIView appearance] setTintColor:APP_DELEGATE.defaultTintColor];
    
    UIImagePickerController* pController = [[UIImagePickerController alloc] init];
	pController.delegate = self;
	pController.allowsEditing = YES;
	pController.sourceType = UIImagePickerControllerSourceTypeCamera;
	[self presentModalViewController: pController animated: YES];
}

- (IBAction)onBack:(id)sender
{
    [addViewController.dicDayInfo setObject:originalImageData forKey:@"imagedata"];
    [APP_DELEGATE.viewController.navigationController popViewControllerAnimated:YES];
}

- (IBAction)onDone:(id)sender
{
    [APP_DELEGATE.viewController.navigationController popViewControllerAnimated:YES];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    if (IS_IOS7UP)
        [[UIView appearance] setTintColor:[UIColor whiteColor]];
    
	UIImage* image = [info objectForKey: UIImagePickerControllerOriginalImage];
    NSData *imageData = UIImageJPEGRepresentation(image, 1.0);
    
    [addViewController.dicDayInfo setObject:imageData forKey:@"imagedata"];
    
	[picker dismissModalViewControllerAnimated:YES];
    [popoverController dismissPopoverAnimated:YES];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
	// Dismiss the image selection and close the program
    if (IS_IOS7UP)
        [[UIView appearance] setTintColor:[UIColor whiteColor]];
    
	[picker dismissModalViewControllerAnimated:YES];
}

- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
}

@end
