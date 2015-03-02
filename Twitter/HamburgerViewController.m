//
//  HamburgerViewController.m
//  Twitter
//
//  Created by Neal Wu on 3/1/15.
//  Copyright (c) 2015 Neal Wu. All rights reserved.
//

#import "HamburgerViewController.h"
#import "HamburgerCell.h"

@interface HamburgerViewController () <UITableViewDataSource, UITableViewDelegate, HamburgerCellDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation HamburgerViewController

const int NUMBER_OF_TABS = 4;

const int PROFILE_TAB = 0;
const int HOME_TIMELINE_TAB = 1;
const int MENTIONS_TAB = 2;
const int LOGOUT_TAB = 3;

- (void)viewDidLoad {
    [super viewDidLoad];

    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    [self.tableView registerNib:[UINib nibWithNibName:@"HamburgerCell" bundle:nil] forCellReuseIdentifier:@"HamburgerCell"];
}

#pragma mark - Table view methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return NUMBER_OF_TABS;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    HamburgerCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HamburgerCell" forIndexPath:indexPath];
    cell.delegate = self;

    if (indexPath.row == PROFILE_TAB) {
        cell.text = @"Profile";
    } else if (indexPath.row == HOME_TIMELINE_TAB) {
        cell.text = @"Timeline";
    } else if (indexPath.row == MENTIONS_TAB) {
        cell.text = @"Mentions";
    } else if (indexPath.row == LOGOUT_TAB) {
        cell.text = @"Logout";
    } else {
        NSLog(@"Unknown row for the hamburger menu table!");
        assert(NO);
    }

    return cell;
}

#pragma mark - HamburgerCell delegate methods

- (void)hamburgerCellDidPressButton:(HamburgerCell *)hamburgerCell {
    NSInteger row = [self.tableView indexPathForCell:hamburgerCell].row;

    if (row == PROFILE_TAB) {

    } else if (row == HOME_TIMELINE_TAB) {

    } else if (row == MENTIONS_TAB) {

    } else if (row == LOGOUT_TAB) {

    } else {
        NSLog(@"Unknown row for the hamburger menu table!");
        assert(NO);
    }
}

@end
