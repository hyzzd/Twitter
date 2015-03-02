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

@interface MainViewController () <TweetsViewControllerDelegate>

@property (weak, nonatomic) IBOutlet UIView *contentView;

@property (strong, nonatomic) HamburgerViewController *hamburgerVC;
@property (strong, nonatomic) TweetsViewController *tweetsVC;
@property (strong, nonatomic) UINavigationController *tweetsNVC;

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

    self.tweetsVC = [[TweetsViewController alloc] init];
    self.tweetsVC.delegate = self;
    self.tweetsNVC = [[UINavigationController alloc] initWithRootViewController:self.tweetsVC];
    self.tweetsNVC.view.frame = self.contentView.frame;
    [self addChildViewController:self.tweetsNVC];
    [self.contentView addSubview:self.tweetsNVC.view];
    [self.tweetsNVC didMoveToParentViewController:self];
}

#pragma mark - TweetsViewController delegate methods

- (void)tweetsViewControllerDidPressHamburgerButton:(TweetsViewController *)tweetsViewController {
    self.tweetsNVC.view.center = CGPointMake(self.tweetsNVC.view.center.x + HAMBURGER_WIDTH, self.tweetsNVC.view.center.y);
}

@end
