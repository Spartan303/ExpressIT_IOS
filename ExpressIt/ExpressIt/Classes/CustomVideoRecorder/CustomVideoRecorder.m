//
//  CustomVideoRecorder.m
//  SampleCustomVideoRecording
//
//  Created by naveen on 3/25/14.
//  Copyright (c) 2014 netpace. All rights reserved.
//

#import "CustomVideoRecorder.h"
#import "CaptureManager.h"
#import "AVCamRecorder.h"
#import <AVFoundation/AVFoundation.h>
#import "AMGProgressView.h"
#import "CustomVideoRecorder.h"
#import "EditRecordedViewController.h"
#import <MobileCoreServices/MobileCoreServices.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import <AVFoundation/AVFoundation.h>
#import "UploadVideoViewController.h"
#import "DiskCache.h"
#import "SaveVideoSession.h"

static void *AVCamFocusModeObserverContext = &AVCamFocusModeObserverContext;

@interface CustomVideoRecorder ()
@property (nonatomic, strong) CaptureManager *captureManager;
@property (nonatomic, strong) IBOutlet UIView *videoPreviewView;
@property (nonatomic, strong) AVCaptureVideoPreviewLayer *captureVideoPreviewLayer;
@end

@interface CustomVideoRecorder (CaptureManagerDelegate) <CaptureManagerDelegate>
@end
@implementation CustomVideoRecorder
@synthesize forwardButton;
@synthesize toggleCameraButton;
@synthesize backButton;
@synthesize cancelButton;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
//Sets the capturemanager delegate to the self for backward navigation...
- (void)viewWillAppear:(BOOL)animated {
    self.captureManager.delegate = self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    /********
     Sets the video duration....
     *******/
    _maxDuration = VIDEO_MAXIMUMDURATION;
    /********
    Make the norifcation observer....
     *******/
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(receiveTestNotification:)
                                                 name:@"RefreshNotification"
                                                   object:nil];
    /********
     Initialize the capture manager
     *******/
    CaptureManager *manager = [[CaptureManager alloc] init];
    [self setCaptureManager:manager];
    /********
     Sets the capture manager delegate...
     *******/
    [[self captureManager] setDelegate:self];
    /********
    Checks the capture video session..
     *******/
     if ([[self captureManager] setupSession]) {
        /********
         Video preview layer and apply to the UI   
         *******/
        AVCaptureVideoPreviewLayer *newCaptureVideoPreviewLayer =
        [[AVCaptureVideoPreviewLayer alloc]
         initWithSession:[[self captureManager]
                          session]];
        /********
         make the video layer
         *******/
        CALayer *viewLayer = self.videoPreviewView.layer;
        [viewLayer setMasksToBounds:YES];
        /********
         video bounds
         *******/
        CGRect bounds = self.videoPreviewView.bounds;
        [newCaptureVideoPreviewLayer setFrame:bounds];
        /********
         Checks the Orientation        
         *******/
        if ([newCaptureVideoPreviewLayer.connection isVideoOrientationSupported]) {
            [newCaptureVideoPreviewLayer.connection
             setVideoOrientation:AVCaptureVideoOrientationPortrait];
        }
        /********
        Sets the video capture layer
         *******/
        [newCaptureVideoPreviewLayer setVideoGravity:AVLayerVideoGravityResizeAspectFill];
        
        [viewLayer insertSublayer:newCaptureVideoPreviewLayer
                            below:[[viewLayer sublayers]
                                   objectAtIndex:0]];
        [self setCaptureVideoPreviewLayer:newCaptureVideoPreviewLayer];
        /********
            Start the session. 
         This is done asychronously since -startRunning doesn't return until the session is running.
         *******/
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            [[[self captureManager] session] startRunning];
        });
        /********
         Start the session.
         sets the progress bar properties
         *******/
//        self.durationProgressBar.gradientColors =
//                                    @[[UIColor colorWithRed:0.1f green:0.7f blue:0.1f alpha:1.0f],
//                                     [UIColor colorWithRed:0.6f green:0.9f blue:0.6f alpha:1.0f]];
         self.durationProgressBar.gradientColors =
         @[[UIColor darkGrayColor],
           [UIColor darkGrayColor]];
        [self.view addSubview:self.durationProgressBar];
        // Create the focus mode UI overlay
//        UILabel *newFocusModeLabel = [[UILabel alloc]
//                                      initWithFrame:
//                                      CGRectMake(10, 10, viewLayer.bounds.size.width - 20, 20)];
//         
//        [newFocusModeLabel setBackgroundColor:[UIColor clearColor]];
//        [newFocusModeLabel setTextColor:[UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:0.50]];
//        AVCaptureFocusMode initialFocusMode = [[[self.captureManager videoInput] device] focusMode];
//        [newFocusModeLabel setText:
//                              [NSString
//                               stringWithFormat:@"focus: %@",
//                               [self stringForFocusMode:initialFocusMode]]];
//        [self.videoPreviewView addSubview:newFocusModeLabel];
//        [self addObserver:self
//               forKeyPath:@"captureManager.videoInput.device.focusMode"
//                  options:NSKeyValueObservingOptionNew
//                   context:AVCamFocusModeObserverContext];
//         cancelButton.hidden = YES;
  //      [self setFocusModeLabel:newFocusModeLabel];
     }
}
/********
 Observe the focus mode variable
*******/
- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary *)change
                       context:(void *)context
{
    if (context == AVCamFocusModeObserverContext) {
        // Update the focus UI overlay string when the focus mode changes
//		[self.focusModeLabel setText:[NSString stringWithFormat:@"focus: %@",
//                                      [self stringForFocusMode:
//                                       (AVCaptureFocusMode)[[change objectForKey:NSKeyValueChangeNewKey]
//                                                   integerValue]]]];
	} else {
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}
#pragma mark
/********
Recording will begins while hold the finger.....
 *******/
- (IBAction)startRecording:(UILongPressGestureRecognizer*)recognizer {
    switch (recognizer.state)
    {
        case UIGestureRecognizerStateBegan:
        {
            NSLog(@"START");
            if (![[[self captureManager] recorder] isRecording]) {
                if (self.duration < self.maxDuration) {
                    [[self captureManager] startRecording];
                }
            }
            break;
        }
        case UIGestureRecognizerStateEnded:
        {
            if ([[[self captureManager] recorder] isRecording]) {
                [self.durationTimer invalidate];
                [[self captureManager] stopRecording];
                NSLog(@"END number of pieces %lu", (unsigned long)[self.captureManager.assets count]);
            }
            break;
        }
        default:
            break;
    }
}

/********
  Recording while touch down....
 *******/
- (IBAction)recordTouchDown:(id)sender {
    NSLog(@"START");
    self.cancelButton.hidden = NO;
    self.toggleCameraButton.hidden = YES;
    self.backButton.hidden = YES;
    self.durationProgressBar.hidden = NO;
    self.captureManager.delegate = self;
    if (![[[self captureManager] recorder] isRecording]) {
        if (self.duration < self.maxDuration) {
            [[self captureManager] startRecording];
        }
    }
}
/********
 Recording touch cancel
 *******/
- (IBAction)recordTouchCancel:(id)sender {
    if ([[[self captureManager] recorder] isRecording]) {
        [self.durationTimer invalidate];
        [[self captureManager] stopRecording];
        //  self.videoPreviewView.layer.borderColor = [UIColor clearColor].CGColor;
        NSLog(@"END number of pieces %lu", (unsigned long)[self.captureManager.assets count]);
    }
}
/********
 Recording TouchUpinside and Outside
 *******/
- (IBAction)recordTouchUp:(id)sender {
    if ([[[self captureManager] recorder] isRecording]) {
        [self.durationTimer invalidate];
        [[self captureManager] stopRecording];
        //  self.videoPreviewView.layer.borderColor = [UIColor clearColor].CGColor;
        NSLog(@"END number of pieces %lu", (unsigned long)[self.captureManager.assets count]);
    }
}
/********
 Update the string focus mode...
 *******/

- (NSString *)stringForFocusMode:(AVCaptureFocusMode)focusMode {
	NSString *focusString = @"";
	switch (focusMode) {
		case AVCaptureFocusModeLocked:
			focusString = @"locked";
			break;
		case AVCaptureFocusModeAutoFocus:
			focusString = @"auto";
			break;
		case AVCaptureFocusModeContinuousAutoFocus:
			focusString = @"continuous";
			break;
	}
	return focusString;
}

/********
 Remove the capture observer..
 *******/
//- (void)dealloc {
//    [self removeObserver:self forKeyPath:@"captureManager.videoInput.device.focusMode"];
//}
/********
 ProgressView Indication...
 *******/
- (void) updateDuration {
    /********
     Set the duration for hide/unhide the forward button
     *******/
    if (self.duration>VIDEO_MINIMUMDURATION) {
        self.forwardButton.hidden = NO;
    } else {
        self.forwardButton.hidden = YES;
    }
    /********
     Continous recording based on the time duration...
     .
     *******/
    if ([[[self captureManager] recorder] isRecording]) {
        self.duration = self.duration + 0.1;
        self.durationProgressBar.progress = self.duration/self.maxDuration;
        NSLog(@"self.duration %f, self.progressBar %f", self.duration, self.durationProgressBar.progress);
        /********
         Recording upto limit reaches
         *******/
        if (self.durationProgressBar.progress > .99) {
            [self.durationTimer invalidate];
            self.durationTimer = nil;
            [[self captureManager] stopRecording];
            self.forwardButton.hidden = YES;
            UIActivityIndicatorView * activity = [[UIActivityIndicatorView alloc]
                                                  initWithFrame:CGRectMake(290, 28, 25, 25)];
            [self.view addSubview:activity];
            [activity startAnimating];
            [self performSelector:@selector(goToEditView:)
                       withObject:activity afterDelay:0.8];
        }
    } else {
        /********
        Invalidate the timer if maximum limit reaches
         *******/
        [self.durationTimer invalidate];
        self.durationTimer = nil;
    }
}

/********
   Show the edit view controller after maximum limit reahces.
 *******/
- (void)goToEditView:(UIActivityIndicatorView *)activity {
    
    [activity stopAnimating];
    self.forwardButton.hidden = NO;
    [self editController];
    //[self performSelector:@selector(editController:) withObject:activity afterDelay:0.3];
}
//Common action for gesture as well as the button object.....
- (IBAction)editController {
    EditRecordedViewController * editVc = [[EditRecordedViewController alloc]initWithNibName:@"EditRecordedViewController" bundle:[NSBundle mainBundle]];
    [self.navigationController pushViewController:editVc animated:NO];
    editVc.captureManager = self.captureManager;
}
// Remove the time duartion which helps while editing the video...
- (void) removeTimeFromDuration:(float)removeTime;
{
    self.duration = self.duration - removeTime;
    self.durationProgressBar.progress = self.duration/self.maxDuration;
}
/********
 Show the alert view for cancel,Discard and save for later sessions.
 *******/
- (IBAction)removeTheVideoFromSession:(id)sender
{
    UIActionSheet * actionSheet = [[UIActionSheet alloc]
                                   initWithTitle:@"Save this session for later"
                                   delegate:self cancelButtonTitle:@"Cancel"
                                   destructiveButtonTitle:@"Discard"
                                   otherButtonTitles:@"Save for later",
                                   nil];
    [actionSheet showInView:self.view];
}

#pragma mark - UIActionSheet Delegate Method
// the delegate method to receive notifications is exactly the same as the one for UIActionSheet
- (void)actionSheet:(UIActionSheet *)actionSheet
        clickedButtonAtIndex:(NSInteger)buttonIndex {
    NSLog(@"Button at index: %ld clicked\nIt's title is '%@'",
          (long)buttonIndex, [actionSheet buttonTitleAtIndex:buttonIndex]);
    if ([[actionSheet buttonTitleAtIndex:buttonIndex] isEqualToString:@"Discard"]) {
        [self.captureManager removeCompleteSession];
        [self refresh];
    }
    else if ([[actionSheet buttonTitleAtIndex:buttonIndex] isEqualToString:@"Save for later"]) {
        
        //TODO
//        NSString * fileDirectoryNamepath = [NSString stringWithFormat:@"%@//Library/Caches/sessionVideosCache",NSHomeDirectory()];
//
//        NSMutableArray *diskArray = [DiskCache cachedData:fileDirectoryNamepath];
//        if (diskArray.count >= 10) {
//            [diskArray removeObjectAtIndex:0];
//        }
//        SaveVideoSession * saveVideoSession = [[SaveVideoSession alloc]initWithArray:self.captureManager.assets durationTime:self.durationTimer durationProgressTime:self.durationProgressBar.progress];
//        [diskArray addObject:saveVideoSession];
//        NSMutableArray * array = [[NSMutableArray alloc]initWithObjects:diskArray, nil];
//        [DiskCache writeToFile:array filePath:fileDirectoryNamepath override:YES];
    }
  
    else {
        //TODO
    }
}
//Refresh the controller...
-(void)refresh {
   // self.progressView.hidden = YES;
    self.toggleCameraButton.hidden = NO;
    self.backButton.hidden = NO;
    self.forwardButton.hidden = YES;
    self.duration = 0.0;
    self.durationProgressBar.progress = 0.0;
    [self.durationTimer invalidate];
    self.durationTimer = nil;
}
#pragma pragma------- capture manager delegates---
/********
 Exception raises while recording then show the alert...
 *******/
- (void)captureManager:(CaptureManager *)captureManager
       idFailWithError:(NSError *)error {
    CFRunLoopPerformBlock(CFRunLoopGetMain(), kCFRunLoopCommonModes, ^(void) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:[error localizedDescription]
                                                            message:[error localizedFailureReason]
                                                           delegate:nil
                                                  cancelButtonTitle:NSLocalizedString(@"OK", @"OK button title")
                                                  otherButtonTitles:nil];
        [alertView show];
    });
}

/********
 Capture starts
 *******/
- (void)captureManagerRecordingBegan:(CaptureManager *)captureManager {
     self.durationTimer = [NSTimer scheduledTimerWithTimeInterval:0.1
                                                           target:self
                                                         selector:@selector(updateDuration)
                                                         userInfo:nil
                                                          repeats:YES];
}
- (void)captureManagerRecordingFinished:(CaptureManager *)captureManager {
    NSLog(@"finished recording...");
    //TODO
}
- (void)captureManagerDeviceConfigurationChanged:(CaptureManager *)captureManager {
    NSLog(@"Device Configuration Changed...");
    //TODO
}
- (void) captureManagerStillImageCaptured:(CaptureManager *)captureManager {
    NSLog(@"image has captured");
    //TODO
}
/********
 Capture the photo while recording the video....
 *******/
- (IBAction)captureStillImage:(id)sender {
    /*call the method stillimage for take the pictuer while recording...
     */
    [[self captureManager] captureStillImage];
    /********
     Create the flash animation for take the picture
     *******/
    UIView *flashView = [[UIView alloc] initWithFrame:[[self videoPreviewView] frame]];
    [flashView setBackgroundColor:[UIColor whiteColor]];
    [[[self view] window] addSubview:flashView];
    [UIView animateWithDuration:.4f
                     animations:^{
                         [flashView setAlpha:0.f];
                     }
                     completion:^(BOOL finished){
                         [flashView removeFromSuperview];
                     }
     ];
}
/********
  switch the camera....
 *******/
- (IBAction)switchCamera {
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDuration:0.75];
    [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromLeft forView:self.videoPreviewView cache:YES];
    [UIView commitAnimations];
    [self.captureManager switchCamera];
}
/********
 Receives the notifications from the editcontroller after saving the video...
 *******/
- (void) receiveTestNotification:(NSNotification *) notification {
    self.captureManager.delegate = self;
    if ([[notification name] isEqualToString:@"RefreshNotification"])
        self.forwardButton.hidden = YES;
        [self refresh];
}

- (IBAction)backFromTheView:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)chooseVideoFromGallery:(id)sender {
    UIImagePickerController *mediaPicker = [[UIImagePickerController alloc] init];
    mediaPicker.delegate = self;
    
    mediaPicker.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
    mediaPicker.mediaTypes =[[NSArray alloc] initWithObjects: (NSString *)kUTTypeMovie,(NSString *)kUTTypeVideo,nil];
    mediaPicker.videoMaximumDuration = VIDEO_MAXIMUMDURATION;
    [self presentViewController:mediaPicker animated:YES completion:nil];
}

#pragma mark -  Picker delegate methods

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    //NSString *type = [info objectForKey:UIImagePickerControllerMediaType];
    [picker.presentingViewController dismissViewControllerAnimated:YES completion:nil];

       UploadVideoViewController * uploadVideoVc = [[UploadVideoViewController alloc]initWithNibName:@"UploadVideoViewController" bundle:[NSBundle mainBundle]];
        NSURL *videoURL = [info objectForKey:UIImagePickerControllerMediaURL];
        NSString *urlString=[videoURL path];
        uploadVideoVc.strFilePath = urlString;
        //Creation of the thumbnail......
        AVAsset *  asset = [AVAsset assetWithURL:videoURL];
        AVAssetImageGenerator *imageGenerator = [[AVAssetImageGenerator alloc]initWithAsset:asset];
        CMTime time=CMTimeMakeWithSeconds(0,1);
        uploadVideoVc.thumbNailImage = [UIImage imageWithCGImage:[imageGenerator copyCGImageAtTime:time actualTime:NULL error:NULL]];
        [uploadVideoVc.pickerVideoThumbNailImage setContentMode:UIViewContentModeCenter];
        [self.navigationController pushViewController:uploadVideoVc animated:YES];
        
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
