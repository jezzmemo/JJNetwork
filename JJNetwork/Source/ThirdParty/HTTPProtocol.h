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

 @param request http NSURLRequest
 @param parameters HTTP POST parameter
 @param target callback target
 @param selector callback method name
 */

- (NSURLSessionTask*)httpPostRequest:(NSURLRequest*)request
                          parameters:(NSDictionary*)parameters
                              target:(id)target
                            selector:(SEL)selector;

/**
 Http Get method interface
 
 @param request NSURLRequest
 @param parameters Http get parameter
 @param target callback target
 @param selector callback method name
 */

- (NSURLSessionTask*)httpGetRequest:(NSURLRequest*)request
                         parameters:(NSDictionary*)parameters
                             target:(id)target
                           selector:(SEL)selector;

@end


#endif /* HTTPProtocol_h */
