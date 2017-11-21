//
//  AFNetworkImpl.m
//  JJNetwork
//
//  Created by jezz on 30/07/2017.
//  Copyright © 2017 jezz. All rights reserved.
//

#import "JJAFNetworkImpl.h"
#import <AFNetworking/AFNetworking.h>

@interface JJAFNetworkImpl ()

@property(nonatomic,readwrite,copy)NSDictionary* httpHead;

@end

@implementation JJAFNetworkImpl

#pragma mark - Init

- (instancetype)init{
    self = [super init];
    if (self) {
        
    }
    return self;
}


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


/**
 Wrap POST request

 @param request NSURLRequest
 @param target Which target
 @param selector Target's method name
 @return NSURLSessionTask track the request object
 */
- (NSURLSessionTask*)httpPostRequest:(NSURLRequest*)request parameters:(NSDictionary*)parameters target:(id)target selector:(SEL)selector{
	return [self sendHttpRequest:request parameter:parameters httpMethod:@"POST" target:target selector:selector];
}

/**
 Wrap Get request
 
 @param request NSURLRequest
 @param target Which target
 @param selector Target's method name
 @return NSURLSessionTask track the request object
 */
- (NSURLSessionTask*)httpGetRequest:(NSURLRequest*)request parameters:(NSDictionary*)parameters target:(id)target selector:(SEL)selector{
    return [self sendHttpRequest:request parameter:parameters httpMethod:@"GET" target:target selector:selector];
}


/**
 Final AFNetworking send http request

 @param request NSURLRequest
 @param parameter Request parameter key->value
 @param method Http Post or Get
 @param target Which target
 @param selector Target's method name
 @return NSURLSessionTask track the request object
 */
- (NSURLSessionTask*)sendHttpRequest:(NSURLRequest*)request parameter:(NSDictionary*)parameter httpMethod:(NSString*)method target:(id)target selector:(SEL)selector{
    //Show log
    NSLog(@"Send request >>>>>>>>>>>>>>>>>> START");
    NSLog(@"Request url:%@",[request.URL absoluteString]);
    NSLog(@"Request parameter:%@",parameter);
    NSLog(@"Send request >>>>>>>>>>>>>>>>>> END");
    
    //NSMutableURLRequest
    NSMutableURLRequest *mutableRequest = [[AFHTTPRequestSerializer serializer] requestWithMethod:method URLString:request.URL.absoluteString parameters:parameter error:nil];
    
    mutableRequest.allHTTPHeaderFields = request.allHTTPHeaderFields;
    
    AFURLSessionManager* sessionManager = [self sessionManager];
    
    __weak typeof(self) weakSelf = self;
    __weak typeof(target) weakTarget = target;
    NSURLSessionDataTask *dataTask = [sessionManager dataTaskWithRequest:mutableRequest completionHandler:^(NSURLResponse *response, id responseObject, NSError *error) {
        __strong typeof(self) strongSelf = weakSelf;
        __strong typeof(target) strongTarget = weakTarget;
        NSLog(@"Response <<<<<<<<<<<<<<<<<<<<<<<<<<<< START");
        NSLog(@"Response from url:%@",[[response URL] absoluteString]);
        if (error) {
            NSLog(@"Get Error: %@", error);
            [strongSelf performSelectorOnMainThread:selector withTarget:strongTarget withObject:error];
        } else {
            [strongSelf performSelectorOnMainThread:selector withTarget:strongTarget withObject:responseObject];
            NSString* string = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
            if (string) {
                NSLog(@"Response content:%@",string);
            }else{
                NSLog(@"Response binary:%@",responseObject);
            }
        }
        NSLog(@"Response <<<<<<<<<<<<<<<<<<<<<<<<<<<< END");
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
	
	[invo performSelectorOnMainThread:@selector(invoke) withObject:nil waitUntilDone:YES];
}

@end
