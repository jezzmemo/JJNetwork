//
//  APIServiceManager.h
//  JJNetwork
//
//  Created by Jezz on 2017/9/8.
//  Copyright © 2017年 jezz. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "APIModule.h"
#import "APIService.h"

@interface APIServiceManager : NSObject<APIServiceInterseptor>

+ (instancetype)share;

@property(nonatomic,readwrite,weak)id<APIDominIPModule> domainIPs;

@property(nonatomic,readwrite,weak)id<APIHttpHeadModule> httpHeadField;

- (void)addServiceInterseptor:(id<APIServiceInterseptor>)interseptor forServiceClass:(Class)className;

- (void)removeServiceInterseptor:(id<APIServiceInterseptor>)interseptor forServiceClass:(Class)className;

@end
