//
//  AFPhotoEditorStyle.h
//  AviarySDK
//
//  Created by Cameron Spickert on 3/19/12.
//  Copyright (c) 2012 Aviary, Inc. All rights reserved.
//

/**
 This class is deprecated. Please use AFPhotoEditorCustomization instead. If you are transitioning from this version to the new system, please see the property descriptions below for information on which keys to use.
 */
@interface AFPhotoEditorStyle : NSObject

/**
 Deprecated.
 
 Instead, you may set this value by calling [AFPhotoEditorCustomization setOptionValue:forKey:] with the desired color as the option value and @"editor.canvasColor" as the key.
 */
@property (nonatomic, strong) UIColor *editorBackgroundColor;

/**
 Deprecated.
 
 Instead, you may set this value by calling [AFPhotoEditorCustomization setOptionValue:forKey:] with the desired color as the option value and @"editor.backgroundColor" as the key.
 */
@property (nonatomic, strong) UIColor *backgroundColor;

/**
 Deprecated.
 
 Instead, you may set this value by calling [AFPhotoEditorCustomization setOptionValue:forKey:] with the desired color as the option value and @"editor.accentColor" as the key.
 */
@property (nonatomic, strong) UIColor *accentColor;

/**
 Deprecated.
 
 Instead, you may set this value by calling [AFPhotoEditorCustomization setOptionValue:forKey:] with the desired color as the option value and @"editor.navigationBarBackgroundColor" as the key.
 */
@property (nonatomic, strong) UIColor *topBarBackgroundColor;

/**
 Deprecated.
 
 Instead, you may set this value by calling [AFPhotoEditorCustomization setOptionValue:forKey:] with the desired color as the option value and @"editor.navigationBarTextColor" as the key.
 */
@property (nonatomic, strong) UIColor *topBarTextColor;

/**
 Deprecated.
 
 Instead, you may set this value by calling [AFPhotoEditorCustomization setOptionValue:forKey:] with the desired color as the option value and @"editor.navigationBarCancelTextColor" as the key.
 */
@property (nonatomic, strong) UIColor *topBarLeftButtonTextColor;

/**
 Deprecated.
 
 Instead, you may set this value by calling [AFPhotoEditorCustomization setOptionValue:forKey:] with the desired color as the option value and @"editor.navigationBarCancelColor" as the key.
 */
@property (nonatomic, strong) UIColor *topBarLeftButtonBackgroundColor;

/**
 Deprecated.
 
 Instead, you may set this value by calling [AFPhotoEditorCustomization setOptionValue:forKey:] with the desired color as the option value and @"editor.bottomBarButtonIconColor" as the key.
 */
@property (nonatomic, strong) UIColor *buttonIconColor;

/**
 Deprecated.
 
 Instead, you may set this value by calling [AFPhotoEditorCustomization setOptionValue:forKey:] with the desired color as the option value and @"editor.bottomBarButtonTextColor" as the key.
 */
@property (nonatomic, strong) UIColor *buttonTextColor;

/**
 Deprecated.
 
 Instead, you may set this value by calling [AFPhotoEditorCustomization setOptionValue:forKey:] with the desired color as the option value and @"editor.pageControlUnselectedColor" as the key.
 */
@property (nonatomic, strong) UIColor *pageControlUnselectedColor;

@end
