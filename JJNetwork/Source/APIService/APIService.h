//
//  APIService.h
//  JJNetwork
//
//  Created by jezz on 30/07/2017.
//  Copyright © 2017 jezz. All rights reserved.
//

#import <Foundation/Foundation.h>

@class APIService;


@protocol APIServiceProtocol <NSObject>

@optional

- (NSDictionary*)requestParameters;

- (void)responseSuccess:(APIService*)service responseData:(id)data;

- (void)responseFail:(APIService*)service errorMessage:(NSError*)error;

@end

@protocol APIServiceConfigProtocol <NSObject>

- (Class)generateRequest;

@end

@interface APIService : NSObject<APIServiceConfigProtocol>

@property(nonatomic,readwrite,weak)id<APIServiceProtocol> serviceProtocol;

- (void)startRequest;

@end
