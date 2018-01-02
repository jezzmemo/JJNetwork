//
//  MockDemoManager.m
//  JJNetwork
//
//  Created by Jezz on 2017/12/26.
//  Copyright © 2017年 jezz. All rights reserved.
//

#import "MockDemoManager.h"
#import "JJAPIMock.h"
#import "DemoRequest.h"

@implementation MockDemoManager

+ (instancetype)shareMockManager{
    static id shareMockManager;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        shareMockManager = [[self alloc] init];
    });
    return shareMockManager;
}

-(instancetype)init{
    self = [super init];
    if (self) {
        [self setupMockConfing];
        [self setupMockRequest];
    }
    return self;
}

- (void)setupMockConfing{
    JJAPIMock.mockSwitch = NO;
}

- (void)setupMockRequest{
    [JJAPIMock testRequest:[DemoRequest class] responseString:@"jsondata/xml" isOn:YES];
}

@end
