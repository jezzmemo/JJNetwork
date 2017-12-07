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

/**
 Use service interface
 Get the request parameter
 Response delegate
 */
@protocol JJRequestDelegate <NSObject>

@optional

- (NSDictionary*)requestParameters:(JJAPIRequest*)request;

/**
 Response Success delegate
 
 @param request Which JJAPIRequest instance
 @param data JSON/Html/XML/Binary response is origin data
 */
- (void)responseSuccess:(JJAPIRequest*)request responseData:(id)data;


/**
 Response failed delegate
 
 @param request Which JJAPIRequest instance
 @param error NSError object
 */
- (void)responseFail:(JJAPIRequest*)request errorMessage:(NSError*)error;

@end


#endif /* JJRequestDelegate_h */
