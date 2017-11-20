[![CocoaPods Compatible](https://img.shields.io/cocoapods/v/JJNetwork.svg)](https://img.shields.io/cocoapods/v/JJNetwork.svg)
[![Platform](https://img.shields.io/cocoapods/p/JJNetwork.svg?style=flat)](http://cocoadocs.org/docsets/JJNetwork)
[![Build Status](https://travis-ci.org/jezzmemo/JJNetwork.svg?branch=master)](https://travis-ci.org/jezzmemo/JJNetwork.svg?branch=master)
[![Pod License](http://img.shields.io/cocoapods/l/JJNetwork.svg?style=flat)](https://www.apache.org/licenses/LICENSE-2.0.html)

基于AFNetworking的网络库，使用delegate为交互方式,加入了一些业务增强和性能优化，[详细文档](https://github.com/jezzmemo/JJNetwork/blob/master/EXPLAIN.md)

## 特色功能

- [x] 根据自定义的Key签名参数，安全校验
- [x] 根据缓存规则缓存POST或者Get
- [x] 支持用IP替换域名，达到提高网络性能，支持HTTP HEAD设置
- [x] 可以设置任意一个APIService的拦截器

## 安装环境

- iOS 8.0以上
- Xcode 7.3以上

## 如何安装

__Podfile__
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
## 如何使用

#### 新建一个Request继承于 `APIRequest`，并实现 `RequestProtocol`协议，如:

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

#### 新建一个Service继承于 `APIService`,如：

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

#### 最后一步，在ViewController调用DemoAPIService,如:
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
