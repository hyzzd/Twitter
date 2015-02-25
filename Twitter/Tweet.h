//
//  Tweet.h
//  Twitter
//
//  Created by Neal Wu on 2/24/15.
//  Copyright (c) 2015 Neal Wu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "User.h"

@interface Tweet : NSObject

@property (strong, nonatomic) NSString *tweetID;
@property (strong, nonatomic) NSString *text;
@property (strong, nonatomic) NSDate *createdAt;
@property (strong, nonatomic) User *user;
@property (assign, nonatomic) BOOL retweeted;
@property (assign, nonatomic) BOOL favorited;

- (id)initWithDictionary:(NSDictionary *)dictionary;

+ (NSArray *)tweetsWithArray:(NSArray *)array;

@end
