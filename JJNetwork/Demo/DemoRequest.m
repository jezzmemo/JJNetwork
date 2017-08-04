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
	return @"http://ask.dev.mojoymusic.com/api/user/login_with_wx";
}

- (HTTPMethod)requestMethod{
	return GET;
}

@end
