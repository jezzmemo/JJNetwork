//
//  APIService+Extension.m
//  JJNetwork
//
//  Created by Jezz on 2017/10/26.
//  Copyright © 2017年 jezz. All rights reserved.
//

#import "JJAPIService+Extension.h"
#import "JJAPIServiceManager.h"

@implementation JJAPIService (Extension)

#pragma mark - Register APIModule

+ (void)registerDomainIP:(id<JJAPIDominIPModule>)module{
    [JJAPIServiceManager share].domainIPs = module;
}

+ (void)registerHttpHeadField:(id<JJAPIHttpHeadModule>)module{
    [JJAPIServiceManager share].httpHeadField = module;
}

#pragma mark - Service Interseptor

+ (void)addServiceInterseptor:(id<JJAPIServiceInterseptor>)interseptor forServiceClass:(Class)className{
    NSAssert([interseptor conformsToProtocol:@protocol(JJAPIServiceInterseptor)], @"interseptor must implement APIServiceInterseptor");
    NSAssert([className isSubclassOfClass:[JJAPIService class]], @"className must extend from APIService");
    
    [[JJAPIServiceManager share] addServiceInterseptor:interseptor forServiceClass:className];
}

+ (void)removeServiceInterseptor:(id<JJAPIServiceInterseptor>)interseptor forServiceClass:(Class)className{
    NSAssert([interseptor conformsToProtocol:@protocol(JJAPIServiceInterseptor)], @"interseptor must implement APIServiceInterseptor");
    NSAssert([className isSubclassOfClass:[JJAPIService class]], @"className must extend from APIService");
    [[JJAPIServiceManager share] removeServiceInterseptor:interseptor forServiceClass:className];
}

@end
