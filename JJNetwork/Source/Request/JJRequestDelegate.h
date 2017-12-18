//
//  JJRequestDelegate.h
//  JJNetwork
//
//  Created by Jezz on 2017/11/28.
//  Copyright © 2017年 jezz. All rights reserved.
//

#ifndef JJRequestDelegate_h
#define JJRequestDelegate_h


@class JJAPIRequest;
@class JJAPIResponse;

/**
 Request interface
 Get the request parameter
 Response delegate
 */
@protocol JJRequestDelegate <NSObject>

@optional

/**
 Pass http request parameter

 @param request JJAPIRequest
 @return user's customer NSDictionary parameter
 */
- (NSDictionary*)requestParameters:(JJAPIRequest*)request;

/**
 Response Success delegate
 
 @param request Which JJAPIRequest instance
 @param data JSON/Html/XML/Binary response is origin data
 */
- (void)responseSuccess:(JJAPIResponse*)request responseData:(id)data;


/**
 Response failed delegate
 
 @param request Which JJAPIRequest instance
 @param error NSError object
 */
- (void)responseFail:(JJAPIResponse*)request errorMessage:(NSError*)error;

@end


#endif /* JJRequestDelegate_h */
