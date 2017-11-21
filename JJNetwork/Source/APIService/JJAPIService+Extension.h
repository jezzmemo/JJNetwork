//
//  APIService+Extension.h
//  JJNetwork
//
//  Created by Jezz on 2017/10/26.
//  Copyright © 2017年 jezz. All rights reserved.
//

#import "JJAPIService.h"

@interface JJAPIService (Extension)

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
 Add interseptor to the APIService class

 @param interseptor APIServiceInterseptor
 @param className APIService's SubClass
 */
+ (void)addServiceInterseptor:(id<JJAPIServiceInterseptor>)interseptor forServiceClass:(Class)className;


/**
 Remove interseptor by the APIService class

 @param interseptor APIServiceInterseptor
 @param className APIService's SubClass
 */
+ (void)removeServiceInterseptor:(id<JJAPIServiceInterseptor>)interseptor forServiceClass:(Class)className;

@end
