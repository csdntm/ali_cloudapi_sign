import 'dart:convert';
import 'dart:io';

import 'package:ali_cloudapi_sign/ali_cloudapi_sign.dart';
import 'package:flutter_test/flutter_test.dart';
import 'api.dart';

final String urlGet = "https://app-gw.csdn.net/httpbin/get";
final String urlGetWithParam = "$urlGet?a=1&b=2";
final String urlPost = "https://app-gw.csdn.net/httpbin/post";
final String urlPostWithParam = "$urlPost?a=1&b=2";
void main() {
  AliSign.gatewayStage = "PRE"; //PRE TEST
  AliSign.gatewayAppkey = Platform.environment['gatewayAppkey'];
  AliSign.gatewayAppsecret = Platform.environment['gatewayAppsecret'];
  AliSign.gatewayHosts = Platform.environment['gatewayHosts']?.split(",");

  test('testDioGet', () async {
    Api _api = new Api();

    Map<String, dynamic> ret = await _api.testDioGet(urlGet);
    expect(ret, contains('args'));
  });

  test('testDioGetWithParam', () async {
    Api _api = new Api();

    Map<String, dynamic> ret = await _api.testDioGet(urlGetWithParam);
    expect(ret['args']['a'], equals('1'));
  });

  test('testDioPost', () async {
    Api _api = new Api();
    Map<String, dynamic> ret = await _api.testDioPost(urlPost);
    var data = json.decode(ret['data']);
    expect(data['category'], equals('home'));
  });

  test('testDioPostWithParam', () async {
    Api _api = new Api();
    Map<String, dynamic> ret = await _api.testDioPost(urlPostWithParam);
    var data = json.decode(ret['data']);
    expect(data['category'], equals('home'));
  });
}
