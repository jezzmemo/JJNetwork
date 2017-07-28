# JJNetwork
编写属于自己的网络层，首先这里主要解决的是基于HTTP协议的基础上的，而且是基于AFNetworking写的,主要完成以下目的:

* 开发人员根据规则即可访问网络
* 没有特殊需求，不需要设置访问的参数
* 简单，易用，扩展性强
* 网络层只管获取数据，不给数据做业务逻辑
* 网络优化（发送前，发送中，发送后）
* 网络安全
* 网络层和业务层如何对接
* 对接用delegate还是block
* 快速切换依赖第三方HTTP库

## APIRequest
* 每个请求都叫Request
* URL
* Parameter
* HTTP METHOD

## APIService
* 对应一个或者多个Request
* 返回Request来的数据
* 获取接口参数
