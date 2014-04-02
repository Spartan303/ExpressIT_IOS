//
//  LoginViewController.m
//  ExpressIt
//
//  Created by naveen on 3/14/14.
//  Copyright (c) 2014 netpace. All rights reserved.
//

#import "LoginViewController.h"
#import "SWRevealViewController.h"
#import "HomeViewController.h"
#import <QuartzCore/QuartzCore.h>
@interface LoginViewController ()

@end

@implementation LoginViewController
@synthesize txtEmailId,txtUserName;
// sets the constatns for the keyboard animations based on the orientations...
static const CGFloat KEYBOARD_ANIMATION_DURATION = 0.3;
static const CGFloat MINIMUM_SCROLL_FRACTION = 0.2;
static const CGFloat MAXIMUM_SCROLL_FRACTION = 0.8;
static const CGFloat PORTRAIT_KEYBOARD_HEIGHT = 216;
static const CGFloat LANDSCAPE_KEYBOARD_HEIGHT = 162;

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
    CALayer *btnLayer1 = [_loginButton layer];
    appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    [btnLayer1 setMasksToBounds:YES];
    [btnLayer1 setCornerRadius:5.0f];
    // sets the borders for the textfields......
    [txtEmailId.layer setBorderColor: [[UIColor grayColor] CGColor]];
    [txtEmailId.layer setBorderWidth: 3.0];
    [txtUserName.layer setBorderColor: [[UIColor grayColor] CGColor]];
    [txtUserName.layer setBorderWidth: 3.0];

    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

// display the grid....
/**
 Author			: Netpace
 \n Date of Creation		: 2014/03/14
 \n Function Name		: - (void)loginTrigger
 \n Parameters          : (id)sender
 \n Description			: After the validation Move to the Home view controller
 \n Return				: None
 */
- (IBAction)loginTrigger:(id)sender; {

    [self showTheProgressHud];
    if ([self.txtUserName.text isEqualToString:@""] ||[self.txtEmailId.text isEqualToString:@""]) {
        [self removeTheProgressHud];
        UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"Status" message:@"Make Sure Fill all the fileds" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [alert show];
    }
    else {
        [self performSelector:@selector(goHomeView) withObject:nil afterDelay:2.5];
    }
}
/**
 Author			: Netpace
 \n Date of Creation		: 2014/03/14
 \n Function Name		: - (void)goHomeView
 \n Parameters          : (id)sender
 \n Description			: Validation successful move to the homeview
 \n Return				: None
 */
- (void)goHomeView {
    
    [self removeTheProgressHud];
    SWRevealViewController *revealController = [self revealViewController];
    HomeViewController *homeVc = [[HomeViewController alloc] initWithNibName:@"HomeViewController" bundle:[NSBundle mainBundle]];
    
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:homeVc];
    navigationController.navigationBarHidden = YES;
    [revealController setFrontViewController:navigationController animated:YES];
    //[revealController revealToggleAnimated:YES];
}



#pragma mark -  textfield methods


- (void)textFieldDidBeginEditing:(UITextField *)textField {

    // set the frames for the animations...
   CGRect textFieldRect = [self.view.window convertRect:textField.bounds fromView:textField];
   CGRect viewRect =[self.view.window convertRect:self.view.bounds fromView:self.view];
   CGFloat midline = textFieldRect.origin.y + 0.5 * textFieldRect.size.height;
   CGFloat numerator =
   midline - viewRect.origin.y- MINIMUM_SCROLL_FRACTION * viewRect.size.height;
   CGFloat denominator =(MAXIMUM_SCROLL_FRACTION - MINIMUM_SCROLL_FRACTION)* viewRect.size.height;
   CGFloat heightFraction = numerator / denominator;

               if (heightFraction < 0.0) {
                 heightFraction = 0.0;
             }
             else if (heightFraction > 1.0) {
                 heightFraction = 1.0;
             }
   // checck the UIOrientation...
   UIInterfaceOrientation orientation =[[UIApplication sharedApplication] statusBarOrientation];
    
    if (orientation == UIInterfaceOrientationPortrait || orientation == UIInterfaceOrientationPortraitUpsideDown) {
    animatedDistance = floor(PORTRAIT_KEYBOARD_HEIGHT * heightFraction);
    }
    else {
    animatedDistance = floor(LANDSCAPE_KEYBOARD_HEIGHT * heightFraction);
    }

     CGRect viewFrame = self.view.frame;
     viewFrame.origin.y -= animatedDistance;
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:KEYBOARD_ANIMATION_DURATION];
    [self.view setFrame:viewFrame];
    [UIView commitAnimations];
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    CGRect viewFrame = self.view.frame;
    viewFrame.origin.y += animatedDistance;
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:KEYBOARD_ANIMATION_DURATION];
    
    [self.view setFrame:viewFrame];
    
    [UIView commitAnimations];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    //remove the keyboard from the view...
    [textField resignFirstResponder];
    return  YES;
}
/**
 Author			: Netpace
 \n Date of Creation		: 2014/03/14
 \n Function Name		:- (void)showTheProgressHud
 \n Description			: Shows the activity indicator with status message...
 \n Return				: None
 */
- (void)showTheProgressHud {
    
    [appDelegate progressHudView:self.view passingTheText:@"Validating......"];
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

@end
