//
//  ProfileViewController.m
//  WWCMentorship
//
//  Created by Tripta Gupta on 4/7/14.
//  Copyright (c) 2014 Tripta Gupta. All rights reserved.
//

#import "ProfileViewController.h"
#import "UIImageView+AFNetworking.h"

@interface ProfileViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *avatar;
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UILabel *twitter;
@property (weak, nonatomic) IBOutlet UILabel *github;
@property (weak, nonatomic) IBOutlet UITextView *summary;

@property (weak, nonatomic) IBOutlet UILabel *toLearn1;
@property (weak, nonatomic) IBOutlet UILabel *toLearn2;
@property (weak, nonatomic) IBOutlet UILabel *toLearn3;
@property (weak, nonatomic) IBOutlet UILabel *toLearn4;
@property (weak, nonatomic) IBOutlet UILabel *toLearn5;
@property (weak, nonatomic) IBOutlet UILabel *toLearn6;

@property (weak, nonatomic) IBOutlet UILabel *toTeach1;
@property (weak, nonatomic) IBOutlet UILabel *toTeach2;
@property (weak, nonatomic) IBOutlet UILabel *toTeach3;
@property (weak, nonatomic) IBOutlet UILabel *toTeach4;
@property (weak, nonatomic) IBOutlet UILabel *toTeach5;
@property (weak, nonatomic) IBOutlet UILabel *toTeach6;

- (IBAction)onContactButton:(id)sender;

@end

@implementation ProfileViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
//    PFObject *userObject = [PFObject objectWithClassName:@"User"];
//    userObject[@"foo"] = @"bar";
//    [userObject saveInBackground];
    

    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)onContactButton:(id)sender {
}
@end
