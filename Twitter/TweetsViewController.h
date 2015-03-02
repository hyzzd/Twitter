//
//  TweetsViewController.h
//  Twitter
//
//  Created by Neal Wu on 2/24/15.
//  Copyright (c) 2015 Neal Wu. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TweetsViewController;

@protocol TweetsViewControllerDelegate <NSObject>

- (void)tweetsViewControllerDidPressHamburgerButton:(TweetsViewController *)tweetsViewController;

@end

@interface TweetsViewController : UIViewController

@property (weak, nonatomic) id<TweetsViewControllerDelegate> delegate;

@end
