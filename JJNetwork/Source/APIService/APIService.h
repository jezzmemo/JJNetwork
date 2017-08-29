//
//  APIService.h
//  JJNetwork
//
//  Created by jezz on 30/07/2017.
//  Copyright © 2017 jezz. All rights reserved.
//

#import <Foundation/Foundation.h>

@class APIService;



/**
 Use service interface
 Get the request parameter
 Response delegate
 */
@protocol APIServiceProtocol <NSObject>

@optional

- (NSDictionary*)requestParameters;

- (void)responseSuccess:(APIService*)service responseData:(id)data;

- (void)responseFail:(APIService*)service errorMessage:(NSError*)error;

@end


/**
 Service implement interface get the request object
 Default is nil
 */
@protocol APIServiceConfigProtocol <NSObject>

- (Class)generateRequest;

@end


/**
 Every API must extends from APIService!!!
 */
@interface APIService : NSObject<APIServiceConfigProtocol>

@property(nonatomic,readwrite,weak)id<APIServiceProtocol> serviceProtocol;


/**
 Developer must invoke this method,will start the request
 */
- (void)startRequest;

@end
