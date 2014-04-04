//
//  MediaCaptureViewController.m
//  ExpressIt
//
//  Created by naveen on 4/4/14.
//  Copyright (c) 2014 netpace. All rights reserved.
//

#import "MediaCaptureViewController.h"
#import "CustomVideoRecorder.h"
#import "UploadImageViewController.h"
@interface MediaCaptureViewController ()

@end

@implementation MediaCaptureViewController

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
    // Do any additional setup after loading the view from its nib.
}
- (IBAction)goToPictureView:(id)sender {
    
    UIImagePickerController *mediaPicker = [[UIImagePickerController alloc] init];
    mediaPicker.delegate = self;
    mediaPicker.sourceType = UIImagePickerControllerSourceTypeCamera;
    [self presentViewController:mediaPicker animated:YES completion:nil];
}
- (IBAction)goToVideoView:(id)sender {
    
    CustomVideoRecorder * customVideoVc = [[CustomVideoRecorder alloc]initWithNibName:@"CustomVideoRecorder" bundle:[NSBundle mainBundle]];
    [self.navigationController pushViewController:customVideoVc animated:YES];
    
}
- (IBAction)goToGalleryView:(id)sender {
    
    UIImagePickerController *mediaPicker = [[UIImagePickerController alloc] init];
    mediaPicker.delegate = self;
    mediaPicker.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
    [self presentViewController:mediaPicker animated:YES completion:nil];
}
- (IBAction)goToUrlFromWebView:(id)sender {
  //TODO
}
- (IBAction)backFromTheView:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark -  Picker delegate methods

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    //NSString *type = [info objectForKey:UIImagePickerControllerMediaType];
     [picker.presentingViewController dismissViewControllerAnimated:YES completion:nil];
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
@end
