//
//  UserListViewController.m
//  WWCMentorship
//
//  Created by Tripta Gupta on 4/12/14.
//  Copyright (c) 2014 Tripta Gupta. All rights reserved.
//

#import "UserListViewController.h"
#import "ProfileViewController.h"
#import "LoginViewController.h"
#import "UserCell.h"
#import "REMenu.h"

@interface UserListViewController ()

@property (nonatomic, strong, readwrite) REMenu *menu;
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

//- (void)viewDidLoad
//{
//    [super viewDidLoad];
//    
//    // if not logged in, present login view controller
//    PFUser *user = [PFUser currentUser];
//    if (!user) {
//        PFLogInViewController *pflvc = [[PFLogInViewController alloc] init];
//        pflvc.delegate = self;
//        
//        [self presentViewController:pflvc animated:YES completion:NULL];
//    // if not logged in, present either sign-up view controller, tab bar controller
//    } else {
//        PFQuery *query = [PFQuery queryWithClassName:@"User"];
//        [query whereKey:@"objectId" equalTo:user.objectId];
//            
//        [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
//            if (objects && !error) {
//
//            } else if (!objects) {
//                LoginViewController *lvc = [[LoginViewController alloc] init];
//                [self presentViewController:lvc animated:YES completion:NULL];
//            } else if (error) {
//                NSLog(@"error: %@", error.description);
//            }
//        }];
//    }
//    
//    // assign table view's delegate, data source
//    self.tableView.delegate = self;
//    self.tableView.dataSource = self;
//    
//    // register user cell nib
//    UINib *nib = [UINib nibWithNibName:@"UserCell" bundle:nil];
//    [self.tableView registerNib:nib forCellReuseIdentifier:@"UserCell"];
//    
//    self.showMatch = NO;
//    if (self.showMatch) {
//        [self loadMatches];
//    } else {
//        [self loadPotentials];
//    }
//    
//    // set up navigation menu
//    [self setNavigationMenu];
//    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Menu" style:UIBarButtonItemStylePlain target:self action:@selector(onMenu:)];
//}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

# pragma mark - Private methods

- (void)loadPotentials {
    NSString *key, *type;
    if (self.showMentor) {
        key = @"MenteeID";
        type = @"mentors";
    } else {
        key = @"MentorID";
        type = @"mentees";
    }
    
    // get skills they want to learn/teach
    NSArray *skills;
    
    for (NSString *skill in skills) {
        // perform query to find potential matches
        PFQuery *query = [PFQuery queryWithClassName:@"Skills"];
        [query whereKey:key equalTo:skill];
        [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
            if (!error) {
                if (objects) {
                    NSLog(@"%@: %@", type, objects);
                    
                    // process messages object, initialize mlvc with array
                    
                    [self.tableView reloadData];
                } else {
                    NSLog(@"no %@ :(", type);
                }
            } else {
                NSLog(@"error in retrieving potential %@: %@", type, error.description);
            }
        }];
    }

}

- (void)loadMatches {
    NSString *key, *type;
    if (self.showMentor) {
        key = @"MenteeID";
        type = @"mentors";
    } else {
        key = @"MentorID";
        type = @"mentees";
    }
    
    // perform query in relationships table where current UserID = mentorID
    PFQuery *query = [PFQuery queryWithClassName:@"Relationships"];
    [query whereKey:key equalTo:@"userID"];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            if (objects) {
                NSLog(@"%@: %@", type, objects);
                
                // process messages object, initialize mlvc with array
                
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
                                                     ProfileViewController *pvc = [[ProfileViewController alloc] init];
                                                     [self.navigationController pushViewController:pvc animated:NO];
                                                 }];
    
    REMenuItem *userList = [[REMenuItem alloc] initWithTitle:@"Explore"
                                               subtitle:nil
                                                  image:nil
                                       highlightedImage:nil
                                                 action:^(REMenuItem *item) {
                                                     NSLog(@"item: %@", item);
                                                     NSLog(@"showing user list");
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
