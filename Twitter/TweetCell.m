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

@property (assign, nonatomic) BOOL retweeted;
@property (assign, nonatomic) BOOL favorited;

@end

@implementation TweetCell

@synthesize tweet = _tweet;

- (void)awakeFromNib {
    self.tweetLabel.preferredMaxLayoutWidth = self.tweetLabel.frame.size.width;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.tweetLabel.preferredMaxLayoutWidth = self.tweetLabel.frame.size.width;
}

- (id)initWithTweet:(Tweet *)tweet {
    self = [super init];

    if (self) {
        NSLog(@"Init called with %@", tweet);
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

    self.retweeted = tweet.retweeted;
    self.favorited = tweet.favorited;
    NSLog(@"Retweeted: %d, favorited: %d", self.retweeted, self.favorited);
}

- (IBAction)onReplyButton:(id)sender {
    NSLog(@"User tapped reply button!");
}

- (IBAction)onRetweetButton:(id)sender {
    NSLog(@"User tapped retweet button!");
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObject:self.tweet.tweetID forKey:@"id"];

    if (!self.retweeted) {
        [[TwitterClient sharedInstance] retweetWithParams:params completion:nil];
        [self.retweetButton setImage:[UIImage imageNamed:@"RetweetSelected"] forState:UIControlStateNormal];
    } else {
        [[TwitterClient sharedInstance] undoRetweetWithParams:params completion:nil];
        [self.retweetButton setImage:[UIImage imageNamed:@"Retweet"] forState:UIControlStateNormal];
    }

    self.retweeted = !self.retweeted;
}

- (IBAction)onFavoriteButton:(id)sender {
    NSLog(@"User tapped favorite button!");
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObject:self.tweet.tweetID forKey:@"id"];

    if (!self.favorited) {
        [[TwitterClient sharedInstance] favoriteWithParams:params completion:nil];
        [self.favoriteButton setImage:[UIImage imageNamed:@"StarSelected"] forState:UIControlStateNormal];
    } else {
        [[TwitterClient sharedInstance] undoFavoriteWithParams:params completion:nil];
        [self.favoriteButton setImage:[UIImage imageNamed:@"Star"] forState:UIControlStateNormal];

    }

    self.favorited = !self.favorited;
}

@end
