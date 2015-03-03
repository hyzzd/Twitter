//
//  TweetDetailsViewController.m
//  Twitter
//
//  Created by Neal Wu on 2/25/15.
//  Copyright (c) 2015 Neal Wu. All rights reserved.
//

#import "TweetDetailsViewController.h"
#import "UIImageView+AFNetworking.h"
#import "TwitterClient.h"
#import "ComposeViewController.h"
#import "ProfileViewController.h"

@interface TweetDetailsViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *thumbnailView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *usernameLabel;
@property (weak, nonatomic) IBOutlet UILabel *tweetLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UIButton *replyButton;
@property (weak, nonatomic) IBOutlet UIButton *retweetButton;
@property (weak, nonatomic) IBOutlet UIButton *favoriteButton;
@property (weak, nonatomic) IBOutlet UILabel *retweetCountLabel;
@property (weak, nonatomic) IBOutlet UILabel *favoriteCountLabel;

@property (assign, nonatomic) BOOL retweeted;
@property (assign, nonatomic) BOOL favorited;

@end

@implementation TweetDetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tweet = self.tweet;

    UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onTapProfileImage)];
    tapRecognizer.numberOfTapsRequired = 1;
    tapRecognizer.numberOfTouchesRequired = 1;
    [self.thumbnailView addGestureRecognizer:tapRecognizer];
    self.thumbnailView.userInteractionEnabled = YES;
}

- (void)setTweet:(Tweet *)tweet {
    _tweet = tweet;

    [self.thumbnailView setImageWithURL:[NSURL URLWithString:tweet.user.profileImageURL]];
    self.thumbnailView.layer.cornerRadius = 3;
    self.thumbnailView.clipsToBounds = YES;

    self.nameLabel.text = tweet.user.name;
    self.usernameLabel.text = [NSString stringWithFormat:@"@%@", tweet.user.username];
    self.tweetLabel.text = tweet.text;

    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"EEE MMM d y, HH:mm";
    self.timeLabel.text = [formatter stringFromDate:tweet.createdAt];

    self.retweetCountLabel.text = [NSString stringWithFormat:@"%ld", tweet.retweetCount];
    self.favoriteCountLabel.text = [NSString stringWithFormat:@"%ld", tweet.favoriteCount];

    self.retweeted = tweet.retweeted;
    self.favorited = tweet.favorited;
}

- (IBAction)onReplyButton:(id)sender {
    ComposeViewController *vc = [[ComposeViewController alloc] init];
    UINavigationController *nvc = [[UINavigationController alloc] initWithRootViewController:vc];
    [self presentViewController:nvc animated:YES completion:^{
        [vc setReplyID:self.tweet.tweetID andReplyUsername:self.tweet.user.username];
    }];
}

- (IBAction)onRetweetButton:(id)sender {
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObject:self.tweet.tweetID forKey:@"id"];

    if (!self.retweeted) {
        [[TwitterClient sharedInstance] retweetWithParams:params completion:nil];
        [self.retweetButton setImage:[UIImage imageNamed:@"RetweetSelected"] forState:UIControlStateNormal];
        self.tweet.retweetCount++;
        self.tweet = self.tweet;
    } else {
        [[TwitterClient sharedInstance] undoRetweetWithParams:params completion:nil];
        [self.retweetButton setImage:[UIImage imageNamed:@"Retweet"] forState:UIControlStateNormal];
        self.tweet.retweetCount--;
        self.tweet = self.tweet;
    }

    self.retweeted = !self.retweeted;
}

- (IBAction)onFavoriteButton:(id)sender {
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObject:self.tweet.tweetID forKey:@"id"];

    if (!self.favorited) {
        [[TwitterClient sharedInstance] favoriteWithParams:params completion:nil];
        [self.favoriteButton setImage:[UIImage imageNamed:@"StarSelected"] forState:UIControlStateNormal];
        self.tweet.favoriteCount++;
        self.tweet = self.tweet;
    } else {
        [[TwitterClient sharedInstance] undoFavoriteWithParams:params completion:nil];
        [self.favoriteButton setImage:[UIImage imageNamed:@"Star"] forState:UIControlStateNormal];
        self.tweet.favoriteCount--;
        self.tweet = self.tweet;
    }

    self.favorited = !self.favorited;
}

- (void)onTapProfileImage {
    ProfileViewController *vc = [[ProfileViewController alloc] init];
    vc.user = self.tweet.user;
    [self.navigationController pushViewController:vc animated:YES];
}

@end
