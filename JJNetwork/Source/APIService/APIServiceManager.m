//
//  APIServiceManager.m
//  JJNetwork
//
//  Created by Jezz on 2017/9/8.
//  Copyright © 2017年 jezz. All rights reserved.
//

#import "APIServiceManager.h"

@interface APIServiceManager()


@property(nonatomic,readwrite,strong)NSMutableDictionary* classNameToInterseptorDic;

@end

@implementation APIServiceManager

+ (instancetype)share{
    static APIServiceManager* serviceManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        serviceManager = [[self alloc] init];
    });
    return serviceManager;
}

- (void)addServiceInterseptor:(id<APIServiceInterseptor>)interseptor forServiceClass:(Class)className{
    NSMutableArray* array = self.classNameToInterseptorDic[NSStringFromClass(className)];
    if (array) {
        if ([array indexOfObject:interseptor] != NSNotFound) {
            NSLog(@"Add duplicate interseptor for the :%@",NSStringFromClass(className));
            return;
        }
        [array addObject:interseptor];
        self.classNameToInterseptorDic[NSStringFromClass(className)] = array;
    }else{
        NSMutableArray*  array = [NSMutableArray arrayWithObject:interseptor];
        self.classNameToInterseptorDic[NSStringFromClass(className)] = array;
    }
}

- (void)removeServiceInterseptor:(id<APIServiceInterseptor>)interseptor forServiceClass:(Class)className{
    NSMutableArray* array = self.classNameToInterseptorDic[NSStringFromClass(className)];
    for (int i = 0; i < array.count; i++) {
        if (array[i] == interseptor) {
            [array removeObjectAtIndex:i];
            self.classNameToInterseptorDic[NSStringFromClass(className)] = array;
            break;
        }
    }
}

- (NSMutableDictionary*)classNameToInterseptorDic{
    if (_classNameToInterseptorDic != nil) {
        return _classNameToInterseptorDic;
    }
    _classNameToInterseptorDic = [[NSMutableDictionary alloc] init];
    return _classNameToInterseptorDic;
}

- (void)apiService:(APIService*)service beforeStartRequest:(APIRequest*)request{
    NSString* className = NSStringFromClass([service class]);
    NSArray* interseptorArray = self.classNameToInterseptorDic[className];
    for (id<APIServiceInterseptor> interseptor in interseptorArray) {
        [interseptor apiService:service beforeStartRequest:request];
    }
}

- (void)apiService:(APIService*)service afterStartRequest:(APIRequest*)request{
    NSString* className = NSStringFromClass([service class]);
    NSArray* interseptorArray = self.classNameToInterseptorDic[className];
    for (id<APIServiceInterseptor> interseptor in interseptorArray) {
        [interseptor apiService:service afterStartRequest:request];
    }
}

- (void)apiService:(APIService*)service beforeResponse:(id)data{
    NSString* className = NSStringFromClass([service class]);
    NSArray* interseptorArray = self.classNameToInterseptorDic[className];
    for (id<APIServiceInterseptor> interseptor in interseptorArray) {
        [interseptor apiService:service beforeResponse:data];
    }
}

- (void)apiService:(APIService*)service afterResponse:(id)data{
    NSString* className = NSStringFromClass([service class]);
    NSArray* interseptorArray = self.classNameToInterseptorDic[className];
    for (id<APIServiceInterseptor> interseptor in interseptorArray) {
        [interseptor apiService:service afterResponse:data];
    }
}

@end
