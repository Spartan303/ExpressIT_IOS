//
//  ADHomeViewController.m
//  MediaSharingSample
//
//  Created by Adnan on 3/4/14.
//  Copyright (c) 2014 Netpace Inc. All rights reserved.
//

#import "HomeViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "AppContants.h"
#import "SWRevealViewController.h"
#import "EXRemoteCall.h"
#import "UploadImageViewController.h"
#import <MobileCoreServices/MobileCoreServices.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import <AVFoundation/AVFoundation.h>
#import "UploadVideoViewController.h"

@interface HomeViewController ()

@end


@implementation HomeViewController
@synthesize gridScrollView;
#pragma mark - Lifecyle Methods
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
    
	//sets the navigation bar to hidden state. Due to custom header implementation...
    self.navigationController.navigationBar.hidden = YES;
    
    SWRevealViewController *revealController = [self revealViewController];
    
    [self.view addGestureRecognizer:revealController.panGestureRecognizer];
    //customise the appearance through the layers....
    CALayer *btnLayer1 = [_mediaGroupBtn layer];
    [btnLayer1 setMasksToBounds:YES];
    [btnLayer1 setCornerRadius:5.0f];
    [self showGridView];
    UIRefreshControl *refreshControl = [[UIRefreshControl alloc] init];
    refreshControl.tintColor = [UIColor grayColor];
    refreshControl.attributedTitle = [[NSAttributedString alloc] initWithString:@"Pull to Refresh"];
    [refreshControl addTarget:self action:@selector(updateTable:) forControlEvents:UIControlEventValueChanged];
    
    [self.gridScrollView addSubview:refreshControl];
}
// display the grid....
/**
 Author			: Netpace
 \n Date of Creation		: 2014/03/10
 \n Function Name		: - (void)showGridView
 \n Description			: Custom grid view will display with images
 \n Return				: None
 */
- (void)showGridView
{
    // testing array for display the images....
    NSMutableArray * testArrayImages = [[NSMutableArray alloc]init] ;
    for (int i = 0; i<20; i++) {
        [testArrayImages addObject:[UIImage imageNamed:@"Nature.jpeg"]];
    }
    
    // sets the gridscrollview properties programmatically..
    gridScrollView.delegate = self;
    gridScrollView.showsVerticalScrollIndicator = YES;
    gridScrollView.userInteractionEnabled = YES;
    gridScrollView.scrollEnabled = YES;

//Mathematical implementation for the grid images
    
    int x = 10;
    int y = 10;
    int tag = 0;
    
    // Display the set of images into the scroll view.....
    for (UIImage * img in testArrayImages){
        // create the imageview
        UIImageView * imageView = [[UIImageView alloc]initWithImage:img];
        //sets the imageview frame
        imageView.frame = CGRectMake(x, y, TEMP_IMAGE_WIDTH, TEMP_IMAGE_HEIGHT);
        //sets the imageview tag
        imageView.tag = tag;
        // setst the border for the image
        [imageView.layer setBorderColor: [[UIColor grayColor] CGColor]];
        [imageView.layer setBorderWidth: 5.0];
        imageView.userInteractionEnabled = YES;
        
        // sets the tap gesture to the imageview for idemtifies the selected image
        UITapGestureRecognizer *tapped = [[UITapGestureRecognizer alloc]
                                          initWithTarget:self
                                          action:@selector(selectedImage:)];
        //sets the tap count
        tapped.numberOfTapsRequired = 1;
        
        //adds the gesture on the imageview
        [imageView addGestureRecognizer:tapped];
        //release the gesture object...
       
        //adds the imageview on the scrollview
        [gridScrollView addSubview:imageView];
        //release the imageview Object...
      
        // sets the x and y postitions ...
        y = (tag%2 == 1)? (y = y + TEMP_IMAGE_HEIGHT + 10):(y = y);
        x = ( x == 10)? (x = x + TEMP_IMAGE_WIDTH + 10) : (x = 10);
        //increment the tag for unique values for the image views..
        tag++;
        
    }
    // sets the scrollview contenet size
    [gridScrollView setContentSize:CGSizeMake(320, y)];
    
}

// selected image triggered method
/**
 Author			: Netpace
 \n Date of Creation		: 2014/03/10
 \n Function Name		:-(void)selectedImage:
 \n Function Parameters :(id)sender
 \n Description			: Gesture event occured by the imageview which is displayed in the gridview. 
                          This method uses for the event occured in the gridview and recognizes 
                          its unique.
 \n Return				: None
 */

-(void)selectedImage:(id) sender
{
    UITapGestureRecognizer *gesture = (UITapGestureRecognizer *) sender;
    NSLog(@"Tag = %ld", (long)gesture.view.tag);
}

-(IBAction)mediaGroupViewController:(id)sender
{
  
    UIAlertView * mediaCategoryAlertView = [[UIAlertView alloc]initWithTitle:@"Select Media" message:nil delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Image",@"Video", nil];
    [mediaCategoryAlertView show];

}
- (IBAction)toggleToMainMenuButton:(id)sender
{
    
    SWRevealViewController *revealController = [self revealViewController];
    [revealController revealToggle:self];
    
}
- (void)updateTable:(UIRefreshControl *)controller
{
    NSLog(@"I am in the refresh view controller.....");
    [self getTheMediaList];
    [self stopRefresh:controller];
    
}
- (void)stopRefresh:(UIRefreshControl *)refreshController {

    [refreshController endRefreshing];
    
}

#pragma mark ---------AlertViewDelgegateMethods-------------
// Called when a button is clicked. The view will be automatically dismissed after this call returns
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
   
    if ([[alertView buttonTitleAtIndex:buttonIndex] isEqualToString:@"Image"]) {
        
        UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"Image Picker" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Choose Image", @"Take Picture", nil];
        [actionSheet showInView:self.view];
        
    } else if ([[alertView buttonTitleAtIndex:buttonIndex] isEqualToString:@"Video"]){
        
        UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"Video Picker" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Choose Video", @"Take Video", nil];
        [actionSheet showInView:self.view];
    }
    else {
        //Nothing..
    }
}

- (void)getTheMediaList {
    
    EXRemoteCall * remoteCall = [[EXRemoteCall alloc]initWithURL:[NSString stringWithFormat:@"%@%@",HOST_DEVELOPMENT_URL,API_GET_MEDIA_LIST_URL]];
    [remoteCall fetchResponseWithFormat:EX_RESPONSE_FORMAT_JSON dataWithCompletion:^(id string) {
        NSLog(@"%@",string);
    } failure:^(NSError *error) {
        NSLog(@"%@",[error description]);
    }];
    

}
#pragma mark - UIActionSheet Delegate Method

// the delegate method to receive notifications is exactly the same as the one for UIActionSheet
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    NSLog(@"Button at index: %ld clicked\nIt's title is '%@'", (long)buttonIndex, [actionSheet buttonTitleAtIndex:buttonIndex]);
    if ([[actionSheet buttonTitleAtIndex:buttonIndex] isEqualToString:@"Choose Image"]) {
        // sets the enumerated value based on the user selection and pass the value to the parameter..
        [self displayThePicker:EX_PICKER_SOURCE_IMAGE_LIBRARY];
    }
    else if ([[actionSheet buttonTitleAtIndex:buttonIndex] isEqualToString:@"Take Picture"]) {
        // sets the enumerated value based on the user selection and pass the value to the parameter..
        [self displayThePicker:EX_PICKER_SOURCE_IMAGE_CAMERA];
    }
    else if ([[actionSheet buttonTitleAtIndex:buttonIndex] isEqualToString:@"Choose Video"]) {
        [self displayThePicker:EX_PICKER_SOURCE_VIDEO_LIBRARY];
    }
    else {
        //TODO
    }
}

#pragma mark ---void methods----
/**
 Author			: Netpace
 \n Date of Creation		: 2014/03/10
 \n Function Name		:- - (void)displayThePicker:
 \n Function Parameters :(ADPickerSourceType)sourceType
 \n Description			: Displayed the picker controller based on the enumerated value...
 the camera....
 \n Return				: None
 */
- (void)displayThePicker:(EX_PICKER_SOURCE_TYPE)sourceTypeCategory
{
    
    sourceType = sourceTypeCategory;
    // create the image picker controller object and assigns the delegate to self
    UIImagePickerController *mediaPicker = [[UIImagePickerController alloc] init];
    mediaPicker.delegate = self;
    // put the condition for the source type. Add the library source type to the picker controller
    //based on the selection
    if (sourceType == EX_PICKER_SOURCE_IMAGE_LIBRARY) {
        mediaPicker.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
        
    }
    // put the condition for the source type. Add the camera source type to the picker controller
    //based on the selection
    
    else if (sourceType == EX_PICKER_SOURCE_IMAGE_CAMERA) {
        // check the camera availability...
#if TARGET_IPHONE_SIMULATOR
        UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"Sorry" message:@"Device is mandatory for this action" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:Nil, nil];
        [alert show];
        
#elif TARGET_OS_IPHONE
        
        mediaPicker.sourceType = UIImagePickerControllerSourceTypeCamera;
        
#endif
    }
    
    else if (sourceTypeCategory == EX_PICKER_SOURCE_VIDEO_LIBRARY) {
        
        mediaPicker.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
        mediaPicker.mediaTypes =[[NSArray alloc] initWithObjects: (NSString *)kUTTypeMovie,(NSString *)kUTTypeVideo,nil];
        mediaPicker.videoMaximumDuration = 6;
    }
    
    else {
        
    }
    
    [self presentViewController:mediaPicker animated:YES completion:nil];
}

#pragma mark -  Picker delegate methods

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    //NSString *type = [info objectForKey:UIImagePickerControllerMediaType];
    [picker.presentingViewController dismissViewControllerAnimated:YES completion:nil];
   
  if (sourceType == EX_PICKER_SOURCE_IMAGE_LIBRARY || sourceType == EX_PICKER_SOURCE_IMAGE_CAMERA) {
    
      UploadImageViewController * uploadImgVc = [[UploadImageViewController alloc]initWithNibName:@"UploadImageViewController" bundle:[NSBundle mainBundle]];

      UIImage* image = [info valueForKey:@"UIImagePickerControllerOriginalImage"];
      
      // Get the data for the image as a PNG
      uploadImgVc.imgData = UIImagePNGRepresentation(image);
      
      // Give a name to the file
      NSString* imageName = @"MyImage.png";
      
      // Now, we have to find the documents directory so we can save it
      // Note that you might want to save it elsewhere, like the cache directory,
      // or something similar.
      NSArray* paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
      NSString* documentsDirectory = [paths objectAtIndex:0];
      
      // Now we get the full path to the file
      NSString* fullPathToFile = [documentsDirectory stringByAppendingPathComponent:imageName];
      
      // and then we write it out
      [uploadImgVc.imgData writeToFile:fullPathToFile atomically:NO];
      uploadImgVc.strFilePath = fullPathToFile;
      [self.navigationController pushViewController:uploadImgVc animated:YES];
    }
    
  else {
      
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

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
