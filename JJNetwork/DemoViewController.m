//
//  ViewController.m
//  JJNetwork
//
//  Created by jezz on 30/07/2017.
//  Copyright © 2017 jezz. All rights reserved.
//

#import "DemoViewController.h"
#import "PresentViewController.h"
#import "UploadFileDemoViewController.h"

@interface DemoViewController ()


@end

@implementation DemoViewController

- (void)viewDidLoad {
	[super viewDidLoad];
    
    UIButton* simpleButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [simpleButton setTitle:@"Simple request" forState:UIControlStateNormal];
    simpleButton.frame = CGRectMake(0, 0, CGRectGetWidth(self.view.frame), 30);
    [simpleButton addTarget:self action:@selector(presentViewController) forControlEvents:UIControlEventTouchUpInside];
    simpleButton.center = self.view.center;
    [self.view addSubview:simpleButton];
    
    UIButton* uploadButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [uploadButton setTitle:@"Upload request" forState:UIControlStateNormal];
    uploadButton.frame = CGRectMake(0, 0, CGRectGetWidth(self.view.frame), 30);
    [uploadButton addTarget:self action:@selector(uploadFileViewController) forControlEvents:UIControlEventTouchUpInside];
    uploadButton.center = CGPointMake(self.view.center.x, self.view.center.y + 40);
    [self.view addSubview:uploadButton];
}

- (void)presentViewController{
    PresentViewController* present = [[PresentViewController alloc] init];
    [self presentViewController:present animated:YES completion:nil];
}

- (void)uploadFileViewController{
    UploadFileDemoViewController* present = [[UploadFileDemoViewController alloc] init];
    [self presentViewController:present animated:YES completion:nil];
}

@end
