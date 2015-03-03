//
//  TweetCell.m
//  Twitter
//
//  Created by Neal Wu on 2/24/15.
//  Copyright (c) 2015 Neal Wu. All rights reserved.
//

#import "TweetCell.h"
#import "UIImageView+AFNetworking.h"
#import "TwitterClient.h"
#import "NSDate+DateTools.h"

@interface TweetCell ()

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

@implementation TweetCell

- (void)awakeFromNib {
    self.tweetLabel.preferredMaxLayoutWidth = self.tweetLabel.frame.size.width;

    UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onTapProfileImage)];
    tapRecognizer.numberOfTapsRequired = 1;
    tapRecognizer.numberOfTouchesRequired = 1;
    [self.thumbnailView addGestureRecognizer:tapRecognizer];
    self.thumbnailView.userInteractionEnabled = YES;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.tweetLabel.preferredMaxLayoutWidth = self.tweetLabel.frame.size.width;
}

- (id)initWithTweet:(Tweet *)tweet {
    self = [super init];

    if (self) {
        self.tweet = tweet;
    }

    return self;
}

- (void)setTweet:(Tweet *)tweet {
    _tweet = tweet;

    [self.thumbnailView setImageWithURL:[NSURL URLWithString:tweet.user.profileImageURL]];
    self.thumbnailView.layer.cornerRadius = 3;
    self.thumbnailView.clipsToBounds = YES;

    self.nameLabel.text = tweet.user.name;
    self.usernameLabel.text = [NSString stringWithFormat:@"@%@", tweet.user.username];
    self.tweetLabel.text = tweet.text;
    self.timeLabel.text = tweet.createdAt.shortTimeAgoSinceNow;

    self.retweetCountLabel.text = [NSString stringWithFormat:@"%ld", tweet.retweetCount];
    self.favoriteCountLabel.text = [NSString stringWithFormat:@"%ld", tweet.favoriteCount];

    self.retweeted = tweet.retweeted;
    self.favorited = tweet.favorited;
}

- (IBAction)onReplyButton:(id)sender {
    [self.delegate tweetCell:self onReplyButtonWithReplyID:self.tweet.tweetID andReplyUsername:self.tweet.user.username];
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
    [self.delegate tweetCellDidTapThumbnail:self];
}

@end
