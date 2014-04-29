//
//  ComposeViewController.m
//  WWCMentorship
//
//  Created by Stephanie Szeto on 4/24/14.
//  Copyright (c) 2014 Tripta Gupta. All rights reserved.
//

#import "ComposeViewController.h"
#import "UserListViewController.h"
#import "AFNetworking.h"
#import "UIImageView+AFNetworking.h"
#import "TSMessage.h"

@interface ComposeViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *avatar;
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UITextView *message;
@property (weak, nonatomic) IBOutlet UIView *messageBox;
@property (weak, nonatomic) IBOutlet UIButton *sendButton;

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

- (IBAction)onSendButton:(id)sender;

@end

@implementation ComposeViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = @"Compose";
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    // register for keyboard notifications
    //[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWasShown:) name:UIKeyboardDidShowNotification object:nil];
    //[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillBeHidden:) name:UIKeyboardDidHideNotification object:nil];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    // unregister for keyboard notifications
    //[[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardDidShowNotification object:nil];
    //[[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardDidHideNotification object:nil];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // coloring
    self.view.backgroundColor = [UIColor blackColor];
    self.message.backgroundColor = [UIColor blackColor];
    self.message.textColor = [UIColor whiteColor];
    self.name.textColor = [UIColor whiteColor];
    self.sendButton.tintColor = [UIColor colorWithRed:0/255.0f green:182/255.0f blue:170/255.0f alpha:1.0f];
    
    CALayer *boxLayer = self.messageBox.layer;
    boxLayer.borderWidth = 0.5;
    boxLayer.borderColor = [[UIColor whiteColor] CGColor];
    
    self.message.delegate = self;
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onCustomTap:)];
    [self.view addGestureRecognizer:tapGestureRecognizer];
    
    CALayer *avatarLayer = self.avatar.layer;
    avatarLayer.cornerRadius = self.avatar.frame.size.width / 2;
    avatarLayer.borderColor = [[UIColor whiteColor] CGColor];
    avatarLayer.borderWidth = 0.5;
    avatarLayer.masksToBounds = YES;
    [self.avatar setImageWithURL:self.receiver.avatarURL];
    
    self.name.text = self.receiver.name;
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"back.png"] style:UIBarButtonItemStylePlain target:self action:@selector(popNavigationItemAnimated:)];
    
    //CGRect fullScreenRect = [[UIScreen mainScreen] applicationFrame];
    //self.scrollView = [[UIScrollView alloc] initWithFrame:fullScreenRect];
    //self.scrollView.contentSize = CGSizeMake(320,758);
    
    //[self.scrollView addSubview:self.avatar];
    //[self.scrollView addSubview:self.name];
    //[self.scrollView addSubview:self.message];
    //[self.scrollView addSubview:self.messageBox];
    
    // do any further configuration to the scroll view
    // add a view, or views, as a subview of the scroll view.
    
    // release scrollView as self.view retains it
    //self.view = self.scrollView;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

// Called when the UIKeyboardDidShowNotification is sent.
- (void)keyboardWasShown:(NSNotification*)aNotification {
    CGSize keyboardSize = [[[aNotification userInfo] objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    UIEdgeInsets contentInsets = UIEdgeInsetsMake(0.0, 0.0, keyboardSize.height, 0.0);
    
    self.scrollView.contentInset = contentInsets;
    self.scrollView.scrollIndicatorInsets = contentInsets;
    
    CGRect rect = self.view.frame; rect.size.height -= keyboardSize.height;
    
    if (!CGRectContainsPoint(rect, self.message.frame.origin)) {
        CGPoint scrollPoint = CGPointMake(0.0, self.message.frame.origin.y - (keyboardSize.height - self.message.frame.size.height));
        [self.scrollView setContentOffset:scrollPoint animated:NO];
    }
}

// Called when the UIKeyboardWillHideNotification is sent
- (void)keyboardWillBeHidden:(NSNotification*)aNotification
{
    UIEdgeInsets contentInsets = UIEdgeInsetsZero;
    self.scrollView.contentInset = contentInsets;
    self.scrollView.scrollIndicatorInsets = contentInsets;
}

# pragma mark - Private methods

- (BOOL)textViewShouldEndEditing:(UITextView *)textView {
    [textView resignFirstResponder];
    return YES;
}

- (void)onCustomTap:(UITapGestureRecognizer *)tapGestureRecognizer {
    [self.message endEditing:YES];
    //[self textViewDidEndEditing:self.message];
}

- (IBAction)onSendButton:(id)sender {
    PFObject *messageObject = [PFObject objectWithClassName:@"Messages"];
    messageObject[@"SenderID"] = self.sender.pfUser;
    messageObject[@"ReceiverID"] = self.receiver.pfUser;
    messageObject[@"Message"] = self.message.text;
    messageObject[@"isNew"] = @YES;
    [messageObject saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        NSLog(@"success: saved %@ in parse", self.message.text);
    }];
    
    UserListViewController *rvc = self.navigationController.viewControllers[0];
    NSLog(@"vcs: %@", self.navigationController.viewControllers);
    [rvc removeUser:self.receiver];
    [self.navigationController popToRootViewControllerAnimated:NO];
    
    PFObject *requestObject = [PFObject objectWithClassName:@"Requests"];
    requestObject[@"RequesterID"] = self.sender.pfUser;
    requestObject[@"RequesteeID"] = self.receiver.pfUser;
    [requestObject saveInBackground];
    
    NSString *subtitle = [NSString stringWithFormat:@"Your request has been sent to %@", self.receiver.name];
    [TSMessage showNotificationWithTitle:@"Success!"
                                subtitle:subtitle
                                    type:TSMessageNotificationTypeSuccess];

}

# pragma mark - Navigation methods

- (void)popNavigationItemAnimated:(id)sender {
    [self.navigationController popViewControllerAnimated:NO];
}

@end
