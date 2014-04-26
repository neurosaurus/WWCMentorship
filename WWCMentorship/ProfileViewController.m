//
//  ProfileViewController.m
//  WWCMentorship
//
//  Created by Tripta Gupta on 4/7/14.
//  Copyright (c) 2014 Tripta Gupta. All rights reserved.
//

#import "ProfileViewController.h"
#import "UserListViewController.h"
#import "MessageListViewController.h"
#import "ProfileFormViewController.h"
#import "ComposeViewController.h"
#import "CustomParseLoginViewController.h"
#import "CustomParseSignupViewController.h"

#import "UIImageView+AFNetworking.h"
#import "REMenu.h"

@interface ProfileViewController ()

@property (nonatomic, strong) User *me;
@property (nonatomic, strong, readwrite) REMenu *menu;

@property (weak, nonatomic) IBOutlet UIImageView *avatar;
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UILabel *twitter;
@property (weak, nonatomic) IBOutlet UILabel *github;
@property (weak, nonatomic) IBOutlet UITextView *summary;
@property (weak, nonatomic) IBOutlet UIButton *contactButton;

@property (weak, nonatomic) IBOutlet UILabel *skill1;
@property (weak, nonatomic) IBOutlet UILabel *skill2;
@property (weak, nonatomic) IBOutlet UILabel *skill3;
@property (weak, nonatomic) IBOutlet UILabel *skill4;
@property (weak, nonatomic) IBOutlet UILabel *skill5;
@property (weak, nonatomic) IBOutlet UILabel *skill6;

- (IBAction)onContactButton:(id)sender;

@end

@implementation ProfileViewController

- (id)initWithUser:(User *)user {
    self = [super init];
    if (self) {
        self.user = user;
    }
    return self;
}

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
    
    // coloring
    self.view.backgroundColor = [UIColor blackColor];
    self.name.textColor = [UIColor whiteColor];
    self.twitter.textColor = [UIColor whiteColor];
    self.github.textColor = [UIColor whiteColor];
    self.summary.textColor = [UIColor whiteColor];
    self.summary.backgroundColor = [UIColor blackColor];
    self.skill1.textColor = [UIColor whiteColor];
    self.skill2.textColor = [UIColor whiteColor];
    self.skill3.textColor = [UIColor whiteColor];
    self.skill4.textColor = [UIColor whiteColor];
    self.skill5.textColor = [UIColor whiteColor];
    self.skill6.textColor = [UIColor whiteColor];
    self.contactButton.tintColor = [UIColor colorWithRed:0/255.0f green:182/255.0f blue:170/255.0f alpha:1.0f];

    // set up navigation menu
    [self setNavigationMenu];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Menu" style:UIBarButtonItemStylePlain target:self action:@selector(onMenu:)];
    
    // hide contact button if looking at self
    if (self.isSelf) {
        [self.contactButton setHidden:YES];
    }
    
    // grab user object for profile
    PFUser *myself = [PFUser currentUser];
    self.me = [self convertToUser:myself.objectId];
    
    // set values
    User *user = self.user;
    self.name.text = [NSString stringWithFormat:@"%@ %@", user.firstName, user.lastName];
    self.summary.text = user.summary;
    
    // for testing only
    //NSURL *tim = [NSURL URLWithString:@"https://avatars3.githubusercontent.com/u/99078?s=400"];
    [self.avatar setImageWithURL:user.avatarURL];
    
    NSArray *skills = user.skills;
    //NSLog(@"this is %@", self.name.text);
    //NSLog(@"skills: %@", skills);
    NSArray *skillLabels = @[self.skill1, self.skill2, self.skill3, self.skill4, self.skill5, self.skill6];
    for (int i = 0; i < skillLabels.count; i++) {
        UILabel *skill = skillLabels[i];
        if (i < skills.count) {
            skill.text = skills[i];
        } else {
            [skill setHidden:YES];
        }
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

# pragma mark - Private methods

- (User *)convertToUser:(NSString *)userId {
    PFQuery *userQuery = [PFQuery queryWithClassName:@"_User"];
    PFObject *fullUserObject = [userQuery getObjectWithId:userId];
    
    NSDictionary *parameters = @{@"pfUser" : fullUserObject,
                                 @"objectId" : userId,
                                 @"username" : fullUserObject[@"username"],
                                 @"email" : fullUserObject[@"email"],
                                 @"firstName" : fullUserObject[@"firstName"],
                                 @"lastName" : fullUserObject[@"lastName"],
                                 @"summary" : fullUserObject[@"summary"],
                                 @"avatarURL" : fullUserObject[@"avatarURL"],
                                 @"isMentor" : fullUserObject[@"isMentor"],
                                 @"skills" : fullUserObject[@"skills"]};
    
    User *user = [[User alloc] init];
    //[user loadSkills:(PFUser *)fullUserObject];
    [user setUserWithDictionary:parameters];
    return user;
}

- (PFUser *)convertToPFUser:(NSString *)userId {
    PFQuery *userQuery = [PFQuery queryWithClassName:@"_User"];
    PFObject *fullUserObject = [userQuery getObjectWithId:userId];
    return (PFUser *) fullUserObject;
}

- (void)loadUser:(User *)user {
    self.user = user;
    self.name.text = [NSString stringWithFormat:@"%@ %@", user.firstName, user.lastName];
    self.summary.text = user.summary;
    
    // for testing only
    NSURL *tim = [NSURL URLWithString:@"https://avatars3.githubusercontent.com/u/99078?s=400"];
    [self.avatar setImageWithURL:tim]; // user.avatarURL
    
    NSArray *skills;
    if (user.menteeSkills) {
        skills = user.menteeSkills;
    } else if (user.mentorSkills) {
        skills = user.mentorSkills;
    }
    NSArray *skillLabels = @[self.skill1, self.skill2, self.skill3, self.skill4, self.skill5, self.skill6];
    for (int i = 0; i == skillLabels.count; i++) {
        UILabel *skill = skillLabels[i];
        if (skills[i]) {
            skill.text = skills[i];
        } else {
            [skill setHidden:YES];
        }
    }
}

# pragma mark - Navigation methods

- (void)onMenu:(id)sender {
    NSLog(@"let's go somewhere else");
    if (self.menu.isOpen) {
        return [self.menu close];
    } else {
        [self.menu showFromNavigationController:self.navigationController];
    }
}

- (IBAction)onContactButton:(id)sender {
    ComposeViewController *cvc = [[ComposeViewController alloc] init];
    cvc.sender = self.me;
    cvc.receiver = self.user;
    [self.navigationController pushViewController:cvc animated:YES];
}

- (void)logInViewController:(PFLogInViewController *)logInController didLogInUser:(PFUser *)user {
    NSLog(@"i'm in!");
    [self.navigationController popToRootViewControllerAnimated:NO];
}

- (void)signUpViewController:(PFSignUpViewController *)signUpController didSignUpUser:(PFUser *)user {
    NSLog(@"signed up");
    [self dismissViewControllerAnimated:YES completion:^{
        ProfileFormViewController *pfvc = [[ProfileFormViewController alloc] init];
        [self.navigationController pushViewController:pfvc animated:NO];
    }];
}

- (void)setNavigationMenu {
    PFUser *user = [PFUser currentUser];
    PFQuery *query = [PFQuery queryWithClassName:@"_User"];
    PFObject *userObject = [query getObjectWithId:user.objectId];
    
    NSString *type = @"Matches", *singular_type = @"Match";
    NSLog(@"isMentor: %@ // 1 is true", [userObject objectForKey:@"isMentor"]);
    NSNumber *isMentorNumber = (NSNumber *) [userObject objectForKey:@"isMentor"];
    int isMentor = [isMentorNumber intValue];
    if (isMentor == 1) {
        type = @"Mentees";
        singular_type = @"Mentee";
    } else if (isMentor == 0) {
        type = @"Mentors";
        singular_type = @"Mentor";
    }
    
    REMenuItem *profile = [[REMenuItem alloc] initWithTitle:@"Profile"
                                                   subtitle:@"View Your Profile"
                                                      image:nil
                                           highlightedImage:nil
                                                     action:^(REMenuItem *item) {
                                                         NSLog(@"item: %@", item);
                                                         NSLog(@"showing profile");
                                                         
                                                         if (!self.isSelf) {
                                                             ProfileViewController *pvc = [[ProfileViewController alloc] init];
                                                             pvc.user = self.me;
                                                             pvc.isSelf = YES;
                                                             
                                                             [self.navigationController pushViewController:pvc animated:NO];
                                                         }
                                                     }];
    
    REMenuItem *potentials = [[REMenuItem alloc] initWithTitle:@"Explore"
                                                      subtitle:[NSString stringWithFormat:@"Find a %@", singular_type]
                                                         image:nil
                                              highlightedImage:nil
                                                        action:^(REMenuItem *item) {
                                                            NSLog(@"item: %@", item);
                                                            NSLog(@"showing potential users");
                                                            UserListViewController *ulvc = [[UserListViewController alloc] init];
                                                            ulvc.showMatch = NO;
                                                            if (isMentor == 1){
                                                                ulvc.showMentor = NO;
                                                            } else if (isMentor == 0) {
                                                                ulvc.showMentor = YES;
                                                            }
                                                            [self.navigationController pushViewController:ulvc animated:NO];
                                                        }];
    
    REMenuItem *matches = [[REMenuItem alloc] initWithTitle:type
                                                   subtitle:[NSString stringWithFormat:@"View Your %@", type]
                                                      image:nil
                                           highlightedImage:nil
                                                     action:^(REMenuItem *item) {
                                                         NSLog(@"item: %@", item);
                                                         NSLog(@"showing matches");
                                                         UserListViewController *ulvc = [[UserListViewController alloc] init];
                                                         ulvc.showMatch = YES;
                                                         if (isMentor == 1){
                                                             ulvc.showMentor = NO;
                                                         } else if (isMentor == 0) {
                                                             ulvc.showMentor = YES;
                                                         }
                                                         [self.navigationController pushViewController:ulvc animated:NO];
                                                     }];
    
    REMenuItem *messages = [[REMenuItem alloc] initWithTitle:@"Messages"
                                                    subtitle:@"View Your Messages"
                                                       image:nil
                                            highlightedImage:nil
                                                      action:^(REMenuItem *item) {
                                                          NSLog(@"item: %@", item);
                                                          NSLog(@"showing messages");
                                                          
                                                          MessageListViewController *mlvc = [[MessageListViewController alloc] init];
                                                          [self.navigationController pushViewController:mlvc animated:NO];
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
                                                         
                                                         [self.navigationController pushViewController:pflvc animated:NO];
                                                     }];
    
    self.menu = [[REMenu alloc] initWithItems:@[profile, potentials, matches, messages, signOut]];
    UIColor * color = [UIColor colorWithRed:33/255.0f green:33/255.0f blue:33/255.0f alpha:1.0f];
    self.menu.backgroundColor = color;
    self.menu.textColor = [UIColor whiteColor];
    self.menu.subtitleTextColor = [UIColor whiteColor];
    self.menu.separatorColor = [UIColor colorWithWhite:1.0 alpha:0.3];
    self.menu.shadowOffset = CGSizeZero;
    self.menu.subtitleTextShadowOffset = CGSizeZero;
    self.menu.separatorHeight = 0.8;
}

@end
