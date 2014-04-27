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
    
    [self.logInView setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"WWC Icon"]]];
    //    UIImage *logo = [UIImage imageNamed:@"WWC Icon"];
    //    CGRect rect = CGRectMake(0.0f, 40.0f, logo.size.width, logo.size.height);
    //    UIImageView *logoView = [[UIImageView alloc] initWithFrame:rect];
    //    [logoView setImage:logo];
    //    self.signUpView.logo = logoView;
    //
    //    self.view.backgroundColor = [UIColor blackColor];
    
    self.logInView.usernameField.backgroundColor = [UIColor colorWithRed:0/255.0f green:182/255.0f blue:170/255.0f alpha:1.0f];
    self.logInView.passwordField.backgroundColor = [UIColor colorWithRed:0/255.0f green:182/255.0f blue:170/255.0f alpha:1.0f];
//    self.logInView.emailField.backgroundColor = [UIColor blackColor];
    self.logInView.logo = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"None"]];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
