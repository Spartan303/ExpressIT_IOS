//
//  ADViewController.h
//  MediaSharingSample
//
//  Created by Adnan on 3/3/14.
//  Copyright (c) 2014 Netpace Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
typedef enum _VideoPickerSourceType
{
    
    VideoPickerSourceTypeLibrary,
    VideoPickerSourceTypeCamera
    
    
}VideoPickerSourceType;

@interface UploadVideoViewController : UIViewController<UITextFieldDelegate,UITextViewDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UIActionSheetDelegate> {
    


    //TODO: TASK 1 - Write the CTV sample for uploading the video through REST API


    //TODO: TASK 2 - Write the sample for uploading the video on Amazon S3 bucket
    
    // create the outlet for the title of the story...
    IBOutlet UITextField *txtStoryTitle;
    
    //create the outlet for the description of the story....
    IBOutlet UITextView *txtStoryDescription;
    
    // sets the file path....
    NSString * strFilePath;
    
    IBOutlet UIImageView *pickerVideoThumbNailImage;
    
      // creates the appdelegate obejct
    AppDelegate * appDelegate;
    
    //UIImage
    UIImage * thumbNailImage;

}

@property (retain, nonatomic) IBOutlet UIImageView *pickerVideoThumbNailImage;
@property (retain, nonatomic) IBOutlet UIButton *uploadActionBtn;
// sets the properties for the story title and description...
@property (retain, nonatomic) IBOutlet UITextField *txtStoryTitle;
@property (retain, nonatomic) IBOutlet UITextView *txtStoryDescription;
@property (retain, nonatomic) NSString * strFilePath;
@property (retain, nonatomic) UIImage * thumbNailImage;
//implement the action for the publish story...
- (IBAction)publishVideoStory:(id)sender;

@end
