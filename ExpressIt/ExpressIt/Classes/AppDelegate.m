//
//  AppDelegate.m
//  ExpressIt
//
//  Created by naveen on 3/12/14.
//  Copyright (c) 2014 netpace. All rights reserved.
//

#import "AppDelegate.h"
#import "AppContants.h"
#import <ADMediaSharing/ADLogger.h>
#import "MenuViewController.h"

@implementation AppDelegate
@synthesize progressHud;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    self.window.backgroundColor = [UIColor whiteColor];
    // Created the object of the front and rear view controller objects ......
    HomeViewController * homeVc = [[HomeViewController alloc]initWithNibName:@"HomeViewController" bundle:[NSBundle mainBundle]];
    MenuViewController *menuVC = [[MenuViewController alloc] initWithNibName:@"MenuViewController" bundle:[NSBundle mainBundle]];
    // set the root controllers to the front and rear
    UINavigationController *frontNavigationController = [[UINavigationController alloc] initWithRootViewController:homeVc];
    //Hide the statusbar for custom implementation....
    frontNavigationController.navigationBarHidden = YES;
    UINavigationController *rearNavigationController = [[UINavigationController alloc] initWithRootViewController:menuVC];
    //Hide the statusbar for custom implementaiton.....
    rearNavigationController.navigationBarHidden = YES;
    
    //Initialise hte swrevealview controller for display the slide menu....
    self.viewController = [[SWRevealViewController alloc]
                           initWithRearViewController:rearNavigationController
                           frontViewController:frontNavigationController];
    
    //csutomize width of the rearview
    self.viewController.rearViewRevealWidth = 200;
    //sets the delegates to the current ....
    self.viewController.delegate = self;
    //sets the rootview controller.....
    self.window.rootViewController = self.viewController;
    [self.window makeKeyAndVisible];
    return YES;
}

#pragma mark MBProgressHud Function
/**
 Author			: Netpace
 \n Date of Creation		: 2014/03/14
 \n Function Name		:-(void) progressHudView
 \n Function Parameters :(UIView *) view passingTheText:(NSString *)statusText
 \n Description			: This method will display the activity indiactor with the appropriate status text...
 \n Return				: None
 */
-(void) progressHudView : (UIView *) view passingTheText:(NSString *)statusText
{
    progressHud = [[MBProgressHUD alloc] initWithView:view];
    progressHud.mode = MBProgressHUDModeIndeterminate;
    progressHud.labelText = statusText;
    [view addSubview:progressHud];
    progressHud.delegate = self;
	[progressHud show:YES];
}


- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
