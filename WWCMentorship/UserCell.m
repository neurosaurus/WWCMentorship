//
//  UserCell.m
//  WWCMentorship
//
//  Created by Stephanie Szeto on 4/16/14.
//  Copyright (c) 2014 Tripta Gupta. All rights reserved.
//

#import "UserCell.h"
#import "UIImageView+AFNetworking.h"

@interface UserCell ()

@property (weak, nonatomic) IBOutlet UIImageView *avatar;
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UILabel *skills;
@property (weak, nonatomic) IBOutlet UILabel *summary;

@end

@implementation UserCell

- (void)awakeFromNib
{
    // do something
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setUser:(User *)user {
    // coloring
    self.name.textColor = [UIColor whiteColor];
    self.skills.textColor = [UIColor whiteColor];
    self.summary.textColor = [UIColor whiteColor];
    
    // set values
    //self.name.text = [NSString stringWithFormat:@"%@ %@", user.firstName, user.lastName];
    self.name.text = user.name;
    NSArray *skills = user.skills;

    //NSLog(@"skills/cell: %@", skills);
    NSString *skillsText = [skills componentsJoinedByString:@", "];
    //NSLog(@"skillsText: %@", skillsText);
    self.skills.text = [NSString stringWithFormat:@"Skills: %@", skillsText];
    self.summary.text = user.summary;
    
    // for testing only
    //NSURL *tim = [NSURL URLWithString:@"https://avatars3.githubusercontent.com/u/99078?s=400"];
    [self.avatar setImageWithURL:user.avatarURL];
}

@end
