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
@property (weak, nonatomic) IBOutlet UITextField *emailTextField;
@property (weak, nonatomic) IBOutlet UITextField *summaryTextField;

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
    self.navigationItem.title = @"Your Profile";
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Save" style:UIBarButtonItemStyleDone target:self action:@selector(onSave)];
}

- (void)onSave
{
    NSLog(@"Saving User Info");
    //Create a user
    PFObject *newUser = [PFObject objectWithClassName:@"User"];
    newUser[@"FirstName"]          = self.firstnameTextField;
    newUser[@"LastName"]           = self.lastnameTextField;
    newUser[@"Email"]              = self.emailTextField;
    newUser[@"Description"]        = self.summaryTextField;
    
    // Save to Parse
    [newUser saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        NSLog(@"User Saved to Parse");
    }];
    
    // Dismiss and go back to WeddingInfoView
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
