//
//  APIRequest.h
//  JJNetwork
//
//  Created by jezz on 30/07/2017.
//  Copyright © 2017 jezz. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JJRequestDelegate.h"
#import "JJRequestInterseptor.h"

typedef NS_ENUM(NSUInteger,HTTPMethod){
	JJRequestPOST,
	JJRequestGET,
	JJRequestPUT,
	JJRequestDELETE,
};

/**
 Request support the cache feature,the cache data from cacheFromCurrentRequest method.

 - JJReloadFromLocalCache: If have cache,will return the cache,do not request network,if not exist cache,will load origin source
 - ReloadFromCacheTimeLimit: First time load request origin source,save the cache for the limit time,if expire，will load origin source and replace the old cache
 */
typedef NS_ENUM(NSUInteger,JJHTTPCachePolicy){
    JJReloadFromNone,
    JJReloadFromLocalCache,
    JJReloadFromCacheTimeLimit
};

/**
 Appends the HTTP header `Content-Disposition: file; filename=#{filename}; name=#{name}"` and `Content-Type: #{mimeType}`, followed by the encoded file data and the multipart form boundary.
 */

@protocol JJUploadFileBody <NSObject>

/**
 Add need upload file information
 
 @param fileURL encoded file data's URL
 @param name file #{name}
 @param fileName #{filename}
 @param mimeType #{mimeType}
 */
- (void)addFileURL:(NSURL*)fileURL name:(NSString*)name fileName:(NSString*)fileName mimeType:(NSString*)mimeType;

@end


/**
 Upload file callback
 
 */
typedef void(^JJUploadFileBlock)(id<JJUploadFileBody>);



@protocol JJRequestInput <NSObject>

@optional


/**
 RequestURL required,if not implement  will can't complete request
 
 @return NSString
 */
- (NSString*)requestURL;


/**
 * Default request method is GET
 
 * @return HTTPMethod
 */
- (HTTPMethod)requestMethod;

/**
 If return key lenght greater than zero
 will sign the http parameter

 @return Sign the parameter with parameterKey
 */
- (NSString*)signParameterKey;


/**
 If you need the cache feature,please choose the cache policy and implement requestCachePolicy

 @return HTTPCache
 */
- (JJHTTPCachePolicy)requestCachePolicy;


/**
 If you choose the ReloadFromCacheTimeLimit policy,you must implement this method,
 If cache expired,will request from network,replace the old cache.
 The UNIT is second,For example:60 seconds is 1 minute.

 @return Seconds
 */
- (NSUInteger)cacheLimitTime;

/**
 If you want to upload file,must implement this method
 And add file info.
 
 @return JJUploadFileBlock
 */
- (JJUploadFileBlock)requestFileBody;


@end

@interface JJAPIRequest : NSObject<NSCopying,JJRequestInput>

/**
 Customer Head Field
 */
@property(nonatomic,readwrite,copy)NSDictionary* httpHeadField;

/**
 JJAPIRequest's send network request interseptor
 Monitor the send request before or after,response before or after action
 */
@property(nonatomic,readwrite,weak)id<JJRequestInterseptor> requestInterseptor;

/**
 JJAPIRequest's delegate
 Http response, success or fail
 */
@property(nonatomic,readwrite,weak)id<JJRequestDelegate> delegate;

/**
 Every request extends from JJAPIRequest,config the parameter and delegate,
 and then,invoke this method,will request network
 */
- (void)startRequest;

/**
 If override requestCachePolicy method,you choose policy and exist cache data,will
 return the cache data

 @return Cache data
 */
- (id)cacheFromCurrentRequest;

@end
