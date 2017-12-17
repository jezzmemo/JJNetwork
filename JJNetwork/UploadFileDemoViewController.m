//
//  UploadFileDemoViewController.m
//  JJNetwork
//
//  Created by Jezz on 2017/12/15.
//  Copyright © 2017年 jezz. All rights reserved.
//

#import "UploadFileDemoViewController.h"
#import "UploadFileDemoRequest.h"

@interface UploadFileDemoViewController ()<JJRequestDelegate>

@property(nonatomic,readwrite,strong)UploadFileDemoRequest* demoRequest;

@end

@implementation UploadFileDemoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    UIButton* button = [UIButton buttonWithType:UIButtonTypeSystem];
    [button setTitle:@"Dismiss Controller" forState:UIControlStateNormal];
    button.frame = CGRectMake(0, 0, CGRectGetWidth(self.view.frame), 30);
    [button addTarget:self action:@selector(dismissViewController) forControlEvents:UIControlEventTouchUpInside];
    button.center = self.view.center;
    [self.view addSubview:button];
    
    [self.demoRequest startRequest];
}

- (void)dismissViewController{
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - Network response

- (void)responseSuccess:(JJAPIRequest *)request responseData:(id)data{
    NSLog(@"responseSuccess");
}

- (void)responseFail:(JJAPIRequest *)request errorMessage:(NSError *)error{
    NSLog(@"responseFail");
}

#pragma mark - Upload file

- (NSDictionary*)requestParameters:(JJAPIRequest *)request{
    return @{@"mod":@"upload"};
}

#pragma mark - Get property

- (UploadFileDemoRequest*)demoRequest{
    if (_demoRequest != nil) {
        return _demoRequest;
    }
    _demoRequest = [UploadFileDemoRequest new];
    _demoRequest.delegate = self;
    return _demoRequest;
}

@end
