//
//  AFNetworkImpl.m
//  JJNetwork
//
//  Created by jezz on 30/07/2017.
//  Copyright © 2017 jezz. All rights reserved.
//

#import "AFNetworkImpl.h"
#import <AFNetworking/AFNetworking.h>

@implementation AFNetworkImpl


- (void)httpPost:(NSURL*)url parameter:(NSDictionary*)parameter target:(id)target selector:(SEL)selector{
	NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
	AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
	
	NSURLRequest *request = [[AFHTTPRequestSerializer serializer] requestWithMethod:@"POST" URLString:url.absoluteString parameters:parameter error:nil];
	
	
	NSURLSessionDataTask *dataTask = [manager dataTaskWithRequest:request completionHandler:^(NSURLResponse *response, id responseObject, NSError *error) {
		if (error) {
			NSLog(@"Post Error: %@", error);
			[self performSelectorOnMainThread:selector withTarget:target withObject:error];
		} else {
			NSLog(@"Post %@ %@", response, responseObject);
			[self performSelectorOnMainThread:selector withTarget:target withObject:responseObject];
		}
	}];
	[dataTask resume];
}

- (void)httpGet:(NSURL*)url parameter:(NSDictionary*)parameter target:(id)target selector:(SEL)selector{
	
	NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
	AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
	
	NSURLRequest *request = [[AFHTTPRequestSerializer serializer] requestWithMethod:@"GET" URLString:url.absoluteString parameters:parameter error:nil];

	
	NSURLSessionDataTask *dataTask = [manager dataTaskWithRequest:request completionHandler:^(NSURLResponse *response, id responseObject, NSError *error) {
		if (error) {
			NSLog(@"Get Error: %@", error);
			[self performSelectorOnMainThread:selector withTarget:target withObject:error];
		} else {
			NSLog(@"Get %@ %@", response, responseObject);
			[self performSelectorOnMainThread:selector withTarget:target withObject:responseObject];
		}
	}];
	[dataTask resume];

}

- (void) performSelectorOnMainThread:(SEL)selector withTarget:(id)target withObject:(id)arg1{
	NSMethodSignature* sign = [target methodSignatureForSelector:selector];
	if (!sign) {
		return;
	}
	NSInvocation* invo = [NSInvocation invocationWithMethodSignature:sign];
	[invo setTarget:target];
	[invo setSelector:selector];
	[invo setArgument:&arg1 atIndex:2];//0:target 1:_cmd
	[invo retainArguments];
	
	[invo performSelectorOnMainThread:@selector(invoke) withObject:nil waitUntilDone:NO];
}

@end
