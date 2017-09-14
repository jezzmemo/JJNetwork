//
//  APIService.h
//  JJNetwork
//
//  Created by jezz on 30/07/2017.
//  Copyright © 2017 jezz. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "APIRequest.h"
#import "APIFileCache.h"
#import "APIServiceDelegate.h"
#import "APIModule.h"

@class APIService;



/**
 Use service interface
 Get the request parameter
 Response delegate
 */
@protocol APIServiceProtocol <NSObject>

@optional


/**
 Response Success delegate

 @param service Which APIService instance
 @param data JSON/Html/XML/Binary response is origin data
 */
- (void)responseSuccess:(APIService*)service responseData:(id)data;


/**
 Response failed delegate

 @param service Which APIService instance
 @param error NSError object
 */
- (void)responseFail:(APIService*)service errorMessage:(NSError*)error;

@end

@protocol ResponseCache <NSObject>


/**
 Default response will save the cache data with file or memory
 If the implement this protocol,will return the cache data

 @param service APIService instance
 @param data Cache data,json/html/binary...
 */
- (void)responseCacheData:(APIService*)service cacheData:(id)data;

@end


/**
 Every API must extends from APIService!!!
 Don't override the startRequest: method
 */
@interface APIService : NSObject<APIServiceDelegate>


/**
 Resovle the performance DNS problem
 Input the IP address and domain name,key is IP,value is Domain name
 For example:api.xxxx.com->12.12.12.128

 @param module APIModuleDomainIp Delegate
 */
+ (void)registerDomainIP:(id<APIModule>)module;


/**
 Global the Http request head field data
 User implement the interface get the head value

 @param module APIModuleHttpHead Delegate
 */
+ (void)registerHttpHeadField:(id<APIModule>)module;


/**
 APIService's delegate
 Http response, success or fail
 */
@property(nonatomic,readwrite,weak)id<APIServiceProtocol> serviceProtocol;

/**
 ResponseCache's delegate
 */
@property(nonatomic,readwrite,weak)id<ResponseCache> serviceCacheProtocol;


/**
 Get the request information
 For example:url,parameter...
 */
@property(nonatomic,readonly,strong)APIRequest<RequestProtocol>* currentRequest;

@end
