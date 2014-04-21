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

@property (nonatomic, strong) NSMutableArray *selectedList;
- (IBAction)onSave:(id)sender;

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
    
    NSDictionary *info = [[NSBundle mainBundle] infoDictionary];
    NSString *bundleName = [NSString stringWithFormat:@"%@", [info objectForKey:@"CFbundleDisplayName"]];
    self.title = bundleName;
}

#pragma mark - Array list
- (NSArray *)list
{
    return [NSArray arrayWithObjects:@"Objective-C", @"Android", @"Ruby", nil];
}

- (IBAction)skillsButton:(id)sender
{
    float paddingTopBottom = 20.0f;
    float paddingLeftRight = 20.0f;
    
    CGPoint point = CGPointMake(paddingLeftRight,
                                (self.navigationController.navigationBar.frame.size.height + paddingTopBottom) + paddingTopBottom);
    CGSize size = CGSizeMake((self.view.frame.size.width - (paddingLeftRight * 2)), self.view.frame.size.height - ((self.navigationController.navigationBar.frame.size.height + paddingTopBottom) + (paddingTopBottom * 2)));
    
    LPPopupListView *listView = [[LPPopupListView alloc] initWithTitle:@"Skills" list:[self list] selectedList:self.selectedList point:point size:size multipleSelection:YES];
    listView.delegate = self;
    
    [listView showInView:self.navigationController.view animated:YES];
}

- (void)popupListView:(LPPopupListView *)popUpListView didSelectedIndex:(NSInteger)index
{
    NSLog(@"popUpListView - didSelectedIndex: %d", index);
}

- (void)popupListViewDidHide:(LPPopupListView *)popUpListView selectedList:(NSArray *)list
{
    NSLog(@"popupListViewDidHide - selectedList: %@", list.description);
    
    self.selectedList = [NSMutableArray arrayWithArray:list];
    
    self.textView.text = self.selectedList.description;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)onSave:(id)sender {
    // for testing
    self.firstnameTextField.text = @"firstname - test";
    self.lastnameTextField.text = @"lastname - test";
    self.summaryTextView.text = @"test";
    
    NSLog(@"Saving User Info");
    PFUser *user = [PFUser currentUser];
    
    PFQuery *query = [PFQuery queryWithClassName:@"_User"];
    [query whereKey:@"objectId" equalTo:user.objectId];
    PFObject *object = [query getObjectWithId:user.objectId];
    NSLog(@"user: %@", object);
    [object setObject:self.firstnameTextField.text forKey:@"firstName"];
    [object setObject:self.lastnameTextField.text forKey:@"lastName"];
    [object setObject:self.summaryTextView.text forKey:@"summary"];
    [object setObject:@YES forKey:@"isMentor"];
    
    // save to Parse
    [object saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        NSLog(@"User Saved to Parse");
    }];
    
    [self dismissViewControllerAnimated:YES completion:nil];
}
@end
