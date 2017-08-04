# JJNetwork


## CocoaPods
```
source 'https://github.com/CocoaPods/Specs.git'
platform :ios, '8.0'

target 'TargetName' do
pod 'JJNetwork'
end
```
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

3.最后调用者调用Service,如:
```objc
@interface DemoViewController ()<APIServiceProtocol>

@property(nonatomic,readwrite,strong)DemoAPIService* apiService;

@end

@implementation DemoViewController

- (void)viewDidLoad {
	[super viewDidLoad];
	
	[self.apiService startRequest];
}


- (DemoAPIService*)apiService{
	if (_apiService != nil) {
		return _apiService;
	}
	_apiService = [[DemoAPIService alloc] init];
	_apiService.serviceProtocol = self;
	return _apiService;
}

- (void)responseSuccess:(APIService *)service responseData:(id)data{
	
}

- (void)responseFail:(APIService *)service errorMessage:(NSError *)error{
	
}

- (NSDictionary*)requestParameters{
	return nil;
}
@end
```

