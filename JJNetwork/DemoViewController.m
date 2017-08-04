//
//  ViewController.m
//  JJNetwork
//
//  Created by jezz on 30/07/2017.
//  Copyright © 2017 jezz. All rights reserved.
//

#import "DemoViewController.h"
#import "DemoAPIService.h"

@interface DemoViewController ()<APIServiceProtocol>

@property(nonatomic,readwrite,strong)DemoAPIService* apiService;

@end

@implementation DemoViewController

- (void)viewDidLoad {
	[super viewDidLoad];
	
	[self.apiService startRequest];
}


- (DemoAPIService*)apiService{
	if (_apiService != nil) {
		return _apiService;
	}
	_apiService = [[DemoAPIService alloc] init];
	_apiService.serviceProtocol = self;
	return _apiService;
}

- (void)responseSuccess:(APIService *)service responseData:(id)data{
	
}

- (void)responseFail:(APIService *)service errorMessage:(NSError *)error{
	
}

- (NSDictionary*)requestParameters{
	return nil;
}

- (void)didReceiveMemoryWarning {
	[super didReceiveMemoryWarning];
	// Dispose of any resources that can be recreated.
}


@end
