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
    
    // set values
    self.name.text = user.name;
    NSArray *skills = user.skills;

    NSString *skillsText = [skills componentsJoinedByString:@", "];
    self.skills.text = [NSString stringWithFormat:@"Skills: %@", skillsText];
    
    // for testing only
    //NSURL *tim = [NSURL URLWithString:@"https://avatars3.githubusercontent.com/u/99078?s=400"];
    [self.avatar setImageWithURL:user.avatarURL];
    CALayer *avatarLayer = self.avatar.layer;
    avatarLayer.cornerRadius = 45;
    avatarLayer.borderColor = [[UIColor whiteColor] CGColor];
    avatarLayer.borderWidth = 0.5;
    avatarLayer.masksToBounds = YES;
}

@end
