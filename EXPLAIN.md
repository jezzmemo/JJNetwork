# JJNetwork
封装网络通信的必要性，对于一般应用封装下第三方的网络库，提供常用的POST和GET方法，然后Callback给调用者，可以满足一般的情况，但是随着业务发展，用户量的增长，给网络通信提出更多的要求，比如:改进网络通信的性能，网络通信的安全，以及网络封装的灵活性...基于这些要求所有我们有必要封装一个网络通信的模块，它的目的要解决我们常见问题，也要满足某些请求特殊性，所以我列出以下问题需要解决:

## 架构

### JJAPIRequest
每个请求的基本单位，每个网络请求必须是继承这个对象,并实现`JJRequestInput`里的方法，最终调用startRequest即可工作,[代码示例](https://github.com/jezzmemo/JJNetwork/blob/master/JJNetwork/Demo/DemoRequest.m)

* 使用方式的选择:Category or Extend

使用Extend的好处是：编译期间,可以使用自定义变量，对于开发者来说比较灵活 坏处是：侵入性太强
使用Category的好处是：运行时,按需加载，不破坏原来的结构扩展 坏处是：写自定义变量不方便(技术上做的到)，方法名重复问题

在这个选择上，我选择了继承(extend)这种方式，主要是考虑开发者使用的灵活，以及不受方法名约束的问题

* 拦截器的使用

这是JJNetwork的高级功能，有两种方式使用这个功能，使用JJAPIService实例化对象实现`JJAPIServiceInterseptor`或者`[JJAPIService addServiceInterseptor]`来指定任意JJAPIService，拦截器主要功能是监听任意JJAPIService，以及网络执行前后需要做一些工作

* 缓存的策略选择
每个Request可以选择自己对应的缓存策略，由于是Protocol的设计，开发者可以根据自己的逻辑来选择，现在暂时只提供三种策略:
```objc
/**
 Request support the cache feature,default will request network immediately
 do not need cache.

 - ReloadFromNetwork: Default mode,request from network
 - ReloadFromCacheElseLoadNetwork: If have cache,will return the cache,do not request network,if not exist cache,will load origin source
 - ReloadFromCacheTimeLimit: First time load request origin source,save the cache for the limit time,if expire，will load origin source and replace the old cache
 */
typedef NS_ENUM(NSUInteger,HTTPCachePolicy){
    ReloadFromNetwork,
    ReloadFromCacheElseLoadNetwork,
    ReloadFromCacheTimeLimit,
};
```
__最后强调一点就是JJNetwork的Cache支持POST和Get的，iOS自带的CachePolicy只支持GET,因为JJNetwork设计之初就是为接口请求设计的，所以文件上传和下载不在我们功能之内__
* JJAPIDominIPModule和JJAPIHttpHeadModule

`JJAPIDominIPModule`提供全局设置域名和IP映射的功能，减少DNS查找过程，提高性能,[代码示例](https://github.com/jezzmemo/JJNetwork/blob/master/JJNetwork/Demo/DomainModule.m).

`JJAPIHttpHeadModule`全局设置HttpHeadField,[代码示例](https://github.com/jezzmemo/JJNetwork/blob/master/JJNetwork/Demo/HttpHeadModule.m).


### JJAPIService

__在用户是否需要使用APIService这层，我纠结了好久，最终在实用性和学习成本上，我还是选择简便，去掉了这层，只需要继承JJAPIRequest即可，如果中间需要层次，由开发者来决定,自行建立中间层，不过在内部我还是保留了这层，JJAPIRequest只是一个壳，所有的具体的工作都是JJAPIService来做，所有的逻辑和转发请求到第三方库都由JJAPIService来完成__

* ~~方法名表达具体意思~~

~~在这个地方是我要坚持的地方，当我们继承于JJAPIService，我们需要一个自定义的方法来表达我的请求是要干什么，需要传递什么参数，具体达到什么功能用方法名来体现，所以这个方式给维护者来说很明确，使用者看到这个类和方法，很快的清晰知道了Service的作用~~

__每个Request就是一个对象，所以在命名清楚，就可以知道每个Request是什么作用__


### ThirdParty
* 抽象HTTP接口
先定义一个HTTP的接口:
```objc
@protocol JJTTPProtocol <NSObject>

- (void)httpPost:(NSURL*)url
	   parameter:(NSDictionary*)parameter
		  target:(id)target
		selector:(SEL)selector;

- (void)httpGet:(NSURL*)url
	  parameter:(NSDictionary*)parameter
		 target:(id)target
	   selector:(SEL)selector;

@end
```

* 快速切换第三方网络库
如果你用AFNetworking来实现就用AFNetworing来实现，如果用其他的第三方库就用其他的，这个根据你们你们的情况来选，如果需要切换，只需要实现这个接口，然后换下你的实现类就行了，如果需要切换回来再换回来就行.


### Cache
关于缓存这个问题，我也考虑过用HTTP本身的缓存，但是看过iOS的文档后，发现有两个枚举没有实现，如:
```
typedef NS_ENUM(NSUInteger, NSURLRequestCachePolicy)
{
    NSURLRequestUseProtocolCachePolicy = 0,

    NSURLRequestReloadIgnoringLocalCacheData = 1,
    NSURLRequestReloadIgnoringLocalAndRemoteCacheData = 4, // Unimplemented
    NSURLRequestReloadIgnoringCacheData = NSURLRequestReloadIgnoringLocalCacheData,

    NSURLRequestReturnCacheDataElseLoad = 2,
    NSURLRequestReturnCacheDataDontLoad = 3,

    NSURLRequestReloadRevalidatingCacheData = 5, // Unimplemented
};
```
所以长期来看，我放弃使用系统的Cache方案，自己来写

* 抽象Cache的获取，存储，删除等基本需求

* 主要使用File和Memory介质来存储，具体由这两种介质来具体实现

### Category
* 这个地方就不多讲了，就是项目中用到的一些工具类

## 网络性能优化
先看一张Chrome的Timing的流程图，清楚的表述了HTTP的整个流程的关键节点:
![Chrome Timing](https://developers.google.com/web/tools/chrome-devtools/network-performance/imgs/resource-timing-api.png)

在我们这个特定场景下，我们只讨论HTTP的网络优化，先看看HTTP整个过程:
* iOS内部准备

这个阶段就是对应图上的Redirect阶段，是指内部API调用，还没开始正式的Request,这部分的优化空间比较小，都是由NSURLSessionTask来启动的，根据自己的情况可以调节优先级，默认配置:
```objc
self.operationQueue = [[NSOperationQueue alloc] init];
self.operationQueue.maxConcurrentOperationCount = 1;
self.session = [NSURLSession sessionWithConfiguration:self.sessionConfiguration delegate:self delegateQueue:self.operationQueue];
```
* Cache

在发送Request之前，先检查本地是否有Cache，这个Cache的策略可以根据自己的情况来定，有些场景更新不频繁，可以再一定的场景里都用Cache，不用去请求网络。

我们这里选择比较通用的策略，先检查有没Cache，没有就去请求网络，并保存Cache，如果下次请求先返回Cache，再去请求网络，更新Cache,这里缓存的数据我用了单独的Delegate，为了区分网络数据和缓存，因为这次选择让开发者来决定.

* DNS

DNS是一个查找的过程，我们优化的部分就是直接将域名替换成IP，这样就不需要将域名查找的过程省略了，其实DNS在没有变化的情况下是有缓存的，所以在Chrome统计的时候一般只需要几十毫秒，不过从性能的角度来说，也是一个优化的点.

* TCP握手

HTTP一般都是TCP协议的，有三次的握手，HTTPS更多，这个地方的优化可以参考[SPDY](https://developers.google.com/speed/spdy/):

设计SPDY的目的在于降低网页的加载时间。通过优先级和多路复用，SPDY使得只需要创建一个TCP连接即可传送网页内容及图片等资源。SPDY中广泛应用了TLS加密，传输内容也均以gzip或DEFLATE格式压缩（与HTTP不同，HTTP的头部并不会被压缩）。另外，除了像HTTP的网页服务器被动的等待浏览器发起请求外，SPDY的网页服务器还可以主动推送内容.

* Request

这部分主要是指，本地在打包需要发送的数据，在基于TCP握手完成后，主要是数据传输中的优化，在当前的一般的手段是通过GZip压缩，或者通过[Protocol buffers](https://developers.google.com/protocol-buffers/)的方式将数据压缩，来减少在传输的过程中的数据量。

* Response

Response和Request是对应关系，上面那部分说需要压缩，在这部分就是对应着解压，在Request的编码，对应着这边的解码,所以这部分和Request的优化是一起的.

__最后总结下网络请求的原则是，能用Cache就用Cache(比如分类)，能批量发送请求就批量发送(比如统计)，最后实在没办法就走实时请求这条路(比如支付)__

## 网络安全

 * 敏感内容一定要加密
    
 这里就举个常见的例子，在登录的时候，密码在很多app都以明文的形式在发送，这样在黑客的WIFI或者在一些被控住的中间节点，会导致用户信息被窃取,__网易，CSDN事件给我们惨痛的教训，所以这个细节很重要__.

 * HTTPS

 国内的一些主流网站,App,服务好多已经升级到了HTTPS了，iOS也提倡用HTTPS，只是把强制用HTTPS的时间延迟了，所以HTTPS是我们HTTP通讯中，安全环节比较重要的一步，大家对这个认识也达成了共识，主要的功能就是内容加密，防止窃取和篡改，唯一的缺点就是通信之前需要握手好几次，所以通信的效率稍微降低了，不过在当前的网络带宽和服务器配置上，只是一个比较小的问题，当然也有有些技术对HTTPS的握手有优化，在保证安全的前提下，效率变高了，后面我会单独开一片文章来讲解HTTPS的实现原理和优化.

 * 认证和签名

 认证是指在用户使用我们提供的服务之前，会有一个用户登录认证的过程，比如Auth2.0，就是起到一个认证用户合法性的过程.

 签名就是我们在认证之后，双方通讯会用参数和时间戳产生一个签名，然后服务端根据这个规则进行对比，通过代表请求是合法的，否则就是不合法的请求.

 * 保护Key

 1. 简单的混淆敏感的Key,[UAObfuscatedString](https://github.com/UrbanApps/UAObfuscatedString)
 2. iOS Data Protection
 3. 混淆
 4. 使用底层的方式C/C++

 以上几种方法是加强对Key的保护，并不能一定解决这个问题，后续有简单安全的办法再补充
 
  
## 网络层和业务层如何对接

在开始这个话题之前，首先我们的app定义的架构图:

![architecture](https://raw.githubusercontent.com/jezzmemo/JJNetwork/master/architecture.png)

所以在网络通信只是属于架构中，获取数据其中的方式之一，但是当网络层获取到数据的时候，我们不需要做任何加工，在架构中的有Business专门来做业务逻辑，所以网络获取到的数据不管是XML,JSON，还是Binary的，我都原封不动的转给Business层，这样各自的职责很明确，唯一的缺点就是数据加工完后给ViewController，需要另外的传递，胶水代码有点多，不过为了职责分明和方便维护，这点缺点还是可以接受的.

## 对接用Delegate还是Block

> 关于这个选择，我主要参考Casa的意见，他主要给出了三点:
> - block很难追踪，难以维护
> - block会延长相关对象的生命周期
> - block在离散型场景下不符合使用的规范

关于第一点我不太认同，因为复杂这个事是个人的经历和经验来总结的，其实复杂之后用delegate也不见得简单.

关于第三点是第二点的延伸，在网络这个场景下，是需要对网络请求的生命周期进行控制的，因为在一种极端情况下，你的场景申请了很多内存，如果没有得到及时的释放，反复几个来回，你的内存会极速增长，app就会处于一个危险的状态，还有同学坚持用block说可以做到及时释放，那他就需要去手动的告诉网络库，我这边不用了，这样有个问题就是重复代码很多，而且需要你手动申明，如果自己维护这个变量ARC，在当前场景结束后，系统帮你自动结束，剩下的事情就是你网络内部来处理了，这样从维护的角度来说比较优雅，这也是为什么系统的网络库用Delegate的原因之一吧.


## 参考
[casatwy](https://casatwy.com/iosying-yong-jia-gou-tan-wang-luo-ceng-she-ji-fang-an.html)
