//
//  User.h
//  WWCMentorship
//
//  Created by Stephanie Szeto on 4/21/14.
//  Copyright (c) 2014 Tripta Gupta. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface User : NSObject

@property (nonatomic, strong) NSDictionary *userDictionary;
@property (nonatomic, strong) NSString *username;
@property (nonatomic, strong) NSString *email;
@property (nonatomic, strong) NSString *firstName;
@property (nonatomic, strong) NSString *lastName;
@property (nonatomic, strong) NSString *summary;
@property (nonatomic, strong) NSURL *avatarURL;
@property (nonatomic, assign) BOOL isMentor;

- (void)setUserWithDictionary:(NSDictionary *)userDictionary;

@end
