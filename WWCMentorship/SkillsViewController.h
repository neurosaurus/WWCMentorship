//
//  SkillsViewController.h
//  WWCMentorship
//
//  Created by Tripta Gupta on 4/18/14.
//  Copyright (c) 2014 Tripta Gupta. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
#import "LPPopupListView.h"

@interface SkillsViewController : UIViewController <LPPopupListViewDelegate>

@property (strong, nonatomic) IBOutlet UITextView *textView;

- (IBAction)buttonClicked:(id)sender;

@end
