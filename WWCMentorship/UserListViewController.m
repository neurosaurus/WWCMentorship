//
//  UserListViewController.m
//  WWCMentorship
//
//  Created by Tripta Gupta on 4/12/14.
//  Copyright (c) 2014 Tripta Gupta. All rights reserved.
//

#import "UserListViewController.h"

@interface UserListViewController ()

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *users;

@end

@implementation UserListViewController

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
    
    // for now, don't run
    self.showMatch = NO;
    if (self.showMatch) {
        [self loadMatches];
    } else {
        [self loadPotentials];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

# pragma mark - Private methods

- (void)loadPotentials {
    NSString *type;
    if (self.showMentor) {
        type = @"mentors";
    } else {
        type = @"mentees";
    }
    
    // perform query to find potential matches
    PFQuery *query = [PFQuery queryWithClassName:@"Skills"];
    [query whereKey:@"MentorID" equalTo:@"userID"];
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

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.users.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [[UITableViewCell alloc] init];
    return cell;
}

@end
