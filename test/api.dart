import 'dart:io';

import 'package:ali_cloudapi_sign/ali_cloudapi_sign.dart';
import 'package:dio/dio.dart';
import 'package:dio_proxy/dio_proxy.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

class AppException implements Exception {
  final _message;
  final _prefix;

  AppException([this._message, this._prefix]);

  String toString() {
    return "$_prefix$_message";
  }
}

class BadRequestException extends AppException {
  BadRequestException([message]) : super(message, "Invalid Request: ");
}

class Api {
  static Dio getDio() {
    Dio dio = Dio();

    dio.options.contentType = Headers.jsonContentType;

    dio.interceptors.add(PrettyDioLogger(
        requestHeader: true,
        requestBody: true,
        responseBody: true,
        responseHeader: true,
        error: true,
        compact: true,
        maxWidth: 90));

    //设置代理
    bool isRelease = bool.fromEnvironment("dart.vm.product");
    //是否启用代理
    bool isUseProxy = false;
    if (!isRelease && isUseProxy) {
      dio.httpClientAdapter = HttpProxyAdapter();
    }

    return dio;
  }

  Future<Map<String, dynamic>> testDioGet(String url) async {
    Map<String, dynamic> objBody;

    Map<String, String> query = {
      "category": "home",
      "cookieid": "AC64881A-7F49-48DE-B316-B465795E8286"
    };

    Map<String, dynamic> headers = AliSign.creatAliGatewaySign(
        "get", Uri.parse(url),
        queryParameters: query);
    Options options = new Options(
        headers: headers,
        contentType: "application/json; charset=utf-8",
        responseType: ResponseType.json);

    Dio dio = getDio();
    try {
      Response response =
          await dio.get(url, queryParameters: query, options: options);

      objBody = response.data;
    } on DioError catch (e) {
      throw BadRequestException(e.response.data.toString());
    }

    return objBody;
  }

  Future<Map<String, dynamic>> testDioPost(String url) async {
    Map<String, dynamic> objBody;

    Map<String, String> query = {
      "category": "home",
      "cookieid": "AC64881A-7F49-48DE-B316-B465795E8286"
    };

    Map<String, dynamic> headers =
        AliSign.creatAliGatewaySign("POST", Uri.parse(url));

    Options options = new Options(
        headers: headers,
        contentType: "application/json; charset=utf-8",
        responseType: ResponseType.json);

    Dio dio = getDio();
    try {
      Response response = await dio.post(url, data: query, options: options);

      objBody = response.data;
    } on DioError catch (e) {
      throw BadRequestException(e.response.data.toString());
    }
    return objBody;
  }

  Future<Map<String, dynamic>> testUploadDioPost(String url) async {
    Map<String, dynamic> objBody;
    FormData formData = FormData.fromMap({
      "name": "wendux",
      "age": 25,
      "filename": await MultipartFile.fromFile("./pubspec.yaml",
          filename: "pubspec.yaml"),
    });
    Map<String, dynamic> headers =
        AliSign.creatAliGatewaySign("POST", Uri.parse(url), formData: formData);

    Options options =
        new Options(headers: headers, responseType: ResponseType.json);

    Dio dio = getDio();
    try {
      Response response = await dio.post(url, data: formData, options: options);
      objBody = response.data;
    } on DioError catch (e) {
      throw BadRequestException(e.response.data.toString());
    }
    return objBody;
  }
}
