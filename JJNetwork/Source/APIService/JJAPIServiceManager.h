//
//  APIServiceManager.h
//  JJNetwork
//
//  Created by Jezz on 2017/9/8.
//  Copyright © 2017年 jezz. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JJAPIModule.h"
#import "JJAPIRequest.h"

/**
 Global config http request
 Monitor the request by the class name,add/remove
 */
@interface JJAPIServiceManager : NSObject<JJRequestInterseptor>

+ (instancetype)share;

/**
 Replace domain to ip Moudle
 */
@property(nonatomic,readwrite,weak)id<JJAPIDominIPModule> domainIPs;

/**
 Global http head Moudle
 */
@property(nonatomic,readwrite,weak)id<JJAPIHttpHeadModule> httpHeadField;

/**
 Add request interseptor

 @param interseptor JJRequestInterseptor
 @param className JJAPIRequest
 */
- (void)addServiceInterseptor:(id<JJRequestInterseptor>)interseptor forServiceClass:(Class)className;

/**
 Remove request interseptor

 @param interseptor JJRequestInterseptor
 @param className JJAPIRequest
 */
- (void)removeServiceInterseptor:(id<JJRequestInterseptor>)interseptor forServiceClass:(Class)className;


/**
 Check request is mock status

 @param requestClass JJRequest
 @return YES:mock current request NO:do not mock current reuqest
 */
- (BOOL)checkMockRequest:(Class)requestClass;

/**
 Add request to mock,response NSData type
 
 @param request Extends from JJAPIRequest object
 @param data Input binary data
 @param flag flag Yes:to mock request,NO:cancel mock request
 */
- (void)addMockRequest:(Class)request responseData:(NSData*)data isOn:(BOOL)flag;

/**
 Get the mock response data

 @param request JJAPIRequest
 @return User input Data
 */
- (id)mockRequestData:(Class)request;

@end
