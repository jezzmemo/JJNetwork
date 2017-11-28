[![CocoaPods Compatible](https://img.shields.io/cocoapods/v/JJNetwork.svg)](https://img.shields.io/cocoapods/v/JJNetwork.svg)
[![Carthage Compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat)](https://github.com/Carthage/Carthage)
[![Platform](https://img.shields.io/cocoapods/p/JJNetwork.svg?style=flat)](http://cocoadocs.org/docsets/JJNetwork)
[![Build Status](https://travis-ci.org/jezzmemo/JJNetwork.svg?branch=master)](https://travis-ci.org/jezzmemo/JJNetwork.svg?branch=master)
[![Pod License](http://img.shields.io/cocoapods/l/JJNetwork.svg?style=flat)](https://www.apache.org/licenses/LICENSE-2.0.html)

AFNetworking-based network library, with delegate to process network response, integrate more business and optimize network performance,[Chinese document](https://github.com/jezzmemo/JJNetwork/blob/master/EXPLAIN.md)

JJNetwork is used in [iMemo](https://itunes.apple.com/cn/app/%E7%88%B1%E5%A2%A8%E6%97%A5%E8%AE%B0-%E7%AE%80%E6%B4%81%E4%BE%BF%E7%AD%BE%E4%B8%8E%E5%8D%B0%E8%B1%A1%E7%AC%94%E8%AE%B0%E5%90%8C%E6%AD%A5/id912688184?mt=8)

## Features

- [x] Sign the http parameter by your customer key
- [x] Http cache for the GET and POST
- [x] Replace the domain to IP address improve performance and change customer http head field
- [x] Interseptor network request

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
github "AFNetworking/AFNetworking" ~> 3.0
github "jezzmemo/JJNetwork"
```

Run carthage to build the framework and drag the built `AFNetworking.framework`,`JJNetwork.framework` into your Xcode project.

## Usage

#### Sign parameter by the customer key,implement `JJRequestProtocol` method
```objc
- (BOOL)isSignParameter{
    return YES;
}

- (NSString*)signParameterKey{
    return @"key";
}
```

#### Select cache policy for GET and POST,implement `JJRequestProtocol` method
- ReloadFromNetwork: Default mode,request from network
- ReloadFromCacheElseLoadNetwork: If have cache,will return the cache,do not request network,if not exist cache,will load origin source
- ReloadFromCacheTimeLimit: First time load request origin source,save the cache for the limit time,if expire，will load origin source and replace the old cache

```objc
- (HTTPCachePolicy)requestCachePolicy{
    return ReloadFromCacheTimeLimit;
}

- (NSUInteger)cacheLimitTime{
    return 120;
}
```

#### Replace the domain to IP address improve performance and change customer http head field

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

#### Interseptor network request

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
```

## Tourist

#### 1.Create Request file，extends from `JJAPIRequest` class，Implement `JJRequestProtocol`，For example:

DemoRequest.h
```objc
@interface DemoRequest : JJAPIRequest<JJRequestProtocol>

@end
```
DemoRequest.m
```objc
@implementation DemoRequest

- (NSString*)requestURL{
    return @"http://api.imemo8.com/diary.php?mod=getHotDiary";
}

- (HTTPMethod)requestMethod{
    return GET;
}

- (BOOL)isSignParameter{
    return NO;
}

- (NSString*)signParameterKey{
    return @"key";
}

- (HTTPCachePolicy)requestCachePolicy{
    return ReloadFromCacheTimeLimit;
}

- (NSUInteger)cacheLimitTime{
    return 120;
}

@end
```

#### 2.Create Service extends from `JJAPIService`,for example：

DemoAPIService.h
```objc
@interface DemoAPIService : JJAPIService

- (void)userDetailInfo:(NSInteger)uid;

@end
```

DemoAPIService.m
```objc
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
```

#### 3.Finaly,Invoke the DemoAPIService,for example:
```objc
@interface DemoViewController ()<JJAPIServiceProtocol>

@property(nonatomic,readwrite,strong)DemoAPIService* apiService;

@end

@implementation DemoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
	
    [self.apiService userDetailInfo:100];
}


- (DemoAPIService*)apiService{
    if (_apiService != nil) {
	return _apiService;
    }
    _apiService = [[DemoAPIService alloc] init];
    _apiService.serviceProtocol = self;
    return _apiService;
}

#pragma mark - Network response

- (void)responseSuccess:(JJAPIService *)service responseData:(id)data{
	
}
- (void)responseFail:(JJAPIService *)service errorMessage:(NSError *)error{
	
}

@end
```
## License
JJNetwork is released under the MIT license. See LICENSE for details.
