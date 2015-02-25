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
#import "TwitterClient.h"

@interface ComposeViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *thumbnailView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *usernameLabel;
@property (weak, nonatomic) IBOutlet UITextView *tweetTextView;

@property (strong, nonatomic) NSString *replyID;

@end

@implementation ComposeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    User *user = [User currentUser];

    [self.thumbnailView setImageWithURL:[NSURL URLWithString:user.profileImageURL]];
    self.nameLabel.text = user.name;
    self.usernameLabel.text = [NSString stringWithFormat:@"@%@", user.username];

    [self.tweetTextView becomeFirstResponder];

    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(onCancelButton)];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Tweet" style:UIBarButtonItemStyleDone target:self action:@selector(onTweetButton)];
}

- (void)setReplyID:(NSString *)replyID andReplyUsername:(NSString *)replyUsername {
    self.replyID = replyID;
    self.tweetTextView.text = [NSString stringWithFormat:@"@%@ ", replyUsername];
}

#pragma mark - Private methods

- (void)onCancelButton {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)onTweetButton {
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:self.tweetTextView.text forKey:@"status"];

    if (self.replyID != nil) {
        [params setObject:self.replyID forKey:@"in_reply_to_status_id"];
    }

    [[TwitterClient sharedInstance] tweetWithParams:params completion:nil];
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
