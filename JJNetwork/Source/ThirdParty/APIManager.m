//
//  APIManager.m
//  JJNetwork
//
//  Created by jezz on 01/08/2017.
//  Copyright © 2017 jezz. All rights reserved.
//

#import "APIManager.h"
#import "AFNetworkImpl.h"


@interface APIManager ()

@property(nonatomic,readwrite,strong)id<HTTPProtocol> networkImpl;

@end

@implementation APIManager

+ (APIManager*)shareAPIManaer{
	static APIManager* apiManager = nil;
	static dispatch_once_t once;
	dispatch_once(&once, ^{
		apiManager = [[APIManager alloc] init];
	});
	return apiManager;
}

- (instancetype)init{
	self = [super init];
	if (self) {
        //Real network implement
		self.networkImpl = [[AFNetworkImpl alloc] init];
	}
	return self;
}


/**
 Post method
 
 @param request NSURLRequest
 @param parameter Request parameter key->value
 @param target Which target
 @param selector Target's method name
 @return NSURLSessionTask track the request object
 */
- (NSURLSessionTask*)httpPostRequest:(NSURLRequest*)request parameters:(NSDictionary*)parameter target:(id)target selector:(SEL)selector{
    return [self.networkImpl httpPostRequest:request parameters:parameter target:target selector:selector];
}

/**
 Get method
 
 @param request NSURLRequest
 @param parameter Request parameter key->value
 @param target Which target
 @param selector Target's method name
 @return NSURLSessionTask track the request object
 */
- (NSURLSessionTask*)httpGetRequest:(NSURLRequest*)request parameters:(NSDictionary*)parameter target:(id)target selector:(SEL)selector{
	return [self.networkImpl httpGetRequest:request parameters:parameter target:target selector:selector];
}

@end
