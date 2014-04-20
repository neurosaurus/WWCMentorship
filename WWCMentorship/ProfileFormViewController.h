//
//  ProfileFormViewController.h
//  WWCMentorship
//
//  Created by Tripta Gupta on 4/12/14.
//  Copyright (c) 2014 Tripta Gupta. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
#import "LPPopupListView.h"

@interface ProfileFormViewController : UIViewController <UITextFieldDelegate, PFLogInViewControllerDelegate,PFSignUpViewControllerDelegate, LPPopupListViewDelegate>

- (IBAction)skillsButton:(id)sender;

@property (strong, nonatomic) IBOutlet UITextView *textView;

@end
