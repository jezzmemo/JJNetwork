//
//  APICache.h
//  JJNetwork
//
//  Created by Jezz on 2017/9/3.
//  Copyright © 2017年 jezz. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol APICache <NSObject>

@required


/**
 Save the customer data on any storage

 @param data Any data format
 @param key String key
 @return Save success YES,otherwise will NO
 */
- (BOOL)saveCacheWithData:(id)data withKey:(NSString*)key;


/**
 Get the cache data by key

 @param key String key
 @return Any format data
 */
- (id)cacheWithKey:(NSString*)key;

@optional

- (BOOL)removeCacheWithKey:(NSString*)key;

- (void)clearAllCache;

@end
