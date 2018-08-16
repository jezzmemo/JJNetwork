//
//  APIServiceManager.m
//  JJNetwork
//
//  Created by Jezz on 2017/9/8.
//  Copyright © 2017年 jezz. All rights reserved.
//

#import "JJAPIServiceManager.h"
#import "JJAPIResponse.h"

static NSString* const MOCK_DATA_KEY = @"MOCK_DATA_KEY";
static NSString* const MOCK_FLAG_KEY = @"MOCK_FLAG_KEY";

static void blockCleanUp(__strong void(^*block)(void)) {
    (*block)();
}

#define onExit __strong void(^block)(void) __attribute__((cleanup(blockCleanUp), unused)) = ^

@interface JJAPIServiceManager(){
    dispatch_semaphore_t _serviceSemaphore;//Mutex none thread safe collection
}


/**
 Save the request interseptor Dictionary
 */
@property(nonatomic,readwrite,strong)NSMutableDictionary* classNameToInterseptorDic;

/**
 Save the mock request Dictionary
 */
@property(nonatomic,readwrite,strong)NSMutableDictionary* mockRequestDic;

/**
 Save the global request interseptor set
 */
@property(nonatomic,readwrite,strong)NSMutableSet* globalInterseptorSet;

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

- (instancetype)init{
    self = [super init];
    if (self) {
        _serviceSemaphore = dispatch_semaphore_create(1);
    }
    return self;
}

#pragma mark - Interseptor

- (void)addServiceInterseptor:(id<JJRequestInterseptor>)interseptor{
    dispatch_semaphore_wait(_serviceSemaphore, DISPATCH_TIME_FOREVER);
    [self.globalInterseptorSet addObject:[NSValue valueWithNonretainedObject:interseptor]];
    dispatch_semaphore_signal(_serviceSemaphore);
    
}

- (void)removeServiceInterseptor:(id<JJRequestInterseptor>)interseptor{
    dispatch_semaphore_wait(_serviceSemaphore, DISPATCH_TIME_FOREVER);
    [self.globalInterseptorSet removeObject:[NSValue valueWithNonretainedObject:interseptor]];
    dispatch_semaphore_signal(_serviceSemaphore);
}

- (void)addServiceInterseptor:(id<JJRequestInterseptor>)interseptor forServiceClass:(Class)className{
    dispatch_semaphore_wait(_serviceSemaphore, DISPATCH_TIME_FOREVER);
    onExit{
        dispatch_semaphore_signal(_serviceSemaphore);
    };
    NSMutableArray* array = self.classNameToInterseptorDic[NSStringFromClass(className)];
    if (array) {
        if ([array indexOfObject:[NSValue valueWithNonretainedObject:interseptor]] != NSNotFound) {
            NSLog(@"Add duplicate interseptor for the :%@",NSStringFromClass(className));
            dispatch_semaphore_signal(_serviceSemaphore);
            return;
        }
        [array addObject:[NSValue valueWithNonretainedObject:interseptor]];
    }else{
        NSMutableArray*  array = [NSMutableArray arrayWithObject:[NSValue valueWithNonretainedObject:interseptor]];
        self.classNameToInterseptorDic[NSStringFromClass(className)] = array;
    }
}

- (void)removeServiceInterseptor:(id<JJRequestInterseptor>)interseptor forServiceClass:(Class)className{
    dispatch_semaphore_wait(_serviceSemaphore, DISPATCH_TIME_FOREVER);
    onExit{
        dispatch_semaphore_signal(_serviceSemaphore);
    };
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

- (void)beforeRequest:(JJAPIRequest*)request{
    NSString* className = NSStringFromClass([request class]);
    NSArray* interseptorArray = self.classNameToInterseptorDic[className];
    for (NSValue* value in interseptorArray) {
        id<JJRequestInterseptor> interseptor = value.nonretainedObjectValue;
        if ([interseptor respondsToSelector:@selector(beforeRequest:)]) {
            [interseptor beforeRequest:request];
        }
    }
    
    for (NSValue* value in self.globalInterseptorSet) {
        id<JJRequestInterseptor> interseptor = value.nonretainedObjectValue;
        if ([interseptor respondsToSelector:@selector(beforeRequest:)]) {
            [interseptor beforeRequest:request];
        }
    }
}

- (void)afterRequest:(JJAPIRequest*)request{
    NSString* className = NSStringFromClass([request class]);
    NSArray* interseptorArray = self.classNameToInterseptorDic[className];
    for (NSValue* value in interseptorArray) {
        id<JJRequestInterseptor> interseptor = value.nonretainedObjectValue;
        if ([interseptor respondsToSelector:@selector(afterRequest:)]) {
            [interseptor afterRequest:request];
        }
    }
    
    for (NSValue* value in self.globalInterseptorSet) {
        id<JJRequestInterseptor> interseptor = value.nonretainedObjectValue;
        if ([interseptor respondsToSelector:@selector(afterRequest:)]) {
            [interseptor afterRequest:request];
        }
    }
}

- (void)response:(JJAPIResponse*)response beforeResponseData:(id)data{
    NSArray* interseptorArray = self.classNameToInterseptorDic[NSStringFromClass(response.apiRequest.class)];
    for (NSValue* value in interseptorArray) {
        id<JJRequestInterseptor> interseptor = value.nonretainedObjectValue;
        if ([interseptor respondsToSelector:@selector(response:beforeResponseData:)]) {
            [interseptor response:response beforeResponseData:data];
        }
    }
    
    for (NSValue* value in self.globalInterseptorSet) {
        id<JJRequestInterseptor> interseptor = value.nonretainedObjectValue;
        if ([interseptor respondsToSelector:@selector(response:beforeResponseData:)]) {
            [interseptor response:response beforeResponseData:data];
        }
    }
}

- (void)response:(JJAPIResponse*)response afterResponseData:(id)data{
    NSArray* interseptorArray = self.classNameToInterseptorDic[NSStringFromClass(response.apiRequest.class)];
    for (NSValue* value in interseptorArray) {
        id<JJRequestInterseptor> interseptor = value.nonretainedObjectValue;
        if ([interseptor respondsToSelector:@selector(response:afterResponseData:)]) {
            [interseptor response:response afterResponseData:data];
        }
    }
    
    for (NSValue* value in self.globalInterseptorSet) {
        id<JJRequestInterseptor> interseptor = value.nonretainedObjectValue;
        if ([interseptor respondsToSelector:@selector(response:afterResponseData:)]) {
            [interseptor response:response afterResponseData:data];
        }
    }
}

#pragma mark - Mock

- (BOOL)checkMockRequest:(Class)requestClass{
    NSString* requestName = NSStringFromClass(requestClass);
    NSDictionary* value = self.mockRequestDic[requestName];
    if (!value) {
        return NO;
    }
    id flag = value[MOCK_FLAG_KEY];
    if (flag) {
        return [flag boolValue];
    }
    return YES;
}

- (void)addMockRequest:(Class)request responseData:(NSData*)data isOn:(BOOL)flag{
    NSAssert([request isSubclassOfClass:JJAPIRequest.class], @"Request must extends from JJAPIRequest");
    NSAssert(data, @"Data parameter do not nil");
    
    NSDictionary* dic = @{MOCK_DATA_KEY:data,MOCK_FLAG_KEY:@(flag)};
    NSString* requestName = NSStringFromClass(request);
    
    if (!requestName) {
        return;
    }
    
    self.mockRequestDic[requestName] = dic;
}

- (id)mockRequestData:(Class)request{
    NSAssert([request isSubclassOfClass:[JJAPIRequest class]], @"request must extends from JJAPIRequest");
    NSString* requestName = NSStringFromClass(request);
    
    if (!requestName) {
        return nil;
    }
    
    NSDictionary* mockData = self.mockRequestDic[requestName];
    if (!mockData) {
        return nil;
    }

    NSData* binaryData = mockData[MOCK_DATA_KEY];
    if (!binaryData) {
        return nil;
    }
    
    NSString* stringData = [[NSString alloc] initWithData:binaryData encoding:NSUTF8StringEncoding];
    
    if (stringData) {
        return stringData;
    }
    
    return binaryData;
}

#pragma mark - Get Lazy Property

- (NSMutableDictionary*)mockRequestDic{
    if (_mockRequestDic != nil) {
        return _mockRequestDic;
    }
    _mockRequestDic = [[NSMutableDictionary alloc] init];
    return _mockRequestDic;
}

- (NSMutableDictionary*)classNameToInterseptorDic{
    if (_classNameToInterseptorDic != nil) {
        return _classNameToInterseptorDic;
    }
    _classNameToInterseptorDic = [[NSMutableDictionary alloc] init];
    return _classNameToInterseptorDic;
}

- (NSMutableSet*)globalInterseptorSet{
    if (_globalInterseptorSet != nil) {
        return _globalInterseptorSet;
    }
    _globalInterseptorSet = [NSMutableSet new];
    return _globalInterseptorSet;
}

@end
