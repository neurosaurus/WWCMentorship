////
////  LoginViewController.m
////  WWCMentorship
////
////  Created by Tripta Gupta on 4/7/14.
////  Copyright (c) 2014 Tripta Gupta. All rights reserved.
////
//
//#import "LoginViewController.h"
//#import "ProfileFormViewController.h"
//
//@interface LoginViewController ()
//
//@property (weak, nonatomic) IBOutlet UILabel *usernameLabel;
//@property (weak, nonatomic) IBOutlet UIButton *loginButton;
//@property (weak, nonatomic) IBOutlet UIButton *profileButton;
//
//- (IBAction)onLogin:(id)sender;
//- (IBAction)onProfile:(id)sender;
//
//@end
//
//@implementation LoginViewController
//
//- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
//{
//    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
//    if (self) {
//        // Custom initialization
//    }
//    return self;
//}
//
//- (void)viewDidLoad
//{
//    [super viewDidLoad];
//    [self updateLoginLabelAndButton];
//}
//
//- (void)didReceiveMemoryWarning
//{
//    [super didReceiveMemoryWarning];
//    // Dispose of any resources that can be recreated.
//}
//
//- (IBAction)onLogin:(id)sender
//{
//    if (![PFUser currentUser]) { // No user logged in
//        // Create the log in view controller
//        PFLogInViewController *logInViewController = [[PFLogInViewController alloc] init];
//        [logInViewController setDelegate:self]; // Set ourselves as the delegate
//        
//        // Create the sign up view controller
//        PFSignUpViewController *signUpViewController = [[PFSignUpViewController alloc] init];
//        [signUpViewController setDelegate:self]; // Set ourselves as the delegate
//
//        // Assign our sign up controller to be displayed from the login controller
//        [logInViewController setSignUpController:signUpViewController];
//        
//        // Present the log in view controller
//        [self presentViewController:logInViewController animated:YES completion:NULL];
//    }
//    else {
//        [PFUser logOut];
//        [self updateLoginLabelAndButton];
//    }
//}
//
//- (IBAction)onProfile:(id)sender
//{
//    ProfileFormViewController *pvc = [[ProfileFormViewController alloc] init];
//    [self.navigationController pushViewController:pvc animated:YES];
//}
//
//- (void)viewDidAppear:(BOOL)animated
//{
//    [super viewDidAppear:animated];
//    
//}
//
//-(void)updateLoginLabelAndButton
//{
//    if([PFUser currentUser]) {
//        self.loginButton.titleLabel.text=@"Logout";
//        self.usernameLabel.text = [[PFUser currentUser] username];
//    }
//    else {
//        self.loginButton.titleLabel.text=@"Login";
//        self.usernameLabel.text = @"Not logged in";
//    }
//}
//
//
//// Sent to the delegate to determine whether the log in request should be submitted to the server.
//- (BOOL)logInViewController:(PFLogInViewController *)logInController shouldBeginLogInWithUsername:(NSString *)username password:(NSString *)password
//{
//    // Check if both fields are completed
//    if (username && password && username.length != 0 && password.length != 0) {
//        return YES; // Begin login process
//    }
//    
//    [[[UIAlertView alloc] initWithTitle:@"Missing Information"
//                                message:@"Make sure you fill out all of the information!"
//                               delegate:nil
//                      cancelButtonTitle:@"ok"
//                      otherButtonTitles:nil] show];
//    return NO; // Interrupt login process
//}
//
//// Sent to the delegate when a PFUser is logged in.
//- (void)logInViewController:(PFLogInViewController *)logInController didLogInUser:(PFUser *)user
//{
//    [self dismissViewControllerAnimated:YES completion:NULL];
//    [self updateLoginLabelAndButton];
//}
//
//// Sent to the delegate when the log in attempt fails.
//- (void)logInViewController:(PFLogInViewController *)logInController didFailToLogInWithError:(NSError *)error {
//    NSLog(@"Failed to log in...");
//    [self updateLoginLabelAndButton];
//}
//
//// Sent to the delegate when the log in screen is dismissed.
//- (void)logInViewControllerDidCancelLogIn:(PFLogInViewController *)logInController {
//    [self.navigationController popViewControllerAnimated:YES];
//    [self updateLoginLabelAndButton];
//}
//
//
//#pragma mark PFSignUpViewControllerDelegate
//
//// Sent to the delegate to determine whether the sign up request should be submitted to the server.
//- (BOOL)signUpViewController:(PFSignUpViewController *)signUpController shouldBeginSignUp:(NSDictionary *)info {
//    BOOL informationComplete = YES;
//    
//    // loop through all of the submitted data
//    for (id key in info) {
//        NSString *field = [info objectForKey:key];
//        if (!field || field.length == 0) { // check completion
//            informationComplete = NO;
//            break;
//        }
//    }
//    
//    // Display an alert if a field wasn't completed
//    if (!informationComplete) {
//        [[[UIAlertView alloc] initWithTitle:@"Missing Information"
//                                    message:@"Make sure you fill out all of the information!"
//                                   delegate:nil
//                          cancelButtonTitle:@"ok"
//                          otherButtonTitles:nil] show];
//    }
//    
//    return informationComplete;
//}
//
//// Sent to the delegate when a PFUser is signed up.
//- (void)signUpViewController:(PFSignUpViewController *)signUpController didSignUpUser:(PFUser *)user {
//    [self dismissViewControllerAnimated:YES completion:^{} ]; // Dismiss the PFSignUpViewController
//    [self updateLoginLabelAndButton];
//}
//
//// Sent to the delegate when the sign up attempt fails.
//- (void)signUpViewController:(PFSignUpViewController *)signUpController didFailToSignUpWithError:(NSError *)error
//{
//    NSLog(@"Failed to sign up...");
//    [self updateLoginLabelAndButton];
//}
//
//// Sent to the delegate when the sign up screen is dismissed.
//- (void)signUpViewControllerDidCancelSignUp:(PFSignUpViewController *)signUpController
//{
//    NSLog(@"User dismissed the signUpViewController");
//    [self updateLoginLabelAndButton];
//}
//@end
