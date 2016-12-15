//
//  ImageSelectViewController.h
//  CountDownApp
//
//  Created by Eagle on 11/14/12.
//  Copyright (c) 2012 Ariel. All rights reserved.
//

#import "BaseViewController.h"
#import "AddDaysViewController.h"

@interface ImageSelectViewController : BaseViewController <UINavigationControllerDelegate, UIImagePickerControllerDelegate>
{
    UIPopoverController * popoverController;
}

@property (nonatomic, strong) IBOutlet UIScrollView *scrIAPContents;
@property (nonatomic, strong) AddDaysViewController *addViewController;
@property (nonatomic, strong) NSData *originalImageData;

@property (nonatomic, strong) IBOutlet UILabel *lblTitle;
@property (nonatomic, strong) IBOutlet UIButton *btnBack;
@property (nonatomic, strong) IBOutlet UIButton *btnDone;
@property (nonatomic, strong) IBOutlet UIButton *btnDefault;
@property (nonatomic, strong) IBOutlet UIButton *btnPhotoAlbums;
@property (nonatomic, strong) IBOutlet UIButton *btnCamera;

- (IBAction)onDefaultImages:(id)sender;
- (IBAction)onPhotoAlbums:(id)sender;
- (IBAction)onCamera:(id)sender;
- (IBAction)onBack:(id)sender;
- (IBAction)onDone:(id)sender;

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info;
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker;

@end
