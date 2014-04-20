//
//  AppDelegate.m
//  WWCMentorship
//
//  Created by Tripta Gupta on 4/2/14.
//  Copyright (c) 2014 Tripta Gupta. All rights reserved.
//

#import "AppDelegate.h"
#import "ProfileViewController.h"
#import "UserListViewController.h"
#import "LoginViewController.h"
#import "ProfileFormViewController.h"


@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];

    //SkillsViewController *svc = [[SkillsViewController alloc] init];
    //UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:svc];
    //self.window.rootViewController = navigationController;
    
    ProfileFormViewController *pvc = [[ProfileFormViewController alloc] init];
    self.window.rootViewController = pvc;
    
    [Parse setApplicationId:@"EFnYeM1PjDIus6gHu02UTOZ9XbbvuAXlv21ZxFnK"
                  clientKey:@"PQEtRTrB4PJ9A9KeKWQbw1OLGraXtVNOtU4cHHZl"];

//    // set up sign-up view controller
//    LoginViewController *lvc = [[LoginViewController alloc] init];
//    
//    // set up login view controller
//    PFLogInViewController *pflvc = [[PFLogInViewController alloc] init];
//    
//    // set up tab bar controller with related view controllers
//    UITabBarController *tbc = [[UITabBarController alloc] init];
//    
//    ProfileViewController *pvc = [[ProfileViewController alloc] init];
//    UINavigationController *pnc = [[UINavigationController alloc] initWithRootViewController:pvc];
//    
//    UserListViewController *ulvc = [[UserListViewController alloc] init];
//    UINavigationController *ulnc = [[UINavigationController alloc] initWithRootViewController:ulvc];
//    
//    tbc.viewControllers = @[pnc, ulnc];
//    
//    PFUser *user = [PFUser currentUser];
//    // if not logged in, present login view controller
//    if (!user) {
//        self.window.rootViewController = pflvc;
//    // if logged in
//    } else {
//        PFQuery *query = [PFQuery queryWithClassName:@"User"];
//        [query whereKey:@"objectId" equalTo:user.objectId];
//        query.limit = 1;
//        
//        [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
//            if (objects && !error) {
//                self.window.rootViewController = tbc;
//            // user is new, present sign-up view controller
//            } else if (!objects) {
//                self.window.rootViewController = lvc;
//            } else if (error) {
//                NSLog(@"error: %@", error.description);
//            }
//        }];
//    }
//    
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
