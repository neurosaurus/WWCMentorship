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

- (void)viewWillAppear:(BOOL)animated {
    // hide navigation bar
    self.navigationController.navigationBarHidden = YES;
}

- (void)viewWillDisappear:(BOOL)animated {
    // unhide navigation bar
    self.navigationController.navigationBarHidden = NO;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // coloring
    //self.view.backgroundColor = [UIColor blackColor];
    
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

    //[self.view addSubview:listView];
    //[listView showInView:self.view animated:YES];
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
    
    // default values
    if (!self.firstnameTextField.text) {
        self.firstnameTextField.text = @"Foo";
    }
    if (!self.lastnameTextField.text) {
        self.lastnameTextField.text = @"Bar";
    }
    if (!self.summaryTextView.text) {
        self.summaryTextView.text = @"Hello there!";
    }
    if (!self.selectedSkills) {
        self.selectedSkills = [[NSArray alloc] init];
    }

    PFQuery *query = [PFQuery queryWithClassName:@"_User"];
    [query whereKey:@"objectId" equalTo:user.objectId];
    PFObject *object = [query getObjectWithId:user.objectId];
    object[@"firstName"] = self.firstnameTextField.text;
    object[@"lastName"] = self.lastnameTextField.text;
    object[@"summary"] = self.summaryTextView.text;
    object[@"isMentor"] = isMentorObject;
    object[@"skills"] = self.selectedSkills;
    object[@"avatarURL"] = @"https://avatars3.githubusercontent.com/u/99078?s=400";
    
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
