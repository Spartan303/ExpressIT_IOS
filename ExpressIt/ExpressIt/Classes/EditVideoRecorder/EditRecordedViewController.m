//
//  EditRecordedViewController.m
//  SampleCustomVideoRecording
//
//  Created by naveen on 3/25/14.
//  Copyright (c) 2014 netpace. All rights reserved.
//

#import "EditRecordedViewController.h"
#import "MBProgressHUD.h"
#import "UploadVideoViewController.h"
@interface EditRecordedViewController ()
// Player Properties....
@property (nonatomic, retain)AVQueuePlayer *avPlayer;
@end

@implementation EditRecordedViewController
@synthesize captureManager;
@synthesize playerItems;
@synthesize progressHud;
@synthesize avPlayer;
@synthesize thumbnailImages;
@synthesize editView;
int i = 0;
int x = 1;
@synthesize originalPosition;
@synthesize newPosition;

@synthesize horizontalScroll;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    //sets the edtview hidden
    editView.hidden = YES;
    //Sets the frame for progressview for saving indication....
    self.progressBar = [[UIProgressView alloc]
                        initWithFrame:
                        CGRectMake(0.0, self.view.frame.size.height/2, self.view.frame.size.width - 60.0, 2.0)];
    self.progressBar.center = self.view.center;
    [self.view addSubview:self.progressBar];
    self.progressBar.hidden = YES;
    // Initialize the arrays
    playerItems = [[NSMutableArray alloc]init];
    thumbnailImages = [[NSMutableArray alloc]init];
    // Create thumbnails and playeitems and add to the arrays....
    for (AVAsset * asset in self.captureManager.assets) {
        [playerItems addObject:[AVPlayerItem playerItemWithAsset:asset]];
        [thumbnailImages addObject:[self createThumbnailImage:asset]];
    }
    // Pass the mutable array to the array.... Here AVQueuePlayer accepts the Array items only.....
    NSArray * array = [playerItems copy];
    //Initialise the avplayer with array of playeritems.....
    // We can intialize only one time.....
    avPlayer = [[AVQueuePlayer alloc] initWithItems:array];
    //Create the playerlayer with the palyer
    AVPlayerLayer *avPlayerLayer = [AVPlayerLayer playerLayerWithPlayer:avPlayer] ;
    //Sets the videoGravity
    avPlayerLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
    //Sets the playerlayer
    [avPlayerLayer setFrame:self.view.bounds];
    //Sets the frame
    CGRect frame = avPlayerLayer.frame;
    //Sets the frame with requirements
    [avPlayerLayer setFrame:CGRectMake(frame.origin.x, frame.origin.y + 64, frame.size.width, frame.size.width)];
    //adds the sublayers
    [[self.view layer] addSublayer:avPlayerLayer];
    //Starts plays the loop videos....
    [avPlayer play];
    //Set the action after playing single asset...
    avPlayer.actionAtItemEnd = AVPlayerActionAtItemEndAdvance;
    //Create the observer after playing the assets...
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(playerItemDidReachEnd:)
                                                 name:AVPlayerItemDidPlayToEndTimeNotification
                                              object:[[avPlayer items] lastObject]];
    //Sets the capturtemanager delgate to self
    self.captureManager.delegate = self;

    // Do any additional setup after loading the view from its nib.
}
/********
 finished player notification observer..
 *******/
- (void)playerItemDidReachEnd:(id)check {
    NSLog(@"player notification is ");
    [avPlayer play];
    avPlayer.actionAtItemEnd = AVPlayerActionAtItemEndPause;
    self.captureManager.delegate = self;
   
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
/********
 Back the controller...
 *******/
- (IBAction)backFromRoot:(id)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
}
/********
 Save the video with compleiton handler
 *******/
- (IBAction)saveVideo:(id)sender {
    self.progressBar.hidden = NO;
    
    [self progressHudView:self.view passingTheText:@"Saving the Video....."];
    [self.captureManager saveVideoWithCompletionBlock:^(BOOL success) {
        [self removeTheProgressHud];
          if (success) {
            [self performSelector:@selector(refresh) withObject:nil afterDelay:0.0];
              [self sendsTheVideo];
          } else {
              //TODO
          }
    }];
}

- (void)sendsTheVideo {
    
    UploadVideoViewController * uploadVideoVc = [[UploadVideoViewController alloc]initWithNibName:@"UploadVideoViewController" bundle:[NSBundle mainBundle]];
    NSURL *videoURL = self.captureManager.outPutUrl;
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

/********
 Update Progress from the Capturemanager Automatically Calls.......
 For the indication of the progressview.
 *******/
- (void) updateProgress {
    self.progressBar.hidden = NO;
    self.progressBar.progress = self.captureManager.exportSession.progress;
    if (self.progressBar.progress > .99) {
        [self.captureManager.exportProgressBarTimer invalidate];
        self.captureManager.exportProgressBarTimer = nil;
    }
}
/********
 Once the operation will end. Method Will call...
 *******/
- (void)removeProgress {
    self.progressBar.hidden = YES;
}
/********
 Refresh the view once saving functionality is complete
 Post the nofication to the rootviewcontroller for changes
 *******/
- (void)refresh {
    [[NSNotificationCenter defaultCenter]
     postNotificationName:@"RefreshNotification"
     object:self];
}
/********
 Shows the progress Hud View for indication...
 *******/
- (void)progressHudView :(UIView *)view
          passingTheText:(NSString *)statusText {
    progressHud = [[MBProgressHUD alloc] initWithView:view];
    progressHud.mode = MBProgressHUDModeIndeterminate;
    progressHud.labelText = statusText;
    [view addSubview:progressHud];
    progressHud.delegate = self;
	[progressHud show:YES];
}
/********
 Removes the progress hud once the operation ll end
 *******/
- (void)removeTheProgressHud {
    [progressHud removeFromSuperview];
}
/********
 User goes to the editing view when the edit action trigger
 Here shows the thumbnail of the no of session assets and plays the assets when click on it
 *******/
- (IBAction)editingFunctionality:(id)sender {
    // sets teh editview is hidden...
    [self.avPlayer replaceCurrentItemWithPlayerItem:[self.playerItems objectAtIndex:0]];
    [avPlayer play];
    editView.hidden = NO;
    for (int i = 0; i < [thumbnailImages count]; i++) {
        [self addImageWithName:[thumbnailImages objectAtIndex:i] atPosition:i];
    }
    //Prepare the horizontal scrollviw for display the images...
    horizontalScroll.delegate = self;
    horizontalScroll.contentSize = CGSizeMake(60*(thumbnailImages.count+1), 60);
    horizontalScroll.contentOffset = CGPointMake(60, 0);
    horizontalScroll.layer.borderColor = [UIColor darkGrayColor].CGColor;
    horizontalScroll.layer.borderWidth = 2.0f;
    [self horizontally];
}
/*
 Method Name: addImageWithName
 Description: customize the scroll view with buttons
 */

- (void)addImageWithName:(UIImage*)image atPosition:(int)position {
   
    UIView * view = [[UIView alloc]init];
    view.frame = CGRectMake(position*65, 4, 60, 60);
    UIImageView * imageDisplay = [[UIImageView alloc]init];
	imageDisplay.frame = CGRectMake(4, 3, 50, 50);
    imageDisplay.image = image;
    //imageDisplay.layer.borderWidth = 2.0;
	imageDisplay.tag = position;
    imageDisplay.userInteractionEnabled = YES;
    UITapGestureRecognizer *tapped = [[UITapGestureRecognizer alloc]
                                      initWithTarget:self
                                      action:@selector(selectedImage:)];
    tapped.numberOfTapsRequired = 1;
    [imageDisplay addGestureRecognizer:tapped];
    [view addSubview:imageDisplay];
        view.userInteractionEnabled = YES;
    [view makeDraggableWithDropViews:@[self.horizontalScroll] delegate:self];
    //[view setDragMode:UIViewDragDropModeRestrictX];
	[horizontalScroll addSubview:view];
    view.tag = position;
}
/*
 Method horizontally
 Description:set the offset of the scrollview
 */

-(void)horizontally {
    horizontalScroll.contentOffset = CGPointMake(i, 0);
    if (i == (thumbnailImages.count)*65) {
        i = 0;
    } else {
        i = i+65;
    }
    if (x == (thumbnailImages.count)) {
        x = 0;
    } else {
        x++;
    }
    i = 0;x = 1;
    
}
/********
 When cancel the editing button hides the view...
 *******/
- (IBAction)editingCancel:(id)sender {
    self.editView.hidden = YES;
}
/********
 Create the thumbanil using assets.
 *******/
- (UIImage *)createThumbnailImage:(AVAsset *)asset {
    //Create the avasset images generator
    AVAssetImageGenerator *imageGenerator = [[AVAssetImageGenerator alloc]initWithAsset:asset];
    //sets the time for capture the image from video
    CMTime time=CMTimeMakeWithSeconds(0,1);
    //Final thumbanil images from the image generator...
    UIImage * image = [UIImage imageWithCGImage:[imageGenerator copyCGImageAtTime:time actualTime:NULL error:NULL]];
    return image;
    
}
/********
Selects the image gesture..
 *******/
-(void)selectedImage:(id) sender {
    UITapGestureRecognizer *gesture = (UITapGestureRecognizer *) sender;
    NSLog(@"Tag = %ld", (long)gesture.view.tag);
    [self.avPlayer replaceCurrentItemWithPlayerItem:[self.playerItems objectAtIndex:(long)gesture.view.tag]];
    [avPlayer play];
    self.captureManager.delegate = self;
}
#pragma mark - UIViewDragDropDelegate

- (void)view:(UIView *)view wasDroppedOnDropView:(UIView *)drop {
  //  NSString *msg = [NSString stringWithFormat:@"%@ was dropped on %@", [view.subviews[0] text], [drop.subviews[0] text]];
    
//    [self updateDisplayLabel:msg];
}

- (BOOL)viewShouldReturnToStartingPosition:(UIView*)view {
    return NO;
}

- (void)draggingDidBeginForView:(UIView*)view {
    NSLog(@"Draggin began for ");
    view.layer.borderWidth = 2.0;
    NSLog(@"begin %ld",(long)view.tag);
    originalPosition = view.frame;
    
}

- (void)draggingDidEndWithoutDropForView:(UIView*)view {
    
   NSLog(@"Dragging ended without drop for");
    view.layer.borderWidth = 0.0;
    NSLog(@"end without dropforview %ld",(long)view.tag);
    NSLog(@"%@",NSStringFromCGRect(view.frame));
    newPosition = view.frame;
    [self rearrangeTheViewPositions:view];
    
}

- (void)view:(UIView *)view didHoverOverDropView:(UIView *)dropView {
    NSLog(@"hovered over");
}

- (void)view:(UIView *)view didUnhoverOverDropView:(UIView *)dropView {
    NSLog(@"unhovered over");
}
- (void)continousDraggin:(UIView *)view {
    NSLog(@"continious dragging..");
}

//Rearrange the frames with the selections...
- (void)rearrangeTheViewPositions:(UIView *)view1 {
    
    int nearValue = 0;
    int count = 0;
    NSInteger finalTagValue = 0;
// get the subviews and compare those views
    for (UIView * view in [horizontalScroll subviews]) {
        NSLog(@"frame is %@",NSStringFromCGRect(view.frame));
        if (view.tag == view1.tag) {
            view.frame = originalPosition;
        } else {
        if (view.frame.origin.x > newPosition.origin.x) {
            NSLog(@"high value %f",view.frame.origin.x-newPosition.origin.x);
            NSLog(@"%ld",(long)view.tag);
            if (count == 0) {
            nearValue = view.frame.origin.x-newPosition.origin.x;
                finalTagValue = view.tag;
                NSLog(@"%ld",(long)finalTagValue);
            }
            else if(view.frame.origin.x-newPosition.origin.x<nearValue){
                nearValue = view.frame.origin.x-newPosition.origin.x;
                                finalTagValue = view.tag;
                                NSLog(@"%ld",(long)finalTagValue);
            }
        } else {
            NSLog(@"low value %f",-view.frame.origin.x+newPosition.origin.x);
            NSLog(@"%ld",(long)view.tag);
            if (count == 0) {

                nearValue = -view.frame.origin.x+newPosition.origin.x;
                                finalTagValue = view.tag;
                                NSLog(@"%ld",(long)finalTagValue);
            }  else if(-view.frame.origin.x+newPosition.origin.x<nearValue) {
                nearValue = -view.frame.origin.x+newPosition.origin.x;
                                finalTagValue = view.tag;
                                NSLog(@"%ld",(long)finalTagValue);
            }
        }
            
      }
        count ++;
  }
   for (UIView * view in [horizontalScroll subviews]) {
        if (view.tag == finalTagValue) {
            // Rearrange the view position here ....
            view1.frame = view.frame;
            view.frame = originalPosition;
            return;
        }
    }
}

#pragma mark -

- (void) updateDisplayLabel:(NSString*)message {
   //TODO
}

- (IBAction)backForRetakeTheVideo:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
@end
