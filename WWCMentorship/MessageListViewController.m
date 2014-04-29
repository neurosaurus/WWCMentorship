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
#import "UIImageView+AFNetworking.h"

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
        self.title = @"Messages";
        self.messages = [[NSMutableArray alloc] init];
        self.messageDict = [[NSMutableDictionary alloc] init];
        self.correspondents = [[NSMutableSet alloc] init];
        self.correspondentNames = [[NSMutableDictionary alloc] init];
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self.messages removeAllObjects];
    [self.correspondentNames removeAllObjects];
    [self.correspondentNames removeAllObjects];
    [self.messageDict removeAllObjects];
    
    [self loadMessages];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // coloring
    self.tableView.backgroundColor = [UIColor blackColor];
    self.tableView.separatorColor = [UIColor colorWithWhite:1.0 alpha:0.3];
    self.navigationController.navigationBar.tintColor = [UIColor colorWithRed:0/255.0f green:182/255.0f blue:170/255.0f alpha:1.0f];

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
    
    [self setNavigationMenu];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"menu.png"] style:UIBarButtonItemStylePlain target:self action:@selector(onMenu:)];
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
            for (PFObject *senderObject in objects) {
                PFUser *receiver = senderObject[@"ReceiverID"];
                [self.correspondents addObject:receiver.objectId];
            }
            
            NSLog(@"two");
            PFQuery *receiverQuery = [PFQuery queryWithClassName:@"Messages"];
            [receiverQuery whereKey:@"ReceiverID" equalTo:user];
            [receiverQuery findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
                if (objects && !error) {
                    NSLog(@"2/objects: %@", objects);
                    for (PFObject *receiverObject in objects) {
                        PFUser *sender = receiverObject[@"SenderID"];
                        [self.correspondents addObject:sender.objectId];
                    }
                    
                    NSLog(@"three");
                    NSLog(@"correspondents: %@", self.correspondents);
                    for (NSString *correspondent in self.correspondents) {
                        PFUser *correspondentUser = [self convertToPFUser:correspondent];
                        
                        PFQuery *receiverQuery = [PFQuery queryWithClassName:@"Messages"];
                        [receiverQuery whereKey:@"ReceiverID" equalTo:user];
                        [receiverQuery whereKey:@"SenderID" equalTo:correspondentUser];
                        
                        PFQuery *senderQuery = [PFQuery queryWithClassName:@"Messages"];
                        [senderQuery whereKey:@"ReceiverID" equalTo:correspondentUser];
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
                            
                                [self.messages addObject:correspondent]; // key is correspondent objectId
                                [self.messageDict setValue:messages forKey:correspondent]; // key is correspondent objectId
                                
                                NSString *name = [NSString stringWithFormat:@"%@ %@", correspondentUser[@"firstName"], correspondentUser[@"lastName"]];
                                [self.correspondentNames setValue:name forKey:correspondent];
                                
                                //NSLog(@"self.messages: %@", self.messages);
                                //NSLog(@"self.corrNames: %@", self.correspondentNames);
                                //NSLog(@"self.messageDict: %@", self.messageDict);
                                
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
    NSString *msgText = (NSString *) message[kMessageContent];
    
    // Evaluate or add to the message here for example, if we wanted to assign the current userId:
    message[@"sentByUserId"] = self.me.objectId;
    message[@"kMessageRuntimeSentBy"] = [NSNumber numberWithInt:kSentByUser];
    message[@"runtimeSentBy"] = [NSNumber numberWithInt:kSentByUser];
    
    PFObject *messageObject = [PFObject objectWithClassName:@"Messages"];
    messageObject[@"SenderID"] = self.me.pfUser;
    PFUser *receiverUser = [self convertToPFUser:self.chatController.currentUserId];
    messageObject[@"ReceiverID"] = receiverUser;
    messageObject[@"Message"] = msgText;
    messageObject[@"isNew"] = @YES;
    [messageObject saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        NSLog(@"success: saved %@ in parse", message);
    }];
    
    // Must add message to controller for it to show
    [self.chatController addNewMessage:message];
}

# pragma mark - Table view methods

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 45;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.messages.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MessageRowCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"MessageRowCell" forIndexPath:indexPath];
    
    // coloring
    cell.backgroundColor = [UIColor blackColor];
    
    // get name, message
    NSLog(@"loading cell %d", indexPath.row);
    NSString *correspondentId = self.messages[indexPath.row];
    NSString *name = self.correspondentNames[correspondentId];
    NSMutableArray *messages = self.messageDict[correspondentId];
    NSString *message = messages[0][@"Message"];
    
    // set values in cell
    NSArray *params = @[name, message];
    [cell setPreview:params];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self.tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    // get name, message
    NSString *correspondentId = self.messages[indexPath.row];
    NSString *name = self.correspondentNames[correspondentId];
    NSMutableArray *messages = self.messageDict[correspondentId];
    PFUser *correspondent;
    NSLog(@"c: %@", correspondent);
    
    NSMutableArray *mutableMessages = [[NSMutableArray alloc] init];
    NSArray *firstToLastArray = [[messages reverseObjectEnumerator] allObjects];
    for (PFObject *message in firstToLastArray) {
        NSMutableDictionary *dict = [@{kMessageContent : message[@"Message"]} mutableCopy];
        if ([((PFUser *)message[@"SenderID"]).objectId isEqualToString:self.me.objectId]) {
            [dict setValue:[NSNumber numberWithInt:kSentByUser] forKey:kMessageRuntimeSentBy];
            
            if (!correspondent) {
                correspondent = message[@"ReceiverID"];
            }
        } else if ([((PFUser *)message[@"ReceiverID"]).objectId isEqualToString:self.me.objectId]) {
            [dict setValue:[NSNumber numberWithInt:kSentByOpponent] forKey:kMessageRuntimeSentBy];
            
            if (!correspondent) {
                correspondent = message[@"SenderID"];
            }
        }
        
        [mutableMessages addObject:dict];
    }
    
    //NSLog(@"avatarURL: %@", correspondent[@"avatarURL"]);
    //NSData * data = [NSData dataWithContentsOfURL:[NSURL URLWithString:correspondent[@"avatarURL"]]];
    //self.chatController.opponentImg = [UIImage imageWithData:data];
    
    [self.chatController setMessagesArray:mutableMessages];
    [self.chatController setChatTitle:name];
    self.chatController.currentUserId = correspondentId; // actually the receiver id
    self.chatController.tintColor = [UIColor blackColor];
    [self presentViewController:self.chatController animated:NO completion:nil];
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
                                                         
                                                         UserListViewController *rvc = self.navigationController.viewControllers[0];
                                                         rvc.isNewUser = YES;
                                                         
                                                         [self.navigationController pushViewController:pflvc animated:NO];
                                                     }];
    
    self.menu = [[REMenu alloc] initWithItems:@[profile, potentials, matches, signOut]];
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
