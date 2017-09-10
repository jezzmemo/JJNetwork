//
//  AFNetworkImpl.m
//  JJNetwork
//
//  Created by jezz on 30/07/2017.
//  Copyright © 2017 jezz. All rights reserved.
//

#import "AFNetworkImpl.h"
#import <AFNetworking/AFNetworking.h>

@interface AFNetworkImpl ()

@property(nonatomic,readwrite,copy)NSDictionary* httpHead;

@end

@implementation AFNetworkImpl

#pragma mark - Init

- (instancetype)init{
    self = [super init];
    if (self) {
        
    }
    return self;
}

#pragma mark - Config


/**
 Get AFNetworking AFURLSessionManager object

 @return AFURLSessionManager
 */
- (AFURLSessionManager*)sessionManager{
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    AFURLSessionManager* manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];

    return manager;
}

#pragma mark - Implemetn protocol

- (void)setHttpHeadField:(NSDictionary *)dic{
    self.httpHead = dic;
}

/**
 Wrap POST request

 @param url Requset http url
 @param parameter Request parameter key->value
 @param target Which target
 @param selector Target's method name
 @return NSURLSessionTask track the request object
 */
- (NSURLSessionTask*)httpPost:(NSURL*)url parameter:(NSDictionary*)parameter target:(id)target selector:(SEL)selector{
	return [self sendHttpRequestWithURL:url parameter:parameter httpMethod:@"POST" target:target selector:selector];
}

/**
 Wrap Get request
 
 @param url Requset http url
 @param parameter Request parameter key->value
 @param target Which target
 @param selector Target's method name
 @return NSURLSessionTask track the request object
 */
- (NSURLSessionTask*)httpGet:(NSURL*)url parameter:(NSDictionary*)parameter target:(id)target selector:(SEL)selector{
    return [self sendHttpRequestWithURL:url parameter:parameter httpMethod:@"GET" target:target selector:selector];
}


/**
 Final AFNetworking send http request

 @param url Requset http url
 @param parameter Request parameter key->value
 @param method Http Post or Get
 @param target Which target
 @param selector Target's method name
 @return NSURLSessionTask track the request object
 */
- (NSURLSessionTask*)sendHttpRequestWithURL:(NSURL*)url parameter:(NSDictionary*)parameter httpMethod:(NSString*)method target:(id)target selector:(SEL)selector{
    //Show log
    NSLog(@"Send request >>>>>>>>>>>>>>>>>> START");
    NSLog(@"Request url:%@",[url absoluteString]);
    NSLog(@"Request parameter:%@",parameter);
    NSLog(@"Send request >>>>>>>>>>>>>>>>>> END");
    
    //NSMutableURLRequest
    NSMutableURLRequest *request = [[AFHTTPRequestSerializer serializer] requestWithMethod:method URLString:url.absoluteString parameters:parameter error:nil];
    
    AFURLSessionManager* sessionManager = [self sessionManager];
    
    __weak typeof(self) _self = self;
    __weak typeof(target) _target = target;
    NSURLSessionDataTask *dataTask = [sessionManager dataTaskWithRequest:request completionHandler:^(NSURLResponse *response, id responseObject, NSError *error) {
        
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
                NSLog(@"Response binary");
            }
            [_self performSelectorOnMainThread:selector withTarget:_target withObject:responseObject];
        }
    }];
    [dataTask resume];
    
    return dataTask;
    
}


/**
 Invoke the target selector

 @param selector target selector
 @param target input target
 @param arg1 selector argv only for the one argv
 */
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
