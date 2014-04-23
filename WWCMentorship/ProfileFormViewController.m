//
//  ProfileFormViewController.m
//  WWCMentorship
//
//  Created by Tripta Gupta on 4/12/14.
//  Copyright (c) 2014 Tripta Gupta. All rights reserved.
//

#import "ProfileFormViewController.h"

@interface ProfileFormViewController ()

@property (weak, nonatomic) IBOutlet UITextField *firstnameTextField;
@property (weak, nonatomic) IBOutlet UITextField *lastnameTextField;
@property (weak, nonatomic) IBOutlet UITextView *summaryTextView;
@property (weak, nonatomic) IBOutlet UISegmentedControl *isMentorControl;
@property (nonatomic, strong) NSMutableArray *selectedList;

@property (nonatomic, assign) BOOL isMentor;
@property (nonatomic, strong) NSArray *selectedSkills;

- (IBAction)onSave:(id)sender;
- (IBAction)onTap:(id)sender;

@end

@implementation ProfileFormViewController

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
    
    // hide navigation bar
    [self.navigationController.navigationBar setHidden:YES];
    
    NSDictionary *info = [[NSBundle mainBundle] infoDictionary];
    NSString *bundleName = [NSString stringWithFormat:@"%@", [info objectForKey:@"CFbundleDisplayName"]];
    self.title = bundleName;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

# pragma mark - Pop-up modal methods

- (NSArray *)list {
    return [NSArray arrayWithObjects:@"iOS / Objective-C", @"Android", @"Java", @"Ruby on Rails", @"Python", @"HTML / CSS", @"Javascript", @"Algorithms", nil];
}

- (IBAction)skillsButton:(id)sender {
    float paddingTopBottom = 20.0f;
    float paddingLeftRight = 20.0f;
    
    
    CGPoint point = CGPointMake(paddingLeftRight,
                                (self.navigationController.navigationBar.frame.size.height + paddingTopBottom) + paddingTopBottom);
    CGSize size = CGSizeMake((self.view.frame.size.width - (paddingLeftRight * 2)), self.view.frame.size.height - ((self.navigationController.navigationBar.frame.size.height + paddingTopBottom) + (paddingTopBottom * 2)));
    
    LPPopupListView *listView = [[LPPopupListView alloc] initWithTitle:@"Skills" list:[self list] selectedList:self.selectedList point:point size:size multipleSelection:YES];
    listView.delegate = self;

    [self.navigationController.view addSubview:listView];
    [listView showInView:self.navigationController.view animated:YES];
}

- (void)popupListView:(LPPopupListView *)popUpListView didSelectedIndex:(NSInteger)index {
    NSLog(@"popUpListView - didSelectedIndex: %d", index);
}

- (void)popupListViewDidHide:(LPPopupListView *)popUpListView selectedList:(NSArray *)list {
    NSLog(@"popupListViewDidHide - selectedList: %@", list.description);
    
    self.selectedSkills = list;
    self.selectedList = [NSMutableArray arrayWithArray:list];
    self.textView.text = self.selectedList.description;
}

# pragma mark - Private methods

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [self.firstnameTextField resignFirstResponder];
    [self.lastnameTextField resignFirstResponder];
    [self.summaryTextView resignFirstResponder];
}

- (IBAction)onSave:(id)sender {
    NSLog(@"starting to save");
    PFUser *user = [PFUser currentUser];
    id isMentorObject;
    if (self.isMentor) {
        isMentorObject = @YES;
    } else {
        isMentorObject = @NO;
    }
    
    // for testing only
    NSLog(@"first name will be: %@", self.firstnameTextField.text);
    NSLog(@"last name will be: %@", self.lastnameTextField.text);
    NSLog(@"summary will be: %@", self.summaryTextView.text);
    NSLog(@"isMentor will be: %@", isMentorObject);

    PFQuery *query = [PFQuery queryWithClassName:@"_User"];
    [query whereKey:@"objectId" equalTo:user.objectId];
    PFObject *object = [query getObjectWithId:user.objectId];
    object[@"firstName"] = self.firstnameTextField.text;
    object[@"lastName"] = self.lastnameTextField.text;
    object[@"summary"] = self.summaryTextView.text;
    object[@"isMentor"] = isMentorObject;
    
    // save to Parse
    [object saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        NSLog(@"success: saved updated user to parse");
    }];
    
    for (NSString *skill in self.selectedSkills) {
        NSLog(@"adding %@ to Skills table", skill);
        PFObject *skillObject = [PFObject objectWithClassName:@"Skills"];
        skillObject[@"UserID"] = user;
        skillObject[@"Name"] = skill;
        skillObject[@"isMentor"] = isMentorObject;
        [skillObject saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            NSLog(@"success: saved %@ in parse", skill);
        }];
    }
    
    [self.navigationController popToRootViewControllerAnimated:NO];
    [self.navigationController.navigationBar setHidden:NO];
}

- (IBAction)onTap:(id)sender {
    [self.view endEditing:YES]; 
    
    if (self.isMentorControl.selectedSegmentIndex == 0) {
        self.isMentor = YES;
        NSLog(@"setting to isMentor to YES");
    } else if (self.isMentorControl.selectedSegmentIndex == 1) {
        self.isMentor = NO;
        NSLog(@"setting to isMentor to NO");
    }
}

@end
