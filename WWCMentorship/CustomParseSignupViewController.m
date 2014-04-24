//
//  CustomParseSignupViewController.m
//  WWCMentorship
//
//  Created by Tripta Gupta on 4/20/14.
//  Copyright (c) 2014 Tripta Gupta. All rights reserved.
//

#import "CustomParseSignupViewController.h"

@interface CustomParseSignupViewController ()

@end

@implementation CustomParseSignupViewController

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
    
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"WWC Icon"]];
    self.signUpView.usernameField.backgroundColor = [UIColor colorWithWhite:1.0 alpha:0.3];
    self.signUpView.passwordField.backgroundColor = [UIColor colorWithWhite:1.0 alpha:0.3];
    self.signUpView.emailField.backgroundColor = [UIColor colorWithWhite:1.0 alpha:0.3];
    self.signUpView.logo = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"None"]];
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
