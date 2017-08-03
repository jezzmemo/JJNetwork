# JJNetwork
iOS封装的网络通信层

## 如何安装

## 如何使用

1.新建一个Request文件，继承与APIRequest，实现RequestProtocol接口，如:
DemoRequest.h
```objc
@interface DemoRequest : APIRequest<RequestProtocol>

@end
```
DemoRequest.m
```objc
@implementation DemoRequest

- (NSString*)requestURL{
	return @"http://ask.dev.mojoymusic.com/api/user/login_with_wx";
}

- (HTTPMethod)requestMethod{
	return GET;
}

@end
```

2.新建一个Service继承与APIService,如：
DemoAPIService.h
```objc
@interface DemoAPIService : APIService

@end
```

DemoAPIService.m
```objc
@implementation DemoAPIService


- (Class)generateRequest{
	return [DemoRequest class];
}
@end
```
