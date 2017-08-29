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
 Post interface
 
 @param url Requset http url
 @param parameter Request parameter key->value
 @param target Which target
 @param selector Target's method name
 @return NSURLSessionTask track the request object
 */
- (NSURLSessionTask*)httpPost:(NSURL*)url parameter:(NSDictionary*)parameter target:(id)target selector:(SEL)selector{
	return [self.networkImpl httpPost:url parameter:parameter target:target selector:selector];
}

/**
 Get interface
 
 @param url Requset http url
 @param parameter Request parameter key->value
 @param target Which target
 @param selector Target's method name
 @return NSURLSessionTask track the request object
 */
- (NSURLSessionTask*)httpGet:(NSURL*)url parameter:(NSDictionary*)parameter target:(id)target selector:(SEL)selector{
	return [self.networkImpl httpGet:url parameter:parameter target:target selector:selector];
}

@end
