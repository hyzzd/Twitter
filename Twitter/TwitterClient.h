//
//  TwitterClient.h
//  Twitter
//
//  Created by Neal Wu on 2/24/15.
//  Copyright (c) 2015 Neal Wu. All rights reserved.
//

#import "BDBOAuth1RequestOperationManager.h"
#import "User.h"

@interface TwitterClient : BDBOAuth1RequestOperationManager

+ (TwitterClient *)sharedInstance;

// Login methods
- (void)loginWithCompletion:(void (^)(User *user, NSError *error))completion;
- (void)openURL:(NSURL *)url;

// GET methods
- (void)homeTimelineWithParams:(NSDictionary *)params completion:(void (^)(id responseObject, NSError *error))completion;

// POST methods
- (void)tweetWithParams:(NSDictionary *)params completion:(void (^)(id responseObject, NSError *error))completion;
- (void)retweetWithParams:(NSDictionary *)params completion:(void (^)(id responseObject, NSError *error))completion;
- (void)undoRetweetWithParams:(NSDictionary *)params completion:(void (^)(id responseObject, NSError *error))completion;
- (void)favoriteWithParams:(NSDictionary *)params completion:(void (^)(id responseObject, NSError *error))completion;
- (void)undoFavoriteWithParams:(NSDictionary *)params completion:(void (^)(id responseObject, NSError *error))completion;

@end
