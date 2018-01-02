//
//  JJAPIMock.h
//  JJNetwork
//
//  Created by Jezz on 2017/12/25.
//  Copyright © 2017年 jezz. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface JJAPIMock : NSObject

/**
 Global mock settings switch
 */
@property(class,nonatomic,readwrite,assign)BOOL mockSwitch;

/**
 Add request to mock,response NSString

 @param request Extends from JJAPIRequest object
 @param response Response string
 @param flag Yes:to mock request,NO:cancel mock request
 */
+ (void)testRequest:(Class)request responseString:(NSString*)response isOn:(BOOL)flag;

/**
 Add request to mock,response NSString file path

 @param request Extends from JJAPIRequest object
 @param filePath Input the response from the file path
 @param flag Yes:to mock request,NO:cancel mock request
 */
+ (void)testRequest:(Class)request responseFilePath:(NSString*)filePath isOn:(BOOL)flag;

/**
 Add request to mock,response NSData type

 @param request Extends from JJAPIRequest object
 @param data Input binary data
 @param flag flag Yes:to mock request,NO:cancel mock request
 */
+ (void)testRequest:(Class)request responseData:(NSData*)data isOn:(BOOL)flag;

@end

NS_ASSUME_NONNULL_END
