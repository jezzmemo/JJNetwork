//
//  APIRequest.h
//  JJNetwork
//
//  Created by jezz on 30/07/2017.
//  Copyright © 2017 jezz. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger,HTTPMethod){
	POST,
	GET,
	PUT,
	DELETE,
};

@protocol RequestProtocol <NSObject>

@required

- (NSString*)requestURL;

@optional

- (HTTPMethod)requestMethod;

- (BOOL)isSignParameter;

- (NSString*)signParameterKey;

@end

@interface APIRequest : NSObject

@end
