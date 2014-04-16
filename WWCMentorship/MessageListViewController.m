//
//  MessageListViewController.m
//  WWCMentorship
//
//  Created by Tripta Gupta on 4/12/14.
//  Copyright (c) 2014 Tripta Gupta. All rights reserved.
//

#import "MessageListViewController.h"

@interface MessageListViewController ()

@property (nonatomic, strong) NSMutableArray *messages;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

- (void)loadMessages;

@end

@implementation MessageListViewController

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
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
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
    PFQuery *senderQuery = [PFQuery queryWithClassName:@"Messages"];
    [senderQuery whereKey:@"SenderID" equalTo:@"userID"];
    
    PFQuery *receiverQuery = [PFQuery queryWithClassName:@"Messages"];
    [receiverQuery whereKey:@"ReceiverID" equalTo:@"userID"];
    
    PFQuery *query = [PFQuery orQueryWithSubqueries:@[senderQuery, receiverQuery]];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            if (objects) {
                NSLog(@"messages: %@", objects);
                
                // process messages object with array
                
                [self.tableView reloadData];
            } else {
                NSLog(@"no messages :(");
            }
        } else {
            NSLog(@"error in retrieving messages: %@", error.description);
        }
    }];
}

# pragma mark - Table view methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.messages.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [[UITableViewCell alloc] init];
    return cell;
}

@end
