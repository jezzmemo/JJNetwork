[![CocoaPods Compatible](https://img.shields.io/cocoapods/v/JJNetwork.svg)](https://img.shields.io/cocoapods/v/JJNetwork.svg)
[![Platform](https://img.shields.io/cocoapods/p/JJNetwork.svg?style=flat)](http://cocoadocs.org/docsets/JJNetwork)
[![Build Status](https://travis-ci.org/jezzmemo/JJNetwork.svg?branch=master)](https://travis-ci.org/jezzmemo/JJNetwork.svg?branch=master)
[![Pod License](http://img.shields.io/cocoapods/l/JJNetwork.svg?style=flat)](https://www.apache.org/licenses/LICENSE-2.0.html)

## Features

- [x] Sign the http parameter by your customer key

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
## Usage

1.Create Request file，extends from `APIRequest` class，Implement `RequestProtocol`，For example:

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

2.Create Service extends from `APIService`,for example：

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

3.Finaly,Invoke the DemoAPIService,for example:
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
