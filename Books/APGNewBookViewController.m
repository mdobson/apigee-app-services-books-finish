//
//  APGNewBookViewController.m
//  Books
//
//  Created by Matthew Dobson on 6/13/13.
//  Copyright (c) 2013 Matthew Dobson. All rights reserved.
//

#import "APGNewBookViewController.h"

@interface APGNewBookViewController ()

@end

@implementation APGNewBookViewController

@synthesize bookTitleText, delegate;

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
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)createBook:(id)sender {
    NSLog(@"del:%@",self.delegate);
    [[self delegate] addNewBook:@{@"title": bookTitleText.text}];
    [self dismissViewControllerAnimated:YES completion:^(){}];
}

@end
