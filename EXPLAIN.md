# JJNetwork
封装网络通信的必要性，对于一般应用封装下第三方的网络库，提供常用的POST和GET方法，然后Callback给调用者，可以满足一般的情况，但是随着业务发展，用户量的增长，给网络通信提出更多的要求，比如:改进网络通信的性能，网络通信的安全，以及网络封装的灵活性...基于这些要求所有我们有必要封装一个网络通信的模块，它的目的要解决我们常见问题，也要满足某些请求特殊性，所以我列出以下问题需要解决:

## 开发人员根据规则即可访问网络
## 简单，易用，扩展性强
## 网络性能优化
先看一张Chrome的Timing的流程图，清楚的表述了HTTP的整个流程的关键节点:
![Http timing](https://developers.google.com/web/tools/chrome-devtools/network-performance/imgs/resource-timing-api.png)

在我们这个特定场景下，我们只讨论HTTP的网络优化，先看看HTTP整个发送和接受的过程:
* iOS内部准备
* 如果有Cache，走Cache策略
* DNS
* TCP握手
* Request
* Response

## 网络安全

 * 敏感内容一定要加密
    
 这里就举个常见的例子，在登录的时候，密码在很多app都以明文的形式在发送，这样在黑客的WIFI或者在一些被控住的中间节点，会导致用户信息被窃取,__网易，CSDN事件给我们惨痛的教训，所以这个细节很重要__.

 * HTTPS

 国内的一些主流网站,App,服务好多已经升级到了HTTPS了，iOS也提倡用HTTPS，只是把强制用HTTPS的时间延迟了，所以HTTPS是我们HTTP通讯中，安全环节比较重要的一步，大家对这个认识也达成了共识，主要的功能就是内容加密，防止窃取和篡改，唯一的缺点就是通信之前需要握手好几次，所以通信的效率稍微降低了，不过在当前的网络带宽和服务器配置上，只是一个比较小的问题，当然也有有些技术对HTTPS的握手有优化，在保证安全的前提下，效率变高了，后面我会单独开一片文章来讲解HTTPS的实现原理和优化.

 * 认证和签名

 认证是指在用户使用我们提供的服务之前，会有一个用户登录认证的过程，比如Auth2.0，就是起到一个认证用户合法性的过程.

 签名就是我们在认证之后，双方通讯会用参数和时间戳产生一个签名，然后服务端根据这个规则进行对比，通过代表请求是合法的，否则就是不合法的请求.

 * 保护Key
 
  
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

## 快速切换依赖第三方HTTP库

先定义一个HTTP的接口:
```objc
@protocol HTTPProtocol <NSObject>

/**
 Http Post method

 @param url http url
 @param parameter http parameters
 @param target callback target
 @param selector callback method name
 */
- (void)httpPost:(NSURL*)url
	   parameter:(NSDictionary*)parameter
		  target:(id)target
		selector:(SEL)selector;

/**
 Http Get method
 */
- (void)httpGet:(NSURL*)url
	  parameter:(NSDictionary*)parameter
		 target:(id)target
	   selector:(SEL)selector;

@end
```

接下来就是如果你用AFNetworking来实现就用AFNetworing来实现，如果用其他的第三方库就用其他的，这个根据你们你们的情况来选，如果需要切换，只需要实现这个接口，然后换下你的实现类就行了，如果需要切换回来再换回来就行.

## APIRequest
* URL
* HTTP METHOD
* Parameter

## APIService
* 对应一个Request
* 返回Request来的数据
* 获取接口参数

## ThirdParty
* 定义HTTP接口
* 实现由你想用的网络库来执行
* APIManager来管理所有的网络请求，添加和取消请求


## 参考
[casatwy](https://casatwy.com/iosying-yong-jia-gou-tan-wang-luo-ceng-she-ji-fang-an.html)
