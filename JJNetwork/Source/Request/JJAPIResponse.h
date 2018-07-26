//
//  JJAPIResponse.h
//  JJNetwork
//
//  Created by Jezz on 2017/12/14.
//  Copyright © 2017年 jezz. All rights reserved.
//

#import <Foundation/Foundation.h>

@class JJAPIRequest;
@class JJAPIResponse;

/**
 Data convert protocol
 */
@protocol JJAPIResponseDataConvert<NSObject>

@optional
- (id)objectFromResponseData:(id)data __attribute__((deprecated("Instead by objectFromResponseData: withResponse")));

@required

/**
 Convert the response data

 @param data remote data
 @param response JJAPIResponse
 @return processed data from the origin data
 */
- (id)objectFromResponseData:(id)data withResponse:(JJAPIResponse*)response;

@end

/**
 HTTP Response Object
 */
@interface JJAPIResponse : NSObject

/**
 instancetype JJAPIResponse

 @param url request url
 @param headField http head field
 @param apiRequest which request send
 @return JJAPIResponse
 */
- (instancetype)initWithURL:(NSURL*)url headField:(NSDictionary*)headField apiRequest:(JJAPIRequest*)apiRequest;

/**
 HTTP Request URL Address
 */
@property(nonatomic,readonly,copy)NSURL* url;

/**
 Response Head info
 */
@property(nonatomic,readonly,copy)NSDictionary* headerFields;

/**
 Which JJAPIRequest send
 */
@property(nonatomic,readonly,weak)JJAPIRequest* apiRequest;

/**
 Convert response data to your data

 @param convert Implement JJAPIResponseDataConvert protocol object
 @param data Http Response data
 @return Converted data
 */
- (id)resultDataFromConvert:(id<JJAPIResponseDataConvert>)convert withData:(id)data;

@end
