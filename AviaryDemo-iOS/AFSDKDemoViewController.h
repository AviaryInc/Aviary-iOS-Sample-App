//
//  AFSDKDemoViewController.h
//  AviaryDemo-iOS
//
//  Created by Michael Vitrano on 1/23/13.
//  Copyright (c) 2013 Aviary. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AFSDKDemoViewController : UIViewController


@property (strong, nonatomic) IBOutlet UIButton *editSampleButton;
@property (strong, nonatomic) IBOutlet UIButton *choosePhotoButton;
@property (strong, nonatomic) IBOutlet UIImageView *backgroundImageView;
@property (strong, nonatomic) IBOutlet UIImageView *logoImageView;

- (IBAction)editSample:(id)sender;
- (IBAction)choosePhoto:(id)sender;

@end
