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
#import "HttpHeadModule.h"
#import "APIService+Extension.h"

@interface PresentViewController ()<APIServiceProtocol,APIServiceInterseptor>

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
    [APIService registerHttpHeadField:[[HttpHeadModule alloc] init]];
    
    [APIService addServiceInterseptor:self forServiceClass:[DemoAPIService class]];
    //[APIService removeServiceInterseptor:self forServiceClass:[DemoAPIService class]];
    
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
    _apiService.serviceInterseptor = self;
    return _apiService;
}

#pragma mark - Network response

- (void)responseSuccess:(APIService *)service responseData:(id)data{
    NSLog(@"responseSuccess");
}

- (void)responseFail:(APIService *)service errorMessage:(NSError *)error{
    NSLog(@"responseFail");
}

#pragma mark - APIService Interseptor

- (void)apiService:(APIService*)service beforeStartRequest:(APIRequest*)request{
    NSLog(@"beforeStartRequest");
}

- (void)apiService:(APIService*)service afterStartRequest:(APIRequest*)request{
    NSLog(@"afterStartRequest");
}

- (void)apiService:(APIService*)service beforeResponse:(id)data{
    NSLog(@"beforeResponse");
}

- (void)apiService:(APIService*)service afterResponse:(id)data{
    NSLog(@"afterResponse");
}

@end
