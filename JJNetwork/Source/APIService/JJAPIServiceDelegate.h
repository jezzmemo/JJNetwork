//
//  APIServiceDelegate.h
//  JJNetwork
//
//  Created by Jezz on 2017/9/6.
//  Copyright © 2017年 jezz. All rights reserved.
//

#import <Foundation/Foundation.h>

@class JJAPIRequest;

@protocol JJAPIServiceDelegate <NSObject>

@required

/**
 Send http request key method
 
 @param request Must pass the APIRequest<RequestProtocol> point object
 */

- (void)startRequest:(JJAPIRequest<JJRequestProtocol>*)request;


@end
