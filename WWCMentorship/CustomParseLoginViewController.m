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

    //    self.signUpView.logo = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"WWC"]];
    
    self.logInView.usernameField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Username" attributes:@{NSForegroundColorAttributeName: [UIColor whiteColor]}];
    self.logInView.usernameField.backgroundColor = [UIColor colorWithRed:0/255.0f green:114/255.0f blue:91/255.0f alpha:1.0f];
    
    self.logInView.passwordField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Password" attributes:@{NSForegroundColorAttributeName: [UIColor whiteColor]}];
    self.logInView.passwordField.backgroundColor = [UIColor colorWithRed:0/255.0f green:114/255.0f blue:91/255.0f alpha:1.0f];

    self.logInView.signUpButton.backgroundColor = [UIColor colorWithRed:0/255.0f green:114/255.0f blue:91/255.0f alpha:1.0f];
    
    // Set field text color
    [self.logInView.usernameField setTextColor:[UIColor colorWithWhite:1.0 alpha:0.5]];
    [self.logInView.passwordField setTextColor:[UIColor colorWithWhite:1.0 alpha:0.5]];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
