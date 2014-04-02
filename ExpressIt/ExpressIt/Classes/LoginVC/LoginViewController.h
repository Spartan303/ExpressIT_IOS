//
//  LoginViewController.h
//  ExpressIt
//
//  Created by naveen on 3/14/14.
//  Copyright (c) 2014 netpace. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
@interface LoginViewController : UIViewController<UITextFieldDelegate> {
    
    CGFloat animatedDistance;
    // emailid textfield
    IBOutlet UITextField * txtEmailId;
    // user name
    IBOutlet UITextField * txtUserName;
    
    AppDelegate * appDelegate;
}

#pragma mark Properties
@property (nonatomic, retain) IBOutlet UITextField * txtEmailId;
@property (nonatomic, retain) IBOutlet UITextField * txtUserName;
@property (retain, nonatomic) IBOutlet UIButton *loginButton;

//Create the trigger when click on the login...
- (IBAction)loginTrigger:(id)sender;

@end
