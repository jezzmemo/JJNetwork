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

@protocol APIModuleDomainIp<APIModule>

- (NSDictionary*)domainIp;

@end

@protocol APIModuleHttpHead<APIModule>

- (NSDictionary*)httpHeadField;

@end


#endif /* APIModule_h */
