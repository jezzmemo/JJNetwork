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

@property(nonatomic,readwrite,weak)id<JJAPIDominIPModule> domainIPs;

@property(nonatomic,readwrite,weak)id<JJAPIHttpHeadModule> httpHeadField;

- (void)addServiceInterseptor:(id<JJRequestInterseptor>)interseptor forServiceClass:(Class)className;

- (void)removeServiceInterseptor:(id<JJRequestInterseptor>)interseptor forServiceClass:(Class)className;

@end
