//
//  APIRequest.m
//  JJNetwork
//
//  Created by jezz on 30/07/2017.
//  Copyright © 2017 jezz. All rights reserved.
//

#import "JJAPIRequest.h"

@interface JJAPIRequest()

/**
 Network request implement object
 */
@property(nonatomic,readwrite,strong)id apiService;

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
    #pragma clang diagnostic push
    #pragma clang diagnostic ignored "-Wundeclared-selector"
    if (self.requestInterseptor) {
        [self.apiService performSelector:@selector(setServiceInterseptor:) withObject:self.requestInterseptor];
    }
    if (self.delegate) {
        [self.apiService performSelector:@selector(setServiceDelegate:) withObject:self.delegate];
        
    }
    [self.apiService performSelector:@selector(startRequest:) withObject:self];
    #pragma clang diagnostic pop
}

#pragma mark - API Service

- (id)apiService{
    if (_apiService != nil) {
        return _apiService;
    }
    _apiService = [[NSClassFromString(@"JJAPIService") alloc] init];
    return _apiService;
}

@end
