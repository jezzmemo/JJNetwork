//
//  APIRequest.h
//  JJNetwork
//
//  Created by jezz on 30/07/2017.
//  Copyright © 2017 jezz. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger,HTTPMethod){
	POST,
	GET,
	PUT,
	DELETE,
};

/**
 Request support the cache feature,default will request network immediately
 do not need cache.

 - ReloadFromNetwork: Default mode,request from network
 - ReloadFromCacheIfNotLoadFromNetwork: If have cache,will return the cache,if not exist cache,will load origin source
 - ReloadFromCacheForValid: First time load request origin source,save the cache for the limit time,if expire，will load origin source and replace the old cache
 */
typedef NS_ENUM(NSUInteger,HTTPCache){
    ReloadFromNetwork,
    ReloadFromCacheIfNotLoadFromNetwork,
    ReloadFromCacheForValid,
};

@protocol RequestProtocol <NSObject>

@required


/**
 RequestURL required,if not implement  will can't complete request
 
 @return NSString
 */
- (NSString*)requestURL;

@optional


/**
 * Default request method is GET
 
 * @return HTTPMethod
 */
- (HTTPMethod)requestMethod;


/**
 * Sign the parameter with key
 * Default value is NO
 * If you set the YES,you must implement signParameterKey method and return the key

 @return If YES will invoke signParameterKey the method or NO did not invoke any method
 */
- (BOOL)isSignParameter;


/**
 If isSignParameter return YES
 will sign the http parameter

 @return Sign the parameter with parameterKey
 */
- (NSString*)signParameterKey;


/**
 If you need the cache feature,please choose the cache policy and implement requestCachePolicy

 @return HTTPCache
 */
- (HTTPCache)requestCachePolicy;


/**
 If you choose the ReloadFromCacheForValid policy,you must implement this method,
 The UNIT is seconds,For example:60 seconds is 1 minute.

 @return Seconds
 */
- (NSUInteger)cacheLimitTime;


@end

@interface APIRequest : NSObject<NSCopying>


/**
 Http request parameter,Option
 */
@property(nonatomic,readwrite,copy)NSDictionary* parameter;

@property(nonatomic,readwrite,copy)NSDictionary* httpHeadField;

@end
