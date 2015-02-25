//
//  TweetCell.m
//  Twitter
//
//  Created by Neal Wu on 2/24/15.
//  Copyright (c) 2015 Neal Wu. All rights reserved.
//

#import "TweetCell.h"
#import "UIImageView+AFNetworking.h"

@interface TweetCell ()

@property (weak, nonatomic) IBOutlet UIImageView *thumbnailView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *usernameLabel;
@property (weak, nonatomic) IBOutlet UILabel *tweetLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;

@property (weak, nonatomic) IBOutlet UIImageView *replyButton;
@property (weak, nonatomic) IBOutlet UIImageView *retweetButton;
@property (weak, nonatomic) IBOutlet UIImageView *favoriteButton;

@end

@implementation TweetCell

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
        [self populateWithTweet:tweet];
    }

    return self;
}

- (void)populateWithTweet:(Tweet *)tweet {
    [self.thumbnailView setImageWithURL:[NSURL URLWithString:tweet.user.profileImageURL]];
    self.thumbnailView.layer.cornerRadius = 3;
    self.thumbnailView.clipsToBounds = YES;

    self.nameLabel.text = tweet.user.name;
    self.usernameLabel.text = [NSString stringWithFormat:@"@%@", tweet.user.username];
    self.tweetLabel.text = tweet.text;
    //        self.timeLabel.text = tweet.createdAt;

    [self.replyButton setImageWithURL:[NSURL URLWithString:@"https://g.twimg.com/dev/documentation/image/reply.png"]];

    [self.retweetButton setImageWithURL:[NSURL URLWithString:@"https://g.twimg.com/dev/documentation/image/retweet.png"]];

    [self.favoriteButton setImageWithURL:[NSURL URLWithString:@"https://g.twimg.com/dev/documentation/image/favorite.png"]];
}

@end
