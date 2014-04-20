//
//  ProfileViewController.m
//  WWCMentorship
//
//  Created by Tripta Gupta on 4/7/14.
//  Copyright (c) 2014 Tripta Gupta. All rights reserved.
//

#import "ProfileViewController.h"
#import "UserListViewController.h"
#import "UIImageView+AFNetworking.h"
#import "REMenu.h"

@interface ProfileViewController ()

@property (nonatomic, strong, readwrite) REMenu *menu;

@property (weak, nonatomic) IBOutlet UIImageView *avatar;
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UILabel *twitter;
@property (weak, nonatomic) IBOutlet UILabel *github;
@property (weak, nonatomic) IBOutlet UITextView *summary;

@property (weak, nonatomic) IBOutlet UILabel *toLearn1;
@property (weak, nonatomic) IBOutlet UILabel *toLearn2;
@property (weak, nonatomic) IBOutlet UILabel *toLearn3;
@property (weak, nonatomic) IBOutlet UILabel *toLearn4;
@property (weak, nonatomic) IBOutlet UILabel *toLearn5;
@property (weak, nonatomic) IBOutlet UILabel *toLearn6;

@property (weak, nonatomic) IBOutlet UILabel *toTeach1;
@property (weak, nonatomic) IBOutlet UILabel *toTeach2;
@property (weak, nonatomic) IBOutlet UILabel *toTeach3;
@property (weak, nonatomic) IBOutlet UILabel *toTeach4;
@property (weak, nonatomic) IBOutlet UILabel *toTeach5;
@property (weak, nonatomic) IBOutlet UILabel *toTeach6;

- (IBAction)onContactButton:(id)sender;

@end

@implementation ProfileViewController

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
    
//    PFObject *userObject = [PFObject objectWithClassName:@"User"];
//    userObject[@"foo"] = @"bar";
//    [userObject saveInBackground];
    

    // set up navigation menu
    [self setNavigationMenu];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Menu" style:UIBarButtonItemStylePlain target:self action:@selector(onMenu:)];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)onContactButton:(id)sender {
}

# pragma mark - Navigation methods

- (void)logInViewController:(PFLogInViewController *)logInController didLogInUser:(PFUser *)user {
    NSLog(@"i'm in!");
    [self dismissViewControllerAnimated:YES completion:NULL];
}

- (void)onMenu:(id)sender {
    NSLog(@"let's go somewhere else");
    if (self.menu.isOpen) {
        return [self.menu close];
    } else {
        [self.menu showFromNavigationController:self.navigationController];
    }
}

- (void)setNavigationMenu {
    REMenuItem *profile = [[REMenuItem alloc] initWithTitle:@"Profile"
                                                   subtitle:nil
                                                      image:nil
                                           highlightedImage:nil
                                                     action:^(REMenuItem *item) {
                                                         NSLog(@"item: %@", item);
                                                         NSLog(@"showing profile");
                                                     }];
    
    REMenuItem *userList = [[REMenuItem alloc] initWithTitle:@"Explore"
                                                    subtitle:nil
                                                       image:nil
                                            highlightedImage:nil
                                                      action:^(REMenuItem *item) {
                                                          NSLog(@"item: %@", item);
                                                          NSLog(@"showing user list");
                                                          UserListViewController *ulvc = [[UserListViewController alloc] init];
                                                          [self.navigationController pushViewController:ulvc animated:NO];
                                                      }];
    
    REMenuItem *signOut = [[REMenuItem alloc] initWithTitle:@"Sign Out"
                                                   subtitle:nil
                                                      image:nil
                                           highlightedImage:nil
                                                     action:^(REMenuItem *item) {
                                                         NSLog(@"item: %@", item);
                                                         NSLog(@"signing out");
                                                         [PFUser logOut];
                                                         
                                                         PFLogInViewController *pflvc = [[PFLogInViewController alloc] init];
                                                         pflvc.delegate = self;
                                                         [self presentViewController:pflvc animated:YES completion:NULL];
                                                     }];
    
    self.menu = [[REMenu alloc] initWithItems:@[profile, userList, signOut]];
}
@end
