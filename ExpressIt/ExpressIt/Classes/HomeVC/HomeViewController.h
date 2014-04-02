//
//  ADHomeViewController.h
//  MediaSharingSample
//
//  Created by Adnan on 3/4/14.
//  Copyright (c) 2014 Netpace Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum _EX_PICKER_SOURCE_TYPE
{
    
    EX_PICKER_SOURCE_IMAGE_LIBRARY,
    EX_PICKER_SOURCE_IMAGE_CAMERA,
    EX_PICKER_SOURCE_VIDEO_LIBRARY,
    EX_PICKER_SOURCE_VIDEO_CAMERA
    
    
} EX_PICKER_SOURCE_TYPE;

@interface HomeViewController : UIViewController <UIScrollViewDelegate,UIAlertViewDelegate,UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>{
    //create grid scrollview outlet.....
    IBOutlet  UIScrollView * gridScrollView;
    EX_PICKER_SOURCE_TYPE sourceType;
}

#pragma mark Properties
// sets the property for the mediaGroupBtn....
@property (retain, nonatomic) IBOutlet UIButton *mediaGroupBtn;
// sets the property for the gridview.....
@property (retain, nonatomic) IBOutlet UIScrollView * gridScrollView;

//
- (IBAction)mediaGroupViewController:(id)sender;
- (IBAction)toggleToMainMenuButton:(id)sender;
- (void)getTheMediaList;
@end
