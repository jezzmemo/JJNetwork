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

#pragma mark - Override Set Property

- (void)setDelegate:(id<JJRequestDelegate>)delegate{
    if (_delegate != delegate) {
        _delegate = delegate;
    }
    
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wundeclared-selector"
    if (_delegate) {
        [self.apiService performSelector:@selector(setServiceDelegate:) withObject:_delegate];
    }
#pragma clang diagnostic pop
}

- (void)setRequestInterseptor:(id<JJRequestInterseptor>)requestInterseptor{
    if (_requestInterseptor != requestInterseptor) {
        _requestInterseptor = requestInterseptor;
    }
    
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wundeclared-selector"
    if(_requestInterseptor){
        [self.apiService performSelector:@selector(setServiceInterseptor:) withObject:_requestInterseptor];
    }
#pragma clang diagnostic pop
}

#pragma mark - Public

- (void)startRequest{
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wundeclared-selector"
    [self.apiService performSelector:@selector(startRequest:) withObject:self];
#pragma clang diagnostic pop
}

- (id)cacheFromCurrentRequest{
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wundeclared-selector"
    if (self.apiService) {
        return [self.apiService performSelector:@selector(cacheFromCurrentRequest:) withObject:self];
    }
    return nil;
#pragma clang diagnostic pop
}

#pragma mark - API Service

- (id)apiService{
    if (_apiService != nil) {
        return _apiService;
    }
    if (!NSClassFromString(@"JJAPIService")) {
        return nil;
    }
    _apiService = [[NSClassFromString(@"JJAPIService") alloc] init];
    return _apiService;
}

@end
