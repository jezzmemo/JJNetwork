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

- (NSString*)requestURL;

- (HTTPMethod)requestMethod;

@end

@interface APIRequest : NSObject

@end
