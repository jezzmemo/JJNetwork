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
	return @"http://api.imemo8.com/diary.php";
}

- (HTTPMethod)requestMethod{
	return JJRequestGET;
}

- (NSString*)signParameterKey{
    return @"key";
}

- (HTTPCachePolicy)requestCachePolicy{
    return ReloadFromCacheTimeLimit;
}

- (NSUInteger)cacheLimitTime{
    return 120;
}

@end
