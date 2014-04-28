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
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)onCustomTap:(UITapGestureRecognizer *)tapGestureRecognizer {
    [self.message endEditing:YES];
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
    [rvc removeUser:self.receiver];
    [self.navigationController popToRootViewControllerAnimated:NO];
    
    PFObject *requestObject = [PFObject objectWithClassName:@"Requests"];
    requestObject[@"RequesterID"] = self.sender.pfUser;
    requestObject[@"RequesteeID"] = self.receiver.pfUser;
    [requestObject saveInBackground];
    
    [TSMessage showNotificationWithTitle:@"Success!"
                                subtitle:@"Your request has been sent."
                                    type:TSMessageNotificationTypeSuccess];

}

@end
