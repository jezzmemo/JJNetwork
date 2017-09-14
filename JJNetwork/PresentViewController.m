//
//  PresentViewController.m
//  JJNetwork
//
//  Created by Jezz on 2017/8/27.
//  Copyright © 2017年 jezz. All rights reserved.
//

#import "PresentViewController.h"
#import "DemoAPIService.h"
#import "DomainModule.h"

@interface PresentViewController ()<APIServiceProtocol>

@property(nonatomic,readwrite,strong)DemoAPIService* apiService;


@end

@implementation PresentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    UIButton* button = [UIButton buttonWithType:UIButtonTypeSystem];
    [button setTitle:@"Dismiss Controller" forState:UIControlStateNormal];
    button.frame = CGRectMake(0, 0, CGRectGetWidth(self.view.frame), 30);
    [button addTarget:self action:@selector(dismissViewController) forControlEvents:UIControlEventTouchUpInside];
    button.center = self.view.center;
    [self.view addSubview:button];
    
    [APIService registerDomainIP:[[DomainModule alloc] init]];
    
    [self.apiService userDetailInfo:100];
    
}

- (void)dismissViewController{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (DemoAPIService*)apiService{
    if (_apiService != nil) {
        return _apiService;
    }
    _apiService = [[DemoAPIService alloc] init];
    _apiService.serviceProtocol = self;
    return _apiService;
}

#pragma mark - Network response

- (void)responseSuccess:(APIService *)service responseData:(id)data{
    
}

- (void)responseFail:(APIService *)service errorMessage:(NSError *)error{
    
}

@end
