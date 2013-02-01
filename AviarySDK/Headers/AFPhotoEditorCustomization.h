//
//  AFOption.h
//  AFOptions
//
//  Created by Michael Vitrano on 9/5/12.
//  Copyright (c) 2012 Aviary. All rights reserved.
//

/** @defgroup AFPhotoEditorControllerOptions AFPhotoEditorController Option Dictionary Keys */

/** @addtogroup AFPhotoEditorControllerOptions
 @{
 */

/**
 This key allows developers to customize the visibility of, and order in which
 tools appear in the SDK interface. A valid value for this key is a NSArray
 containing NSString instances whose values match the constants below.
 */
extern NSString *const kAFPhotoEditorControllerToolsKey;

extern NSString *const kAFEnhance;     /* Enhance */
extern NSString *const kAFEffects;     /* Effects */
extern NSString *const kAFStickers;    /* Stickers */
extern NSString *const kAFOrientation; /* Orientation */
extern NSString *const kAFCrop;        /* Crop */
extern NSString *const kAFBrightness;  /* Brightness */
extern NSString *const kAFContrast;    /* Contrast */
extern NSString *const kAFSaturation;  /* Saturation */
extern NSString *const kAFSharpness;   /* Sharpness */
extern NSString *const kAFDraw;        /* Draw */
extern NSString *const kAFText;        /* Text */
extern NSString *const kAFRedeye;      /* Redeye */
extern NSString *const kAFWhiten;      /* Whiten */
extern NSString *const kAFBlemish;     /* Blemish */
extern NSString *const kAFMeme;        /* Meme */
extern NSString *const kAFFrames;       /* Frames */

/**
 Use this key to define the interface orientations you want to allow in
 `-shouldAutorotateToInterfaceOrientation`. The value for this key should be
 a NSArray of NSNumber objects wrapping UIInterfaceOrientation values. For
 example, if you only want to support the portrait orientation, set the
 following value for this key: `[NSArray arrayWithObject:[NSNumber
 numberWithUnsignedInt:UIInterfaceOrientationPortrait]]`.
 */
extern NSString *const kAFPhotoEditorControllerSupportedOrientationsKey;

/**
 Use this key to define the background color for the photo editor (behind the
 image being edited). The value for this key should be a UIColor object. Any
 color space supported by UIKit should work, including patterns created with
 `+colorWithPatternImage:`. Use `[UIColor clearColor]` to make the background
 transparent.
 */
extern NSString *const kAFPhotoEditorControllerBackgroundColorKey;

extern NSString *const kAFLeftNavigationTitlePresetCancel; /* Cancel */
extern NSString *const kAFLeftNavigationTitlePresetBack;   /* Back */
extern NSString *const kAFLeftNavigationTitlePresetExit;   /* Exit */

extern NSString *const kAFRightNavigationTitlePresetDone;  /* Done */
extern NSString *const kAFRightNavigationTitlePresetSave;  /* Save */
extern NSString *const kAFRightNavigationTitlePresetNext;  /* Next */

extern NSString *const kAFCropPresetName;   /* Name */
extern NSString *const kAFCropPresetWidth;  /* Width */
extern NSString *const kAFCropPresetHeight; /* Height */

extern NSString *const kAFTextBorderColors; /* Text Tool Text Border Colors */
extern NSString *const kAFTextFillColors;   /* Text Tool Text Fill Colors */

/** @} */


/**
 This class provides a powerful interface for configuring an AFPhotoEditorController's appearance. While setting and removing option values after presenting an AFPhotoEditorController instance is possible, it is strongly recommended that you make all necessary calls to AFPhotoEditorCustomization *before* editor presentation. For a full list of keys and a more detailed explanation, please see the Aviary iOS SDK Customization Guide.
 */
@interface AFPhotoEditorCustomization : NSObject

/**
 Sets the value for key to obj.
 
 @param obj The object.
 @param key The key whose value should be set.
 */
+ (void)setOptionValue:(id)obj forKey:(NSString *)key;

/**
 Sets the value for key to the object returned by block.
 
 The block is lazily evaluated, making it useful for specifying options with values that require loading information from disk.
  
 @param block The block that returns the object that key will be set to.
 @param key The key whose value should be set.
 */
+ (void)setOptionValueWithBlock:(id (^)(void))block forKey:(NSString *)key;

/**
 Sets the value for key to the UIImage named name. 
 
 A convenience method that lazily sets the value of the key to the image with the name provided. This method uses UIImage's imageNamed: class method to create the image. Thus, if the image doesn't exist, the value for key will be set to nil.
 
 @param name The name of the image.
 @param key The key whose value should be set.
 */
+ (void)setOptionWithImageNamed:(NSString *)name forKey:(NSString *)key;

/**
 Removes the value for a given key.
 
 The view elements described by the key will be assume their default appearances.
 
 @param key The key whose value should be removed.
 */
+ (void)removeOptionValueForKey:(NSString *)key;

@end
