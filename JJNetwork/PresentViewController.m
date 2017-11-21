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
#import "JJAPIService+Extension.h"

@interface PresentViewController ()<JJAPIServiceProtocol,JJAPIServiceInterseptor>

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
    
    [JJAPIService registerDomainIP:[[DomainModule alloc] init]];
    [JJAPIService registerHttpHeadField:[[HttpHeadModule alloc] init]];
    
    [JJAPIService addServiceInterseptor:self forServiceClass:[DemoAPIService class]];
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

- (void)responseSuccess:(JJAPIService *)service responseData:(id)data{
    NSLog(@"responseSuccess");
}

- (void)responseFail:(JJAPIService *)service errorMessage:(NSError *)error{
    NSLog(@"responseFail");
}

#pragma mark - APIService Interseptor

- (void)apiService:(JJAPIService*)service beforeStartRequest:(JJAPIRequest*)request{
    NSLog(@"beforeStartRequest");
}

- (void)apiService:(JJAPIService*)service afterStartRequest:(JJAPIRequest*)request{
    NSLog(@"afterStartRequest");
}

- (void)apiService:(JJAPIService*)service beforeResponse:(id)data{
    NSLog(@"beforeResponse");
}

- (void)apiService:(JJAPIService*)service afterResponse:(id)data{
    NSLog(@"afterResponse");
}

@end
