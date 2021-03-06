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
#import "MessageListViewController.h"
#import "CustomParseLoginViewController.h"
#import "CustomParseSignupViewController.h"
#import "User.h"
#import "UserCell.h"
#import "REMenu.h"
#import "TSMessage.h"

@interface UserListViewController ()

@property (nonatomic, strong, readwrite) REMenu *menu;
@property (nonatomic, strong) User *me;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *users;

@end

@implementation UserListViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.isLoaded = NO;
        self.isNewUser = NO;
        self.users = [NSMutableArray array];
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    PFUser *user = [PFUser currentUser];
    self.me = [self convertToUser:user.objectId];
    if (self.me) {
        self.hasEnteredInfo = YES;
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
    
    // skip this method if user has signed in but hasn't put in info
    if (!self.hasEnteredInfo) {
        return;
    }
    
    // if user, present user list view controller
    if (user) {
        self.me = [self convertToUser:user.objectId];
        
        //NSNumber *isMentorNumber = (NSNumber *) [userObject objectForKey:@"isMentor"];
        //int isMentor = [isMentorNumber intValue];
        if (self.me.isMentor) {
            self.showMentor = NO;
        } else {
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
        
        if (!self.isLoaded || self.isNewUser) {
            NSLog(@"reloading table");
            self.isLoaded = YES;
            [self.users removeAllObjects];
            [self.tableView reloadData];
            
            // populate list with potentials or matches
            if (self.showMatch) {
                [self loadMatches];
            } else {
                [self loadPotentials];
            }
            
            [self loadMessages];
        }
        
        // set up navigation menu
        [self.navigationController.navigationBar setHidden:NO];
        [self setNavigationMenu];
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"menu.png"] style:UIBarButtonItemStylePlain target:self action:@selector(onMenu:)];
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    if (self.me) {
        self.hasEnteredInfo = YES;
    } else {
        self.hasEnteredInfo = NO;
    }
    
    // coloring
    self.tableView.backgroundColor = [UIColor blackColor];
    self.tableView.separatorColor = [UIColor colorWithWhite:1.0 alpha:0.3];
    self.navigationController.navigationBar.tintColor = [UIColor colorWithRed:0/255.0f green:182/255.0f blue:170/255.0f alpha:1.0f];
    self.navigationController.navigationBar.barTintColor = [UIColor blackColor];
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor]}];
    self.navigationController.navigationBar.barStyle = UIBarStyleBlackTranslucent;
    
    // assign table view's delegate, data source
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    // register user cell nib
    UINib *nib = [UINib nibWithNibName:@"UserCell" bundle:nil];
    [self.tableView registerNib:nib forCellReuseIdentifier:@"UserCell"];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)removeUser:(User *)user {
    NSLog(@"removing user: %@", user);
    NSLog(@"users before: %@", self.users);
    [self.users removeObject:user];
    NSLog(@"users after: %@", self.users);
    [self.tableView reloadData];
}

# pragma mark - Private methods

- (User *)convertToUser:(NSString *)userId {
    PFQuery *userQuery = [PFQuery queryWithClassName:@"_User"];
    PFObject *fullUserObject = [userQuery getObjectWithId:userId];
    
    if (fullUserObject[@"firstName"] == nil) {
        return NULL;
    }

    NSDictionary *parameters = @{@"pfUser" : fullUserObject,
                                 @"objectId" : userId,
                                 @"username" : fullUserObject[@"username"],
                                 @"email" : fullUserObject[@"email"],
                                 @"firstName" : fullUserObject[@"firstName"],
                                 @"lastName" : fullUserObject[@"lastName"],
                                 @"summary" : fullUserObject[@"summary"],
                                 @"avatarURL" : fullUserObject[@"avatarURL"],
                                 @"isMentor" : fullUserObject[@"isMentor"],
                                 @"skills" : fullUserObject[@"skills"],
                                 @"twitter" : fullUserObject[@"Twitter"],
                                 @"github" : fullUserObject[@"Github"]};
    
    User *user = [[User alloc] init];
    //[user loadSkills:(PFUser *)fullUserObject];
    [user setUserWithDictionary:parameters];
    return user;
}

- (PFUser *)convertToPFUser:(NSString *)userId {
    PFQuery *userQuery = [PFQuery queryWithClassName:@"_User"];
    PFObject *fullUserObject = [userQuery getObjectWithId:userId];
    //NSLog(@"retrieved user: %@", fullUserObject);
    return (PFUser *) fullUserObject;
}

- (void)loadMessages {
    NSLog(@"called load messages");
    PFQuery *receiverQuery = [PFQuery queryWithClassName:@"Messages"];
    [receiverQuery whereKey:@"ReceiverID" equalTo:self.me.pfUser];
    [receiverQuery whereKey:@"isNew" equalTo:@YES];
    [receiverQuery findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (objects && !error) {
            NSLog(@"objects: %@", objects);
            if (objects.count > 0) {
                [TSMessage showNotificationInViewController:self
                                                      title:@"You have new messages."
                                                   subtitle:nil
                                                      image:nil
                                                       type:TSMessageNotificationTypeMessage
                                                   duration:TSMessageNotificationDurationEndless
                                                   callback:nil
                                                buttonTitle:@"Messages"
                                             buttonCallback:^{
                                                 MessageListViewController *mlvc = [[MessageListViewController alloc] init];
                                                 [self.navigationController pushViewController:mlvc animated:NO];
                                             }
                                                 atPosition:TSMessageNotificationPositionTop
                                        canBeDismissedByUser:YES];
                for (PFObject *object in objects) {
                    object[@"isNew"] = @NO;
                    [object saveInBackground];
               }
            }
        }
    }];
}

- (void)loadPotentials {
    PFUser *user = [PFUser currentUser];
    NSString *key, *key1, *key2, *type;
    if (self.showMentor) {
        key = @"MenteeID";
        key1 = @"menteeID";
        key2 = @"mentorID";
        type = @"mentors";
    } else {
        key = @"MentorID";
        key1 = @"mentorID";
        key2 = @"menteeID";
        type = @"mentees";
    }

    // retrieve current user's skills
    PFUser *fullUser = [self convertToPFUser:user.objectId];
    NSArray *skills = fullUser[@"skills"];
    
    if (skills.count > 0) {
        // then find all potential matches with the same skills
        NSMutableArray *subqueries = [[NSMutableArray alloc] init];
        for (NSString *skill in skills) {
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
                
                NSMutableSet *userIds = [[NSMutableSet alloc] init];
                // then add match userID's to userIds set
                for (PFObject *userObject in objects) {
                    PFUser *pfUser = userObject[@"UserID"];
                    [userIds addObject:pfUser.objectId];
                }
                NSLog(@"userIDs: %@", userIds);
                
                // remove users that have requested this user, existing matches
                PFQuery *existingQuery = [PFQuery queryWithClassName:@"Relationships"];
                [existingQuery whereKey:key1 equalTo:user];
                [existingQuery findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
                    NSLog(@"objects: %@", objects);
                    if (!error && objects) {
                        for (PFObject *matchObject in objects) {
                            PFUser *match = matchObject[key2];
                            [userIds removeObject:match.objectId];
                        }
                        
                        // then retrieve full user objects for all userIds
                        for (NSString *userId in userIds) {
                            User *potentialMatch = [self convertToUser:userId];
                            [self.users addObject:potentialMatch];
                        }
                        
                        [self.tableView reloadData];
                    } else if (error) {
                        NSLog(@"error: %@", error.description);
                    }
                }];
        
            } else if (error){
                NSLog(@"error in retrieving potential %@: %@", type, error.description);
            }
        }];
    }
}

- (void)loadMatches {
    PFUser *user = [PFUser currentUser];
    NSString *key1, *key2, *type;
    if (self.showMentor) {
        key1 = @"menteeID"; // if showing mentors, current user is a mentee
        key2 = @"mentorID";
        type = @"mentors";
    } else {
        key1 = @"mentorID"; // if showing mentees, current user is a mentor
        key2 = @"menteeID";
        type = @"mentees";
    }
    
    // perform query in relationships table where current UserID = mentorID if mentor, or current UserID = menteeID if mentee
    PFQuery *query = [PFQuery queryWithClassName:@"Relationships"];
    [query whereKey:key1 equalTo:user];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error && objects) {
                NSLog(@"%@: %@", type, objects);
                
                NSMutableArray *userIds = [[NSMutableArray alloc] init];
                // then add match userID's to userIds set
                for (PFObject *userObject in objects) {
                    PFUser *pfUser = userObject[key2];
                    [userIds addObject:pfUser.objectId];
                }
                NSLog(@"userIDs: %@", userIds);
                
                // then retrieve full user objects for all userIds
                for (NSString *userId in userIds) {
                    User *actualMatch = [self convertToUser:userId];
                    [self.users addObject:actualMatch];
                }
                [self.tableView reloadData];
        } else if (error) {
            NSLog(@"error in retrieving %@: %@", type, error.description);
        }
    }];
}

# pragma mark - Table view methods

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 110;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.users.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UserCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"UserCell" forIndexPath:indexPath];
    User *user = self.users[indexPath.row];
    [cell setUser:user];
    cell.backgroundColor = [UIColor blackColor];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    User *user = self.users[indexPath.row];
    
    PFQuery *requestQuery = [PFQuery queryWithClassName:@"Requests"];
    [requestQuery whereKey:@"RequesterID" equalTo:user.pfUser];
    [requestQuery whereKey:@"RequesteeID" equalTo:self.me.pfUser];
    [requestQuery findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error && objects) {
            ProfileViewController *pvc = [[ProfileViewController alloc] init];
            if (objects.count > 0) {
                pvc.hasRequested = YES;
            } else {
                pvc.hasRequested = NO;
            }
            
//            // modify users you've sent requests to to say "Request Sent"
//            PFQuery *oppositeQuery = [PFQuery queryWithClassName:@"Requests"];
//            [oppositeQuery whereKey:@"RequesterID" equalTo:self.me.pfUser];
//            [oppositeQuery whereKey:@"RequesteeID" equalTo:user.pfUser];
//            [oppositeQuery findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
//                    if (!error && objects) {
//                        if (objects.count > 0) {
//                            pvc.requestedUser = YES;
//                        } else {
//                            pvc.requestedUser = NO;
//                        }
//                
//                        if (self.showMatch) {
//                            pvc.hasRequested = NO;
//                            pvc.isMatch = YES;
//                        }
//                    
//                        pvc.user = user;
//                        pvc.isSelf = NO;
//                        [self.navigationController pushViewController:pvc animated:YES];
//                    } else if (error) {
//                        NSLog(@"error: %@", error.description);
//                    }
//            }];
            
            if (self.showMatch) {
                pvc.hasRequested = NO;
                pvc.isMatch = YES;
            }
            
            pvc.user = user;
            pvc.isSelf = NO;
            [self.navigationController pushViewController:pvc animated:YES];

        } else if (error) {
            NSLog(@"error: %@", error.description);
        }
    }];
}

# pragma mark - Navigation methods

- (void)logInViewController:(PFLogInViewController *)logInController didLogInUser:(PFUser *)user {
    NSLog(@"i'm in!");
    UserListViewController *rvc = self.navigationController.viewControllers[0];
    [rvc viewWillAppear:YES];
    [self.navigationController popToRootViewControllerAnimated:NO];
    [self dismissViewControllerAnimated:YES completion:^{
        NSLog(@"dismissed");
    }];
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
    NSLog(@"currently on %@", self);
    if (self.menu.isOpen) {
        return [self.menu close];
    } else {
        [self.menu showFromNavigationController:self.navigationController];
    }
}

- (void)setNavigationMenu {
    PFUser *user = [PFUser currentUser];
    PFUser *userObject = [self convertToPFUser:user.objectId];
    
    NSString *type = @"Matches", *singular_type = @"Match";
    //NSLog(@"isMentor: %@ // 1 is true", [userObject objectForKey:@"isMentor"]);
    NSNumber *isMentorNumber = (NSNumber *) userObject[@"isMentor"];
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
                                                     pvc.user = self.me;
                                                     pvc.isSelf = YES;
                                                     
                                                     [self.navigationController pushViewController:pvc animated:NO];
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
                                                         
                                                         self.isNewUser = YES;
                                                         
                                                         [self.navigationController pushViewController:pflvc animated:NO];
                                                     }];
    
    if (self.showMatch) {
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
        self.menu = [[REMenu alloc] initWithItems:@[profile, potentials, messages, signOut]];
    } else if (!self.showMatch) {
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
        self.menu = [[REMenu alloc] initWithItems:@[profile, matches, messages, signOut]];
    }
    
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
