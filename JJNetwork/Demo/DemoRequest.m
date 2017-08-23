//
//  DemoRequest.m
//  JJNetwork
//
//  Created by jezz on 31/07/2017.
//  Copyright © 2017 jezz. All rights reserved.
//

#import "DemoRequest.h"

@implementation DemoRequest

- (NSString*)requestURL{
	return @"https://www.google.com";
}

- (HTTPMethod)requestMethod{
	return GET;
}

- (BOOL)isSignParameter{
    return YES;
}

- (NSString*)signParameterKey{
    return @"123456";
}

@end
