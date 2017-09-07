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


/**
 RequestURL required,if not implement  will can't complete request
 
 @return NSString
 */
- (NSString*)requestURL;

@optional


/**
 * Default request method is GET
 
 * @return HTTPMethod
 */
- (HTTPMethod)requestMethod;


/**
 * Sign the parameter with key
 * Default value is NO

 @return YES or NO
 */
- (BOOL)isSignParameter;


/**
 If isSignParameter return YES
 will sign the http parameter

 @return Sign the parameter with parameterKey
 */
- (NSString*)signParameterKey;

@end

@interface APIRequest : NSObject


/**
 Http request parameter,Option
 */
@property(nonatomic,readwrite,copy)NSDictionary* parameter;

@end
