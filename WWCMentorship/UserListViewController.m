//
//  UserListViewController.m
//  WWCMentorship
//
//  Created by Tripta Gupta on 4/12/14.
//  Copyright (c) 2014 Tripta Gupta. All rights reserved.
//

#import "UserListViewController.h"
#import "UserCell.h"

@interface UserListViewController ()

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
    
    // assign table view's delegate, data source
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    // register user cell nib
    UINib *nib = [UINib nibWithNibName:@"UserCell" bundle:nil];
    [self.tableView registerNib:nib forCellReuseIdentifier:@"UserCell"];
    
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

@end
