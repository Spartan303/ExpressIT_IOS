//
//  MenuViewController.m
//  Demo
//
//  Created by naveen on 2/10/14.
//  Copyright (c) 2014 netpace. All rights reserved.
//

#import "MenuViewController.h"
#import "SWRevealViewController.h"
#import "LoginViewController.h"
@interface MenuViewController ()
{
    NSMutableArray * arrayMenuItems;
}
@end

@implementation MenuViewController
@synthesize menuTableView = _menuTableView;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    
        self.navigationController.navigationBar.translucent = NO;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    SWRevealViewController *parentRevealController = self.revealViewController;
    SWRevealViewController *grandParentRevealController = parentRevealController.revealViewController;
    
    UIBarButtonItem *revealButtonItem = [[UIBarButtonItem alloc]
                                         initWithImage:[UIImage imageNamed:@"reveal-icon.png"]
                                         style:UIBarButtonItemStyleBordered
                                         target:grandParentRevealController
                                         action:@selector(revealToggle:)];
      arrayMenuItems = [[NSMutableArray alloc]initWithObjects:@"Login",@"News",@"Entertainment",@"Viral",@"Technology",@"Shows", nil];
    
    menuTableView.backgroundColor = [UIColor blackColor];
    
    
    // if we have a reveal controller as a grand parent, this means we are are being added as a
    // child of a detail (child) reveal controller, so we add a gesture recognizer provided by our grand parent to our
    // navigation bar as well as a "reveal" button
    if ( grandParentRevealController )
    {
        // to present a title, we count the number of ancestor reveal controllers we have, this is of course
        // only a hack for demonstration purposes, on a real project you would have a model telling this.
        NSInteger level=0;
        UIViewController *controller = grandParentRevealController;
        while( nil != (controller = [controller revealViewController]) )
            level++;
        
        NSString *title = [NSString stringWithFormat:@"Detail Level %d", level];
        
        [self.navigationController.navigationBar addGestureRecognizer:grandParentRevealController.panGestureRecognizer];
        self.navigationItem.leftBarButtonItem = revealButtonItem;
        self.navigationItem.title = title;
    }
    
    // otherwise, we are in the top reveal controller, so we just add a title
    else
    {
        self.navigationItem.title = @"Master";
    }

    // Do any additional setup after loading the view from its nib.
}
#pragma marl - UITableView Data Source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if(section == 0)
    return 1;
    else
        return 3;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *resuseIdentifier = @"SlideViewControllerTableCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:resuseIdentifier];
    
    if (!cell) {
        
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:resuseIdentifier] ;
        UIImageView *background = [[UIImageView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 320.0f, 43.0f)];
        [background setImage:[[UIImage imageNamed:@"cell_background.png"] stretchableImageWithLeftCapWidth:0.0f topCapHeight:0.0f]];
        cell.backgroundView = background;
       
        
        UIImageView *selectedBackground = [[UIImageView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 320.0f, 43.0f)];
        [selectedBackground setImage:[[UIImage imageNamed:@"cell_selected_background.png"] stretchableImageWithLeftCapWidth:0.0f topCapHeight:0.0f]];
        cell.selectedBackgroundView = selectedBackground;
        
        //  self.textLabel.textColor = [UIColor colorWithRed:190.0f/255.0f green:197.0f/255.0f blue:212.0f/255.0f alpha:1.0f];
        cell.textLabel.textColor = [UIColor whiteColor];
        cell.textLabel.highlightedTextColor = cell.textLabel.textColor;
        cell.textLabel.shadowColor = [UIColor colorWithRed:33.0f/255.0f green:38.0f/255.0f blue:49.0f/255.0f alpha:1.0f];
        cell.textLabel.shadowOffset = CGSizeMake(0.0f, 1.0f);
        cell.textLabel.backgroundColor = [UIColor clearColor];
        cell.textLabel.font = [UIFont fontWithName:@"Helvetica67-CondensedMedium" size:20.0f];
        
        cell.imageView.clipsToBounds = YES;
        cell.imageView.contentMode = UIViewContentModeScaleAspectFit;

        
    }
    if (indexPath.section == 0) {
       cell.textLabel.text = [arrayMenuItems objectAtIndex:indexPath.row];
    }
    else
    {
        if(indexPath.row == 0)
            cell.textLabel.text = @"Settings";
        else if(indexPath.row == 1)
            cell.textLabel.text = @"My Profile";
        else
            cell.textLabel.text = @"Login";
        

    }
    
    
    
        cell.imageView.image = [UIImage imageNamed:@"HomeMenuIcon.png"];

    
    return cell;
    
}

//- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
//    
//    
//    if (section == 0)
//        return @"Categories";
//    else
//        return @"Accounts&Settings";
//    
//}

//- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
//    
//    
//    NSString *titleString = [self tableView:tableView titleForHeaderInSection:section];
//    
//    if (!titleString)
//        return nil;
//    
//    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 320.0f, 36.0f)];
//    imageView.image = [[UIImage imageNamed:@"settingBg.png"] stretchableImageWithLeftCapWidth:0.0f topCapHeight:0.0f];
//    
//    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectInset(imageView.frame, 10.0f, 0.0f)];
//    titleLabel.font = [UIFont fontWithName:@"Helvetica67-CondensedMedium" size:16.0f];
//    titleLabel.textAlignment = UITextAlignmentLeft;
//    titleLabel.textColor = [UIColor colorWithRed:125.0f/255.0f green:129.0f/255.0f blue:146.0f/255.0f alpha:1.0f];
//    titleLabel.shadowColor = [UIColor colorWithRed:40.0f/255.0f green:45.0f/255.0f blue:57.0f/255.0f alpha:1.0f];
//    titleLabel.shadowOffset = CGSizeMake(0.0f, 1.0f);
//    titleLabel.backgroundColor = [UIColor clearColor];
//    titleLabel.text = titleString;
//    [imageView addSubview:titleLabel];
//    
//    
//    return imageView;
//    
//    
//    //    NSString *titleString = [self tableView:tableView titleForHeaderInSection:section];
//    //
//    //    if (!titleString)
//    //        return nil;
//    //
//    //    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 320.0f, 100.0f)];
//    //    imageView.image = [[UIImage imageNamed:@"section_background"] stretchableImageWithLeftCapWidth:0.0f topCapHeight:0.0f];
//    //
//    //    if (section == 1)
//    //    {
//    //        [imageView addSubview:accountHView];
//    //    }
//    //    if (section == 3)
//    //    {
//    //        [imageView addSubview:sigHView];
//    //    }
//    //    if (section == 2)
//    //    {
//    //        socailHView.backgroundColor = [UIColor colorWithPatternImage:[[UIImage imageNamed:@"section_background"] stretchableImageWithLeftCapWidth:0.0f topCapHeight:0.0f]];
//    //        return socailHView;
//    //    }
//    //    return [imageView autorelease];
//    
//}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad)
    {
   return 83.0;
        
    }
    else
    {
   return 43.0;
    }

    
 
}


//- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
//    
////    if (_slideNavigationControllerState == kSlideNavigationControllerStateSearching) {
////        return 0.0f;
////    }
////    else if ([self tableView:tableView titleForHeaderInSection:section])
////    {
////        return 36;
////    } else {
////        return 0.0f;
////    }
//    
//    
//    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad)
//    {
//        return 83.0;
//        
//    }
//    else
//    {
//        return 44.0;
//    }
//
//}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
   
    UITableViewCell * cell = [tableView cellForRowAtIndexPath:indexPath];
    if ([cell.textLabel.text isEqualToString:@"Logout"]) {
        UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"Success" message:@"successfully logged out" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [alert show];
        cell.textLabel.text = @"Login";
        [menuTableView reloadData];
        return;
    }
    else {
        cell.textLabel.text = @"Logout";
        [menuTableView reloadData];

    SWRevealViewController *revealController = [self revealViewController];
    UIViewController *frontViewController = revealController.frontViewController;
    UINavigationController *frontNavigationController =nil;
    
    if ( [frontViewController isKindOfClass:[UINavigationController class]] )
        frontNavigationController = (id)frontViewController;
    
        //NSInteger row = indexPath.row;
    
        LoginViewController *loginVc = [[LoginViewController alloc] initWithNibName:@"LoginViewController" bundle:[NSBundle mainBundle]];
    
        UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:loginVc];
        navigationController.navigationBarHidden = YES;
        [revealController setFrontViewController:navigationController animated:YES];
    
    
	// Here you'd implement some of your own logic... I simply take for granted that the first row (=0) corresponds to the "FrontViewController".
//	if (row == 0)
//	{
		// Now let's see if we're not attempting to swap the current frontViewController for a new instance of ITSELF, which'd be highly redundant.
//        if ( ![frontNavigationController.topViewController isKindOfClass:[TopStoriesViewController class]] )
//        {
//            if([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad)
//            {
//                TopStoriesViewController *frontViewController = [[TopStoriesViewController alloc] initWithNibName:@"TopStoriesViewControllerIpad" bundle:[NSBundle mainBundle]];
//                
//                UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:frontViewController];
//                navigationController.navigationBarHidden = YES;
//                [revealController setFrontViewController:navigationController animated:YES];
//            }
//            else
//            {
//            	TopStoriesViewController *frontViewController = [[TopStoriesViewController alloc] initWithNibName:@"TopStoriesViewController" bundle:[NSBundle mainBundle]];
//                
//                UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:frontViewController];
//                navigationController.navigationBarHidden = YES;
//                [revealController setFrontViewController:navigationController animated:YES];
//            }
//		
//        }
//		// Seems the user attempts to 'switch' to exactly the same controller he came from!
//		else
//		{
//            [revealController revealToggleAnimated:YES];
//		}
//	}
//    
//	// ... and the second row (=1) corresponds to the "MapViewController".
//	else if(row == 1)
//	{
//		// Now let's see if we're not attempting to swap the current frontViewController for a new instance of ITSELF, which'd be highly redundant.
//        if ( ![frontNavigationController.topViewController isKindOfClass:[EntertainmentViewController class]] )
//        {
//			EntertainmentViewController *entertainVC = [[EntertainmentViewController alloc] init];
//			UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:entertainVC];
//            navigationController.navigationBarHidden = YES;
//			[revealController setFrontViewController:navigationController animated:YES];
//		}
//        
//		// Seems the user attempts to 'switch' to exactly the same controller he came from!
//    }
//    else if(row == 2)
//    {
//        if ( ![frontNavigationController.topViewController isKindOfClass:[SimpleServiceViewController class]] )
//        {
//			SimpleServiceViewController *entertainVC = [[SimpleServiceViewController alloc] init];
//			UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:entertainVC];
//            navigationController.navigationBarHidden = YES;
//			[revealController setFrontViewController:navigationController animated:YES];
//		}
//        
//    }
    
    
      //  [revealController revealToggleAnimated:YES];
    
   
    }
	
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
