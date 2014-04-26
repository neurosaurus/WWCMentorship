//
//  ComposeViewController.m
//  WWCMentorship
//
//  Created by Stephanie Szeto on 4/24/14.
//  Copyright (c) 2014 Tripta Gupta. All rights reserved.
//

#import "ComposeViewController.h"
#import "AFNetworking.h"
#import "UIImageView+AFNetworking.h"

@interface ComposeViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *avatar;
@property (weak, nonatomic) IBOutlet UITextView *message;
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
    self.sendButton.tintColor = [UIColor colorWithRed:0/255.0f green:182/255.0f blue:170/255.0f alpha:1.0f];
    
    self.message.delegate = self;
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onCustomTap:)];
    [self.view addGestureRecognizer:tapGestureRecognizer];
    
    [self.avatar setImageWithURL:self.receiver.avatarURL];
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
    [messageObject saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        NSLog(@"success: saved %@ in parse", self.message.text);
    }];
    [self.navigationController popToRootViewControllerAnimated:YES];
}

@end