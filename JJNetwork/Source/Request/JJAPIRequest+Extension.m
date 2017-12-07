//
//  JJAPIRequest+Extension.m
//  JJNetwork
//
//  Created by Jezz on 2017/12/5.
//  Copyright © 2017年 jezz. All rights reserved.
//

#import "JJAPIRequest+Extension.h"

@implementation JJAPIRequest (Extension)

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wundeclared-selector"

+ (void)registerDomainIP:(id<JJAPIDominIPModule>)module{
    [[self apiServiceManager] performSelector:@selector(setDomainIPs:) withObject:module];
}

+ (void)registerHttpHeadField:(id<JJAPIHttpHeadModule>)module{
    [[self apiServiceManager] performSelector:@selector(setHttpHeadField:) withObject:module];
}

+ (void)addRequestInterseptor:(id<JJRequestInterseptor>)interseptor forRequestClass:(Class)className{
    NSAssert([interseptor conformsToProtocol:@protocol(JJRequestInterseptor)], @"interseptor must implement JJRequestInterseptor");
    NSAssert([className isSubclassOfClass:[JJAPIRequest class]], @"className must extend from JJAPIRequest");
    
    [[self apiServiceManager] performSelector:@selector(addServiceInterseptor:forServiceClass:) withObject:interseptor withObject:className];
}

+ (void)removeRequestInterseptor:(id<JJRequestInterseptor>)interseptor forRequestClass:(Class)className{
    NSAssert([interseptor conformsToProtocol:@protocol(JJRequestInterseptor)], @"interseptor must implement JJRequestInterseptor");
    NSAssert([className isSubclassOfClass:[JJAPIRequest class]], @"className must extend from JJAPIRequest");
    
    [[self apiServiceManager] performSelector:@selector(removeServiceInterseptor:forServiceClass:) withObject:interseptor withObject:className];
}

+ (id)apiServiceManager{
    return [NSClassFromString(@"JJAPIServiceManager") performSelector:@selector(share)];
}

#pragma clang diagnostic pop

@end
