//
//  APIRequest.m
//  JJNetwork
//
//  Created by jezz on 30/07/2017.
//  Copyright © 2017 jezz. All rights reserved.
//

#import "JJAPIRequest.h"
#import "JJAPIService.h"

@interface JJAPIRequest()

/**
 Network request implement object
 */
@property(nonatomic,readwrite,strong)JJAPIService* apiService;

@end

@implementation JJAPIRequest

#pragma mark - Copy

- (id)copyWithZone:(nullable NSZone *)zone{
    JJAPIRequest *request = [[[self class] allocWithZone:zone] init];
    request.httpHeadField = self.httpHeadField;
    request.requestInterseptor = self.requestInterseptor;
    request.delegate = self.delegate;
    return request;
}

#pragma mark - Public

- (void)startRequest{
    if (self.requestInterseptor) {
        self.apiService.serviceInterseptor = self.requestInterseptor;
    }
    if (self.delegate) {
        self.apiService.serviceDelegate = self.delegate;
    }
    [self.apiService startRequest:self];
}

#pragma mark - API Service

- (JJAPIService*)apiService{
    if (_apiService != nil) {
        return _apiService;
    }
    _apiService = [JJAPIService new];
    return _apiService;
}

@end
