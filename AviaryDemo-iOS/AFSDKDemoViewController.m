//
//  AFSDKDemoViewController.m
//  AviaryDemo-iOS
//
//  Created by Michael Vitrano on 1/23/13.
//  Copyright (c) 2013 Aviary. All rights reserved.
//

#import "AFSDKDemoViewController.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import <QuartzCore/QuartzCore.h>
#import "AFPhotoEditorController.h"
#import "AFPhotoEditorCustomization.h"

#define kAFSDKDemoImageViewInset 10.0f
#define kAFSDKDemoBorderAspectRatioPortrait 3.0f/4.0f
#define kAFSDKDemoBorderAspectRatioLandscape 4.0f/3.0f

@interface AFSDKDemoViewController () < UIImagePickerControllerDelegate, UINavigationControllerDelegate, AFPhotoEditorControllerDelegate, UIPopoverControllerDelegate>

@property (strong, nonatomic) UIImageView * imagePreviewView;
@property (nonatomic, strong) UIView * borderView;
@property (nonatomic, strong) UIPopoverController * popover;
@property (nonatomic, assign) BOOL shouldReleasePopover;

@property (nonatomic, strong) ALAssetsLibrary * assetLibrary;
@property (nonatomic, strong) NSMutableArray * sessions;

@end

@implementation AFSDKDemoViewController

#pragma mark - View Controller Methods

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Allocate Asset Library
    ALAssetsLibrary * assetLibrary = [[ALAssetsLibrary alloc] init];
    [self setAssetLibrary:assetLibrary];
    
    // Allocate Sessions Array
    NSMutableArray * sessions = [NSMutableArray new];
    [self setSessions:sessions];
    
    [self setupView];
}

- (void)viewWillLayoutSubviews
{
    [self layoutImageViews];
}

#pragma mark - Photo Editor Launch Methods

- (void) launchEditorWithAsset:(ALAsset *)asset
{
    UIImage * editingResImage = [self editingResImageForAsset:asset];
    UIImage * highResImage = [self highResImageForAsset:asset];
    
    [self launchPhotoEditorWithImage:editingResImage highResolutionImage:highResImage];
}

- (void) launchEditorWithSampleImage
{
    UIImage * sampleImage = [UIImage imageNamed:@"Demo.png"];
    
    [self launchPhotoEditorWithImage:sampleImage highResolutionImage:nil];
}

#pragma mark - Photo Editor Creation and Presentation
- (void) launchPhotoEditorWithImage:(UIImage *)editingResImage highResolutionImage:(UIImage *)highResImage
{    
    // Initialize the photo editor and set its delegate
    AFPhotoEditorController * photoEditor = [[AFPhotoEditorController alloc] initWithImage:editingResImage];
    [photoEditor setDelegate:self];
    
    // Customize the editor's apperance. The customization options really only need to be set once in this case since they are never changing, so we used dispatch once here.
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [self setPhotoEditorCustomizationOptions];
    });
    
    // If a high res image is passed, create the high res context with the image and the photo editor.
    if (highResImage) {
        [self setupHighResContextForPhotoEditor:photoEditor withImage:highResImage];
    }
    
    // Present the photo editor.
    [self presentViewController:photoEditor animated:YES completion:nil];
}

- (void) setupHighResContextForPhotoEditor:(AFPhotoEditorController *)photoEditor withImage:(UIImage *)highResImage
{
    // Capture a reference to the editor's session, which internally tracks user actions on a photo.
    __block AFPhotoEditorSession *session = [photoEditor session];
    
    // Add the session to our sessions array. We need to retain the session until all contexts we create from it are finished rendering.
    [[self sessions] addObject:session];
    
    // Create a context from the session with the high res image.
    AFPhotoEditorContext *context = [session createContextWithImage:highResImage];
    
    __block AFSDKDemoViewController * blockSelf = self;
    
    // Call render on the context. The render will asynchronously apply all changes made in the session (and therefore editor)
    // to the context's image. It will not complete until some point after the session closes (i.e. the editor hits done or
    // cancel in the editor). When rendering does complete, the completion block will be called with the result image if changes
    // were made to it, or `nil` if no changes were made. In this case, we write the image to the user's photo album, and release
    // our reference to the session. 
    [context render:^(UIImage *result) {
        if (result) {
            UIImageWriteToSavedPhotosAlbum(result, nil, nil, NULL);
        }
        
        [[blockSelf sessions] removeObject:session];
        
        blockSelf = nil;
        session = nil;
        
    }];
}

#pragma Photo Editor Delegate Methods

// This is called when the user taps "Done" in the photo editor. 
- (void) photoEditor:(AFPhotoEditorController *)editor finishedWithImage:(UIImage *)image
{
    [[self imagePreviewView] setImage:image];
    [[self imagePreviewView] setContentMode:UIViewContentModeScaleAspectFit];

    [self dismissViewControllerAnimated:YES completion:nil];
}

// This is called when the user taps "Cancel" in the photo editor.
- (void) photoEditorCanceled:(AFPhotoEditorController *)editor
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - Photo Editor Customization

- (void) setPhotoEditorCustomizationOptions
{
    // Set Accent Color
    [AFPhotoEditorCustomization setOptionValue:[UIColor colorWithRed:(159.0f/255.0f) green:(105.0f/255.0f) blue:(201.0f/255.0f) alpha:1.0f] forKey:@"editor.accentColor"];
    
    // Set Tool Order
    NSArray * toolOrder = @[kAFEffects, kAFFrames, kAFStickers, kAFEnhance, kAFOrientation, kAFCrop, kAFBrightness, kAFContrast, kAFSaturation, kAFSharpness, kAFDraw, kAFText,
    kAFRedeye, kAFWhiten, kAFBlemish, kAFMeme];
    [AFPhotoEditorCustomization setOptionValue:toolOrder forKey:@"editor.toolOrder"];
    
    // Set Custom Crop Sizes
    [AFPhotoEditorCustomization setOptionValue:@NO forKey:@"editor.tool.crop.enableOriginal"];
    [AFPhotoEditorCustomization setOptionValue:@YES forKey:@"editor.tool.crop.enableCustom"];
    NSDictionary * fourBySix = @{kAFCropPresetHeight : @(4.0f), kAFCropPresetWidth : @(6.0f)};
    NSDictionary * fiveBySeven = @{kAFCropPresetHeight : @(5.0f), kAFCropPresetWidth : @(7.0f)};
    NSDictionary * square = @{kAFCropPresetName: @"Square", kAFCropPresetHeight : @(1.0f), kAFCropPresetWidth : @(1.0f)};
    [AFPhotoEditorCustomization setOptionValue:@[square, fourBySix, fiveBySeven] forKey:@"editor.tool.crop.presets"];
    
    // Set Supported Orientations
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        NSArray * supportedOrientations = @[@(UIInterfaceOrientationPortrait), @(UIInterfaceOrientationPortraitUpsideDown), @(UIInterfaceOrientationLandscapeLeft), @(UIInterfaceOrientationLandscapeRight)];
        [AFPhotoEditorCustomization setOptionValue:supportedOrientations forKey:@"editor.supportedOrientations"];
    }
}

#pragma mark - UIImagePicker Delegate

- (void) imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    NSURL * assetURL = [info objectForKey:UIImagePickerControllerReferenceURL];

    void(^completion)(void)  = ^(void){
        
        [[self assetLibrary] assetForURL:assetURL resultBlock:^(ALAsset *asset) {
            if (asset){
                [self launchEditorWithAsset:asset];
            }
        } failureBlock:^(NSError *error) {
            [[[UIAlertView alloc] initWithTitle:@"Error" message:@"Please enable access to your device's photos." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
        }];
    };
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
        [self dismissViewControllerAnimated:YES completion:completion];
    }else{
        [self dismissPopoverWithCompletion:completion];
    }
}

- (void) imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - Popover Methods

- (void) presentViewControllerInPopover:(UIViewController *)controller
{
    CGRect sourceRect = [[self choosePhotoButton] frame];
    UIPopoverController *popover = [[UIPopoverController alloc] initWithContentViewController:controller];
    [popover setDelegate:self];
    [self setPopover:popover];
    [self setShouldReleasePopover:YES];
    
    [popover presentPopoverFromRect:sourceRect inView:[self view] permittedArrowDirections:UIPopoverArrowDirectionDown animated:YES];
}

- (void) dismissPopoverWithCompletion:(void(^)(void))completion
{
    [[self popover] dismissPopoverAnimated:YES];
    [self setPopover:nil];

    NSTimeInterval delayInSeconds = 0.5;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        completion();
    });
}

- (void) popoverControllerDidDismissPopover:(UIPopoverController *)popoverController
{
    if ([self shouldReleasePopover]){
        [self setPopover:nil];
    }
    [self setShouldReleasePopover:YES];
}

#pragma mark - ALAssets Helper Methods

- (UIImage *)editingResImageForAsset:(ALAsset*)asset
{
    CGImageRef image = [[asset defaultRepresentation] fullScreenImage];
    
    return [UIImage imageWithCGImage:image scale:1.0 orientation:UIImageOrientationUp];
}

- (UIImage *)highResImageForAsset:(ALAsset*)asset
{
    ALAssetRepresentation * representation = [asset defaultRepresentation];
    
    CGImageRef image = [representation fullResolutionImage];
    UIImageOrientation orientation = [representation orientation];
    CGFloat scale = [representation scale];
    
    return [UIImage imageWithCGImage:image scale:scale orientation:orientation];
}

#pragma mark - Interface Actions

- (IBAction)editSample:(id)sender
{
    [self launchEditorWithSampleImage];
}

- (IBAction)choosePhoto:(id)sender
{
    UIImagePickerController * imagePicker = [UIImagePickerController new];
    [imagePicker setSourceType:UIImagePickerControllerSourceTypeSavedPhotosAlbum];
    [imagePicker setDelegate:self];
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
        [self presentViewController:imagePicker animated:YES completion:nil];
    }else{
        [self presentViewControllerInPopover:imagePicker];
    }
}

#pragma mark - Rotation
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
        return UIInterfaceOrientationIsPortrait(interfaceOrientation);
    }else{
        return YES;
    }
}

- (BOOL) shouldAutorotate
{
    return UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad;
}

- (void) willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
    [self setShouldReleasePopover:NO];
    [[self popover] dismissPopoverAnimated:YES];
}

- (void) didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation
{
    if ([self popover]) {
        CGRect popoverRef = [[self choosePhotoButton] frame];
        [[self popover] presentPopoverFromRect:popoverRef inView:[self view] permittedArrowDirections:UIPopoverArrowDirectionDown animated:YES];
    }
}

#pragma mark - Private Helper Methods

- (void)setupView
{
    // Set View Background Color
    UIColor * backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"background.png"]];
    [[self view] setBackgroundColor:backgroundColor];
    
    // Set Up Image View and Border
    UIView * borderView = [UIView new];
    UIColor * borderColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"border.png"]];
    [borderView setBackgroundColor:borderColor];
    
    CALayer * borderLayer = [borderView layer];
    [borderLayer setCornerRadius:10.0f];
    [borderLayer setBorderColor:[[UIColor blackColor] CGColor]];
    [borderLayer setBorderWidth:2.0f];
    [borderLayer setMasksToBounds:YES];
    [self setBorderView:borderView];
    [[self view] addSubview:borderView];
    
    UIImageView * previewView = [UIImageView new];
    [previewView setContentMode:UIViewContentModeCenter];
    [previewView setImage:[UIImage imageNamed:@"splash.png"]];
    [borderView addSubview:previewView];
    [self setImagePreviewView:previewView];
    
    // Customize UI Components
    UIImage * blueButton = [[UIImage imageNamed:@"blue_button.png"] stretchableImageWithLeftCapWidth:7.0f topCapHeight:0.0f];
    UIImage * blueButtonActive = [[UIImage imageNamed:@"blue_button_pressed.png"] stretchableImageWithLeftCapWidth:7.0f topCapHeight:0.0f];
    [[self choosePhotoButton] setBackgroundImage:blueButton forState:UIControlStateNormal];
    [[self choosePhotoButton] setBackgroundImage:blueButtonActive forState:UIControlStateHighlighted];
    
    UIImage * darkButton = [[UIImage imageNamed:@"dark_button.png"] stretchableImageWithLeftCapWidth:7.0f topCapHeight:0.0f];
    UIImage * darkButtonActive = [[UIImage imageNamed:@"dark_button_pressed.png"] stretchableImageWithLeftCapWidth:7.0f topCapHeight:0.0f];
    [[self editSampleButton] setBackgroundImage:darkButton forState:UIControlStateNormal];
    [[self editSampleButton] setBackgroundImage:darkButtonActive forState:UIControlStateHighlighted];
}

- (void) layoutImageViews
{
    CGRect bounds = [[self view] bounds];
    CGRect logoFrame = [[self logoImageView] frame];
    CGRect choosePhotoFrame = [[self choosePhotoButton] frame];
    
    CGFloat aspectRatio = UIInterfaceOrientationIsPortrait([[UIApplication sharedApplication] statusBarOrientation]) ? kAFSDKDemoBorderAspectRatioPortrait : kAFSDKDemoBorderAspectRatioLandscape;
    CGFloat height = CGRectGetMinY(choosePhotoFrame) - CGRectGetMaxY(logoFrame) - 2.0f * kAFSDKDemoImageViewInset;
    CGFloat width = aspectRatio * height;
    CGRect imageFrame = CGRectMake((CGRectGetWidth(bounds) - width) / 2.0, CGRectGetMaxY(logoFrame) + kAFSDKDemoImageViewInset, width, height);
    
    [[self borderView] setFrame:imageFrame];
    
    CGRect borderBounds = [[self borderView] bounds];
    [[self imagePreviewView] setFrame:CGRectInset(borderBounds, 10.0f, 10.0f)];
}

@end
