//
//  User.m
//  WWCMentorship
//
//  Created by Stephanie Szeto on 4/21/14.
//  Copyright (c) 2014 Tripta Gupta. All rights reserved.
//

#import "User.h"

@implementation User

- (void)setUserWithDictionary:(NSDictionary *)userDictionary {
    self.userDictionary = userDictionary;
    self.username = userDictionary[@"username"];
    self.email = userDictionary[@"email"];
    self.firstName = userDictionary[@"firstName"];
    self.lastName = userDictionary[@"lastName"];
    self.summary = userDictionary[@"summary"];
    self.avatarURL = [NSURL URLWithString:userDictionary[@"avatarURL"]];
    //self.isMentor = userDictionary[@"isMentor"];
}

@end