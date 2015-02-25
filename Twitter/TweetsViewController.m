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

@interface TweetsViewController () <UITableViewDataSource, UITableViewDelegate>

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

    self.title = @"Tweets";
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Logout" style:UIBarButtonItemStylePlain target:self action:@selector(onLogout)];

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
    [cell populateWithTweet:self.tweets[indexPath.row]];
    return cell;
}

#pragma mark - Private methods

- (void)loadTweets {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];

    double lastRefresh = [defaults doubleForKey:LAST_REFRESH_TIME];
    double currentTime = [[NSDate date] timeIntervalSinceReferenceDate];

    if (currentTime - lastRefresh < MINIMUM_REFRESH_TIME) {
        NSLog(@"Skipping refresh and getting tweets from defaults due to minimum refresh time");
        NSData *data = [defaults objectForKey:SAVED_TWEETS];

        if (data != nil) {
            id responseObject = [NSJSONSerialization JSONObjectWithData:data options:0 error:NULL];
            self.tweets = [Tweet tweetsWithArray:responseObject];
            [self.tableView reloadData];
        }

        [self.refreshControl endRefreshing];
        return;
    }

    [defaults setDouble:currentTime forKey:LAST_REFRESH_TIME];

    [[TwitterClient sharedInstance] homeTimelineWithParams:nil completion:^(id responseObject, NSError *error) {
        self.tweets = [Tweet tweetsWithArray:responseObject];
        [self.tableView reloadData];
        [self.refreshControl endRefreshing];
        NSData *data = [NSJSONSerialization dataWithJSONObject:responseObject options:0 error:NULL];
        [defaults setObject:data forKey:SAVED_TWEETS];
        NSLog(@"Got %ld tweets", self.tweets == nil ? 0 : self.tweets.count);
    }];
}

- (void)onLogout {
    [User logout];
}

@end
