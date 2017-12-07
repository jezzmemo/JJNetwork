//
//  APIService.m
//  JJNetwork
//
//  Created by jezz on 30/07/2017.
//  Copyright © 2017 jezz. All rights reserved.
//

#import "JJAPIService.h"
#import "JJAPIManager.h"
#import "JJAPIRequest.h"
#import "NSString+MD5.h"
#import "JJAPIServiceManager.h"
#import "JJAPIFileCache.h"
#import "JJAPIRequest+Extension.h"

@interface JJAPIService ()


/**
 Request object,hold the object,resume and cancel
 */
@property(nonatomic,readwrite,strong)NSURLSessionTask* taskRequest;

/**
 File cache for APIService
 */
@property(nonatomic,readwrite,strong)id<JJAPICache> apiCache;


/**
 RequestKey generate by the url and parameter
 And MD5 String,only for the same url and parameter
 */
@property(nonatomic,readwrite,copy)NSString* requestKey;

@end

@implementation JJAPIService


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

- (void)startRequest:(JJAPIRequest<JJRequestInput>*)request{
    
    //Hold the request,callback may be use request object
    
    _currentRequest = request;
    
    BOOL valid = [self checkRequestValidity:request];
    
    if (!valid) {
        return;
    }
    
    //Handle Interseptor
    [self beforeStartRequest:request];
   
    //Get request info
    
    NSString* url = [self replaceDomainIPFromURL:[request requestURL]];
    
    NSString* signParametersKey = @"";
    
    if ([request respondsToSelector:@selector(signParameterKey)]) {
        signParametersKey = [request signParameterKey];
    }
    
    NSDictionary* parameters = nil;
    
    if ([self.serviceDelegate respondsToSelector:@selector(requestParameters:)]) {
        parameters = [self.serviceDelegate requestParameters:request];
    }
    
    HTTPMethod httpMethod = JJRequestGET;
    if ([request respondsToSelector:@selector(requestMethod)]) {
        httpMethod = [request requestMethod];
    }
    
    
    //Generate the key by the url and parameters
    
    self.requestKey = [self joinURL:url withParameter:parameters];
    
    //Handle local cache
    
    if (![self handleLocalCache]) {
        return;
    }
    
    //Sign the parameter to safety
    
    if ([signParametersKey length] > 0 && parameters) {
        parameters = [self signParameterWithKey:parameters key:[request signParameterKey]];
    }
    
    //Send http request
    
    NSMutableURLRequest* sendRequest = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url]];
    
    [self addHttpHeadFieldFromRequest:&sendRequest];
    
    if (httpMethod == JJRequestGET){
        self.taskRequest = [[JJAPIManager shareAPIManaer] httpGetRequest:sendRequest parameters:parameters target:self selector:@selector(networkResponse:)];
    }else if(httpMethod == JJRequestPOST){
        self.taskRequest = [[JJAPIManager shareAPIManaer] httpPostRequest:sendRequest parameters:parameters target:self selector:@selector(networkResponse:)];
    }
    
    //Interseptor
    [self afterStartRequest:request];
}


/**
 Request return the HttpCachePolicy,process the cache logic
 ReloadFromNetwork:return YES;
 ReloadFromCacheElseLoadNetwork:if cache exist return NO,otherwise return YES;
 ReloadFromCacheTimeLimit:return NO;

 @return If YES will continue request network, NO will return cache,but do not request network
 */
- (BOOL)handleLocalCache{
    HTTPCachePolicy cachePolicy =  ReloadFromNetwork;
    if ([self.currentRequest respondsToSelector:@selector(requestCachePolicy)]) {
        cachePolicy = [self.currentRequest requestCachePolicy];
    }
    
    if(cachePolicy == ReloadFromNetwork){
        return YES;
    }
    
    id cacheData = nil;
    if (cachePolicy == ReloadFromCacheElseLoadNetwork) {
        cacheData = [self.apiCache cacheWithKey:self.requestKey];
    }else if(cachePolicy == ReloadFromCacheTimeLimit){
        cacheData = [self.apiCache cacheWithKey:self.requestKey withTimeLimit:[self.currentRequest cacheLimitTime]];
    }
    
    if(!cacheData){
        return YES;
    }
    
    [self afterStartRequest:self.currentRequest];
    
    [self beforeResponse:cacheData];
    
    if([self.serviceDelegate respondsToSelector:@selector(responseSuccess:responseData:)]){
        [self.serviceDelegate responseSuccess:self.currentRequest responseData:cacheData];
    }
    
    [self afterResponse:cacheData];
    
    return NO;
}

- (BOOL)checkRequestValidity:(JJAPIRequest<JJRequestInput>*)request{
    if (!request) {
        NSAssert(request != nil, @"Request object must not be nil");
        return NO;
    }
    if (![request conformsToProtocol:@protocol(JJRequestInput)]) {
        NSAssert([request conformsToProtocol:@protocol(JJRequestInput)],@"Request must implement RequestProtocol");
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

#pragma mark - API Moudle

/**
 Re-generate new URL,if the ip and domain map size > 0
 We replace the url domain to ip,will improve the performance

 @param url request URL
 @return New URL
 */
- (NSString*)replaceDomainIPFromURL:(NSString*)url{
    
    if (![[JJAPIServiceManager share].domainIPs respondsToSelector:@selector(domainIPData)]) {
        return url;
    }
    
    NSDictionary* ips = [[JJAPIServiceManager share].domainIPs domainIPData];
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
    if (![[JJAPIServiceManager share].httpHeadField respondsToSelector:@selector(customerHttpHead)]) {
        return;
    }
    NSDictionary* heads = [[JJAPIServiceManager share].httpHeadField customerHttpHead];
    for (NSString* key in heads) {
        [*request setValue:heads[key] forHTTPHeaderField:key];
    }
}

#pragma mark  - Interseptor

- (void)beforeStartRequest:(JJAPIRequest*)request{
    if ([self.serviceInterseptor respondsToSelector:@selector(beforeRequest:)]) {
        [self.serviceInterseptor beforeRequest:request];
    }
    [[JJAPIServiceManager share] beforeRequest:request];
}

- (void)afterStartRequest:(JJAPIRequest*)request{
    if ([self.serviceInterseptor respondsToSelector:@selector(afterRequest:)]) {
        [self.serviceInterseptor afterRequest:request];
    }
    [[JJAPIServiceManager share] afterRequest:request];
}

- (void)beforeResponse:(id)response{
    if ([self.serviceInterseptor respondsToSelector:@selector(request:beforeResponse:)]) {
        [self.serviceInterseptor request:self.currentRequest beforeResponse:response];
    }
    [[JJAPIServiceManager share] request:self.currentRequest beforeResponse:response];
}

- (void)afterResponse:(id)response{
    if ([self.serviceInterseptor respondsToSelector:@selector(request:afterResponse:)]) {
        [self.serviceInterseptor request:self.currentRequest afterResponse:response];
    }
    [[JJAPIServiceManager share] request:self.currentRequest afterResponse:response];
}

#pragma mark - Response

- (void)networkResponse:(id)response{
    [self beforeResponse:response];
    
	if ([response isKindOfClass:[NSError class]]) {
		//Handle Error
		if([self.serviceDelegate respondsToSelector:@selector(responseFail:errorMessage:)]){
			[self.serviceDelegate responseFail:self.currentRequest errorMessage:response];
		}
	}else{
        //Save override the cache data
        [self.apiCache saveCacheWithData:response withKey:self.requestKey];
        
		//Handle Content
		if([self.serviceDelegate respondsToSelector:@selector(responseSuccess:responseData:)]){
			[self.serviceDelegate responseSuccess:self.currentRequest responseData:response];
		}
	}
    
    [self afterResponse:response];
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
    NSInteger timestamp = (NSInteger)[[NSDate date] timeIntervalSince1970];
    [mString appendFormat:@"%zd",timestamp];
    NSString* sign = [[NSString stringWithFormat:@"%@%@",mString,key] md5];
    
    dic[@"sign"] = sign;
    dic[@"timestamp"] = @(timestamp);
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

- (id<JJAPICache>)apiCache{
    if (_apiCache != nil) {
        return _apiCache;
    }
    _apiCache = [[JJAPIFileCache alloc] init];
    return _apiCache;
}


@end
