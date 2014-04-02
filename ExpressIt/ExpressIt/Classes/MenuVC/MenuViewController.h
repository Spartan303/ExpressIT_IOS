//
//  MenuViewController.h
//  Demo
//
//  Created by naveen on 2/10/14.
//  Copyright (c) 2014 netpace. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MenuViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>

{

   IBOutlet UITableView *menuTableView;
    
}
@property (nonatomic, retain)IBOutlet UITableView *menuTableView;

@end
