//
//  APIModule.h
//  JJNetwork
//
//  Created by Jezz on 2017/9/10.
//  Copyright © 2017年 jezz. All rights reserved.
//

#ifndef APIModule_h
#define APIModule_h

@protocol APIModule <NSObject>

@end


@protocol APIDominIPModule <APIModule>

- (NSDictionary*)domainIPData;

@end

@protocol APIHttpHeadModule <APIModule>

- (NSDictionary*)customerHttpHead;

@end

#endif /* APIModule_h */
