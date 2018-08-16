//
//  AFNetworkImpl.m
//  JJNetwork
//
//  Created by jezz on 30/07/2017.
//  Copyright © 2017 jezz. All rights reserved.
//

#import "JJAFNetworkImpl.h"
#import <AFNetworking/AFNetworking.h>
#import "JJAPIManager.h"
#import <objc/runtime.h>

@interface JJAFNetworkImpl ()

@end

@implementation JJAFNetworkImpl

#pragma mark - AFURLSessionManager

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

#pragma mark - Implementaion protocol method

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
 Upload files request

 @param request NSURLRequest
 @param parameters NSDictionary
 @param target Which target
 @param selector Target's method name
 @param files file array
 @return NSURLSessionTask track the request object
 */
- (NSURLSessionTask*)httpUploadFileRequest:(NSURLRequest*)request
                                parameters:(NSDictionary*)parameters
                                    target:(id)target
                                  selector:(SEL)selector
                                     files:(NSArray*)files{
    
    [self requestDebugInfo:request parameters:parameters];
    
    NSMutableURLRequest* uploadRequest = [[AFHTTPRequestSerializer serializer] multipartFormRequestWithMethod:@"POST" URLString:request.URL.absoluteString  parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        for (NSDictionary* fileInfo in files) {
            [formData appendPartWithFileURL:fileInfo[JJUploadBodyURLKey] name:fileInfo[JJUploadBodyNameKey] fileName:fileInfo[JJUploadBodyFileNameKey] mimeType:fileInfo[JJUploadBodyMimeTypeKey] error:nil];
        }
        
    } error:nil];
    
    uploadRequest.allHTTPHeaderFields = request.allHTTPHeaderFields;
    
    AFURLSessionManager* sessionManager = [self sessionManager];
    
    __weak typeof(self) weakSelf = self;
    __weak typeof(target) weakTarget = target;
    NSURLSessionUploadTask *uploadTask = [sessionManager
                                          uploadTaskWithStreamedRequest:uploadRequest
                                          progress:nil
                                          completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
                                              __strong typeof(weakSelf) strongSelf = weakSelf;
                                              __strong typeof(weakTarget) strongTarget = weakTarget;
                                              NSLog(@"Response <<<<<<<<<<<<<<<<<<<<<<<<<<<< START");
                                              NSLog(@"Response from url:%@",[[response URL] absoluteString]);
                                              NSLog(@"Response http head field:%@",[(NSHTTPURLResponse*)response allHeaderFields]);
                                              if (error) {
                                                  NSLog(@"Upload Error: %@", error);
                                                  [strongSelf performSelectorOnMainThread:selector withTarget:strongTarget withObject1:response withObject2:error];
                                              } else {
                                                  id targetResponse = [self convertOriginResultToTarget:responseObject];
                                                  [strongSelf performSelectorOnMainThread:selector withTarget:strongTarget withObject1:response withObject2:targetResponse];
                                                  NSString* string = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
                                                  if (string) {
                                                      NSLog(@"Response content:%@",string);
                                                  }else{
                                                      NSLog(@"Response binary:%@",responseObject);
                                                  }
                                              }
                                              NSLog(@"Response <<<<<<<<<<<<<<<<<<<<<<<<<<<< END");
                                          }];
    [uploadTask resume];
    return uploadTask;
}


#pragma mark - Inner implementation

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
    
    [self requestDebugInfo:request parameters:parameter];
    
    //NSMutableURLRequest
    NSMutableURLRequest *mutableRequest = [[AFHTTPRequestSerializer serializer] requestWithMethod:method URLString:request.URL.absoluteString parameters:parameter error:nil];
    mutableRequest.allHTTPHeaderFields = request.allHTTPHeaderFields;
    
    AFURLSessionManager* sessionManager = [self sessionManager];
    
    __weak typeof(self) weakSelf = self;
    __weak typeof(target) weakTarget = target;
    NSURLSessionDataTask *dataTask = [sessionManager dataTaskWithRequest:mutableRequest completionHandler:^(NSURLResponse *response, id responseObject, NSError *error) {
        __strong typeof(weakSelf) strongSelf = weakSelf;
        __strong typeof(weakTarget) strongTarget = weakTarget;
        if (error) {
            [strongSelf performSelectorOnMainThread:selector withTarget:strongTarget withObject1:response withObject2:error];
        } else {
            id targetResponse = [self convertOriginResultToTarget:responseObject];
            [strongSelf performSelectorOnMainThread:selector withTarget:strongTarget withObject1:response withObject2:targetResponse];
        }
        [strongSelf responseDebugInfo:response responseObject:responseObject error:error];
    }];
    [dataTask resume];
    
    return dataTask;
    
}

/**
 Invoke the target selector

 @param selector target selector
 @param target input target
 @param arg1 selector argv only for the first argv
 @param arg2 selector argv only for the second argv
 */
- (void) performSelectorOnMainThread:(SEL)selector withTarget:(id)target withObject1:(id)arg1 withObject2:(id)arg2{
    IMP imp = [target methodForSelector:selector];
    if (imp != NULL) {
        ((void(*)(id,SEL,id,id))imp)(target,selector,arg1,arg2);
    }
}

#pragma mark - Request Response Log

- (void)requestDebugInfo:(NSURLRequest*)request parameters:(NSDictionary*)parameters{
#ifdef DEBUG
    NSLog(@"Send request >>>>>>>>>>>>>>>>>> START");
    NSLog(@"Request url:%@",[request.URL absoluteString]);
    NSLog(@"Request parameter:%@",parameters);
    NSLog(@"Request http head field:%@",request.allHTTPHeaderFields);
    NSLog(@"Send request >>>>>>>>>>>>>>>>>> END");
#endif
}

- (void)responseDebugInfo:(NSURLResponse*)response responseObject:(id)responseObject error:(NSError*)error{
#ifdef DEBUG
    NSLog(@"Response <<<<<<<<<<<<<<<<<<<<<<<<<<<< START");
    NSLog(@"Response from url:%@",[[response URL] absoluteString]);
    NSLog(@"Response http head field:%@",[(NSHTTPURLResponse*)response allHeaderFields]);
    if (error) {
        NSLog(@"Get Error: %@", error);
    } else {
        NSString* string = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        if (string) {
            NSLog(@"Response content:%@",string);
        }else{
            NSLog(@"Response binary:%@",responseObject);
        }
    }
    NSLog(@"Response <<<<<<<<<<<<<<<<<<<<<<<<<<<< END");
#endif
}

#pragma mark - Data convert

/**
 First convert the NSData to JSON.
 Second convert the NSData to NSString.(NSUTF8StringEncoding)
 Third return originData NSData

 @param originData NSData
 @return JSON,NSString or NSData
 */
- (id)convertOriginResultToTarget:(NSData*)originData{
    
    if (!originData) {
        return nil;
    }
    
    NSDictionary* targetDicResult = [NSJSONSerialization JSONObjectWithData:originData options:NSJSONReadingAllowFragments error:nil];
    if (targetDicResult) {
        return targetDicResult;
    }
    NSString* targetStringResult = [[NSString alloc] initWithData:originData encoding:NSUTF8StringEncoding];
    if (targetStringResult) {
        return targetStringResult;
    }
    return originData;
}

@end
