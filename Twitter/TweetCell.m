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

@end

@implementation TweetCell

- (id)initWithTweet:(Tweet *)tweet {
    self = [super init];

    if (self) {
        [self.thumbnailView setImageWithURL:[NSURL URLWithString:tweet.user.profileImageURL]];
        self.nameLabel.text = tweet.user.name;
        self.usernameLabel.text = tweet.user.username;
        self.tweetLabel.text = tweet.text;
//        self.timeLabel.text = tweet.createdAt;
    }

    return self;
}

@end
