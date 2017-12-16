//
//  HTTPProtocol.h
//  JJNetwork
//
//  Created by jezz on 30/07/2017.
//  Copyright © 2017 jezz. All rights reserved.
//

#ifndef JJHTTPProtocol_h
#define JJHTTPProtocol_h

#import <Foundation/Foundation.h>

@protocol JJHTTPProtocol <NSObject>

/**
 Http Post method interface

 @param request http NSURLRequest
 @param parameters HTTP POST parameter
 @param target callback target
 @param selector callback method name
 @return NSURLSessionTask
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
 @return NSURLSessionTask
 */

- (NSURLSessionTask*)httpGetRequest:(NSURLRequest*)request
                         parameters:(NSDictionary*)parameters
                             target:(id)target
                           selector:(SEL)selector;

/**
 Http upload one or more files

 @param request NSURLRequest
 @param parameters NSDictionary
 @param target callback target
 @param selector callback method name
 @param files need upload file array
 @return NSURLSessionTask
 */
- (NSURLSessionTask*)httpUploadFileRequest:(NSURLRequest*)request
                                parameters:(NSDictionary*)parameters
                                    target:(id)target
                                  selector:(SEL)selector
                                     files:(NSArray*)files;

@end


#endif /* JJHTTPProtocol_h */
