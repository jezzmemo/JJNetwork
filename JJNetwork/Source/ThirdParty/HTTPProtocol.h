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
 Http Post method

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
 Http Get method
 */
- (NSURLSessionTask*)httpGet:(NSURL*)url
	  parameter:(NSDictionary*)parameter
		 target:(id)target
	   selector:(SEL)selector;

@end


#endif /* HTTPProtocol_h */
