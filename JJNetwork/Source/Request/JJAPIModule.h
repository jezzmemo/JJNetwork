//
//  APIModule.h
//  JJNetwork
//
//  Created by Jezz on 2017/9/10.
//  Copyright © 2017年 jezz. All rights reserved.
//

#ifndef JJAPIModule_h
#define JJAPIModule_h

#import <Foundation/Foundation.h>

@protocol JJAPIDominIPModule <NSObject>

/**
 The key is origin domain,value is IP address
 For example:api.xxxx.com->12.12.12.128

 @return User Customer domain map IP
 */
- (NSDictionary*)domainIPData;

@end

@protocol JJAPIHttpHeadModule <NSObject>

/**
 Implement set global request customer head,
 If the key exist,will replace the old key

 @return NSDictionary
 */
- (NSDictionary*)customerHttpHead;

@end

#endif /* APIModule_h */
