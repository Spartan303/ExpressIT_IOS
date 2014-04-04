//
//  MediaCaptureViewController.h
//  ExpressIt
//
//  Created by naveen on 4/4/14.
//  Copyright (c) 2014 netpace. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MediaCaptureViewController : UIViewController<UIImagePickerControllerDelegate,UINavigationControllerDelegate>

- (IBAction)goToPictureView:(id)sender;
- (IBAction)goToVideoView:(id)sender;
- (IBAction)goToGalleryView:(id)sender;
- (IBAction)goToUrlFromWebView:(id)sender;
- (IBAction)backFromTheView:(id)sender;
@end
