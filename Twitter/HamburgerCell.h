//
//  HamburgerCell.h
//  Twitter
//
//  Created by Neal Wu on 3/1/15.
//  Copyright (c) 2015 Neal Wu. All rights reserved.
//

#import <UIKit/UIKit.h>

@class HamburgerCell;

@protocol HamburgerCellDelegate <NSObject>

- (void)hamburgerCellDidPressButton:(HamburgerCell *)hamburgerCell;

@end

@interface HamburgerCell : UITableViewCell

@property (weak, nonatomic) id<HamburgerCellDelegate> delegate
@property (strong, nonatomic) NSString *text;;

@end
