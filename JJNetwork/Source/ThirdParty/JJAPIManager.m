//
//  APIManager.m
//  JJNetwork
//
//  Created by jezz on 01/08/2017.
//  Copyright © 2017 jezz. All rights reserved.
//

#import "JJAPIManager.h"
#import "JJAFNetworkImpl.h"

NSString * const JJUploadBodyURLKey = @"JJUploadBodyURLKey";
NSString * const JJUploadBodyNameKey = @"JJUploadBodyNameKey";
NSString * const JJUploadBodyFileNameKey = @"JJUploadBodyFileNameKey";
NSString * const JJUploadBodyMimeTypeKey = @"JJUploadBodyMimeTypeKey";

@interface JJAPIManager ()

@property(nonatomic,readwrite,strong)id<JJHTTPProtocol> networkImpl;

@end

@implementation JJAPIManager

+ (JJAPIManager*)shareAPIManaer{
	static JJAPIManager* apiManager = nil;
	static dispatch_once_t once;
	dispatch_once(&once, ^{
		apiManager = [[JJAPIManager alloc] init];
	});
	return apiManager;
}

- (instancetype)init{
	self = [super init];
	if (self) {
        //Real network implement
		self.networkImpl = [[JJAFNetworkImpl alloc] init];
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

- (NSURLSessionTask*)httpUploadFileRequest:(NSURLRequest*)request
                                parameters:(NSDictionary*)parameters
                                    target:(id)target
                                  selector:(SEL)selector
                                     files:(NSArray*)files{
    return [self.networkImpl httpUploadFileRequest:request parameters:parameters target:target selector:selector files:files];
}

@end
