//
//  APIService.m
//  JJNetwork
//
//  Created by jezz on 30/07/2017.
//  Copyright © 2017 jezz. All rights reserved.
//

#import "APIService.h"
#import "APIManager.h"
#import "APIRequest.h"

@implementation APIService

- (void)dealloc{
	
}

- (Class)generateRequest{
	return nil;
}

- (void)startRequest{
	
	
	Class class = self.generateRequest;
	if (!class) {
		NSAssert(class != nil, @"Request object must not be nil");
		return;
	}
	if (![class conformsToProtocol:@protocol(RequestProtocol)]) {
		NSAssert([class conformsToProtocol:@protocol(RequestProtocol)],@"Request must implement RequestProtocol");
		return;
	}
	APIRequest<RequestProtocol>* request = [[class alloc] init];
	
	NSDictionary* parameters = [self.serviceProtocol requestParameters];
	NSString* url = [request requestURL];
	HTTPMethod httpMethod = [request requestMethod];
	
	//Send http request
	
	if (httpMethod == GET){
		[[APIManager shareAPIManaer] httpGet:[NSURL URLWithString:url] parameter:parameters target:self selector:@selector(networkResponse:)];
	}else if(httpMethod == POST){
		[[APIManager shareAPIManaer] httpPost:[NSURL URLWithString:url] parameter:parameters target:self selector:@selector(networkResponse:)];
	}
}

- (void)networkResponse:(id)response{
	if ([response isKindOfClass:[NSError class]]) {
		//Handle Error
		if([self.serviceProtocol respondsToSelector:@selector(responseFail:errorMessage:)]){
			[self.serviceProtocol responseFail:self errorMessage:response];
		}
	}else{
		//Handle Content
		if([self.serviceProtocol respondsToSelector:@selector(responseSuccess:responseData:)]){
			[self.serviceProtocol responseSuccess:self responseData:response];
		}
	}
}

@end
