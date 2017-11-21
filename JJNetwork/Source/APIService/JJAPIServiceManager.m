//
//  APIServiceManager.m
//  JJNetwork
//
//  Created by Jezz on 2017/9/8.
//  Copyright © 2017年 jezz. All rights reserved.
//

#import "JJAPIServiceManager.h"

@interface JJAPIServiceManager()


@property(nonatomic,readwrite,strong)NSMutableDictionary* classNameToInterseptorDic;

@end

@implementation JJAPIServiceManager

+ (instancetype)share{
    static JJAPIServiceManager* serviceManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        serviceManager = [[self alloc] init];
    });
    return serviceManager;
}

- (void)addServiceInterseptor:(id<JJAPIServiceInterseptor>)interseptor forServiceClass:(Class)className{
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

- (void)removeServiceInterseptor:(id<JJAPIServiceInterseptor>)interseptor forServiceClass:(Class)className{
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

- (void)apiService:(JJAPIService*)service beforeStartRequest:(JJAPIRequest*)request{
    NSString* className = NSStringFromClass([service class]);
    NSArray* interseptorArray = self.classNameToInterseptorDic[className];
    for (id<JJAPIServiceInterseptor> interseptor in interseptorArray) {
        [interseptor apiService:service beforeStartRequest:request];
    }
}

- (void)apiService:(JJAPIService*)service afterStartRequest:(JJAPIRequest*)request{
    NSString* className = NSStringFromClass([service class]);
    NSArray* interseptorArray = self.classNameToInterseptorDic[className];
    for (id<JJAPIServiceInterseptor> interseptor in interseptorArray) {
        [interseptor apiService:service afterStartRequest:request];
    }
}

- (void)apiService:(JJAPIService*)service beforeResponse:(id)data{
    NSString* className = NSStringFromClass([service class]);
    NSArray* interseptorArray = self.classNameToInterseptorDic[className];
    for (id<JJAPIServiceInterseptor> interseptor in interseptorArray) {
        [interseptor apiService:service beforeResponse:data];
    }
}

- (void)apiService:(JJAPIService*)service afterResponse:(id)data{
    NSString* className = NSStringFromClass([service class]);
    NSArray* interseptorArray = self.classNameToInterseptorDic[className];
    for (id<JJAPIServiceInterseptor> interseptor in interseptorArray) {
        [interseptor apiService:service afterResponse:data];
    }
}

@end
