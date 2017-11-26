[![CocoaPods Compatible](https://img.shields.io/cocoapods/v/JJNetwork.svg)](https://img.shields.io/cocoapods/v/JJNetwork.svg)
[![Carthage Compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat)](https://github.com/Carthage/Carthage)
[![Platform](https://img.shields.io/cocoapods/p/JJNetwork.svg?style=flat)](http://cocoadocs.org/docsets/JJNetwork)
[![Build Status](https://travis-ci.org/jezzmemo/JJNetwork.svg?branch=master)](https://travis-ci.org/jezzmemo/JJNetwork.svg?branch=master)
[![Pod License](http://img.shields.io/cocoapods/l/JJNetwork.svg?style=flat)](https://www.apache.org/licenses/LICENSE-2.0.html)

基于AFNetworking的网络库，使用Delegate为交互方式,加入了一些业务增强和性能优化，[详细文档](https://github.com/jezzmemo/JJNetwork/blob/master/EXPLAIN.md)

## 特色功能

- [x] 自定义Key签名参数
- [x] 缓存不止支持GET，还支持POST
- [x] 支持用IP替换域名，达到提高网络性能，支持HTTP HEAD设置
- [x] JJAPIService的扩展支持拦截器,可以添加和删除任意JJAPIService

## 安装环境

- iOS 8.0以上
- Xcode 7.3以上

## 如何安装

#### Podfile
```
source 'https://github.com/CocoaPods/Specs.git'
platform :ios, '8.0'

target 'TargetName' do
pod 'JJNetwork'
end
```
执行命令:
```
$ pod install
```
#### 使用Carthage集成

在你的`Cartfile`文件里，加入以下内容:

```
github "AFNetworking/AFNetworking" ~> 3.0
github "jezzmemo/JJNetwork"
```

将 `AFNetworking.framework`,`JJNetwork.framework` 两个framework加入到自己的项目

## 特色功能使用

#### 使用自定义Key签名参数,实现 `JJRequestProtocol` 的以下方法:
```objc
- (BOOL)isSignParameter{
    return YES;
}

- (NSString*)signParameterKey{
    return @"key";
}
```

#### GET和POST都支持缓存,实现 `JJRequestProtocol` 的以下方法:
- ReloadFromNetwork: 只从网络获取
- ReloadFromCacheElseLoadNetwork: 有缓存就从缓存获取，没有就从网路获取
- ReloadFromCacheTimeLimit: 缓存限定的时间范围内

```objc
- (HTTPCachePolicy)requestCachePolicy{
    return ReloadFromCacheTimeLimit;
}

- (NSUInteger)cacheLimitTime{
    return 120;
}
```

#### 支持用IP替换域名(服务器要支持IP访问)，达到提高网络性能，支持HTTP HEAD设置

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

并注册到`JJAPIService+Extension`

```objc
[JJAPIService registerDomainIP:[[DomainModule alloc] init]];
[JJAPIService registerHttpHeadField:[[HttpHeadModule alloc] init]];
```

#### 拦截器的使用

* 从`JJAPIService`实例化对象的serviceInterseptor的属性，并实现`JJAPIServiceInterseptor`协议:
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

* JJAPIService 的扩展实现以下方法，可以监听任意JJAPIService子类:
```objc
+ (void)addServiceInterseptor:(id<JJAPIServiceInterseptor>)interseptor forServiceClass:(Class)className;
+ (void)removeServiceInterseptor:(id<JJAPIServiceInterseptor>)interseptor forServiceClass:(Class)className;
```

使用如下:
```objc
[JJAPIService addServiceInterseptor:self forServiceClass:[DemoAPIService class]];
```

## 快速试用

#### 1.新建一个Request继承于 `APIRequest`，并实现 `RequestProtocol`协议，如:

DemoRequest.h
```objc
@interface DemoRequest : APIRequest<RequestProtocol>

@end
```
DemoRequest.m
```objc
@implementation DemoRequest

- (NSString*)requestURL{
    return @"https://www.google.com";
}

@end
```

#### 2.新建一个Service继承于 `APIService`,如：

DemoAPIService.h
```objc
@interface DemoAPIService : APIService

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

#### 3.最后一步，在ViewController调用DemoAPIService,如:
```objc
@interface DemoViewController ()<APIServiceProtocol>

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

- (void)responseSuccess:(APIService *)service responseData:(id)data{
	
}
- (void)responseFail:(APIService *)service errorMessage:(NSError *)error{
	
}

@end
```

## License
JJNetwork is released under the MIT license. See LICENSE for details.
