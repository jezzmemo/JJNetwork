[![CocoaPods Compatible](https://img.shields.io/cocoapods/v/JJNetwork.svg)](https://img.shields.io/cocoapods/v/JJNetwork.svg)
[![Carthage Compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat)](https://github.com/Carthage/Carthage)
[![Platform](https://img.shields.io/cocoapods/p/JJNetwork.svg?style=flat)](http://cocoadocs.org/docsets/JJNetwork)
[![Build Status](https://travis-ci.org/jezzmemo/JJNetwork.svg?branch=master)](https://travis-ci.org/jezzmemo/JJNetwork.svg?branch=master)
![License MIT](https://img.shields.io/github/license/mashape/apistatus.svg?maxAge=2592000)

基于AFNetworking封装的网络库，主要是为了满足一些复杂App的网络请求，并在层次划分上比较清新，所有的网络请求是数据提供者，还归纳了一些常见的功能封装在里面(缓存,签名...),[设计文档](https://github.com/jezzmemo/JJNetwork/blob/master/EXPLAIN.md)

## 特色功能

- [x] 自定义Key签名参数
- [x] 缓存不止支持GET，还支持POST,根据自己的场景，自己选择策略
- [x] 支持用IP替换域名，达到提高网络性能，支持HTTP HEAD设置
- [x] 拦截网络请求，方便拦截任意请求，复用请求，加入Loading
- [x] 支持文件上传

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
github "jezzmemo/JJNetwork"
```

将 `AFNetworking.framework`,`JJNetwork.framework` 两个framework加入到自己的项目

## 如何使用

### JJAPIRequest

每个网络请求都是继承`JJAPIRequest`,并按照`JJRequestInput`协议的方法，按照自己的需求，重写(overwrite)指定的方法，来满足自己的需求.

下面我用JJNetwork来向`http://api.imemo8.com/diary.php`发送一个GET请求，参数是mod=getHotDiary:

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
填写一个完整的URL，继承JJAPIRequest的时候，必须需要实现这个方法，其余方法都是可选的，

* requestMethod
返回一个枚举类型，POST,GET,PUT,DELETE,如果不实现，默认是GET

### 如何传递参数和调用
关于在哪初始化Request，这个根据自己的情况自己选择，你可以在ViewController里调用，也可以再自己的中间层调用，这里给的例子是在ViewController里的例子:

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

- (void)responseSuccess:(JJAPIResponse *)response responseData:(id)data{
    NSLog(@"responseSuccess");
}

- (void)responseFail:(JJAPIResponse *)response errorMessage:(NSError *)error{
    NSLog(@"responseFail");
}
@end
```

* 调用startRequest方法执行网络请求
* 实现requestParameters来提供请求的参数，网络情况的输入
* responseSuccess和responseFail,网络请求的输出
* 至于为什么选择Delegate这种交互方式，[传送门](https://github.com/jezzmemo/JJNetwork/blob/master/EXPLAIN.md)

### 使用自定义Key签名参数,示例如下:
```objc
- (NSString*)signParameterKey{
    return @"key";
}
```
如果使用了`signParameterKey`方法，就会产生两个参数`sign`和`timestamp`,并且实现的方式是:md5(parameters + timestamp + key)

### GET和POST都支持缓存,示例如下:
```objc
- (HTTPCachePolicy)requestCachePolicy{
    return JJReloadFromCacheTimeLimit;
}

- (NSUInteger)cacheLimitTime{
    return 120;
}
```

如果选择了ReloadFromCacheTimeLimit缓存策略，就必须实现`cacheLimitTime`方法,作用是你的缓存持续的时间，过期后获取缓存的数据将为空

- JJReloadFromNone: 只从网络获取
- JJReloadFromLocalCache: 有缓存就从缓存获取，当网络返回时，更新老的缓存
- JJReloadFromCacheTimeLimit: 缓存限定的时间范围内，当网络返回时，更新老的缓存

在前面选择了缓存的策略后，最后一步就是怎么获取到缓存,直接调用继承JJAPIRequest任意类的`cacheFromCurrentRequest`方法:
```objc
id cacheData = [self.demoRequest cacheFromCurrentRequest];
NSLog(@"Local cache:%@",cacheData);
//先显示缓存
[self.demoRequest startRequest];
//在请求网络，更新UI
```

### 支持用IP替换域名(服务器要支持IP访问)，达到提高网络性能，支持HTTP HEAD设置

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

并注册到`JJAPIRequest+Extension`

```objc
[JJAPIRequest registerDomainIP:[[DomainModule alloc] init]];
[JJAPIRequest registerHttpHeadField:[[HttpHeadModule alloc] init]];
```

这是两个设置的接口，DomainModule是将域名替换成IP，减少了DNS的时间，从而提高访问速度.

HttpHeadModule是设置全局的Head Field,根据自己的项目需要来决定是否需要设置.

### 拦截器的使用

* 从`JJAPIRequest`实例化对象的requestInterseptor的属性，并实现`JJRequestInterseptor`协议:
```objc
- (DemoRequest*)demoRequest{
    if (_demoRequest != nil) {
        return _demoRequest;
    }
    _demoRequest = [DemoRequest new];
    _demoRequest.delegate = self;
    _demoRequest.requestInterseptor = self;
    return _demoRequest;
}
``` 

* JJAPIService 的扩展实现以下方法，可以监听任意JJAPIService子类:
```objc
+ (void)addRequestInterseptor:(id<JJRequestInterseptor>)interseptor forRequestClass:(Class)className;
+ (void)removeRequestInterseptor:(id<JJRequestInterseptor>)interseptor forRequestClass:(Class)className;
```

使用示例:
```objc
[JJAPIService addServiceInterseptor:self forServiceClass:[DemoAPIService class]];

- (void)beforeRequest:(JJAPIRequest*)request{
    NSLog(@"网络发送Request执行前");
}

- (void)afterRequest:(JJAPIRequest*)request{
    NSLog(@"网络发送Request执行后");
}

- (void)response:(JJAPIResponse*)response beforeResponseData:(id)data{
    NSLog(@"返回结果前");
}

- (void)response:(JJAPIResponse*)response afterResponseData:(id)data{
    NSLog(@"返回结果后");
}
```

主要应用的两个场景就是Loading的显示和关闭,还有就是如果我需要用某个网络请求的数据，不需要改动原来的业务逻辑，只需要添加一份拦截即可，对已有的代码不需要任何改动.

### 文件上传

支持单个文件和多个文件上传，Request的demo如下:
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

- (JJUploadFileBlock)requestFileBody{
    return ^(id<JJUploadFileBody> fileBody){
        NSString* filePath = [[NSBundle mainBundle] pathForResource:@"Info" ofType:@"plist"];
        [fileBody addFileURL:[NSURL fileURLWithPath:filePath] name:@"file" fileName:@"backup" mimeType:@"json"];
    };
}


@end
```

ViewController的代码片段示例:
```objc

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.demoRequest startRequest];
}

#pragma mark - Upload file

- (NSDictionary*)requestParameters:(JJAPIRequest *)request{
    return @{@"mod":@"upload"};
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

实现`requestFileBody`方法，添加要上传的文件即可，__这是HTTP上传文件，建议上传较小的文件__

## License
JJNetwork is released under the MIT license. See LICENSE for details.
