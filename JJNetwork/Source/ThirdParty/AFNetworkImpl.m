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

- (AFURLSessionManager*)sessionManager{
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    AFURLSessionManager* manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    return manager;
}


- (NSURLSessionTask*)httpPost:(NSURL*)url parameter:(NSDictionary*)parameter target:(id)target selector:(SEL)selector{
	return [self sendHttpRequestWithURL:url parameter:parameter httpMethod:@"POST" target:target selector:selector];
}

- (NSURLSessionTask*)httpGet:(NSURL*)url parameter:(NSDictionary*)parameter target:(id)target selector:(SEL)selector{
    return [self sendHttpRequestWithURL:url parameter:parameter httpMethod:@"GET" target:target selector:selector];
}

- (NSURLSessionTask*)sendHttpRequestWithURL:(NSURL*)url parameter:(NSDictionary*)parameter httpMethod:(NSString*)method target:(id)target selector:(SEL)selector{
    //Show log
    NSLog(@"Send request >>>>>>>>>>>>>>>>>> START");
    NSLog(@"Request url:%@",[url absoluteString]);
    NSLog(@"Request parameter:%@",parameter);
    NSLog(@"Send request >>>>>>>>>>>>>>>>>> END");
    
    NSURLRequest *request = [[AFHTTPRequestSerializer serializer] requestWithMethod:method URLString:url.absoluteString parameters:parameter error:nil];
    
    __weak typeof(self) _self = self;
    __weak typeof(target) _target = target;
    NSURLSessionDataTask *dataTask = [[self sessionManager] dataTaskWithRequest:request completionHandler:^(NSURLResponse *response, id responseObject, NSError *error) {
        
        if (error) {
            NSLog(@"Get Error: %@", error);
            [_self performSelectorOnMainThread:selector withTarget:_target withObject:error];
        } else {
            NSString* string = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
            if (string) {
                NSLog(@"Response <<<<<<<<<<<<<<<<<<<<<<<<<<<< START");
                NSLog(@"Response from url:%@",[[response URL] absoluteString]);
                NSLog(@"Response content:%@",string);
                NSLog(@"Response <<<<<<<<<<<<<<<<<<<<<<<<<<<< END");
            }else{
                NSLog(@"Response string nil");
            }
            [_self performSelectorOnMainThread:selector withTarget:_target withObject:responseObject];
        }
    }];
    [dataTask resume];
    
    return dataTask;
    
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
