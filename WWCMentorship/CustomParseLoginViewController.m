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
    
    UIImage *logo = [UIImage imageNamed:@"WWC Icon"];
    CGRect rect = CGRectMake(0.0f, 40.0f, logo.size.width, logo.size.height);
    UIImageView *logoView = [[UIImageView alloc] initWithFrame:rect];
    [logoView setImage:logo];
    self.logInView.logo = logoView;
    
    self.view.backgroundColor = [UIColor blackColor];
    self.logInView.usernameField.backgroundColor = [UIColor blackColor];
    self.logInView.passwordField.backgroundColor = [UIColor blackColor];
    
    //self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"WWC Icon"]];
    //self.logInView.usernameField.backgroundColor = [UIColor colorWithWhite:1.0 alpha:0.3];
    //self.logInView.passwordField.backgroundColor = [UIColor colorWithWhite:1.0 alpha:0.3];
    //self.logInView.logo = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"None"]];
    
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
