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
	return @"http://i1.haidii.com/v/1415586041/i1/images/dict_search_logo.png";
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
