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


- (Class)generateRequest{
	return [DemoRequest class];
}

@end
