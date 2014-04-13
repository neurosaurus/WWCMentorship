//
//  MenuViewController.m
//  WWCMentorship
//
//  Created by Tripta Gupta on 4/12/14.
//  Copyright (c) 2014 Tripta Gupta. All rights reserved.
//

#import "MenuViewController.h"

@interface MenuViewController ()

- (IBAction)onMentorButton:(id)sender;
- (IBAction)onMenteeButton:(id)sender;
- (IBAction)onMessagesButton:(id)sender;

@end

@implementation MenuViewController

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

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

# pragma mark - Private methods

- (IBAction)onMentorButton:(id)sender {
}

- (IBAction)onMenteeButton:(id)sender {
}

- (IBAction)onMessagesButton:(id)sender {
}

@end
