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

+ (void)addGlobalRequestInterseptor:(id<JJRequestInterseptor>)interseptor{
    NSAssert([interseptor conformsToProtocol:@protocol(JJRequestInterseptor)], @"Interseptor must implement JJRequestInterseptor");
    [[self apiServiceManager] performSelector:@selector(addServiceInterseptor:) withObject:interseptor withObject:nil];
}

+ (void)removeGlobalRequestInterseptor:(id<JJRequestInterseptor>)interseptor{
    NSAssert([interseptor conformsToProtocol:@protocol(JJRequestInterseptor)], @"Interseptor must implement JJRequestInterseptor");
    [[self apiServiceManager] performSelector:@selector(removeServiceInterseptor:) withObject:interseptor withObject:nil];
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
