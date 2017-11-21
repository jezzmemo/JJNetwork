//
//  APIService.h
//  JJNetwork
//
//  Created by jezz on 30/07/2017.
//  Copyright © 2017 jezz. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JJAPIRequest.h"
#import "JJAPIServiceDelegate.h"
#import "JJAPIModule.h"

@class JJAPIService;


/**
 Interseptor for the APIService
 Monitor the request before or after,reponse before or after
 */
@protocol JJAPIServiceInterseptor <NSObject>

@optional

/**
 Invoke beforeStartRequest before sendRequest

 @param service APIService
 @param request APIRequest request object
 */
- (void)apiService:(JJAPIService*)service beforeStartRequest:(JJAPIRequest*)request;


/**
 Invoke afterStartRequest after sendRequest

 @param service APIService
 @param request APIRequest request object
 */
- (void)apiService:(JJAPIService*)service afterStartRequest:(JJAPIRequest*)request;

/**
 Invoke beforeResponse before Response

 @param service APIService
 @param data Response data object
 */
- (void)apiService:(JJAPIService*)service beforeResponse:(id)data;

/**
 Invoke afterResponse before Response
 
 @param service APIService
 @param data Response data object
 */
- (void)apiService:(JJAPIService*)service afterResponse:(id)data;

@end



/**
 Use service interface
 Get the request parameter
 Response delegate
 */
@protocol JJAPIServiceProtocol <NSObject>

@optional


/**
 Response Success delegate

 @param service Which APIService instance
 @param data JSON/Html/XML/Binary response is origin data
 */
- (void)responseSuccess:(JJAPIService*)service responseData:(id)data;


/**
 Response failed delegate

 @param service Which APIService instance
 @param error NSError object
 */
- (void)responseFail:(JJAPIService*)service errorMessage:(NSError*)error;

@end


/**
 Every API must extends from APIService!!!
 Don't override the startRequest: method
 */
@interface JJAPIService : NSObject<JJAPIServiceDelegate>


/**
 APIService's send network request interseptor
 Monitor the send request before or after,response before or after
 */
@property(nonatomic,readwrite,weak)id<JJAPIServiceInterseptor> serviceInterseptor;

/**
 APIService's delegate
 Http response, success or fail
 */
@property(nonatomic,readwrite,weak)id<JJAPIServiceProtocol> serviceProtocol;


/**
 Get the request information
 For example:url,parameter...
 */
@property(nonatomic,readonly,strong)JJAPIRequest<JJRequestProtocol>* currentRequest;

@end
