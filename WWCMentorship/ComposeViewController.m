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
@property (weak, nonatomic) IBOutlet UIView *containerView;

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
    self.message.tintColor = [UIColor whiteColor];
    self.messageBox.backgroundColor = [UIColor blackColor];
    self.name.textColor = [UIColor whiteColor];
    self.sendButton.tintColor = [UIColor colorWithRed:0/255.0f green:182/255.0f blue:170/255.0f alpha:1.0f];
    
    CALayer *boxLayer = self.messageBox.layer;
    boxLayer.borderWidth = 0.5;
    boxLayer.borderColor = [[UIColor whiteColor] CGColor];
    
    self.message.delegate = self;
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onCustomTap:)];
    [tapGestureRecognizer setCancelsTouchesInView:NO];
    [self.view addGestureRecognizer:tapGestureRecognizer];
    
    CALayer *avatarLayer = self.avatar.layer;
    avatarLayer.cornerRadius = self.avatar.frame.size.width / 2;
    avatarLayer.borderColor = [[UIColor whiteColor] CGColor];
    avatarLayer.borderWidth = 0.5;
    avatarLayer.masksToBounds = YES;
    [self.avatar setImageWithURL:self.receiver.avatarURL];
    
    self.name.text = self.receiver.name;
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"back.png"] style:UIBarButtonItemStylePlain target:self action:@selector(popNavigationItemAnimated:)];
    
    // configure scroll view
    [self.containerView addSubview:self.avatar];
    [self.containerView addSubview:self.name];
    [self.containerView addSubview:self.messageBox];
    [self.containerView addSubview:self.message];
    [self.scrollView addSubview:self.sendButton];
    [self.scrollView addSubview:self.containerView];
    [self.scrollView bringSubviewToFront:self.sendButton];
    
    CGRect size = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    self.scrollView.contentSize = self.scrollView.frame.size;
    self.scrollView.frame = size;
    self.scrollView.scrollEnabled = YES;
    self.containerView.userInteractionEnabled = YES;
    
    [self.view addSubview:self.scrollView];
    self.scrollView.delegate = self;
    [self.scrollView setContentOffset:CGPointMake(0, 0)];
    self.scrollView.delaysContentTouches = NO;
    self.scrollView.canCancelContentTouches = NO;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

// Called when the UIKeyboardDidShowNotification is sent.
- (void)keyboardWasShown:(NSNotification*)aNotification {
    NSLog(@"in here");
    
    NSDictionary* info = [aNotification userInfo];
    CGSize kbSize = [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    UIEdgeInsets contentInsets = UIEdgeInsetsMake(0.0, 0.0, kbSize.height, 0.0);
    self.scrollView.contentInset = contentInsets;
    self.scrollView.scrollIndicatorInsets = contentInsets;
    
//    UIView *view = [[UIView alloc] initWithFrame:self.messageBox.frame];
//    [view addSubview:self.messageBox];
//    [view addSubview:self.message];
    
    // If active text field is hidden by keyboard, scroll it so it's visible
    // Your application might not need or want this behavior.
    CGRect aRect = self.view.frame;
    aRect.size.height -= kbSize.height;
    if (!CGRectContainsPoint(aRect, self.message.frame.origin) ) {
        CGPoint scrollPoint = CGPointMake(0.0, self.message.frame.origin.y-kbSize.height);
        [self.scrollView setContentOffset:scrollPoint animated:YES];
    }
}

// Called when the UIKeyboardWillHideNotification is sent
- (void)keyboardWillBeHidden:(NSNotification*)aNotification {
    NSLog(@"now in here");
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
