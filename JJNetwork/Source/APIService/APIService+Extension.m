//
//  APIService+Extension.m
//  JJNetwork
//
//  Created by Jezz on 2017/10/26.
//  Copyright © 2017年 jezz. All rights reserved.
//

#import "APIService+Extension.h"
#import "APIServiceManager.h"

@implementation APIService (Extension)

#pragma mark - Register APIModule

+ (void)registerDomainIP:(id<APIDominIPModule>)module{
    [APIServiceManager share].domainIPs = module;
}

+ (void)registerHttpHeadField:(id<APIHttpHeadModule>)module{
    [APIServiceManager share].httpHeadField = module;
}

#pragma mark - Service Interseptor

+ (void)addServiceInterseptor:(id<APIServiceInterseptor>)interseptor forServiceClass:(Class)className{
    NSAssert([interseptor conformsToProtocol:@protocol(APIServiceInterseptor)], @"interseptor must implement APIServiceInterseptor");
    NSAssert([className isSubclassOfClass:[APIService class]], @"className must extend from APIService");
    
    [[APIServiceManager share] addServiceInterseptor:interseptor forServiceClass:className];
}

+ (void)removeServiceInterseptor:(id<APIServiceInterseptor>)interseptor forServiceClass:(Class)className{
    NSAssert([interseptor conformsToProtocol:@protocol(APIServiceInterseptor)], @"interseptor must implement APIServiceInterseptor");
    NSAssert([className isSubclassOfClass:[APIService class]], @"className must extend from APIService");
    [[APIServiceManager share] removeServiceInterseptor:interseptor forServiceClass:className];
}

@end
