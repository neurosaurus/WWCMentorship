//
//  SkillsViewController.m
//  WWCMentorship
//
//  Created by Tripta Gupta on 4/18/14.
//  Copyright (c) 2014 Tripta Gupta. All rights reserved.
//

#import "SkillsViewController.h"

@interface SkillsViewController ()

@property (nonatomic, strong) NSMutableArray *selectedList;

@end

@implementation SkillsViewController

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


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Array list

- (NSArray *)list
{
    return [NSArray arrayWithObjects:@"Objective-C", @"Android", @"Ruby", nil];
}

#pragma mark - Button

- (IBAction)buttonClicked:(id)sender
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

@end
