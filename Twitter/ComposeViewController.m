//
//  ComposeViewController.m
//  Twitter
//
//  Created by Neal Wu on 2/25/15.
//  Copyright (c) 2015 Neal Wu. All rights reserved.
//

#import "ComposeViewController.h"
#import "User.h"
#import "UIImageView+AFNetworking.h"

@interface ComposeViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *thumbnailView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *usernameLabel;
@property (weak, nonatomic) IBOutlet UITextView *tweetTextView;

@end

@implementation ComposeViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    User *user = [User currentUser];

    [self.thumbnailView setImageWithURL:[NSURL URLWithString:user.profileImageURL]];
    self.nameLabel.text = user.name;
    self.usernameLabel.text = [NSString stringWithFormat:@"@%@", user.username];

    self.tweetTextView.text = @"";
    [self.tweetTextView becomeFirstResponder];

    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Tweet" style:UIBarButtonItemStyleDone target:self action:@selector(onComposeReady)];
}

#pragma mark - Private methods

- (void)onComposeReady {

}

@end
