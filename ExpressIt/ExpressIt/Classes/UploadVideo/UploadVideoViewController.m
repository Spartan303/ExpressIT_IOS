//
//  ADViewController.m
//  MediaSharingSample
//
//  Created by Adnan on 3/3/14.
//  Copyright (c) 2014 Netpace Inc. All rights reserved.
//

#import "UploadVideoViewController.h"

@interface UploadVideoViewController ()

@end

@implementation UploadVideoViewController

@synthesize txtStoryDescription,txtStoryTitle;
@synthesize strFilePath;
@synthesize pickerVideoThumbNailImage;
@synthesize thumbNailImage;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    //Customise the appearance of the button....
    appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    
    CALayer *btnLayer1 = [_uploadActionBtn layer];
    [btnLayer1 setMasksToBounds:YES];
    [btnLayer1 setCornerRadius:5.0f];
    
    // sets the borders for the textfields and textviews...
    [txtStoryTitle.layer setBorderColor: [[UIColor grayColor] CGColor]];
    [txtStoryTitle.layer setBorderWidth: 3.0];
    [txtStoryDescription.layer setBorderColor: [[UIColor grayColor] CGColor]];
    [txtStoryDescription.layer setBorderWidth: 3.0];
    
    pickerVideoThumbNailImage.image = thumbNailImage;
    
	// Do any additional setup after loading the view, typically from a nib.
}
#pragma mark - Action Methods
/**
 Author			: Netpace
 \n Date of Creation		: 2014/03/10
 \n Function Name		:- - (IBAction)publishVideoStory
 \n Function Parameters :(id)sender
 \n Description			: Send the image to the amazon cloud to the remotecalls....
 the camera....
 \n Return				: Action
 */
- (IBAction)publishVideoStory:(id)sender {
    
    if ([self.txtStoryTitle.text isEqualToString:@""]) {
    }
    else {
        
        BOOL networkStatus = [Util networkStatus];
        if (networkStatus == NO) {
            return;
        }

        [self showTheProgressHud];
        
        /*
         TODO: Tasks
         
         a) you have to get the media (image or video) filename from REMOTE SERVER > REST API
         
         b) then you have to make the request to amazon S3 cloud using TVM+Anonoymous approach
         
         c) once it's successful, then return the information such as (title, description and etc) back to REMOTE SERVER > REST API
         
         d) Once successful from REMOTE SERVER, then this opeartion compeletes properly !!!
         ---- completed
         */
        
        NSMutableDictionary * paramasDict = [[NSMutableDictionary alloc]init];
        [paramasDict setValue:REMOTE_TYPE_PARAM_VALUE_VIDEO forKey:REMOTE_TYPE_PARAM];
        [paramasDict setValue:self.txtStoryDescription.text forKey:REMOTE_DESCRIPTION_PARAM];
        
        Util * util = [[Util alloc]init];
        
        [util publishTheMediaWithType:MEDIATYPE_VIDEO
                           postParams:paramasDict
                       localImagePath:strFilePath
                          keyMediaUrl:[NSString stringWithFormat:@"%@%@",HOST_DEVELOPMENT_URL,API_GET_SHORT_MEDIA_URL]
                       uploadMediaUrl:[NSString stringWithFormat:@"%@%@",HOST_DEVELOPMENT_URL,API_POST_PUBLISH_MEDIA_URL]
                              handler:^(id result, NSError *error) {
                                  if (error) {
                                      NSLog(@"upload fail error");
                                  } else {
                                      NSLog(@"%@",result);
                                  }
                                  [self removeTheProgressHud];
                              } fileExtension:[strFilePath pathExtension]];
    }
}


#pragma mark -  textfield methods
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    //remove the keyboard from the view...
    [textField resignFirstResponder];
    return  YES;
}
#pragma mark -  textView delegate methods
-(BOOL)textView:(UITextView *)textview shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if([text isEqualToString:@"\n"])
    {
        //remove the keyboard from the view....
        [textview resignFirstResponder];
    }
    NSLog(@"%@",textview.text);
    
    return YES;
}


/**
 Author			: Netpace
 \n Date of Creation		: 2014/03/14
 \n Function Name		:- (void)showTheProgressHud
 \n Description			: Shows the activity indicator with status message...
 \n Return				: None
 */
- (void)showTheProgressHud {
    
    [appDelegate progressHudView:self.view passingTheText:@"Uploading......"];
}

/**
 Author			: Netpace
 \n Date of Creation		: 2014/03/14
 \n Function Name		:- (void)removeTheProgressHud
 \n Description			: Remove the status activity indiactor from the view
 \n Return				: None
 */
- (void)removeTheProgressHud {
    
    [appDelegate.progressHud removeFromSuperview];
    [self.navigationController popToRootViewControllerAnimated:YES];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
