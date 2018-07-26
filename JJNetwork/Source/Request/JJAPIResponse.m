//
//  JJAPIResponse.m
//  JJNetwork
//
//  Created by Jezz on 2017/12/14.
//  Copyright © 2017年 jezz. All rights reserved.
//

#import "JJAPIResponse.h"

@implementation JJAPIResponse

- (instancetype)initWithURL:(NSURL*)url headField:(NSDictionary*)headField apiRequest:(JJAPIRequest*)apiRequest{
    self = [super init];
    if (self) {
        _url = url;
        _headerFields = headField;
        _apiRequest = apiRequest;
    }
    return self;
}

- (id)resultDataFromConvert:(id<JJAPIResponseDataConvert>)convert withData:(id)data{
    if (!convert) {
        return nil;
    }
    if (!data) {
        return nil;
    }
    if ([convert respondsToSelector:@selector(objectFromResponseData:withResponse:)]) {
        id processedData = [convert objectFromResponseData:data withResponse:self];
        return processedData;
    }
    return nil;
}

@end
