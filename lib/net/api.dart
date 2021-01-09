import 'dart:io';
import 'package:dio/dio.dart';
import 'package:idol/env.dart';
import 'package:idol/net/interceptor.dart';
import 'package:idol/net/request/base.dart';

class DioClient {
  static DioClient _instance;
  Dio _dio;
  BaseOptions _options = BaseOptions(
    baseUrl: apiEntry,
    connectTimeout: 10000,
    receiveTimeout: 10000,
    contentType: "application/json; charset=utf-8",
    responseType: ResponseType.json,
    headers: {
      HttpHeaders.userAgentHeader: 'flutter-idol-android',
      'token': '',
      'domain': '',
    },
    extra: {
      'UserAgent': 'Flutter-Android',
    },
  );

  DioClient._() {
    _dio = Dio(_options);
    _dio.interceptors.add(TokenInterceptors(_dio));
    _dio.interceptors.add(LogInterceptor(
      request: true,
      requestBody: true,
      requestHeader: true,
      responseHeader: true,
      responseBody: true,
      error: true,
    ));
  }

  factory DioClient.getInstance() => _getInstance();

  static _getInstance() {
    if (_instance == null) {
      _instance = DioClient._();
    }
    return _instance;
  }

  void setApiIO(io) {
    _dio = io;
  }

  Future<Map<String, dynamic>> dashboard(String path,
      {BaseRequest baseRequest}) async {
    try {
      Response rsp = await _dio.get(path);
      if (rsp.data['code'] == 0) {
        return rsp.data['data'];
      }
      throw rsp.data['msg'];
    } on DioError catch (e) {
      print(e.message);
      throw e.message;
    }
  }
}
