//
//  APIService.h
//  JJNetwork
//
//  Created by jezz on 30/07/2017.
//  Copyright © 2017 jezz. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "APIRequest.h"

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


/**
 Every API must extends from APIService!!!
 */
@interface APIService : NSObject

@property(nonatomic,readwrite,weak)id<APIServiceProtocol> serviceProtocol;


/**
 Send http request key method

 @param request Must pass the APIRequest<RequestProtocol> point object
 */
- (void)startRequest:(APIRequest<RequestProtocol>*)request;

@end
