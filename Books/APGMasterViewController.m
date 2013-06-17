//
//  APGMasterViewController.m
//  Books
//
//  Created by Matthew Dobson on 6/13/13.
//  Copyright (c) 2013 Matthew Dobson. All rights reserved.
//

#import "APGMasterViewController.h"

#import "APGDetailViewController.h"

#import "APGNewBookViewController.h"

#import "UGClient.h"

@interface APGMasterViewController () {
    NSMutableArray *_objects;
}
@end

@implementation APGMasterViewController

- (void)awakeFromNib
{
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
        self.clearsSelectionOnViewWillAppear = NO;
        self.contentSizeForViewInPopover = CGSizeMake(320.0, 600.0);
    }
    [super awakeFromNib];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    UGClient * client = [[UGClient alloc] initWithOrganizationId:@"mdobson" withApplicationID:@"books"];
    UGClientResponse *result = [client getEntities:@"book" query:nil];
    if (result.transactionState == kUGClientResponseSuccess) {
        _objects = result.response[@"entities"];
    } else {
        _objects = @[];
    }

    
    self.navigationItem.leftBarButtonItem = self.editButtonItem;

    UIBarButtonItem *addButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(insertNewObject:)];
    self.navigationItem.rightBarButtonItem = addButton;
    self.detailViewController = (APGDetailViewController *)[[self.splitViewController.viewControllers lastObject] topViewController];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)insertNewObject:(id)sender
{
    [self performSegueWithIdentifier:@"newBook" sender:self];
//    if (!_objects) {
//        _objects = [[NSMutableArray alloc] init];
//    }
//    [_objects insertObject:[NSDate date] atIndex:0];
//    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
//    [self.tableView insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
}

- (void)addNewBook:(NSDictionary *)book {
    NSLog(@"called");
    if (!_objects) {
        _objects = [[NSMutableArray alloc] init];
    }
    
    UGClient * client = [[UGClient alloc] initWithOrganizationId:@"mdobson" withApplicationID:@"books"];
    UGClientResponse * response = [client createEntity:@{@"type":@"book", @"title":book[@"title"]}];
    if (response.transactionState == kUGClientResponseSuccess) {
        [_objects insertObject:response.response[@"entities"][0] atIndex:0];
    } else {
        [_objects insertObject:@{@"title":@"error"} atIndex:0];
    }
    [self.tableView reloadData];
    

}

#pragma mark - Table View

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _objects.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    NSString *object = _objects[indexPath.row][@"title"];
    cell.textLabel.text = object;
    
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [_objects removeObjectAtIndex:indexPath.row];
        NSDictionary *entity = [_objects objectAtIndex:indexPath.row];
        UGClient * client = [[UGClient alloc] initWithOrganizationId:@"mdobson" withApplicationID:@"books"];
        UGClientResponse * response = [client removeEntity:@"book" entityID:entity[@"uuid"]];
        if (response.transactionState == kUGClientResponseSuccess) {
            [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
        }
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
    }
}

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
        NSDate *object = _objects[indexPath.row];
        self.detailViewController.detailItem = object;
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"showDetail"]) {
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        NSDate *object = _objects[indexPath.row];
        [[segue destinationViewController] setDetailItem:object];
    } else if ([[segue identifier] isEqualToString:@"newBook"]) {
        NSLog(@"set delegate");
        APGNewBookViewController * vc = [[APGNewBookViewController alloc] init];
        [(APGNewBookViewController *)[segue destinationViewController] setDelegate:self];
    }
}

@end
