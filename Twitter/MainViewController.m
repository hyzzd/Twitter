//
//  MainViewController.m
//  Twitter
//
//  Created by Neal Wu on 3/2/15.
//  Copyright (c) 2015 Neal Wu. All rights reserved.
//

#import "MainViewController.h"
#import "HamburgerViewController.h"
#import "TweetsViewController.h"
#import "ProfileViewController.h"

@interface MainViewController () <TweetsViewControllerDelegate>

@property (weak, nonatomic) IBOutlet UIView *contentView;

@property (strong, nonatomic) HamburgerViewController *hamburgerVC;
@property (strong, nonatomic) UIViewController *tweetsVC;
@property (strong, nonatomic) UINavigationController *tweetsNVC;

@property (assign, nonatomic) BOOL hamburgerMenuEnabled;

@end

@implementation MainViewController

const int HAMBURGER_WIDTH = 140;

- (void)viewDidLoad {
    [super viewDidLoad];

    self.hamburgerVC = [[HamburgerViewController alloc] init];
    self.hamburgerVC.view.frame = self.contentView.frame;
    [self addChildViewController:self.hamburgerVC];
    [self.contentView addSubview:self.hamburgerVC.view];
    [self.hamburgerVC didMoveToParentViewController:self];

    [self onTimelineButton];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onProfileButton) name:PROFILE_BUTTON_NOTIFICATION object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onTimelineButton) name:TIMELINE_BUTTON_NOTIFICATION object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onMentionsButton) name:MENTIONS_BUTTON_NOTIFICATION object:nil];
}

#pragma mark - TweetsViewController delegate methods

- (void)tweetsViewControllerDidPressHamburgerButton:(TweetsViewController *)tweetsViewController {
    [UIView animateWithDuration:0.8 delay:0 usingSpringWithDamping:0.7 initialSpringVelocity:0 options:0 animations:^{
        self.tweetsNVC.view.center = CGPointMake(self.tweetsNVC.view.center.x + (self.hamburgerMenuEnabled ? -1 : +1) * HAMBURGER_WIDTH, self.tweetsNVC.view.center.y);
    } completion:nil];

    self.hamburgerMenuEnabled = !self.hamburgerMenuEnabled;
}

#pragma mark - Private methods

- (void)onProfileButton {
    ProfileViewController *vc = [[ProfileViewController alloc] init];
    vc.user = [User currentUser];
    [self.tweetsVC.navigationController pushViewController:vc animated:YES];
    [self tweetsViewControllerDidPressHamburgerButton:nil];
}

- (void)onTimelineButton {
    TweetsViewController *vc = [[TweetsViewController alloc] init];
    vc.delegate = self;
    vc.shouldDisplayMentions = NO;
    self.tweetsVC = vc;

    self.tweetsNVC = [[UINavigationController alloc] initWithRootViewController:self.tweetsVC];
    self.tweetsNVC.view.frame = self.contentView.frame;
    [self addChildViewController:self.tweetsNVC];
    [self.contentView addSubview:self.tweetsNVC.view];
    [self.tweetsNVC didMoveToParentViewController:self];

    self.hamburgerMenuEnabled = NO;
}

- (void)onMentionsButton {
    [self onTimelineButton];
    ((TweetsViewController *) self.tweetsVC).shouldDisplayMentions = YES;
}

@end
