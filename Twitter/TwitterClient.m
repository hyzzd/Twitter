//
//  TwitterClient.m
//  Twitter
//
//  Created by Neal Wu on 2/24/15.
//  Copyright (c) 2015 Neal Wu. All rights reserved.
//

#import "TwitterClient.h"
#import "Tweet.h"

NSString * const TWITTER_CONSUMER_KEY = @"SFpW1p6RrxRf4yrbHqEutckvv";
NSString * const TWITTER_CONSUMER_SECRET = @"866JybNIey39gkVRsf41noBuEiWC24vGFeEGLIDGMTGwBVOzlo";
NSString * const TWITTER_BASE_URL = @"https://api.twitter.com";

@interface TwitterClient ()

@property (strong, nonatomic) void (^loginCompletion)(User *user, NSError *error);

@end

@implementation TwitterClient

+ (TwitterClient *)sharedInstance {
    static TwitterClient *instance = nil;

    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (instance == nil) {
            instance = [[TwitterClient alloc] initWithBaseURL:[NSURL URLWithString:TWITTER_BASE_URL] consumerKey:TWITTER_CONSUMER_KEY consumerSecret:TWITTER_CONSUMER_SECRET];
        }
    });

    return instance;
}

- (void)loginWithCompletion:(void (^)(User *, NSError *))completion {
    self.loginCompletion = completion;

    [self.requestSerializer removeAccessToken];

    [self fetchRequestTokenWithPath:@"oauth/request_token" method:@"GET" callbackURL:[NSURL URLWithString:@"cptwitter://oauth"] scope:nil success:^(BDBOAuth1Credential *requestToken) {
        NSURL *authURL = [NSURL URLWithString:[NSString stringWithFormat:@"https://api.twitter.com/oauth/authorize?oauth_token=%@", requestToken.token]];
        [[UIApplication sharedApplication] openURL:authURL];
    } failure:^(NSError *error) {
        if (self.loginCompletion != nil) {
            self.loginCompletion(nil, error);
        }
    }];
}

- (void)openURL:(NSURL *)url {
    [self fetchAccessTokenWithPath:@"oauth/access_token" method:@"POST" requestToken:[BDBOAuth1Credential credentialWithQueryString:url.query] success:^(BDBOAuth1Credential *accessToken) {
        [self.requestSerializer saveAccessToken:accessToken];

        [self GET:@"1.1/account/verify_credentials.json" parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
            User *user = [[User alloc] initWithDictionary:responseObject];
            [User setCurrentUser:user];

            if (self.loginCompletion != nil) {
                self.loginCompletion(user, nil);
            }
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            if (self.loginCompletion != nil) {
                self.loginCompletion(nil, error);
            }
        }];
    } failure:^(NSError *error) {
    }];
}

- (void)homeTimelineWithParams:(NSDictionary *)params completion:(void (^)(id responseObject, NSError *error))completion {
    [self GET:@"1.1/statuses/home_timeline.json" parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (completion != nil) {
            completion(responseObject, nil);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (completion != nil) {
            completion(nil, error);
        }
    }];
}

- (void)userTimelineWithParams:(NSDictionary *)params completion:(void (^)(id responseObject, NSError *error))completion {
    [self GET:@"1.1/statuses/user_timeline.json" parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (completion != nil) {
            completion(responseObject, nil);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (completion != nil) {
            completion(nil, error);
        }
    }];
}

- (void)tweetWithParams:(NSDictionary *)params completion:(void (^)(id, NSError *))completion {
    [self POST:@"1.1/statuses/update.json" parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (completion != nil) {
            completion(responseObject, nil);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (completion != nil) {
            completion(nil, error);
        }
    }];
}

- (void)retweetWithParams:(NSDictionary *)params completion:(void (^)(id, NSError *))completion {
    NSString *tweetID = params[@"id"];

    [self POST:[NSString stringWithFormat:@"1.1/statuses/retweet/%@.json", tweetID] parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (completion != nil) {
            completion(responseObject, nil);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (completion != nil) {
            completion(nil, error);
        }
    }];
}

- (void)undoRetweetWithParams:(NSDictionary *)params completion:(void (^)(id, NSError *))completion {
    NSString *tweetID = params[@"id"];

    [self POST:[NSString stringWithFormat:@"1.1/statuses/destroy/%@.json", tweetID] parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (completion != nil) {
            completion(responseObject, nil);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (completion != nil) {
            completion(nil, error);
        }
    }];
}

- (void)favoriteWithParams:(NSDictionary *)params completion:(void (^)(id, NSError *))completion {
    [self POST:@"1.1/favorites/create.json" parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (completion != nil) {
            completion(responseObject, nil);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (completion != nil) {
            completion(nil, error);
        }
    }];
}

- (void)undoFavoriteWithParams:(NSDictionary *)params completion:(void (^)(id, NSError *))completion {
    [self POST:@"1.1/favorites/destroy.json" parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (completion != nil) {
            completion(responseObject, nil);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (completion != nil) {
            completion(nil, error);
        }
    }];
}

@end
