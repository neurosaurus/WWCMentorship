//
//  UserListViewController.h
//  WWCMentorship
//
//  Created by Tripta Gupta on 4/12/14.
//  Copyright (c) 2014 Tripta Gupta. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
#import "User.h"

@interface UserListViewController : UIViewController < UITableViewDataSource, UITableViewDelegate, PFLogInViewControllerDelegate, PFSignUpViewControllerDelegate >

@property (nonatomic, assign) BOOL showMentor;
@property (nonatomic, assign) BOOL showMatch;
@property (nonatomic, assign) BOOL isLoaded;
@property (nonatomic, assign) BOOL isNewUser;

- (void)removeUser:(User *)user;

@end
