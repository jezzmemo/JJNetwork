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
		self.networkImpl = [[AFNetworkImpl alloc] init];
	}
	return self;
}

- (void)httpPost:(NSURL*)url parameter:(NSDictionary*)parameter target:(id)target selector:(SEL)selector{
	[self.networkImpl httpPost:url parameter:parameter target:target selector:selector];
}

- (void)httpGet:(NSURL*)url parameter:(NSDictionary*)parameter target:(id)target selector:(SEL)selector{
	[self.networkImpl httpGet:url parameter:parameter target:target selector:selector];
}

@end
