//
//  APIManager.h
//  JJNetwork
//
//  Created by jezz on 01/08/2017.
//  Copyright © 2017 jezz. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JJHTTPProtocol.h"

@interface JJAPIManager : NSObject<JJHTTPProtocol>



/**
 Send API Request Manager
 
 @return APIManager
 */
+ (JJAPIManager*)shareAPIManaer;

@end
