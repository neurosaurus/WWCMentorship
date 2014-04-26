//
//  MessageListViewController.h
//  WWCMentorship
//
//  Created by Tripta Gupta on 4/12/14.
//  Copyright (c) 2014 Tripta Gupta. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
#import "ChatController.h"

@interface MessageListViewController : UIViewController < UITableViewDelegate, UITableViewDataSource, ChatControllerDelegate, PFLogInViewControllerDelegate, PFSignUpViewControllerDelegate >

@property (nonatomic, strong) ChatController *chatController;

@end

