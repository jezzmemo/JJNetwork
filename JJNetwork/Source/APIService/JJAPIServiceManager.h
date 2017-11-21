//
//  APIServiceManager.h
//  JJNetwork
//
//  Created by Jezz on 2017/9/8.
//  Copyright © 2017年 jezz. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JJAPIModule.h"
#import "JJAPIService.h"

@interface JJAPIServiceManager : NSObject<JJAPIServiceInterseptor>

+ (instancetype)share;

@property(nonatomic,readwrite,weak)id<JJAPIDominIPModule> domainIPs;

@property(nonatomic,readwrite,weak)id<JJAPIHttpHeadModule> httpHeadField;

- (void)addServiceInterseptor:(id<JJAPIServiceInterseptor>)interseptor forServiceClass:(Class)className;

- (void)removeServiceInterseptor:(id<JJAPIServiceInterseptor>)interseptor forServiceClass:(Class)className;

@end
