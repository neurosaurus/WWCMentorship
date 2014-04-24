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
    self.pfUser = userDictionary[@"pfUser"];
    self.userDictionary = userDictionary;
    self.objectId = userDictionary[@"objectId"];
    self.username = userDictionary[@"username"];
    self.email = userDictionary[@"email"];
    self.firstName = userDictionary[@"firstName"];
    self.lastName = userDictionary[@"lastName"];
    self.summary = userDictionary[@"summary"];
    //self.avatarURL = [NSURL URLWithString:userDictionary[@"avatarURL"]];
    
    [self loadSkills];
    
    NSNumber *isMentorNumber = (NSNumber *) userDictionary[@"isMentor"];
    int isMentorInt = [isMentorNumber intValue];
    if (isMentorInt == 1) {
        self.isMentor = YES;
    } else if (isMentorInt == 0){
        self.isMentor = NO;
    }
}

- (void)loadSkills {
    NSMutableArray *skills = [[NSMutableArray alloc] init];
    
    // retrieve current user's skills
    PFQuery *skillQuery = [PFQuery queryWithClassName:@"Skills"];
    [skillQuery whereKey:@"UserID" equalTo:self.pfUser];
    NSLog(@"finding skills for user %@", self.objectId);
    [skillQuery findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error && objects) {
            // save skill names
            NSLog(@"skills of user: %@", objects);
            for (PFObject *skillObject in objects) {
                NSString *skill = skillObject[@"Name"];
                [skills addObject:skill];
            }
            
            self.skills = skills;
            // save skills in right property
            if (self.isMentor) {
                self.mentorSkills = skills;
            } else {
                self.menteeSkills = skills;
            }
        } else if (error) {
            NSLog(@"error: %@", error.description);
        }
    }];
}

@end