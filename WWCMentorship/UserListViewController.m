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
#import "UserCell.h"
#import "REMenu.h"

@interface UserListViewController ()

@property (nonatomic, strong, readwrite) REMenu *menu;
@property (nonatomic, strong) NSMutableArray *skills;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *users;

@end

@implementation UserListViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.users = [[NSMutableArray alloc] init];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
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
    PFUser *user = [PFUser currentUser];
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
    
    PFQuery *query = [PFQuery queryWithClassName:@"Skills"];
    //[query whereKey:@"UserID" equalTo:user.objectId];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error && objects) {
            NSLog(@"skills: %@", objects);
            for (NSString *skill in objects) {
                [self.skills addObject:skill];
            }
        } else if (error) {
            NSLog(@"error: %@", error.description);
        }
    }];
    
    for (NSString *skill in self.skills) {
        // perform query to find potential matches
        PFQuery *query = [PFQuery queryWithClassName:@"Skills"];
        //[query whereKey:@"Name" equalTo:skill];
        if (self.showMentor) {
            [query whereKey:@"isMentor" equalTo:@YES];
        } else {
            [query whereKey:@"isMentor" equalTo:@NO];
        }
        [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
            if (!error && objects) {
                NSLog(@"%@: %@", type, objects);
                    
                // process messages object, initialize mlvc with array
                for (id user in objects) {
                    [self.users addObject:user];
                }
                [self.tableView reloadData];
            } else if (error){
                NSLog(@"error in retrieving potential %@: %@", type, error.description);
            }
        }];
    }

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
                                                     ProfileViewController *pvc = [[ProfileViewController alloc] init];
                                                     pvc.isSelf = YES;
                                                     [self.navigationController pushViewController:pvc animated:NO];
                                                 }];
    
    REMenuItem *potentials = [[REMenuItem alloc] initWithTitle:@"Explore"
                                               subtitle:nil
                                                  image:nil
                                       highlightedImage:nil
                                                 action:^(REMenuItem *item) {
                                                     NSLog(@"item: %@", item);
                                                     NSLog(@"showing potential users");
                                                     if (self.showMatch) {
                                                         UserListViewController *ulvc = [[UserListViewController alloc] init];
                                                         ulvc.showMatch = NO;
                                                         if ([userObject objectForKey:@"isMentor"]){
                                                             ulvc.showMentor = NO;
                                                         } else {
                                                             ulvc.showMentor = YES;
                                                         }
                                                         [self.navigationController pushViewController:ulvc animated:NO];
                                                     }
                                                 }];
    
    REMenuItem *matches = [[REMenuItem alloc] initWithTitle:type
                                                      subtitle:nil
                                                         image:nil
                                              highlightedImage:nil
                                                        action:^(REMenuItem *item) {
                                                            NSLog(@"item: %@", item);
                                                            NSLog(@"showing matches");
                                                            
                                                            if (!self.showMatch) {
                                                                UserListViewController *ulvc = [[UserListViewController alloc] init];
                                                                ulvc.showMatch = YES;
                                                                if ([userObject objectForKey:@"isMentor"]){
                                                                    ulvc.showMentor = NO;
                                                                } else {
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
                                                     
                                                     [self presentViewController:pflvc animated:YES completion:NULL];
                                                 }];
    
    self.menu = [[REMenu alloc] initWithItems:@[profile, potentials, matches, signOut]];
}

@end
