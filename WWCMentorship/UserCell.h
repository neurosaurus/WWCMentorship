//
//  UserCell.h
//  WWCMentorship
//
//  Created by Stephanie Szeto on 4/16/14.
//  Copyright (c) 2014 Tripta Gupta. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "User.h"

@interface UserCell : UITableViewCell

@property (nonatomic, strong) User *user;

- (void)setUser:(User *)user;

@end
