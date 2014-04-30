//
//  CustomParseLoginViewController.m
//  WWCMentorship
//
//  Created by Tripta Gupta on 4/20/14.
//  Copyright (c) 2014 Tripta Gupta. All rights reserved.
//

#import "CustomParseLoginViewController.h"

@interface CustomParseLoginViewController ()

@end

@implementation CustomParseLoginViewController

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
    
    self.logInView.logo = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"WWC_small"]];
    
    self.logInView.usernameField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Username" attributes:@{NSForegroundColorAttributeName: [UIColor whiteColor]}];
    self.logInView.usernameField.backgroundColor = [UIColor colorWithRed:0/255.0f green:114/255.0f blue:91/255.0f alpha:0.3];
    
    self.logInView.passwordField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Password" attributes:@{NSForegroundColorAttributeName: [UIColor whiteColor]}];
    self.logInView.passwordField.backgroundColor = [UIColor colorWithRed:0/255.0f green:114/255.0f blue:91/255.0f alpha:0.3];
    
    // Set field text color
    [self.logInView.usernameField setTextColor:[UIColor colorWithWhite:1.0 alpha:0.5]];
    [self.logInView.passwordField setTextColor:[UIColor colorWithWhite:1.0 alpha:0.5]];
    
    self.logInView.logInButton.tintColor = [UIColor darkGrayColor];
    self.logInView.signUpButton.tintColor = [UIColor darkGrayColor];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
