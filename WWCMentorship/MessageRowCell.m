//
//  MessageRowCell.m
//  WWCMentorship
//
//  Created by Stephanie Szeto on 4/24/14.
//  Copyright (c) 2014 Tripta Gupta. All rights reserved.
//

#import "MessageRowCell.h"

@interface MessageRowCell ()

@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UILabel *message;

@end

@implementation MessageRowCell

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setPreview:(NSArray *)params {
    self.name.text = params[0];
    self.message.text = params[1];
}

@end
