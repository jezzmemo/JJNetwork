//
//  UploadFileDemoRequest.m
//  JJNetwork
//
//  Created by Jezz on 2017/12/15.
//  Copyright © 2017年 jezz. All rights reserved.
//

#import "UploadFileDemoRequest.h"

@implementation UploadFileDemoRequest

- (NSString*)requestURL{
    return @"http://api.imemo8.com/xxxx.php";
}

- (HTTPMethod)requestMethod{
    return JJRequestPOST;
}

- (JJUploadFileBlock)requestFileBody{
    return ^(id<JJUploadFileBody> fileBody){
        NSString* filePath = [[NSBundle mainBundle] pathForResource:@"Info" ofType:@"plist"];
        [fileBody addFileURL:[NSURL fileURLWithPath:filePath] name:@"file" fileName:@"backup" mimeType:@"json"];
    };
}


@end
