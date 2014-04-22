//
//  UserListViewController.m
//  WWCMentorship
//
//  Created by Tripta Gupta on 4/12/14.
//  Copyright (c) 2014 Tripta Gupta. All rights reserved.
//

#import "UserListViewController.h"
#import "ProfileViewController.h"
#import "ProfileFormViewController.h"
#import "CustomParseLoginViewController.h"
#import "CustomParseSignupViewController.h"
#import "User.h"
#import "UserCell.h"
#import "REMenu.h"

@interface UserListViewController ()

@property (nonatomic, strong, readwrite) REMenu *menu;
@property (nonatomic, strong) NSMutableArray *skills;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSMutableSet *users;
@property (nonatomic, strong) NSMutableArray *usersArray;

@end

@implementation UserListViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.skills = [[NSMutableArray alloc] init];
        self.users = [[NSMutableSet alloc] init];
        self.usersArray = [[NSMutableArray alloc] init];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    PFUser *user = [PFUser currentUser];
    PFQuery *query = [PFQuery queryWithClassName:@"_User"];
    PFObject *userObject = [query getObjectWithId:user.objectId];
    NSNumber *isMentorNumber = (NSNumber *) [userObject objectForKey:@"isMentor"];
    int isMentor = [isMentorNumber intValue];
    if (isMentor == 1) {
        self.showMentor = NO;
    } else if (isMentor == 0) {
        self.showMentor = YES;
    }
    
    // set title
    if (self.showMentor && self.showMatch) {
        self.title = @"Mentors";
    } else if (!self.showMentor && self.showMatch) {
        self.title = @"Mentees";
    } else if (self.showMentor && !self.showMatch) {
        self.title = @"Find a Mentor";
    } else if (!self.showMentor && !self.showMatch) {
        self.title = @"Find a Mentee";
    }
    
    // if not logged in, present login view controller
    if (!user) {
        CustomParseLoginViewController *pflvc = [[CustomParseLoginViewController alloc] init];
        CustomParseSignupViewController *pfsvc = [[CustomParseSignupViewController alloc] init];
        
        pflvc.delegate = self;
        pfsvc.delegate = self;

        pflvc.signUpController = pfsvc;
        
        [self presentViewController:pflvc animated:YES completion:NULL];
    }
    
    // assign table view's delegate, data source
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    // register user cell nib
    UINib *nib = [UINib nibWithNibName:@"UserCell" bundle:nil];
    [self.tableView registerNib:nib forCellReuseIdentifier:@"UserCell"];
    
    // populate list with potentials or matches
    if (self.showMatch) {
        [self loadMatches];
    } else {
        [self loadPotentials];
    }
    
    // set up navigation menu
    [self setNavigationMenu];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Menu" style:UIBarButtonItemStylePlain target:self action:@selector(onMenu:)];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

# pragma mark - Private methods

- (void)loadPotentials {
    PFUser *user = [PFUser currentUser];
    NSString *key, *type;
    if (self.showMentor) {
        key = @"MenteeID";
        type = @"mentors";
    } else {
        key = @"MentorID";
        type = @"mentees";
    }

    // retrieve current user's skills
    PFQuery *skillQuery = [PFQuery queryWithClassName:@"Skills"];
    [skillQuery whereKey:@"UserID" equalTo:user];
    [skillQuery findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error && objects) {
            for (PFObject *skillObject in objects) {
                NSString *skill = skillObject[@"Name"];
                [self.skills addObject:skill];
            }
            NSLog(@"self.skills: %@", self.skills);
            
            // perform query to find potential matches
            NSMutableArray *subqueries = [[NSMutableArray alloc] init];
            for (NSString *skill in self.skills) {
                PFQuery *subquery = [PFQuery queryWithClassName:@"Skills"];
                [subquery whereKey:@"Name" equalTo:skill];
                if (self.showMentor) {
                    [subquery whereKey:@"isMentor" equalTo:@YES];
                } else {
                    [subquery whereKey:@"isMentor" equalTo:@NO];
                }
                [subqueries addObject:subquery];
            }
            PFQuery *matchQuery = [PFQuery orQueryWithSubqueries:[[NSArray alloc] initWithArray:subqueries]];
                
                [matchQuery findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
                    if (objects && !error) {
                        NSLog(@"%@: %@", type, objects);
                        
                        for (PFObject *userObject in objects) {
                            PFUser *pfUser = userObject[@"UserID"];
                            [self.users addObject:pfUser.objectId];
                        }
                        NSLog(@"self.users: %@", self.users);
                        
                        for (NSString *userId in self.users) {
                            PFQuery *userQuery = [PFQuery queryWithClassName:@"_User"];
                            PFObject *fullUserObject = [userQuery getObjectWithId:userId];
                            
                            NSDictionary *parameters = @{@"firstName" : fullUserObject[@"firstName"],
                                                         @"lastName" : fullUserObject[@"lastName"],
                                                         @"summary" : fullUserObject[@"summary"],
                                                         @"avatarURL" : fullUserObject[@"avatarURL"]};
                            NSLog(@"params: %@", parameters);
                            User *potential = [[User alloc] init];
                            [potential setUserWithDictionary:parameters];
                            [self.usersArray addObject:potential];
                        }
                        [self.tableView reloadData];
                    } else if (error){
                        NSLog(@"error in retrieving potential %@: %@", type, error.description);
                    }
                }];
            
        } else if (error) {
            NSLog(@"error: %@", error.description);
        }
    }];
}

- (void)loadMatches {
    PFUser *user = [PFUser currentUser];
    NSString *key, *type;
    if (self.showMentor) {
        key = @"MenteeID"; // if showing mentors, current user is a mentee
        type = @"mentors";
    } else {
        key = @"MentorID"; // if showing mentees, current user is a mentor
        type = @"mentees";
    }
    
    // perform query in relationships table where current UserID = mentorID if mentor, or current UserID = menteeID if mentee
    PFQuery *query = [PFQuery queryWithClassName:@"Relationships"];
    [query whereKey:key equalTo:user.objectId];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            if (objects) {
                NSLog(@"%@: %@", type, objects);
                
                // process messages object, initialize mlvc with array
                for (id user in objects) {
                    [self.users addObject:user];
                }
                
                [self.tableView reloadData];
            } else {
                NSLog(@"no %@ :(", type);
            }
        } else {
            NSLog(@"error in retrieving %@: %@", type, error.description);
        }
    }];
}

# pragma mark - Table view methods

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 100;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 10;
    //return self.users.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UserCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"UserCell" forIndexPath:indexPath];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
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
        [self.navigationController pushViewController:pfvc animated:YES];
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
                                                     ProfileViewController *pvc = [[ProfileViewController alloc] init];
                                                     pvc.isSelf = YES;
                                                     [self.navigationController pushViewController:pvc animated:NO];
                                                 }];
    
    REMenuItem *potentials = [[REMenuItem alloc] initWithTitle:@"Explore"
                                                      subtitle:[NSString stringWithFormat:@"Find a %@", singular_type]
                                                  image:nil
                                       highlightedImage:nil
                                                 action:^(REMenuItem *item) {
                                                     NSLog(@"item: %@", item);
                                                     NSLog(@"showing potential users");
                                                     if (self.showMatch) {
                                                         UserListViewController *ulvc = [[UserListViewController alloc] init];
                                                         ulvc.showMatch = NO;
                                                         if (isMentor == 1){
                                                             ulvc.showMentor = NO;
                                                         } else if (isMentor == 0) {
                                                             ulvc.showMentor = YES;
                                                         }
                                                         [self.navigationController pushViewController:ulvc animated:NO];
                                                     }
                                                 }];
    
    REMenuItem *matches = [[REMenuItem alloc] initWithTitle:type
                                                      subtitle:[NSString stringWithFormat:@"View Your %@", type]
                                                         image:nil
                                              highlightedImage:nil
                                                        action:^(REMenuItem *item) {
                                                            NSLog(@"item: %@", item);
                                                            NSLog(@"showing matches");
                                                            
                                                            if (!self.showMatch) {
                                                                UserListViewController *ulvc = [[UserListViewController alloc] init];
                                                                ulvc.showMatch = YES;
                                                                if (isMentor == 1){
                                                                    ulvc.showMentor = NO;
                                                                } else if (isMentor == 0) {
                                                                    ulvc.showMentor = YES;
                                                                }
                                                                [self.navigationController pushViewController:ulvc animated:NO];
                                                            }
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
    
    self.menu = [[REMenu alloc] initWithItems:@[profile, potentials, matches, signOut]];
}

@end
