//
//  MessageListViewController.m
//  WWCMentorship
//
//  Created by Tripta Gupta on 4/12/14.
//  Copyright (c) 2014 Tripta Gupta. All rights reserved.
//

#import "MessageListViewController.h"
#import "ProfileFormViewController.h"
#import "ProfileViewController.h"
#import "CustomParseLoginViewController.h"
#import "CustomParseSignupViewController.h"
#import "UserListViewController.h"
#import "MessageRowCell.h"
#import "User.h"
#import "REMenu.h"

@interface MessageListViewController ()

@property (nonatomic, strong) User *me;
@property (nonatomic, strong) NSMutableArray *messages;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic, strong) NSMutableSet *correspondents;
@property (nonatomic, strong) NSMutableDictionary *correspondentNames;
@property (nonatomic, strong) NSMutableDictionary *messageDict;

@property (nonatomic, strong, readwrite) REMenu *menu;

- (void)loadMessages;

@end

@implementation MessageListViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.messages = [[NSMutableArray alloc] init];
        self.correspondents = [[NSMutableSet alloc] init];
        self.correspondentNames = [[NSMutableDictionary alloc] init];
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated {
    [self.messages removeAllObjects];
    [self.correspondentNames removeAllObjects];
    [self.correspondentNames removeAllObjects];
    [self.messageDict removeAllObjects];
    
    [self loadMessages];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // coloring
    self.tableView.tintColor = [UIColor blackColor];
    
    PFUser *user = [PFUser currentUser];
    self.me = [self convertToUser:user.objectId];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    // set up chat controller
    if (!self.chatController) {
        self.chatController = [ChatController new];
        self.chatController.delegate = self;
    }
    
    // register message cell
    UINib *nib = [UINib nibWithNibName:@"MessageRowCell" bundle:nil];
    [self.tableView registerNib:nib forCellReuseIdentifier:@"MessageRowCell"];
    
    [self loadMessages];
    [self setNavigationMenu];
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

- (void)loadMessages {
    // perform query in messages table where current User ID = senderID, receiverID
    PFUser *user = [PFUser currentUser];
    NSLog(@"user: %@", user);
    NSLog(@"one");
    PFQuery *senderQuery = [PFQuery queryWithClassName:@"Messages"];
    [senderQuery whereKey:@"SenderID" equalTo:user];
    [senderQuery findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (objects && !error) {
            NSLog(@"1/objects: %@", objects);
            for (PFObject *correspondent in objects) {
                PFUser *receiver = correspondent[@"ReceiverID"];
                [self.correspondents addObject:receiver];
            }
            
            NSLog(@"two");
            PFQuery *receiverQuery = [PFQuery queryWithClassName:@"Messages"];
            [receiverQuery whereKey:@"ReceiverID" equalTo:user];
            [receiverQuery findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
                if (objects && !error) {
                    NSLog(@"2/objects: %@", objects);
                    for (PFObject *correspondent in objects) {
                        PFUser *sender = correspondent[@"SenderID"];
                        [self.correspondents addObject:sender];
                    }
                    
                    NSLog(@"three");
                    NSLog(@"correspondents: %@", self.correspondents);
                    for (PFUser *correspondent in self.correspondents) {
                        PFQuery *receiverQuery = [PFQuery queryWithClassName:@"Messages"];
                        [receiverQuery whereKey:@"ReceiverID" equalTo:user];
                        [receiverQuery whereKey:@"SenderID" equalTo:correspondent];
                        
                        PFQuery *senderQuery = [PFQuery queryWithClassName:@"Messages"];
                        [senderQuery whereKey:@"ReceiverID" equalTo:correspondent];
                        [senderQuery whereKey:@"SenderID" equalTo:user];
                        
                        PFQuery *query = [PFQuery orQueryWithSubqueries:@[senderQuery, receiverQuery]];
                        [query orderByDescending:@"createdAt"];
                        
                        [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
                            if (!error && objects) {
                                    NSLog(@"messages: %@", objects);
                                
                                    NSMutableArray *messages = [[NSMutableArray alloc] init];
                                
                                    for (PFObject *message in objects) {
                                        [messages addObject:message];
                                    }
                                self.messageDict[correspondent.objectId] = messages;
                                //[self.messageDict setObject:messages forKey:correspondent.objectId];
                                [self.messages addObject:correspondent.objectId];
                                NSString *name = [NSString stringWithFormat:@"%@ %@", correspondent[@"firstName"], correspondent[@"lastName"]];
                                self.correspondentNames[correspondent.objectId] = name;
                                
                                [self.tableView reloadData];
                            } else {
                                NSLog(@"error in retrieving messages: %@", error.description);
                            }
                        }];
                    }

                    
                    
                } else if (error) {
                    NSLog(@"error: %@", error.description);
                }
            }];
            
        } else if (error) {
            NSLog(@"error: %@", error.description);
        }
    }];


    
       }

# pragma mark - Chat controller methods

- (void)chatController:(ChatController *)chatController didSendMessage:(NSMutableDictionary *)message {
    
    NSLog(@"Message Contents: %@", message[kMessageContent]);
    NSLog(@"Timestamp: %@", message[kMessageTimestamp]);
    //NSString *message = message[kMessageContent];
    
    // Evaluate or add to the message here for example, if we wanted to assign the current userId:
    message[@"sentByUserId"] = self.me.objectId;
    
//    PFObject *messageObject = [PFObject objectWithClassName:@"Messages"];
//    messageObject[@"SenderID"] = self.me.pfUser;
//    messageObject[@"ReceiverID"] = self.receiver.pfUser;
//    messageObject[@"Message"] = message;
//    [messageObject saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
//        NSLog(@"success: saved %@ in parse", message);
//    }];
    
    // Must add message to controller for it to show
    [self.chatController addNewMessage:message];
}

# pragma mark - Table view methods

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 80;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.messages.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MessageRowCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"MessageRowCell" forIndexPath:indexPath];
    
    // get name, message
    NSString *correspondentId = self.messages[indexPath.row];
    NSString *name = self.correspondentNames[correspondentId];
    NSMutableArray *messages = self.messageDict[correspondentId];
    NSString *message = messages[0];
    
    // set values in cell
    NSArray *params = @[name, message];
    [cell setPreview:params];
    NSLog(@"CORRESPONDENT: %@", name);
    NSLog(@"WILL DISPLAY: %@", message);
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self.tableView deselectRowAtIndexPath:indexPath animated:NO];
    [self presentViewController:self.chatController animated:YES completion:nil];
}

# pragma mark - Navigation methods

- (void)logInViewController:(PFLogInViewController *)logInController didLogInUser:(PFUser *)user {
    NSLog(@"i'm in!");
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
