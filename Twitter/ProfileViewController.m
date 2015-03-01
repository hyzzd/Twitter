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
#import "TweetCell.h"
#import "ComposeViewController.h"
#import "TwitterClient.h"

@interface ProfileViewController () <UITableViewDataSource, UITableViewDelegate, TweetCellDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *profileImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *usernameLabel;

@property (weak, nonatomic) IBOutlet UILabel *tweetCountLabel;
@property (weak, nonatomic) IBOutlet UILabel *followingCountLabel;
@property (weak, nonatomic) IBOutlet UILabel *followersCountLabel;

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (strong, nonatomic) NSArray *tweets;

@end

@implementation ProfileViewController

@synthesize user = _user;

- (void)viewDidLoad {
    [super viewDidLoad];
    self.profileImageView.layer.cornerRadius = 5;
    self.profileImageView.clipsToBounds = YES;

    [self.tableView registerNib:[UINib nibWithNibName:@"TweetCell" bundle:nil] forCellReuseIdentifier:@"TweetCell"];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.user = self.user;
}

- (NSString *)highResolutionImageURLFromURL:(NSString *)imageURL {
    NSRange sizeChunk = [imageURL rangeOfString:@"_normal" options:NSBackwardsSearch];
    NSString *generalURL = [imageURL substringToIndex:sizeChunk.location];
    NSString *extension = [imageURL substringFromIndex:(sizeChunk.location + sizeChunk.length)];
    return [generalURL stringByAppendingString:extension];
}

- (void)setUser:(User *)user {
    _user = user;

    NSString *highResolutionImageURL = [self highResolutionImageURLFromURL:user.profileImageURL];
    [self.profileImageView setImageWithURL:[NSURL URLWithString:highResolutionImageURL]];
    self.nameLabel.text = user.name;
    self.usernameLabel.text = [NSString stringWithFormat:@"@%@", user.username];
    self.tweetCountLabel.text = [NSString stringWithFormat:@"%ld", user.tweetCount];
    self.followingCountLabel.text = [NSString stringWithFormat:@"%ld", user.followingCount];
    self.followersCountLabel.text = [NSString stringWithFormat:@"%ld", user.followersCount];

    // Set self.tweets
    NSDictionary *params = [NSDictionary dictionaryWithObject:self.user.username forKey:@"screen_name"];

    [[TwitterClient sharedInstance] userTimelineWithParams:params completion:^(id responseObject, NSError *error) {
        self.tweets = [Tweet tweetsWithArray:responseObject];
        NSLog(@"%ld tweets: %@", self.tweets.count, self.tweets);
        [self.tableView reloadData];
    }];
}

#pragma mark - Table view methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.tweets.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TweetCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TweetCell" forIndexPath:indexPath];
    cell.tweet = self.tweets[indexPath.row];
    cell.delegate = self;
    return cell;
}

#pragma mark - Tweet cell delegate methods

- (void)tweetCell:(TweetCell *)tweetCell onReplyButtonWithReplyID:(NSString *)replyID andReplyUsername:(NSString *)replyUsername {
    ComposeViewController *vc = [[ComposeViewController alloc] init];
    UINavigationController *nvc = [[UINavigationController alloc] initWithRootViewController:vc];
    [self presentViewController:nvc animated:YES completion:^{
        [vc setReplyID:replyID andReplyUsername:replyUsername];
    }];
}

- (void)didTapThumbnailForTweetCell:(TweetCell *)tweetCell {
    ProfileViewController *vc = [[ProfileViewController alloc] init];
    NSIndexPath *indexPath = [self.tableView indexPathForCell:tweetCell];
    vc.user = ((Tweet *)self.tweets[indexPath.row]).user;
    [self.navigationController pushViewController:vc animated:YES];
}

@end
