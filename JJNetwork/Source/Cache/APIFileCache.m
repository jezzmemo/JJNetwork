//
//  APIFileCache.m
//  JJNetwork
//
//  Created by Jezz on 2017/9/3.
//  Copyright © 2017年 jezz. All rights reserved.
//

#import "APIFileCache.h"
#import "NSString+MD5.h"

@implementation APIFileCache

- (BOOL)saveCacheWithData:(id)data withKey:(NSString*)key{
    NSString* fileName = [key md5];
    NSString* filePath = [self tempFilePath:fileName];
    if (data && filePath) {
        [data writeToFile:filePath atomically:YES];
    }
    return NO;
}

- (id)cacheWithKey:(NSString*)key{
    NSString* filePath = [self tempFilePath:[key md5]];
    if (![[NSFileManager defaultManager] fileExistsAtPath:filePath]) {
        return nil;
    }
    //String
    NSString* stringData = [NSString stringWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:nil];
    if (stringData) {
        return stringData;
    }
    //Binary
    NSData* binaryData = [NSData dataWithContentsOfFile:filePath];
    if (binaryData) {
        return binaryData;
    }
    return nil;
}

- (id)cacheWithKey:(NSString *)key withTimeLimit:(NSUInteger)seconds{
    NSString* filePath = [self tempFilePath:[key md5]];
    if (![[NSFileManager defaultManager] fileExistsAtPath:filePath]) {
        return nil;
    }
    NSDictionary* attributes = [[NSFileManager defaultManager] attributesOfItemAtPath:filePath error:nil];
    NSDate* createDate = attributes[NSFileCreationDate];
    NSDate* nowDate = [NSDate date];
    NSInteger diff = [nowDate timeIntervalSince1970] - [createDate timeIntervalSince1970];
    if (diff > seconds) {
        [self removeCacheWithKey:key];
        NSLog(@"Cache expired");
        return nil;
    }
    return [self cacheWithKey:key];
}

- (BOOL)removeCacheWithKey:(NSString*)key{
    NSString* filePath = [self tempFilePath:[key md5]];
    if (![[NSFileManager defaultManager] fileExistsAtPath:filePath]) {
        return NO;
    }
    [[NSFileManager defaultManager] removeItemAtPath:filePath error:nil];
    return YES;
}

- (NSString*)tempFilePath:(NSString*)fileName{
    if (!fileName) {
        return nil;
    }
    NSArray* cacheFolders = NSSearchPathForDirectoriesInDomains(NSCachesDirectory,NSUserDomainMask,YES);
    if (cacheFolders.count > 0) {
        NSString* cacheFilePath = [[cacheFolders lastObject] stringByAppendingPathComponent:fileName];
        return cacheFilePath;
    }
    return nil;
}



@end
