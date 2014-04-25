//
//  MessageListViewController.m
//  WWCMentorship
//
//  Created by Tripta Gupta on 4/12/14.
//  Copyright (c) 2014 Tripta Gupta. All rights reserved.
//

#import "MessageListViewController.h"
#import "MessageRowCell.h"

@interface MessageListViewController ()

@property (nonatomic, strong) NSMutableArray *messages;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic, strong) NSMutableSet *correspondents;
@property (nonatomic, strong) NSMutableDictionary *messageDict;

- (void)loadMessages;

@end

@implementation MessageListViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.messages = [[NSMutableArray alloc] init];
        self.correspondents = [[NSMutableSet alloc] init];
    }
    return self;
}

- (void)viewDidLoad
{
    NSLog(@"view did load");
    [super viewDidLoad];
    
    // coloring
    self.tableView.tintColor = [UIColor blackColor];
    
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
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

# pragma mark - Private methods

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
                                [self.messageDict setObject:messages forKey:correspondent.objectId];
                                [self.messages addObject:correspondent.objectId];
                                
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

# pragma mark - Table view methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.messages.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MessageRowCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"MessageRowCell" forIndexPath:indexPath];
    NSString *correspondentId = self.messages[indexPath.row];
    NSMutableArray *messages = self.messageDict[correspondentId];
    NSString *toDisplay = messages[0];
    NSLog(@"CORRESPONDENT: %@", correspondentId);
    NSLog(@"WILL DISPLAY: %@", toDisplay);
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self.tableView deselectRowAtIndexPath:indexPath animated:NO];
    [self presentViewController:self.chatController animated:YES completion:nil];
}

@end
