//
//  CustomVideoRecorder.h
//  SampleCustomVideoRecording
//
//  Created by naveen on 3/25/14.
//  Copyright (c) 2014 netpace. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AMGProgressView.h"
@class CaptureManager, AVCamPreviewView, AVCaptureVideoPreviewLayer;

@interface CustomVideoRecorder : UIViewController<UIGestureRecognizerDelegate,UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>

// Camera properties.
@property (nonatomic, assign) float maxDuration;
@property (nonatomic, assign) BOOL showCameraSwitch;
@property (nonatomic, assign) float duration;
@property (nonatomic, strong) NSTimer *durationTimer;
//progressview
@property (nonatomic, strong) IBOutlet AMGProgressView *durationProgressBar;
@property (nonatomic, strong) UIProgressView *progressBar;
//hide.unhide buttons
@property (nonatomic, retain) IBOutlet UIButton * forwardButton;
@property (nonatomic, retain) IBOutlet UIButton * toggleCameraButton;
@property (nonatomic, retain) IBOutlet UIButton * backButton;
@property (nonatomic, retain) IBOutlet UIButton * cancelButton;
@property (weak, nonatomic) IBOutlet UIButton *recordButton;
//toogle camera action....
- (IBAction)switchCamera;
- (IBAction)backFromTheView:(id)sender;
@end
