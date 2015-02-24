//
//  User.h
//  Twitter
//
//  Created by Neal Wu on 2/24/15.
//  Copyright (c) 2015 Neal Wu. All rights reserved.
//

#import <Foundation/Foundation.h>

extern NSString * const USER_DID_LOGIN_NOTIFICATION;
extern NSString * const USER_DID_LOGOUT_NOTIFICATION;

@interface User : NSObject

@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) NSString *username;
@property (strong, nonatomic) NSString *profileImageURL;
@property (strong, nonatomic) NSString *tagline;

- (id)initWithDictionary:(NSDictionary *)dictionary;

+ (User *)currentUser;
+ (void)setCurrentUser:(User *)user;

+ (void)logout;

@end
