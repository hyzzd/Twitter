//
//  User.m
//  Twitter
//
//  Created by Neal Wu on 2/24/15.
//  Copyright (c) 2015 Neal Wu. All rights reserved.
//

#import "User.h"
#import "TwitterClient.h"

NSString * const USER_DID_LOGIN_NOTIFICATION = @"UserDidLoginNotification";
NSString * const USER_DID_LOGOUT_NOTIFICATION = @"UserDidLogoutNotification";

@interface User ()

@property (strong, nonatomic) NSDictionary *dictionary;

@end

@implementation User

- (id) initWithDictionary:(NSDictionary *)dictionary {
    self = [super init];

    if (self) {
        self.dictionary = dictionary;
        self.name = dictionary[@"name"];
        self.username = dictionary[@"screen_name"];
        self.profileImageURL = dictionary[@"profile_image_url"];
        self.tagline = dictionary[@"description"];
    }

    return self;
}

static User *_currentUser = nil;

NSString * const CURRENT_USER_KEY = @"kCurrentUserKey";

+ (User *)currentUser {
    if (_currentUser == nil) {
        NSData *data = [[NSUserDefaults standardUserDefaults] objectForKey:CURRENT_USER_KEY];

        if (data != nil) {
            NSDictionary *dictionary = [NSJSONSerialization JSONObjectWithData:data options:0 error:NULL];
            _currentUser = [[User alloc] initWithDictionary:dictionary];
        }
    }

    return _currentUser;
}

+ (void)setCurrentUser:(User *)currentUser {
    _currentUser = currentUser;

    if (_currentUser != nil) {
        NSData *data = [NSJSONSerialization dataWithJSONObject:_currentUser.dictionary options:0 error:NULL];
        [[NSUserDefaults standardUserDefaults] setObject:data forKey:CURRENT_USER_KEY];
        [[NSNotificationCenter defaultCenter] postNotificationName:USER_DID_LOGIN_NOTIFICATION object:nil];
    } else {
        [[NSUserDefaults standardUserDefaults] setObject:nil forKey:CURRENT_USER_KEY];
        [[NSNotificationCenter defaultCenter] postNotificationName:USER_DID_LOGOUT_NOTIFICATION object:nil];
    }

    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (void)logout {
    [User setCurrentUser:nil];
    [[TwitterClient sharedInstance].requestSerializer removeAccessToken];
}

@end
