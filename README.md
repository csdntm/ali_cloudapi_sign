# ali_cloudapi_sign [![Pub](https://img.shields.io/pub/v/ali_cloudapi_sign.svg?style=flat-square)](https://pub.dartlang.org/packages/ali_cloudapi_sign)

阿里云网关签名算法实现

## Getting Started

```
//设置网关的域名
AliSign.gatewayHosts = [];
//设置网关的Appkey
AliSign.gatewayAppkey = "";
//设置网关的Appsecret
AliSign.gatewayAppsecret = "";
//设置网关环境
AliSign.gatewayStage = "PRE"; //PRE TEST

//对访问的地址进行签名，返回签名的头信息
Map<String, dynamic> headers =
        AliSign.creatAliGatewaySign("get", Uri.parse(url), query);

```

如果使用 dio 实现网络请求，可以使用 dio 拦截器[(dio_ali_sign)](https://github.com/csdntm/dio_ali_sign) 实现请求签名 https://github.com/csdntm/dio_ali_sign
