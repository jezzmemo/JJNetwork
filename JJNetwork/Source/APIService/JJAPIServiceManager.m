//
//  APIServiceManager.m
//  JJNetwork
//
//  Created by Jezz on 2017/9/8.
//  Copyright © 2017年 jezz. All rights reserved.
//

#import "JJAPIServiceManager.h"
#import "JJAPIResponse.h"

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

- (void)addServiceInterseptor:(id<JJRequestInterseptor>)interseptor forServiceClass:(Class)className{
    NSMutableArray* array = self.classNameToInterseptorDic[NSStringFromClass(className)];
    if (array) {
        if ([array indexOfObject:[NSValue valueWithNonretainedObject:interseptor]] != NSNotFound) {
            NSLog(@"Add duplicate interseptor for the :%@",NSStringFromClass(className));
            return;
        }
        [array addObject:[NSValue valueWithNonretainedObject:interseptor]];
        self.classNameToInterseptorDic[NSStringFromClass(className)] = array;
    }else{
        NSMutableArray*  array = [NSMutableArray arrayWithObject:[NSValue valueWithNonretainedObject:interseptor]];
        self.classNameToInterseptorDic[NSStringFromClass(className)] = array;
    }
}

- (void)removeServiceInterseptor:(id<JJRequestInterseptor>)interseptor forServiceClass:(Class)className{
    NSMutableArray* array = self.classNameToInterseptorDic[NSStringFromClass(className)];
    for (int i = 0; i < array.count; i++) {
        NSValue* value = array[i];
        if (value.nonretainedObjectValue == interseptor) {
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

- (void)beforeRequest:(JJAPIRequest*)request{
    NSString* className = NSStringFromClass([request class]);
    NSArray* interseptorArray = self.classNameToInterseptorDic[className];
    for (NSValue* value in interseptorArray) {
        id<JJRequestInterseptor> interseptor = value.nonretainedObjectValue;
        [interseptor beforeRequest:request];
    }
}

- (void)afterRequest:(JJAPIRequest*)request{
    NSString* className = NSStringFromClass([request class]);
    NSArray* interseptorArray = self.classNameToInterseptorDic[className];
    for (NSValue* value in interseptorArray) {
        id<JJRequestInterseptor> interseptor = value.nonretainedObjectValue;
        [interseptor afterRequest:request];
    }
}

- (void)response:(JJAPIResponse*)response beforeResponseData:(id)data{
    NSArray* interseptorArray = self.classNameToInterseptorDic[response.requestName];
    for (NSValue* value in interseptorArray) {
        id<JJRequestInterseptor> interseptor = value.nonretainedObjectValue;
        [interseptor response:response beforeResponseData:data];
    }
}

- (void)response:(JJAPIResponse*)response afterResponseData:(id)data{
    NSArray* interseptorArray = self.classNameToInterseptorDic[response.requestName];
    for (NSValue* value in interseptorArray) {
        id<JJRequestInterseptor> interseptor = value.nonretainedObjectValue;
        [interseptor response:response afterResponseData:data];
    }
}

@end
