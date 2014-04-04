//
//  ADViewController.h
//  MediaSharingSample
//
//  Created by Adnan on 3/3/14.
//  Copyright (c) 2014 Netpace Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import <ADMediaSharing/ADMediaSharing.h>

@interface UploadImageViewController : UIViewController<UITextFieldDelegate,UITextViewDelegate> {

    //TODO: TASK 1 - Write the CTV sample for uploading the image through REST API --- completed
    //TODO: TASK 2 - Write the sample for uploading the image on Amazon S3 bucket  --- completed

    // create the outlet for the title of the story...
    IBOutlet UITextField *txtStoryTitle;
    
    //create the outlet for the description of the story....
    IBOutlet UITextView *txtStoryDescription;
    
    // sets the file path....
    NSString * strFilePath;
    
    IBOutlet UIImageView *pickerImage;
    
    // sets the picker image data
    NSData * imgData;
    
    // creates the appdelegate obejct
    AppDelegate * appDelegate;
    
    }

#pragma mark Properties
// sets the properties for the uplaod action button
@property (retain, nonatomic) IBOutlet UIButton *uploadActionBtn;
// sets the properties for the picker image..
@property (retain, nonatomic) IBOutlet UIImageView *pickerImage;

// sets the properties for the story title and description...
@property (retain, nonatomic) IBOutlet UITextField *txtStoryTitle;
@property (retain, nonatomic) IBOutlet UITextView *txtStoryDescription;

@property (retain, nonatomic) NSString * strFilePath;
@property (retain, nonatomic) NSData * imgData;

// publish the image to the amazon cloud..
- (IBAction)publishImageStoryWithAmazonTVMS3:(id)sender;
- (IBAction)backForRetakeTheImage:(id)sender;
@end
