//
//  APIModule.h
//  JJNetwork
//
//  Created by Jezz on 2017/9/10.
//  Copyright © 2017年 jezz. All rights reserved.
//

#ifndef JJAPIModule_h
#define JJAPIModule_h

@protocol JJAPIModule <NSObject>

@end


@protocol JJAPIDominIPModule <JJAPIModule>

- (NSDictionary*)domainIPData;

@end

@protocol JJAPIHttpHeadModule <JJAPIModule>

- (NSDictionary*)customerHttpHead;

@end

#endif /* APIModule_h */
