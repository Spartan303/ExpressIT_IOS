//
//  EditRecordedViewController.h
//  SampleCustomVideoRecording
//
//  Created by naveen on 3/25/14.
//  Copyright (c) 2014 netpace. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CaptureManager.h"
#import "MBProgressHUD.h"
#import "UIView+DragDrop.h"
@interface EditRecordedViewController : UIViewController<CaptureManagerDelegate,MBProgressHUDDelegate,UIScrollViewDelegate,UIViewDragDropDelegate>

@property (nonatomic, strong) CaptureManager *captureManager;
@property (nonatomic, assign) CGRect  originalPosition;
@property (nonatomic, assign) CGRect  newPosition;
//Shows the view controllers...
@property (nonatomic, strong) UIProgressView *progressBar;
@property (nonatomic, retain) NSMutableArray * playerItems;
@property (nonatomic, retain) MBProgressHUD * progressHud;
@property (nonatomic, retain) NSMutableArray * thumbnailImages;
@property (nonatomic, retain) IBOutlet UIScrollView * horizontalScroll;
@property (nonatomic, retain) IBOutlet UIView * editView;
@property (nonatomic, retain) IBOutlet UIView * cameraView;
- (IBAction)backForRetakeTheVideo:(id)sender;
@end
