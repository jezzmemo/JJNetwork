//
//  JJAPIResponse.h
//  JJNetwork
//
//  Created by Jezz on 2017/12/14.
//  Copyright © 2017年 jezz. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JJAPIResponse : NSObject

@property(nonatomic,readonly,copy)NSURL* url;

@property(nonatomic,readonly,copy)NSDictionary* headerFields;

@end
