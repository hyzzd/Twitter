//
//  ProfileViewController.m
//  Twitter
//
//  Created by Neal Wu on 2/26/15.
//  Copyright (c) 2015 Neal Wu. All rights reserved.
//

#import "ProfileViewController.h"
#import "User.h"
#import "UIImageView+AFNetworking.h"

@interface ProfileViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *profileImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *usernameLabel;

@property (weak, nonatomic) IBOutlet UILabel *tweetCountLabel;
@property (weak, nonatomic) IBOutlet UILabel *followingCountLabel;
@property (weak, nonatomic) IBOutlet UILabel *followersCountLabel;

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation ProfileViewController

@synthesize user = _user;

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.user = self.user;
}

- (void)setUser:(User *)user {
    _user = user;

    [self.profileImageView setImageWithURL:[NSURL URLWithString:user.profileImageURL]];
    self.nameLabel.text = user.name;
    self.usernameLabel.text = [NSString stringWithFormat:@"@%@", user.username];
    self.tweetCountLabel.text = [NSString stringWithFormat:@"%ld", user.tweetCount];
    self.followingCountLabel.text = [NSString stringWithFormat:@"%ld", user.followingCount];
    self.followersCountLabel.text = [NSString stringWithFormat:@"%ld", user.followersCount];
}

@end
