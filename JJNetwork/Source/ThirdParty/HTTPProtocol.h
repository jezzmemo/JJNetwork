//
//  HTTPProtocol.h
//  JJNetwork
//
//  Created by jezz on 30/07/2017.
//  Copyright © 2017 jezz. All rights reserved.
//

#ifndef HTTPProtocol_h
#define HTTPProtocol_h

#import <Foundation/Foundation.h>

@protocol HTTPProtocol <NSObject>

/**
 Http Post method interface

 @param url http url
 @param parameter http parameters
 @param target callback target
 @param selector callback method name
 */

- (NSURLSessionTask*)httpPost:(NSURL*)url
	   parameter:(NSDictionary*)parameter
		  target:(id)target
		selector:(SEL)selector;

/**
 Http Get method interface
 
 @param url http url
 @param parameter http parameters
 @param target callback target
 @param selector callback method name
 */

- (NSURLSessionTask*)httpGet:(NSURL*)url
	  parameter:(NSDictionary*)parameter
		 target:(id)target
	   selector:(SEL)selector;



/**
 Set the http head data

 @param dic key-value
 */
- (void)setHttpHeadField:(NSDictionary*)dic;

@end


#endif /* HTTPProtocol_h */
