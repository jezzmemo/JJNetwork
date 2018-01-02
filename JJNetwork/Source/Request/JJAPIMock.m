//
//  JJAPIMock.m
//  JJNetwork
//
//  Created by Jezz on 2017/12/25.
//  Copyright © 2017年 jezz. All rights reserved.
//

#import "JJAPIMock.h"
#import "JJAPIRequest.h"

@implementation JJAPIMock

@dynamic mockSwitch;

static BOOL mockGlobalStatus = NO;

+ (void)setMockSwitch:(BOOL)mockSwitch{
    if (mockSwitch != mockGlobalStatus) {
        mockGlobalStatus = mockSwitch;
    }
}

+ (BOOL)mockSwitch{
    return mockGlobalStatus;
}


+ (void)testRequest:(Class)request responseString:(NSString*)response isOn:(BOOL)flag{
    NSData* data = [response dataUsingEncoding:NSUTF8StringEncoding];
    [self testRequest:request responseData:data isOn:flag];
}

+ (void)testRequest:(Class)request responseFilePath:(NSString*)filePath isOn:(BOOL)flag{
    [self testRequest:request responseData:[NSData dataWithContentsOfFile:filePath] isOn:flag];
}

+ (void)testRequest:(Class)request responseData:(NSData*)data isOn:(BOOL)flag{
    
    SEL addMockSelector = NSSelectorFromString(@"addMockRequest:responseData:isOn:");
    id target = [self apiServiceManager];
    
    if ([target respondsToSelector:addMockSelector]) {
        NSInvocation* serviceManagerInvocation = [NSInvocation invocationWithMethodSignature:[[self apiServiceManager] methodSignatureForSelector:addMockSelector]];
        [serviceManagerInvocation setTarget:target];
        [serviceManagerInvocation setSelector:addMockSelector];
        
        [serviceManagerInvocation setArgument:&(request) atIndex:2];
        [serviceManagerInvocation setArgument:&(data) atIndex:3];
        [serviceManagerInvocation setArgument:&(flag) atIndex:4];
        
        [serviceManagerInvocation invoke];
    }
}

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wundeclared-selector"

+ (id)apiServiceManager{
    return [NSClassFromString(@"JJAPIServiceManager") performSelector:@selector(share)];
}

#pragma clang diagnostic pop

@end
