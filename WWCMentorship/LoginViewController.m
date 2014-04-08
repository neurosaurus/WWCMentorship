//
//  LoginViewController.m
//  WWCMentorship
//
//  Created by Tripta Gupta on 4/7/14.
//  Copyright (c) 2014 Tripta Gupta. All rights reserved.
//

#import "LoginViewController.h"

@interface LoginViewController ()

@property (weak, nonatomic) IBOutlet UITextField *usernameTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;

- (IBAction)submitButton:(id)sender;

@end

@implementation LoginViewController

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
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)submitButton:(id)sender
{
    NSString *usernameString = self.usernameTextField.text;
    NSString *passwordString = self.passwordTextField.text;
    
    PFQuery *query = [PFQuery queryWithClassName:@"User"];
    [query whereKey:@"username" equalTo:@"stephanie"];
    [query whereKey:@"password" equalTo:@"678901"];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error && objects && objects.count == 1) {
            NSLog(@"found stephanie");
        } else {
            NSLog(@"no stephanie here");
        }
    }];
    
}
@end
