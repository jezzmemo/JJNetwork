//
//  PresentViewController.m
//  JJNetwork
//
//  Created by Jezz on 2017/8/27.
//  Copyright © 2017年 jezz. All rights reserved.
//

#import "PresentViewController.h"
#import "DomainModule.h"
#import "HttpHeadModule.h"
#import "DemoRequest.h"
#import "JJAPIRequest+Extension.h"

@interface PresentViewController ()<JJRequestDelegate,JJRequestInterseptor>

@property(nonatomic,readwrite,strong)DemoRequest* demoRequest;

@property(nonatomic,readwrite,strong)DomainModule* domainModule;

@property(nonatomic,readwrite,strong)HttpHeadModule* allHttpHeadField;

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
    
//    [JJAPIRequest registerDomainIP:self.domainModule];
    [JJAPIRequest registerHttpHeadField:self.allHttpHeadField];
    
    [JJAPIRequest addRequestInterseptor:self forRequestClass:[DemoRequest class]];
    
    [self.demoRequest startRequest];
}

- (void)dealloc{
    [JJAPIRequest removeRequestInterseptor:self forRequestClass:[DemoRequest class]];
}

- (void)dismissViewController{
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - Get property

- (HttpHeadModule*)allHttpHeadField{
    if (_allHttpHeadField != nil) {
        return _allHttpHeadField;
    }
    _allHttpHeadField = [HttpHeadModule new];
    return _allHttpHeadField;
}

- (DomainModule*)domainModule{
    if (_domainModule != nil) {
        return _domainModule;
    }
    _domainModule = [DomainModule new];
    return _domainModule;
}

- (DemoRequest*)demoRequest{
    if (_demoRequest != nil) {
        return _demoRequest;
    }
    _demoRequest = [DemoRequest new];
    _demoRequest.delegate = self;
    _demoRequest.requestInterseptor = self;
    return _demoRequest;
}

#pragma mark - Request parameter

- (NSDictionary*)requestParameters:(JJAPIRequest *)request{
    return @{@"mod":@"getHotDiary"};
}

#pragma mark - Network response

- (void)responseSuccess:(JJAPIRequest *)request responseData:(id)data{
    NSLog(@"responseSuccess");
}

- (void)responseFail:(JJAPIRequest *)request errorMessage:(NSError *)error{
    NSLog(@"responseFail");
}

#pragma mark - JJAPIRequest Interseptor

- (void)beforeRequest:(JJAPIRequest*)request{
    NSLog(@"beforeStartRequest");
}

- (void)afterRequest:(JJAPIRequest*)request{
    NSLog(@"afterStartRequest");
}

- (void)request:(JJAPIRequest*)request beforeResponse:(id)data{
    NSLog(@"beforeResponse");
}

- (void)request:(JJAPIRequest*)request afterResponse:(id)data{
    NSLog(@"afterResponse");
}

@end
