//
//  DemoAPIService.m
//  JJNetwork
//
//  Created by jezz on 31/07/2017.
//  Copyright © 2017 jezz. All rights reserved.
//

#import "DemoAPIService.h"
#import "DemoRequest.h"

@implementation DemoAPIService


- (void)userDetailInfo:(NSInteger)uid{
    //wrapper the parameter
    NSDictionary* parameter = @{@"userid":[NSString stringWithFormat:@"%d",uid]};
    
    //generate request,set the parameter
    DemoRequest* request = [[DemoRequest alloc] init];
    [request setParameter:parameter];
    
    //send request
    [self startRequest:request];
}

@end
