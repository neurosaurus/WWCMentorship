//
//  ProfileViewController.h
//  WWCMentorship
//
//  Created by Tripta Gupta on 4/7/14.
//  Copyright (c) 2014 Tripta Gupta. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
#import "User.h"

@interface ProfileViewController : UIViewController < PFLogInViewControllerDelegate, PFSignUpViewControllerDelegate >

@property (nonatomic, assign) BOOL isSelf;
@property (nonatomic, assign) BOOL isMatch;
@property (nonatomic, assign) BOOL hasRequested;
@property (nonatomic, strong) User *user;
@property (nonatomic, strong) NSString *userId;

- (id)initWithUser:(User *)user;

@end
