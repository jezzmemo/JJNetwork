//
//  APIService.h
//  JJNetwork
//
//  Created by jezz on 30/07/2017.
//  Copyright © 2017 jezz. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JJRequestDelegate.h"
#import "JJRequestInterseptor.h"
#import "JJAPIServiceDelegate.h"
#import "JJAPIRequest.h"
#import "JJAPIModule.h"




/**
 Network request implement
 */
@interface JJAPIService : NSObject<JJAPIServiceDelegate>


/**
 APIService's send network request interseptor
 Monitor the send request before or after,response before or after
 */
@property(nonatomic,readwrite,weak)id<JJRequestInterseptor> serviceInterseptor;

/**
 APIService's delegate
 Http response, success or fail
 */
@property(nonatomic,readwrite,weak)id<JJRequestDelegate> serviceDelegate;


/**
 Get the request information
 For example:url,parameter...
 */
@property(nonatomic,readonly,weak)JJAPIRequest<JJRequestInput>* currentRequest;

@end
