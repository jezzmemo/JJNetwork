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
#import "NSString+MD5.h"
#import <Aspects/Aspects.h>
#import "APIServiceManager.h"

@interface APIService ()


/**
 Request object,hold the object,resume and cancel
 */
@property(nonatomic,readwrite,strong)NSURLSessionTask* taskRequest;

/**
 File cache for APIService
 */
@property(nonatomic,readwrite,strong)id<APICache> apiCache;


/**
 RequestKey generate by the url and parameter
 And MD5 String,only for the same url and parameter
 */
@property(nonatomic,readwrite,copy)NSString* requestKey;

@end

@implementation APIService

#pragma mark - Register APIModule

+ (void)registerDomainIP:(id<APIModule>)module{
    NSDictionary* dic = [module keyMap];
    [APIServiceManager share].domainIPs = dic;
}

+ (void)registerHttpHeadField:(id<APIModule>)module{
    NSDictionary* dic = [module keyMap];
    [APIServiceManager share].httpHeadField = dic;
}


#pragma mark - Init/Dealloc

- (instancetype)init{
    self = [super init];
    if (self) {
    }
    return self;
}

- (void)dealloc{
    if (self.taskRequest != nil) {
        [self.taskRequest cancel];
    }
}

#pragma mark - Request

- (void)startRequest:(APIRequest<RequestProtocol>*)request{
    
    //Hold the request,callback may be use request object
    
    _currentRequest = request;
    
    BOOL valid = [self checkRequestValidity:request];
    
    if (!valid) {
        return;
    }
   
    //Get request info
    
    NSString* url = [self replaceDomainIPFromURL:[request requestURL]];
    
    BOOL isSignParameter = NO;
    
    if ([request respondsToSelector:@selector(isSignParameter)]) {
        isSignParameter = [request isSignParameter];
    }
    
    NSDictionary* parameters = request.parameter;
    
    HTTPMethod httpMethod = GET;
    if ([request respondsToSelector:@selector(requestMethod)]) {
        httpMethod = [request requestMethod];
    }
    
    //Handle cache
    
    self.requestKey = [self joinURL:url withParameter:parameters];
    
    id data = [self.apiCache cacheWithKey:self.requestKey];
    
    if (data && [self.serviceCacheProtocol respondsToSelector:@selector(responseCacheData:cacheData:)]) {
        NSLog(@"Cache response");
        [self.serviceCacheProtocol responseCacheData:self cacheData:data];
    }
    
    //Sign the parameter to safety
    
    if (isSignParameter && parameters) {
        parameters = [self signParameterWithKey:parameters key:[request signParameterKey]];
    }
    
    //Send http request
    
    NSMutableURLRequest* sendRequest = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url]];
    
    [self addHttpHeadFieldFromRequest:&sendRequest];
    
    if (httpMethod == GET){
        self.taskRequest = [[APIManager shareAPIManaer] httpGetRequest:sendRequest parameters:parameters target:self selector:@selector(networkResponse:)];
    }else if(httpMethod == POST){
        self.taskRequest = [[APIManager shareAPIManaer] httpPostRequest:sendRequest parameters:parameters target:self selector:@selector(networkResponse:)];
    }

}

- (BOOL)checkRequestValidity:(APIRequest<RequestProtocol>*)request{
    if (!request) {
        NSAssert(request != nil, @"Request object must not be nil");
        return NO;
    }
    if (![request conformsToProtocol:@protocol(RequestProtocol)]) {
        NSAssert([request conformsToProtocol:@protocol(RequestProtocol)],@"Request must implement RequestProtocol");
        return NO;
    }
    
    if (![request respondsToSelector:@selector(requestURL)]) {
        NSAssert([request respondsToSelector:@selector(requestURL)],@"Request must implement requestURL selector");
        return NO;
    }
    
    NSString* url = [request requestURL];
    if (!url) {
        NSAssert(url,@"Request must set URL value");
        return NO;
    }
    
    return YES;
}


/**
 Re-generate new URL,if the ip and domain map size > 0
 We replace the url domain to ip,will improve the performance

 @param url request URL
 @return New URL
 */
- (NSString*)replaceDomainIPFromURL:(NSString*)url{
    NSDictionary* ips = [APIServiceManager share].domainIPs;
    if (ips.count == 0) {
        return url;
    }
    NSString* newURL = url;
    for (NSString* key in ips) {
        newURL = [newURL stringByReplacingOccurrencesOfString:key withString:ips[key]];
    }
    return newURL;
}


/**
 Add head field to the request

 @param request NSMutableURLRequest
 */
- (void)addHttpHeadFieldFromRequest:(NSMutableURLRequest**)request{
    NSDictionary* heads = [APIServiceManager share].httpHeadField;
    for (NSString* key in heads) {
        [*request setValue:heads[key] forHTTPHeaderField:key];
    }
}

#pragma mark - Response

- (void)networkResponse:(id)response{
	if ([response isKindOfClass:[NSError class]]) {
		//Handle Error
		if([self.serviceProtocol respondsToSelector:@selector(responseFail:errorMessage:)]){
			[self.serviceProtocol responseFail:self errorMessage:response];
		}
	}else{
        //Save override the cache data
        [self.apiCache saveCacheWithData:response withKey:self.requestKey];
        
		//Handle Content
		if([self.serviceProtocol respondsToSelector:@selector(responseSuccess:responseData:)]){
			[self.serviceProtocol responseSuccess:self responseData:response];
		}
	}
}

#pragma mark - Sign parameter with key

- (NSDictionary*)signParameterWithKey:(NSDictionary *)para key:(NSString*)key{
    NSMutableDictionary* dic = [NSMutableDictionary dictionaryWithDictionary:para];
    
    NSMutableString* mString = [NSMutableString string];
    for (NSString* key in para) {
        NSString* value = para[key];
        [mString appendString:value];
    }
    
    //MD5 the all value and contact the timeStamp,
    //The sign will change every seconds
    
    [mString appendFormat:@"%d",(int)[[NSDate date] timeIntervalSince1970]];
    NSString* sign = [[NSString stringWithFormat:@"%@%@",mString,key] md5];
    
    dic[@"sign"] = sign;
    return dic;
}

#pragma mark - Contact url and parameter

- (NSString*)joinURL:(NSString*)url withParameter:(NSDictionary*)parameter{
    NSParameterAssert(url);
    
    if (!url) {
        return nil;
    }
    
    NSMutableString* string = [NSMutableString stringWithString:url];
    
    for (NSString* key in parameter) {
        [string appendString:key];
        [string appendString:parameter[key]];
    }
    return string;
}

#pragma mark - Lazying get method

- (id<APICache>)apiCache{
    if (_apiCache != nil) {
        return _apiCache;
    }
    _apiCache = [[APIFileCache alloc] init];
    return _apiCache;
}


@end
