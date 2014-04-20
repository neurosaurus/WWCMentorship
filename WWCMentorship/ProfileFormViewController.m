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
@property (weak, nonatomic) IBOutlet UIPickerView *genderPick;

@property (nonatomic, strong) NSMutableArray *selectedList;

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

- (void)onSave
{
    NSLog(@"Saving User Info");
    //Create a user
    PFObject *newUser = [PFObject objectWithClassName:@"User"];
    newUser[@"FirstName"]          = self.firstnameTextField;
    newUser[@"LastName"]           = self.lastnameTextField;
    newUser[@"Description"]        = self.summaryTextView;
    newUser[@"Gender"]             = self.genderPick;
    
    // Save to Parse
    [newUser saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        NSLog(@"User Saved to Parse");
    }];
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
