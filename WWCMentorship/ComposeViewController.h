//
//  ComposeViewController.h
//  WWCMentorship
//
//  Created by Stephanie Szeto on 4/24/14.
//  Copyright (c) 2014 Tripta Gupta. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
#import <QuartzCore/QuartzCore.h>
#import "User.h"

@interface ComposeViewController : UIViewController <UITextViewDelegate, UIScrollViewDelegate >

@property (nonatomic, strong) User *sender;
@property (nonatomic, strong) User *receiver;

@end
