//
//  JJAPIResponse.h
//  JJNetwork
//
//  Created by Jezz on 2017/12/14.
//  Copyright © 2017年 jezz. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 HTTP Response Object
 */
@interface JJAPIResponse : NSObject

/**
 HTTP Request URL Address
 */
@property(nonatomic,readwrite,copy)NSURL* url;

/**
 Response Head info
 */
@property(nonatomic,readwrite,copy)NSDictionary* headerFields;

/**
 Record request class name
 */
@property(nonatomic,readwrite,copy)NSString* requestName;

@end
