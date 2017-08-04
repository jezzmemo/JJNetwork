//
//  APIManager.h
//  JJNetwork
//
//  Created by jezz on 01/08/2017.
//  Copyright © 2017 jezz. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HTTPProtocol.h"

@interface APIManager : NSObject<HTTPProtocol>

+ (APIManager*)shareAPIManaer;

@end
