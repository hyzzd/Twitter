//
//  LoginViewController.m
//  Twitter
//
//  Created by Neal Wu on 2/21/15.
//  Copyright (c) 2015 Neal Wu. All rights reserved.
//

#import "LoginViewController.h"
#import "TwitterClient.h"
#import "TweetsViewController.h"
#import "User.h"

@interface LoginViewController ()

@end

@implementation LoginViewController

- (IBAction)onLogin:(id)sender {
    [[TwitterClient sharedInstance] loginWithCompletion:^(User *user, NSError *error) {
        if (user != nil) {
            // Modally present tweets view
            [[NSNotificationCenter defaultCenter] postNotificationName:USER_DID_LOGIN_NOTIFICATION object:nil];
        } else {
            // Present error view
            NSLog(@"Error: %@", error);
        }
    }];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

@end
