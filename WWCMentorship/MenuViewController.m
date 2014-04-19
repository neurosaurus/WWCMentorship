//
//  MenuViewController.m
//  WWCMentorship
//
//  Created by Tripta Gupta on 4/12/14.
//  Copyright (c) 2014 Tripta Gupta. All rights reserved.
//

#import "MenuViewController.h"
#import "UserListViewController.h"
#import "MessageListViewController.h"
#import "ProfileViewController.h"
#import "LoginViewController.h"

@interface MenuViewController ()

- (IBAction)onMentorButton:(id)sender;
- (IBAction)onMenteeButton:(id)sender;
- (IBAction)onMessagesButton:(id)sender;
- (IBAction)onProfileButton:(id)sender;
- (IBAction)onSignOutButton:(id)sender;

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
    NSLog(@"mentors, please");
    
    // push view controller
    UserListViewController *ulvc = [[UserListViewController alloc] init];
    ulvc.showMentor = YES;
    [self.navigationController pushViewController:ulvc animated:YES];
}

- (IBAction)onMenteeButton:(id)sender {
    NSLog(@"mentees, please");
    
    // push view controller
    UserListViewController *ulvc = [[UserListViewController alloc] init];
    ulvc.showMentor = NO;
    [self.navigationController pushViewController:ulvc animated:YES];
}

- (IBAction)onMessagesButton:(id)sender {
    NSLog(@"messages, please");
    
    // push view controller
    MessageListViewController *mlvc = [[MessageListViewController alloc] init];
    [self.navigationController pushViewController:mlvc animated:YES];
}

- (IBAction)onProfileButton:(id)sender {
    NSLog(@"profile, please");
    
    // push view controller
    ProfileViewController *pvc = [[ProfileViewController alloc] init];
    [self.navigationController pushViewController:pvc animated:YES];
}

- (IBAction)onSignOutButton:(id)sender {
    NSLog(@"get me outta here");
    
    // push view controller
    LoginViewController *lvc = [[LoginViewController alloc] init];
    [self.navigationController pushViewController:lvc animated:YES];
}

@end
