//
//  APIRequest.m
//  JJNetwork
//
//  Created by jezz on 30/07/2017.
//  Copyright © 2017 jezz. All rights reserved.
//

#import "JJAPIRequest.h"
#import <objc/runtime.h>

@implementation JJAPIRequest

- (id)copyWithZone:(nullable NSZone *)zone{
    JJAPIRequest *request = [[[self class] allocWithZone:zone] init];
    request.parameter = self.parameter;
    request.httpHeadField = self.httpHeadField;
    return request;
}

@end
