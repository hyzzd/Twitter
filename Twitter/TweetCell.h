//
//  TweetCell.h
//  Twitter
//
//  Created by Neal Wu on 2/24/15.
//  Copyright (c) 2015 Neal Wu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Tweet.h"

@class TweetCell;

@protocol TweetCellDelegate <NSObject>

- (void)tweetCell:(TweetCell *)tweetCell onReplyButtonWithReplyID:(NSString *)replyID andReplyUsername:(NSString *)replyUsername;
- (void)didTapThumbnailForTweetCell:(TweetCell *)tweetCell;

@end

@interface TweetCell : UITableViewCell

@property (weak, nonatomic) id<TweetCellDelegate> delegate;
@property (strong, nonatomic) Tweet *tweet;

- (id)initWithTweet:(Tweet *)tweet;

@end
