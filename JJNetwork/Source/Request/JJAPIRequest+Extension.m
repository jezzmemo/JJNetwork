//
//  JJAPIRequest+Extension.m
//  JJNetwork
//
//  Created by Jezz on 2017/12/5.
//  Copyright © 2017年 jezz. All rights reserved.
//

#import "JJAPIRequest+Extension.h"
#import "JJAPIServiceManager.h"

@implementation JJAPIRequest (Extension)

+ (void)registerDomainIP:(id<JJAPIDominIPModule>)module{
    [JJAPIServiceManager share].domainIPs = module;
}

+ (void)registerHttpHeadField:(id<JJAPIHttpHeadModule>)module{
    [JJAPIServiceManager share].httpHeadField = module;
}

+ (void)addRequestInterseptor:(id<JJRequestInterseptor>)interseptor forRequestClass:(Class)className{
    NSAssert([interseptor conformsToProtocol:@protocol(JJRequestInterseptor)], @"interseptor must implement JJRequestInterseptor");
    NSAssert([className isSubclassOfClass:[JJAPIRequest class]], @"className must extend from JJAPIRequest");
    
    [[JJAPIServiceManager share] addServiceInterseptor:interseptor forServiceClass:className];
}

+ (void)removeRequestInterseptor:(id<JJRequestInterseptor>)interseptor forRequestClass:(Class)className{
    NSAssert([interseptor conformsToProtocol:@protocol(JJRequestInterseptor)], @"interseptor must implement JJRequestInterseptor");
    NSAssert([className isSubclassOfClass:[JJAPIRequest class]], @"className must extend from JJAPIRequest");
    [[JJAPIServiceManager share] removeServiceInterseptor:interseptor forServiceClass:className];
}

@end
