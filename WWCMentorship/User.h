//
//  User.h
//  WWCMentorship
//
//  Created by Stephanie Szeto on 4/21/14.
//  Copyright (c) 2014 Tripta Gupta. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Parse/Parse.h>

@interface User : NSObject

@property (nonatomic, strong) PFUser *pfUser;
@property (nonatomic, strong) NSDictionary *userDictionary;
@property (nonatomic, strong) NSString *objectId;
@property (nonatomic, strong) NSString *username;
@property (nonatomic, strong) NSString *email;
@property (nonatomic, strong) NSString *firstName;
@property (nonatomic, strong) NSString *lastName;
@property (nonatomic, strong) NSString *summary;
@property (nonatomic, strong) NSURL *avatarURL;
@property (nonatomic, assign) BOOL isMentor;
@property (nonatomic, strong) NSArray *mentorSkills;
@property (nonatomic, strong) NSArray *menteeSkills;
@property (nonatomic, strong) NSArray *skills;

- (void)setUserWithDictionary:(NSDictionary *)userDictionary;
- (void)loadSkills:(PFUser *)user;

@end
