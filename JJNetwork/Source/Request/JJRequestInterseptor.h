//
//  JJRequestInterseptor.h
//  JJNetwork
//
//  Created by Jezz on 2017/11/30.
//  Copyright © 2017年 jezz. All rights reserved.
//

#ifndef JJRequestInterseptor_h
#define JJRequestInterseptor_h

@class JJAPIRequest;

/**
 Interseptor for the JJAPIRequest
 Monitor the request before or after,reponse before or after
 */
@protocol JJRequestInterseptor <NSObject>

@optional

/**
 Invoke beforeStartRequest before sendRequest
 
 @param request APIRequest request object
 */
- (void)beforeRequest:(JJAPIRequest*)request;


/**
 Invoke afterStartRequest after sendRequest
 
 @param request APIRequest request object
 */
- (void)afterRequest:(JJAPIRequest*)request;

/**
 Invoke beforeResponse before Response
 
 @param data Response data object
 */
- (void)request:(JJAPIRequest*)request beforeResponse:(id)data;

/**
 Invoke afterResponse before Response
 
 @param data Response data object
 */
- (void)request:(JJAPIRequest*)request afterResponse:(id)data;

@end


#endif /* JJRequestInterseptor_h */
