//
//  JJRequestDelegate.h
//  JJNetwork
//
//  Created by Jezz on 2017/11/28.
//  Copyright © 2017年 jezz. All rights reserved.
//

#ifndef JJRequestDelegate_h
#define JJRequestDelegate_h


@class JJAPIRequest;
@class JJAPIResponse;

/**
 Appends the HTTP header `Content-Disposition: file; filename=#{filename}; name=#{name}"` and `Content-Type: #{mimeType}`, followed by the encoded file data and the multipart form boundary.
 */

@protocol JJUploadFileBody <NSObject>

/**
 Add need upload file information

 @param fileURL encoded file data's URL
 @param name file #{name}
 @param fileName #{filename}
 @param mimeType #{mimeType}
 */
- (void)addFileURL:(NSURL*)fileURL name:(NSString*)name fileName:(NSString*)fileName mimeType:(NSString*)mimeType;

@end


/**
 Upload file callback

 */
typedef void(^JJUploadFileBlock)(id<JJUploadFileBody>);

/**
 Request interface
 Get the request parameter
 Response delegate
 */
@protocol JJRequestDelegate <NSObject>

@optional

/**
 Pass http request parameter

 @param request JJAPIRequest
 @return user's customer NSDictionary parameter
 */
- (NSDictionary*)requestParameters:(JJAPIRequest*)request;

/**
 If you want to upload file,must implement this method
 And add file info.

 @param request JJAPIRequest
 @return JJUploadFileBlock
 */
- (JJUploadFileBlock)requestFileBody:(JJAPIRequest*)request;

/**
 Response Success delegate
 
 @param request Which JJAPIRequest instance
 @param data JSON/Html/XML/Binary response is origin data
 */
- (void)responseSuccess:(JJAPIRequest*)request responseData:(id)data;


/**
 Response failed delegate
 
 @param request Which JJAPIRequest instance
 @param error NSError object
 */
- (void)responseFail:(JJAPIRequest*)request errorMessage:(NSError*)error;

@end


#endif /* JJRequestDelegate_h */
