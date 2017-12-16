//
//  APIManager.h
//  JJNetwork
//
//  Created by jezz on 01/08/2017.
//  Copyright © 2017 jezz. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JJHTTPProtocol.h"


/**
 Appends the HTTP header `Content-Disposition: file; filename=#{filename}; name=#{name}"` and `Content-Type: #{mimeType}`, followed by the encoded file data and the multipart form boundary.
 */
FOUNDATION_EXTERN NSString* const JJUploadBodyURLKey;//provide file data path
FOUNDATION_EXTERN NSString* const JJUploadBodyNameKey;//#{name}
FOUNDATION_EXTERN NSString* const JJUploadBodyFileNameKey;//#{filename}
FOUNDATION_EXTERN NSString* const JJUploadBodyMimeTypeKey;//#{mimeType}

@interface JJAPIManager : NSObject<JJHTTPProtocol>



/**
 Send API Request Manager
 
 @return APIManager
 */
+ (JJAPIManager*)shareAPIManaer;

@end
