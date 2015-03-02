//
//  TweetsViewController.m
//  Twitter
//
//  Created by Neal Wu on 2/24/15.
//  Copyright (c) 2015 Neal Wu. All rights reserved.
//

#import "TweetsViewController.h"
#import "User.h"
#import "Tweet.h"
#import "TwitterClient.h"
#import "TweetCell.h"
#import "ComposeViewController.h"
#import "TweetDetailsViewController.h"
#import "ProfileViewController.h"

@interface TweetsViewController () <UITableViewDataSource, UITableViewDelegate, TweetCellDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (strong, nonatomic) UIRefreshControl *refreshControl;
@property (strong, nonatomic) NSArray *tweets;

@end

NSString * const LAST_REFRESH_TIME = @"LastRefreshTime";
NSString * const SAVED_TWEETS = @"SavedTweets";
const double MINIMUM_REFRESH_TIME = 60; // 60 seconds required in between refresh calls

@implementation TweetsViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.title = @"Home";
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Logout" style:UIBarButtonItemStylePlain target:self action:@selector(onLogoutButton)];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCompose target:self action:@selector(onComposeButton)];

    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    [self.tableView registerNib:[UINib nibWithNibName:@"TweetCell" bundle:nil] forCellReuseIdentifier:@"TweetCell"];

    self.refreshControl = [[UIRefreshControl alloc] init];
    [self.refreshControl addTarget:self action:@selector(loadTweets) forControlEvents:UIControlEventValueChanged];
    [self.tableView insertSubview:self.refreshControl atIndex:0];

    self.tableView.estimatedRowHeight = 10;
    self.tableView.rowHeight = UITableViewAutomaticDimension;

    [self loadTweets];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.tableView reloadData];
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

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    TweetDetailsViewController *vc = [[TweetDetailsViewController alloc] init];
    vc.tweet = self.tweets[indexPath.row];
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - TweetCell delegate methods

- (void)tweetCell:(TweetCell *)tweetCell onReplyButtonWithReplyID:(NSString *)replyID andReplyUsername:(NSString *)replyUsername {
    ComposeViewController *vc = [[ComposeViewController alloc] init];
    UINavigationController *nvc = [[UINavigationController alloc] initWithRootViewController:vc];
    [self presentViewController:nvc animated:YES completion:^{
        [vc setReplyID:replyID andReplyUsername:replyUsername];
    }];
}

- (void)tweetCellDidTapThumbnail:(TweetCell *)tweetCell {
    ProfileViewController *vc = [[ProfileViewController alloc] init];
    NSIndexPath *indexPath = [self.tableView indexPathForCell:tweetCell];
    vc.user = ((Tweet *)self.tweets[indexPath.row]).user;
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - Private methods

- (void)useDefaultsForTweets:(NSUserDefaults *)defaults {
    NSData *data = [defaults objectForKey:SAVED_TWEETS];

    if (data != nil) {
        id responseObject = [NSJSONSerialization JSONObjectWithData:data options:0 error:NULL];
        self.tweets = [Tweet tweetsWithArray:responseObject];
        [self.tableView reloadData];
    }

    [self.refreshControl endRefreshing];
}

- (void)loadTweets {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    double lastRefresh = [defaults doubleForKey:LAST_REFRESH_TIME];
    double currentTime = [[NSDate date] timeIntervalSinceReferenceDate];

    if (currentTime - lastRefresh < MINIMUM_REFRESH_TIME) {
        [self useDefaultsForTweets:defaults];
        return;
    }

    [[TwitterClient sharedInstance] homeTimelineWithParams:nil completion:^(id responseObject, NSError *error) {
        if (error == nil) {
            [defaults setDouble:currentTime forKey:LAST_REFRESH_TIME];
            self.tweets = [Tweet tweetsWithArray:responseObject];
            [self.tableView reloadData];
            [self.refreshControl endRefreshing];
            NSData *data = [NSJSONSerialization dataWithJSONObject:responseObject options:0 error:NULL];
            [defaults setObject:data forKey:SAVED_TWEETS];
        } else {
            [self useDefaultsForTweets:defaults];
        }
    }];
}

- (void)onLogoutButton {
    [User logout];
}

- (void)onComposeButton {
    ComposeViewController *vc = [[ComposeViewController alloc] init];
    UINavigationController *nvc = [[UINavigationController alloc] initWithRootViewController:vc];
    [self presentViewController:nvc animated:YES completion:nil];
}

@end
