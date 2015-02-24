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

@interface LoginViewController ()

@end

@implementation LoginViewController

- (IBAction)onLogin:(id)sender {
    [[TwitterClient sharedInstance] loginWithCompletion:^(User *user, NSError *error) {
        if (user != nil) {
            // Modally present tweets view
            NSLog(@"Welcome to Twitter, %@", user.name);
            [self presentViewController:[[TweetsViewController alloc] init] animated:YES completion:nil];
        } else {
            // Present error view
        }
    }];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

@end
