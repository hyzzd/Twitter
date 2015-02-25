//
//  Tweet.m
//  Twitter
//
//  Created by Neal Wu on 2/24/15.
//  Copyright (c) 2015 Neal Wu. All rights reserved.
//

#import "Tweet.h"

@implementation Tweet

- (id) initWithDictionary:(NSDictionary *)dictionary {
    self = [super init];

    if (self) {
        self.tweetID = dictionary[@"id_str"];
        self.user = [[User alloc] initWithDictionary:dictionary[@"user"]];
        self.text = [dictionary[@"text"] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        formatter.dateFormat = @"EEE MMM d HH:mm:ss Z y";
        self.createdAt = [formatter dateFromString:dictionary[@"created_at"]];
        self.retweeted = [dictionary[@"retweeted"] boolValue];
        self.favorited = [dictionary[@"favorited"] boolValue];
    }

    return self;
}

+ (NSArray *)tweetsWithArray:(NSArray *)array {
    NSMutableArray *tweets = [NSMutableArray array];

    for (NSDictionary *dictionary in array) {
        [tweets addObject:[[Tweet alloc] initWithDictionary:dictionary]];
    }

    return tweets;
}

@end
