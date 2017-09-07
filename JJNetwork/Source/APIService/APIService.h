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


/**
 Make the http post or get the head field data

 @param service Which APIService instance
 @return user input the dic for example:userToken,DeviceID
 */
- (NSDictionary*)httpHeadField:(APIService*)service;

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
 */
@interface APIService : NSObject<APIServiceDelegate>


/**
 APIService's delegate
 Http response, success or fail
 */
@property(nonatomic,readwrite,weak)id<APIServiceProtocol> serviceProtocol;

/**
 ResponseCache's delegate
 */
@property(nonatomic,readwrite,weak)id<ResponseCache> serviceCacheProtocol;

@end
