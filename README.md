[![CocoaPods Compatible](https://img.shields.io/cocoapods/v/JJNetwork.svg)](https://img.shields.io/cocoapods/v/JJNetwork.svg)
[![Carthage Compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat)](https://github.com/Carthage/Carthage)
[![Platform](https://img.shields.io/cocoapods/p/JJNetwork.svg?style=flat)](http://cocoadocs.org/docsets/JJNetwork)
[![Build Status](https://travis-ci.org/jezzmemo/JJNetwork.svg?branch=master)](https://travis-ci.org/jezzmemo/JJNetwork.svg?branch=master)
[![Pod License](http://img.shields.io/cocoapods/l/JJNetwork.svg?style=flat)](https://www.apache.org/licenses/LICENSE-2.0.html)

AFNetworking-based network library, with delegate to process network response, integrate more business and optimize network performance,[Chinese document](https://github.com/jezzmemo/JJNetwork/blob/master/EXPLAIN.md)

## Features

- [x] Sign the http parameter by your customer key
- [x] Customer cache for the GET and POST
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
    return @"https://www.google.com";
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
