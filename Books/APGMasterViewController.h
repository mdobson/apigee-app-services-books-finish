//
//  APGMasterViewController.h
//  Books
//
//  Created by Matthew Dobson on 6/13/13.
//  Copyright (c) 2013 Matthew Dobson. All rights reserved.
//

#import <UIKit/UIKit.h>

@class APGDetailViewController;

@interface APGMasterViewController : UITableViewController

@property (strong, nonatomic) APGDetailViewController *detailViewController;

@end
