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
	return @"http://api.imemo8.com/diary.php?mod=getHotDiary";
}

- (HTTPMethod)requestMethod{
	return GET;
}

- (BOOL)isSignParameter{
    return NO;
}

- (NSString*)signParameterKey{
    return @"key";
}

@end
