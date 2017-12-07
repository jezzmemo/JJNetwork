//
//  JJAPIRequest+Extension.h
//  JJNetwork
//
//  Created by Jezz on 2017/12/5.
//  Copyright © 2017年 jezz. All rights reserved.
//

#import "JJAPIModule.h"
#import "JJAPIRequest.h"

@interface JJAPIRequest (Extension)

/**
 Resovle the performance DNS problem
 Input the IP address and domain name,key is IP,value is Domain name
 For example:api.xxxx.com->12.12.12.128
 
 @param module APIModuleDomainIp Delegate
 */
+ (void)registerDomainIP:(id<JJAPIDominIPModule>)module;


/**
 Global the Http request head field data
 User implement the interface get the head value
 
 @param module APIModuleHttpHead Delegate
 */
+ (void)registerHttpHeadField:(id<JJAPIHttpHeadModule>)module;


/**
 Add interseptor to the JJAPIRequest class
 
 @param interseptor JJRequestInterseptor
 @param className JJAPIRequest's SubClass
 */
+ (void)addRequestInterseptor:(id<JJRequestInterseptor>)interseptor forRequestClass:(Class)className;


/**
 Remove interseptor by the JJAPIRequest class
 
 @param interseptor JJRequestInterseptor
 @param className JJAPIRequest's SubClass
 */
+ (void)removeRequestInterseptor:(id<JJRequestInterseptor>)interseptor forRequestClass:(Class)className;

@end
