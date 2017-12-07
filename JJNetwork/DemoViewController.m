//
//  ViewController.m
//  JJNetwork
//
//  Created by jezz on 30/07/2017.
//  Copyright © 2017 jezz. All rights reserved.
//

#import "DemoViewController.h"
#import "PresentViewController.h"

@interface DemoViewController ()


@end

@implementation DemoViewController

- (void)viewDidLoad {
	[super viewDidLoad];
    
    UIButton* button = [UIButton buttonWithType:UIButtonTypeSystem];
    [button setTitle:@"Present View Controller" forState:UIControlStateNormal];
    button.frame = CGRectMake(0, 0, CGRectGetWidth(self.view.frame), 30);
    [button addTarget:self action:@selector(presentViewController) forControlEvents:UIControlEventTouchUpInside];
    button.center = self.view.center;
    [self.view addSubview:button];
}

- (void)presentViewController{
    PresentViewController* present = [[PresentViewController alloc] init];
    [self presentViewController:present animated:YES completion:nil];
}

@end
