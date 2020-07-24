library ali_cloudapi_sign;

import 'dart:collection';
import 'dart:convert';
import 'dart:math';
import 'package:crypto/crypto.dart';
import 'package:dio/dio.dart';

/// 阿里网关签名
/// 阿里网关签名算法文档 https://help.aliyun.com/document_detail/29475.html
class AliSign {
  static const String CLOUDAPI_LF = "\n";
  static String gatewayAppkey = "";
  static String gatewayAppsecret = "";
  static List<String> gatewayHosts = [];
  static String gatewayStage = "";

  ///阿里网关签名
  /// [method] GET/POST
  /// [uri] url，可以包含query
  /// [queryParameters] 可选参数，url中的query
//  static Map<String, String> creatAliGatewaySign(String method, Uri uri,
//      [Map<String, String> queryParameters]) {
//    if (gatewayAppkey.isEmpty ||
//        gatewayAppsecret.isEmpty ||
//        gatewayHosts.isEmpty) {
//      throw Exception(
//          "pls specify gatewayAppkey/gatewayAppsecret/gatewayHosts");
//    }
//    var params = Map<String, String>.from(uri.queryParameters);
//    if (null != queryParameters) {
//      params.addAll(queryParameters);
//    }
//
//    params =
//        SplayTreeMap<String, String>.from(params, (a, b) => a.compareTo(b));
//
//    Map<String, String> headerParams = Map<String, String>();
//    headerParams.putIfAbsent("x-ca-key", () => gatewayAppkey);
//    headerParams.putIfAbsent("accept", () => "application/json");
//    if (method.toUpperCase() == "POST") {
//      headerParams.putIfAbsent(
//          "content-type", () => "application/json; charset=utf-8");
//    }
//
//    var time = DateTime.now().millisecondsSinceEpoch;
//    headerParams.putIfAbsent("x-ca-timestamp", () => time.toString());
//    StringBuffer sb = StringBuffer();
//
//    sb.write(method.toUpperCase() + CLOUDAPI_LF);
//    List<String> keys = ["accept", "content-md5", "content-type", "date"];
//    keys.forEach((element) {
//      if (headerParams.containsKey(element)) {
//        sb.write(headerParams[element]);
//      }
//      sb.write(CLOUDAPI_LF);
//    });
//
//    sb.write(("x-ca-key") + (':') + (gatewayAppkey) + (CLOUDAPI_LF));
//    sb.write(("x-ca-timestamp") +
//        (':') +
//        (headerParams["x-ca-timestamp"]) +
//        (CLOUDAPI_LF));
//    sb.write(uri.path);
//
//    if (null != params && params.isNotEmpty) {
//      String queryString =
//          Uri(queryParameters: Map<String, dynamic>.from(params)).query;
//      sb.write("?$queryString");
//    }
//
//    headerParams.putIfAbsent(
//        "x-ca-signature-headers", () => "x-ca-timestamp,x-ca-key");
//    print("aliSign==${sb.toString()}");
//    headerParams = aliSign(sb, headerParams);
//    return headerParams;
//  }

  static Map<String, String> creatAliGatewaySign(String method, Uri uri,
      {Map<String, String> queryParameters, FormData formData}) {
    if (gatewayAppkey.isEmpty ||
        gatewayAppsecret.isEmpty ||
        gatewayHosts.isEmpty) {
      throw Exception(
          "pls specify gatewayAppkey/gatewayAppsecret/gatewayHosts");
    }
    var params = Map<String, String>.from(uri.queryParameters);
    if (null != queryParameters) {
      params.addAll(queryParameters);
    }

    params =
        SplayTreeMap<String, String>.from(params, (a, b) => a.compareTo(b));

    Map<String, String> headerParams = Map<String, String>();
    headerParams.putIfAbsent("x-ca-key", () => gatewayAppkey);
    headerParams.putIfAbsent("accept", () => "application/json");
    if (null != formData) {
      String boundary = formData.boundary;
      boundary = boundary.replaceAll("----", "--");
      headerParams.putIfAbsent(
          "content-type", () => "multipart/form-data; boundary=" + boundary);
    } else if (method.toUpperCase() == "POST") {
      headerParams.putIfAbsent(
          "content-type", () => "application/json; charset=utf-8");
    }

    var time = DateTime.now().millisecondsSinceEpoch;
    headerParams.putIfAbsent("x-ca-timestamp", () => time.toString());
    StringBuffer sb = StringBuffer();

    sb.write(method.toUpperCase() + CLOUDAPI_LF);
    List<String> keys = ["accept", "content-md5", "content-type", "date"];
    keys.forEach((element) {
      if (headerParams.containsKey(element)) {
        sb.write(headerParams[element]);
      }
      sb.write(CLOUDAPI_LF);
    });

    sb.write(("x-ca-key") + (':') + (gatewayAppkey) + (CLOUDAPI_LF));
    sb.write(("x-ca-timestamp") +
        (':') +
        (headerParams["x-ca-timestamp"]) +
        (CLOUDAPI_LF));
    sb.write(uri.path);

    if (null != params && params.isNotEmpty) {
      String queryString =
          Uri(queryParameters: Map<String, dynamic>.from(params)).query;
      sb.write("?$queryString");
    }

    headerParams.putIfAbsent(
        "x-ca-signature-headers", () => "x-ca-timestamp,x-ca-key");
    print("aliSign==${sb.toString()}");
    headerParams = aliSign(sb, headerParams);
    return headerParams;
  }

  static Map<dynamic, dynamic> aliSign(
      StringBuffer string, Map<dynamic, dynamic> headerParams) {
    var key = utf8.encode(gatewayAppsecret);
    var bytes = utf8.encode(string.toString());
    var hmacSha256 = Hmac(sha256, key);
    var digest = hmacSha256.convert(bytes);
    String sign = base64Encode(digest.bytes);
    headerParams.putIfAbsent("x-ca-signature", () => sign);
    //是否正式环境
    if (gatewayStage.isNotEmpty) {
      headerParams.putIfAbsent(
          "X-Ca-Stage", () => gatewayStage.toUpperCase()); // TEST 测试 // PRE 预发布
    }
    return headerParams;
  }
}
