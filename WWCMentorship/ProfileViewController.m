//
//  ProfileViewController.m
//  WWCMentorship
//
//  Created by Tripta Gupta on 4/7/14.
//  Copyright (c) 2014 Tripta Gupta. All rights reserved.
//

#import "ProfileViewController.h"
#import "UserListViewController.h"
#import "ProfileFormViewController.h"
#import "CustomParseLoginViewController.h"
#import "CustomParseSignupViewController.h"
#import "UIImageView+AFNetworking.h"
#import "REMenu.h"

@interface ProfileViewController ()

@property (nonatomic, strong, readwrite) REMenu *menu;

@property (weak, nonatomic) IBOutlet UIImageView *avatar;
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UILabel *twitter;
@property (weak, nonatomic) IBOutlet UILabel *github;
@property (weak, nonatomic) IBOutlet UITextView *summary;
@property (weak, nonatomic) IBOutlet UIButton *contactButton;

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
- (void)setUser;

@end

@implementation ProfileViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = @"Profile";
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
//    PFObject *userObject = [PFObject objectWithClassName:@"User"];
//    userObject[@"foo"] = @"bar";
//    [userObject saveInBackground];
    
    
    // populate values
    [self setUser];

    // set up navigation menu
    [self setNavigationMenu];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Menu" style:UIBarButtonItemStylePlain target:self action:@selector(onMenu:)];
    
    // hide contact button if looking at self
    [self.contactButton setHidden:YES];
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

- (void)signUpViewController:(PFSignUpViewController *)signUpController didSignUpUser:(PFUser *)user {
    NSLog(@"signed up");
    [self dismissViewControllerAnimated:YES completion:^{
        ProfileFormViewController *pfvc = [[ProfileFormViewController alloc] init];
        [self presentViewController:pfvc animated:NO completion:NULL];
    }];
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
    PFUser *user = [PFUser currentUser];
    PFQuery *query = [PFQuery queryWithClassName:@"_User"];
    PFObject *userObject = [query getObjectWithId:user.objectId];
    
    NSString *type = @"Matches";
    if ([userObject objectForKey:@"isMentor"]) {
        type = @"Mentees";
    } else {
        type = @"Mentors";
    }
    
    REMenuItem *profile = [[REMenuItem alloc] initWithTitle:@"Profile"
                                                   subtitle:nil
                                                      image:nil
                                           highlightedImage:nil
                                                     action:^(REMenuItem *item) {
                                                         NSLog(@"item: %@", item);
                                                         NSLog(@"showing profile");
                                                     }];
    
    REMenuItem *potentials = [[REMenuItem alloc] initWithTitle:@"Explore"
                                                      subtitle:nil
                                                         image:nil
                                              highlightedImage:nil
                                                        action:^(REMenuItem *item) {
                                                            NSLog(@"item: %@", item);
                                                            NSLog(@"showing potential users");
                                                            UserListViewController *ulvc = [[UserListViewController alloc] init];
                                                            ulvc.showMatch = NO;
                                                            if ([userObject objectForKey:@"isMentor"]){
                                                                ulvc.showMentor = NO;
                                                            } else {
                                                                ulvc.showMentor = YES;
                                                            }
                                                            [self.navigationController pushViewController:ulvc animated:NO];
                                                        }];
    
    REMenuItem *matches = [[REMenuItem alloc] initWithTitle:type
                                                   subtitle:nil
                                                      image:nil
                                           highlightedImage:nil
                                                     action:^(REMenuItem *item) {
                                                         NSLog(@"item: %@", item);
                                                         NSLog(@"showing matches");
                                                         UserListViewController *ulvc = [[UserListViewController alloc] init];
                                                         ulvc.showMatch = YES;
                                                         if ([userObject objectForKey:@"isMentor"]){
                                                             ulvc.showMentor = NO;
                                                         } else {
                                                             ulvc.showMentor = YES;
                                                         }
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
                                                         
                                                         CustomParseLoginViewController *pflvc = [[CustomParseLoginViewController alloc] init];
                                                         CustomParseSignupViewController *pfsvc = [[CustomParseSignupViewController alloc] init];
                                                         
                                                         pflvc.delegate = self;
                                                         pfsvc.delegate = self;
                                                         
                                                         pflvc.signUpController = pfsvc;
                                                         
                                                         [self presentViewController:pflvc animated:YES completion:NULL];
                                                     }];
    
    self.menu = [[REMenu alloc] initWithItems:@[profile, potentials, matches, signOut]];
}

# pragma mark - Private methods

- (void)setUser {
    
}

@end
