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
#import "JJAPIResponse.h"
#import "NSString+MD5.h"
#import "JJAPIServiceManager.h"
#import "JJAPIFileCache.h"
#import "JJAPIRequest+Extension.h"
#import "JJAPIMock.h"


/**
 Convert normal object to file Dictionary Array object
 */
@interface JJFileBodyImpl : NSObject <JJUploadFileBody>{
    NSMutableArray* _uploadFiles;
}

@property(nonatomic,readonly,copy)NSArray* uploadFiles;

@end

@implementation JJFileBodyImpl

- (instancetype)init{
    self = [super init];
    if (self) {
        _uploadFiles = [NSMutableArray array];
    }
    return self;
}

- (void)addFileURL:(NSURL *)fileURL name:(NSString *)name fileName:(NSString *)fileName mimeType:(NSString *)mimeType{
    NSMutableDictionary* fileInfo = [NSMutableDictionary dictionary];
    fileInfo[JJUploadBodyURLKey] = fileURL;
    fileInfo[JJUploadBodyNameKey] = name;
    fileInfo[JJUploadBodyFileNameKey] = fileName;
    fileInfo[JJUploadBodyMimeTypeKey] = mimeType;
    
    [_uploadFiles addObject:fileInfo];
}

- (NSArray*)uploadFiles{
    return _uploadFiles;
}
@end

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
    
    if([self mockRequest:request]){
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
    
    //Sign the parameter to safety
    
    if ([signParametersKey length] > 0 && parameters) {
        parameters = [self signParameterWithKey:parameters key:[request signParameterKey]];
    }
    
    //Send http request
    
    NSMutableURLRequest* sendRequest = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url]];
    
    [self addHttpHeadFieldFromRequest:&sendRequest];
    

    if (httpMethod == JJRequestGET){
        //GET
        self.taskRequest = [[JJAPIManager shareAPIManaer] httpGetRequest:sendRequest parameters:parameters target:self selector:@selector(networkResponse:withData:)];
    }else if ([self.currentRequest respondsToSelector:@selector(requestFileBody)]) {
        //Upload
        JJUploadFileBlock fileBodyBlock  = [self.currentRequest requestFileBody];
        JJFileBodyImpl* fileImpl = [JJFileBodyImpl new];
        if (fileBodyBlock) {
            fileBodyBlock(fileImpl);
        }
        self.taskRequest = [[JJAPIManager shareAPIManaer] httpUploadFileRequest:sendRequest parameters:parameters target:self selector:@selector(networkResponse:withData:) files:fileImpl.uploadFiles];
    }else if(httpMethod == JJRequestPOST){
        //POST
        self.taskRequest = [[JJAPIManager shareAPIManaer] httpPostRequest:sendRequest parameters:parameters target:self selector:@selector(networkResponse:withData:)];
    }
    
    //Interseptor
    [self afterStartRequest:request];
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
 Add global head field and instance reuqest head to the request

 @param request NSMutableURLRequest
 */
- (void)addHttpHeadFieldFromRequest:(NSMutableURLRequest**)request{
    if (![[JJAPIServiceManager share].httpHeadField respondsToSelector:@selector(customerHttpHead)]) {
        return;
    }
    NSDictionary* globalHeads = [[JJAPIServiceManager share].httpHeadField customerHttpHead];
    
    NSDictionary* requestHeads = [self.currentRequest httpHeadField];
    
    NSMutableDictionary* allHeads = [NSMutableDictionary dictionary];
    
    if (globalHeads) {
        [allHeads addEntriesFromDictionary:globalHeads];
    }
    if (requestHeads) {
        [allHeads addEntriesFromDictionary:requestHeads];
    }
    
    for (NSString* key in allHeads) {
        [*request setValue:allHeads[key] forHTTPHeaderField:key];
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

- (void)beforeResponse:(JJAPIResponse*)response withResponseData:(id)data{
    if ([self.serviceInterseptor respondsToSelector:@selector(response:beforeResponseData:)]) {
        [self.serviceInterseptor response:response beforeResponseData:data];
    }
    [[JJAPIServiceManager share] response:response beforeResponseData:data];
}

- (void)afterResponse:(JJAPIResponse*)response withResponseData:(id)data{
    if ([self.serviceInterseptor respondsToSelector:@selector(response:afterResponseData:)]) {
        [self.serviceInterseptor response:response afterResponseData:data];
    }
    [[JJAPIServiceManager share] response:response afterResponseData:data];
}

#pragma mark - Mock

- (BOOL)checkRequestMockStatus:(JJAPIRequest*)request{
    if(!JJAPIMock.mockSwitch){
        return NO;
    }
    if (![[JJAPIServiceManager share] checkMockRequest:[request class]]) {
        return NO;
    }
    return YES;
}

- (BOOL)mockRequest:(JJAPIRequest*)request{
    if (![self checkRequestMockStatus:request]) {
        return NO;
    }
    //----------------------------Mock Start-------------------------------
    [self beforeStartRequest:request];
    [self afterStartRequest:request];
    
    //Mock response
    JJAPIResponse* apiResponse = [[JJAPIResponse alloc]initWithURL:[NSURL URLWithString:_currentRequest.requestURL] headField:@{} apiRequest:request];
    
    id responseData = [[JJAPIServiceManager share] mockRequestData:request.class];
    
    [self beforeResponse:apiResponse withResponseData:responseData];
    
    if ([self.serviceDelegate respondsToSelector:@selector(responseSuccess:responseData:)]) {
        [self.serviceDelegate responseSuccess:apiResponse responseData:responseData];
    }
    
    [self afterResponse:apiResponse withResponseData:responseData];
    //----------------------------Mock End---------------------------------
    return YES;
}

#pragma mark - Cache

- (void)handleResponseCacheData:(id)responseData{
    JJHTTPCachePolicy cachePolicy =  JJReloadFromNone;
    if ([self.currentRequest respondsToSelector:@selector(requestCachePolicy)]) {
        cachePolicy = [self.currentRequest requestCachePolicy];
    }
    if (cachePolicy == JJReloadFromLocalCache || cachePolicy == JJReloadFromCacheTimeLimit) {
        [self.apiCache saveCacheWithData:responseData withKey:self.requestKey];
    }
}

- (id)cacheFromCurrentRequest:(JJAPIRequest<JJRequestInput>*)request{
    
    BOOL valid = [self checkRequestValidity:request];
    
    if (!valid) {
        return nil;
    }
    
    if([self checkRequestMockStatus:request]){
        id responseData = [[JJAPIServiceManager share] mockRequestData:request.class];
        return responseData;
    }
    
    NSString* url = [self replaceDomainIPFromURL:[request requestURL]];
    
    NSDictionary* parameters = nil;
    
    if ([self.serviceDelegate respondsToSelector:@selector(requestParameters:)]) {
        parameters = [self.serviceDelegate requestParameters:request];
    }
    
    self.requestKey = [self joinURL:url withParameter:parameters];
    
    JJHTTPCachePolicy cachePolicy = JJReloadFromNone;
    if ([request respondsToSelector:@selector(requestCachePolicy)]) {
        cachePolicy = [request requestCachePolicy];
    }
    id cacheData = nil;
    if (cachePolicy == JJReloadFromLocalCache) {
        cacheData = [self.apiCache cacheWithKey:self.requestKey];
    }else if(cachePolicy == JJReloadFromCacheTimeLimit && [request respondsToSelector:@selector(cacheLimitTime)]){
        cacheData = [self.apiCache cacheWithKey:self.requestKey withTimeLimit:[request cacheLimitTime]];
    }
    return cacheData;
}

#pragma mark - Response

- (void)networkResponse:(NSHTTPURLResponse*)response withData:(id)data{
    JJAPIResponse* apiResponse = [[JJAPIResponse alloc]initWithURL:response.URL headField:response.allHeaderFields apiRequest:_currentRequest];
    
    [self beforeResponse:apiResponse withResponseData:data];
    
    do{
        //Handle Error
        if ([data isKindOfClass:[NSError class]] && [self.serviceDelegate respondsToSelector:@selector(responseFail:errorMessage:)]) {
            [self.serviceDelegate responseFail:apiResponse errorMessage:data];
            break;
        }
        
        //Handle Cache Data
        [self handleResponseCacheData:data];
        
        //Handle Success Content
        if([self.serviceDelegate respondsToSelector:@selector(responseSuccess:responseData:)]){
            [self.serviceDelegate responseSuccess:apiResponse responseData:data];
        }
        
    }while (0);
    
    [self afterResponse:apiResponse withResponseData:data];
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
