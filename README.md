[![CocoaPods Compatible](https://img.shields.io/cocoapods/v/JJNetwork.svg)](https://img.shields.io/cocoapods/v/JJNetwork.svg)
[![Platform](https://img.shields.io/cocoapods/p/JJNetwork.svg?style=flat)](http://cocoadocs.org/docsets/JJNetwork)


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
## Usage

1.Create Request file，extends from APIRequest class，Implement RequestProtocol，For example:

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

2.Create Service extends from APIService,for example：

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

3.Finaly,Invoke the DemoAPIService,for example:
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

## License
JJNetwork is released under the MIT license. See LICENSE for details.
