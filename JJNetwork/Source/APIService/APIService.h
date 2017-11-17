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
 Interseptor for the APIService
 Monitor the request before or after,reponse before or after
 */
@protocol APIServiceInterseptor <NSObject>

@optional

/**
 Invoke beforeStartRequest before sendRequest

 @param service APIService
 @param request APIRequest request object
 */
- (void)apiService:(APIService*)service beforeStartRequest:(APIRequest*)request;


/**
 Invoke afterStartRequest after sendRequest

 @param service APIService
 @param request APIRequest request object
 */
- (void)apiService:(APIService*)service afterStartRequest:(APIRequest*)request;

/**
 Invoke beforeResponse before Response

 @param service APIService
 @param data Response data object
 */
- (void)apiService:(APIService*)service beforeResponse:(id)data;

/**
 Invoke afterResponse before Response
 
 @param service APIService
 @param data Response data object
 */
- (void)apiService:(APIService*)service afterResponse:(id)data;

@end



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
 Don't override the startRequest: method
 */
@interface APIService : NSObject<APIServiceDelegate>


/**
 APIService's send network request interseptor
 Monitor the send request before or after,response before or after
 */
@property(nonatomic,readwrite,weak)id<APIServiceInterseptor> serviceInterseptor;

/**
 APIService's delegate
 Http response, success or fail
 */
@property(nonatomic,readwrite,weak)id<APIServiceProtocol> serviceProtocol;


/**
 Get the request information
 For example:url,parameter...
 */
@property(nonatomic,readonly,strong)APIRequest<RequestProtocol>* currentRequest;

@end
