//
//  HamburgerCell.m
//  Twitter
//
//  Created by Neal Wu on 3/1/15.
//  Copyright (c) 2015 Neal Wu. All rights reserved.
//

#import "HamburgerCell.h"

@interface HamburgerCell ()

@property (weak, nonatomic) IBOutlet UIButton *itemButton;

@end

@implementation HamburgerCell

@synthesize text = _text;

- (void)setText:(NSString *)text {
    _text = text;
    [self.itemButton setTitle:text forState:UIControlStateNormal];
}

- (IBAction)onButtonPressed:(id)sender {
    [self.delegate hamburgerCellDidPressButton:self];
}

@end
