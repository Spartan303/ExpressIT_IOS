//
//  AppDelegate.h
//  ExpressIt
//
//  Created by naveen on 3/12/14.
//  Copyright (c) 2014 netpace. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HomeViewController.h"
#import "MBProgressHUD.h"
#import "SWRevealViewController.h"
@interface AppDelegate : UIResponder <UIApplicationDelegate,MBProgressHUDDelegate,SWRevealViewControllerDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (nonatomic , retain) MBProgressHUD * progressHud;
@property (strong, nonatomic) SWRevealViewController *viewController;

-(void) progressHudView : (UIView *) view passingTheText:(NSString *)statusText;
@end
