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
    
    UIImage *logo = [UIImage imageNamed:@"WWC Icon"];
    CGRect rect = CGRectMake(0.0f, 40.0f, logo.size.width, logo.size.height);
    UIImageView *logoView = [[UIImageView alloc] initWithFrame:rect];
    [logoView setImage:logo];
    self.signUpView.logo = logoView;
    
    self.view.backgroundColor = [UIColor blackColor];
    self.signUpView.usernameField.backgroundColor = [UIColor blackColor];
    self.signUpView.passwordField.backgroundColor = [UIColor blackColor];
    self.signUpView.emailField.backgroundColor = [UIColor blackColor];
    //self.signUpView.usernameField.backgroundColor = [UIColor colorWithWhite:1.0 alpha:0.3];
    //self.signUpView.passwordField.backgroundColor = [UIColor colorWithWhite:1.0 alpha:0.3];
    //self.signUpView.emailField.backgroundColor = [UIColor colorWithWhite:1.0 alpha:0.3];
    //self.signUpView.logo = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"WWC Icon"]];
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
