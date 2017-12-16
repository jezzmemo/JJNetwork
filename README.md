[![CocoaPods Compatible](https://img.shields.io/cocoapods/v/JJNetwork.svg)](https://img.shields.io/cocoapods/v/JJNetwork.svg)
[![Carthage Compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat)](https://github.com/Carthage/Carthage)
[![Platform](https://img.shields.io/cocoapods/p/JJNetwork.svg?style=flat)](http://cocoadocs.org/docsets/JJNetwork)
[![Build Status](https://travis-ci.org/jezzmemo/JJNetwork.svg?branch=master)](https://travis-ci.org/jezzmemo/JJNetwork.svg?branch=master)
![License MIT](https://img.shields.io/github/license/mashape/apistatus.svg?maxAge=2592000)

AFNetworking-based network library, with delegate to process network response, integrate more business and optimize network performance,[中文使用说明](https://github.com/jezzmemo/JJNetwork/blob/master/README_CN.md),[设计文档](https://github.com/jezzmemo/JJNetwork/blob/master/EXPLAIN.md)

## Features

- [x] Sign the http parameter by your customer key
- [x] Http cache for the GET and POST
- [x] Replace the domain to IP address improve performance and change customer http head field
- [x] Interseptor request and response
- [x] Support upload files

## Requirements

- iOS 8.0 or later
- Xcode 7.3 or later

## Installation

__Podfile__
```
source 'https://github.com/CocoaPods/Specs.git'
platform :ios, '8.0'

target 'TargetName' do
pod 'JJNetwork'
end
```
run the following command:
```
$ pod install
```

#### Installation with Carthage

To integrate JJNetwork into your Xcode project using Carthage, specify it in your `Cartfile`:

```
github "jezzmemo/JJNetwork"
```

Run carthage to build the framework and drag the built `AFNetworking.framework`,`JJNetwork.framework` into your Xcode project.

## Usage

### JJAPIRequest

Every network request extends from `JJAPIRequest`,and then implement `JJRequestInput` protocol,overwrite some method.


For example:JJNetwork `http://api.imemo8.com/diary.php` send GET request，parameter:mod=getHotDiary

```objc
#import "JJNetwork.h"

@interface DemoRequest : JJAPIRequest

@end

#import "DemoRequest.h"

@implementation DemoRequest

- (NSString*)requestURL{
    return @"http://api.imemo8.com/diary.php";
}

- (HTTPMethod)requestMethod{
    return JJRequestGET;
}
@end
```

* requestURL

Fill whole request URL,this method is required,other is optional

* requestMethod

return enum，POST,GET,PUT,DELETE,default is GET,if you did not implement

### Parameter and Start request

```objc
#import "PresentViewController.h"
#import "DemoRequest.h"

@interface PresentViewController ()<JJRequestDelegate>

@property(nonatomic,readwrite,strong)DemoRequest* demoRequest;

@end

@implementation PresentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.demoRequest startRequest];
}

#pragma mark - Get property

- (DemoRequest*)demoRequest{
    if (_demoRequest != nil) {
        return _demoRequest;
    }
    _demoRequest = [DemoRequest new];
    _demoRequest.delegate = self;
    return _demoRequest;
}

#pragma mark - Request parameter

- (NSDictionary*)requestParameters:(JJAPIRequest *)request{
    return @{@"mod":@"getHotDiary"};
}

#pragma mark - Network response

- (void)responseSuccess:(JJAPIRequest *)request responseData:(id)data{
    NSLog(@"responseSuccess");
}

- (void)responseFail:(JJAPIRequest *)request errorMessage:(NSError *)error{
    NSLog(@"responseFail");
}
@end
```

* Invoke `startRequest` will process network request
* Implement `requestParameters` request parameter
* `responseSuccess` and `responseFail`,network response

### Sign parameter by the customer key
```objc
- (NSString*)signParameterKey{
    return @"key";
}
```
If implement `signParameterKey`,request will add two parameters,`sign` and `timestamp`,sign = md5(parameters + timestamp + key)

### Select cache policy for GET and POST
```objc
- (HTTPCachePolicy)requestCachePolicy{
    return ReloadFromCacheTimeLimit;
}

//UNIT Second
- (NSUInteger)cacheLimitTime{
    return 120;
}
```

- ReloadFromNetwork: Default mode,request from network
- ReloadFromCacheElseLoadNetwork: If have cache,will return the cache,do not request network,if not exist cache,will load origin source
- ReloadFromCacheTimeLimit: First time load request origin source,save the cache for the limit time,if expire，will load origin source and replace the old cache

If choose ReloadFromCacheTimeLimit policy,you must implement `cacheLimitTime`

### Replace the domain to IP address improve performance and change customer http head field

* `JJAPIDominIPModule`

```objc
@interface DomainModule : NSObject<JJAPIDominIPModule>

@end
@implementation DomainModule
- (NSDictionary*)domainIPData{
    return @{@"api.imemo8.com":@"218.244.140.1"};
}
@end
```

* `JJAPIHttpHeadModule`

```objc
@interface HttpHeadModule : NSObject<JJAPIHttpHeadModule>

@end
@implementation HttpHeadModule

- (NSDictionary*)customerHttpHead{
    return @{@"user-token":@"xxxxx",@"device-id":@"xxxxx"};
}

@end
```

Register module to `JJAPIService+Extension`

```objc
[JJAPIService registerDomainIP:[[DomainModule alloc] init]];
[JJAPIService registerHttpHeadField:[[HttpHeadModule alloc] init]];
```

### Interseptor

* Implement from `JJAPIServiceInterseptor` to the instance `JJAPIService` object:
```objc
- (DemoAPIService*)apiService{
    if (_apiService != nil) {
        return _apiService;
    }
    _apiService = [[DemoAPIService alloc] init];
    _apiService.serviceProtocol = self;
    _apiService.serviceInterseptor = self;
    return _apiService;
}
```

* JJAPIService (Extension)
```objc
+ (void)addServiceInterseptor:(id<JJAPIServiceInterseptor>)interseptor forServiceClass:(Class)className;
+ (void)removeServiceInterseptor:(id<JJAPIServiceInterseptor>)interseptor forServiceClass:(Class)className;
```

For example:
```objc
[JJAPIService addServiceInterseptor:self forServiceClass:[DemoAPIService class]];

- (void)beforeRequest:(JJAPIRequest*)request{
    NSLog(@"beforeRequest");
}

- (void)afterRequest:(JJAPIRequest*)request{
    NSLog(@"afterRequest");
}

- (void)request:(JJAPIRequest*)request beforeResponse:(id)data{
    NSLog(@"beforeResponse");
}

- (void)request:(JJAPIRequest*)request afterResponse:(id)data{
    NSLog(@"afterResponse");
}
```

* Control Loading show/hide
* AOP Request

### Upload files

Support upload one or more files，UploadFileDemoRequest's demo:
```objc

#import <JJNetwork/JJNetwork.h>

@interface UploadFileDemoRequest : JJAPIRequest

@end

@implementation UploadFileDemoRequest

- (NSString*)requestURL{
    return @"http://api.imemo8.com/xxxx.php";
}

- (HTTPMethod)requestMethod{
    return JJRequestPOST;
}


@end
```

ViewController's Demo:
```objc

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.demoRequest startRequest];
}

#pragma mark - Upload file

- (NSDictionary*)requestParameters:(JJAPIRequest *)request{
    return @{@"mod":@"upload"};
}

- (JJUploadFileBlock)requestFileBody:(JJAPIRequest*)request{
    return ^(id<JJUploadFileBody> fileBody){
        NSString* filePath = [[NSBundle mainBundle] pathForResource:@"Info" ofType:@"plist"];
        [fileBody addFileURL:[NSURL fileURLWithPath:filePath] name:@"name" fileName:@"filename" mimeType:@"txt"];
    };
}

#pragma mark - Get property

- (UploadFileDemoRequest*)demoRequest{
    if (_demoRequest != nil) {
        return _demoRequest;
    }
    _demoRequest = [UploadFileDemoRequest new];
    _demoRequest.delegate = self;
    return _demoRequest;
}
```

Implement `requestFileBody` method，add file information，__This is upload file by HTTP, it is recommended to upload a smaller file__

## License
JJNetwork is released under the MIT license. See LICENSE for details.
