//
//  ComposeViewController.m
//  Twitter
//
//  Created by Neal Wu on 2/25/15.
//  Copyright (c) 2015 Neal Wu. All rights reserved.
//

#import "ComposeViewController.h"

@interface ComposeViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *thumbnailView;

@end

@implementation ComposeViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self.thumbnailView setImage:[UIImage imageNamed:@"Star"]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
