import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:idol/net/interceptor.dart';
import 'package:idol/net/request/base.dart';

class DioClient {
  static DioClient _instance;
  static final String _baseUrl =
      'https://www.fastmock.site/mock/1b6bacacb1d24a5476d15e12d54a7093/idol';
  Dio _dio;
  BaseOptions _options = BaseOptions(
    baseUrl: _baseUrl,
    connectTimeout: 5000,
    receiveTimeout: 5000,
    contentType: "application/json; charset=utf-8",
    responseType: ResponseType.json,
    headers: {
      HttpHeaders.userAgentHeader: 'flutter-idol-android',
      'token': '',
      'domain': '',
    },
    extra: {
      'UserAgen': 'Flutter-Android',
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

  Future<Map<String, dynamic>> api(path, data, session) async {
    Response rsp = await _dio.post('$_baseUrl$path',
        data: data, options: Options(headers: {'x-session': session}));
    if (rsp.data['code'] == 0) {
      return rsp.data['data'];
    }
    throw rsp.data['msg'];
  }

  Future<Map<String, dynamic>> dashboard(String path,
      {BaseRequest baseRequest}) async {
    try {
      Response rsp = await _dio.get(path);
      EasyLoading.dismiss();
      if (rsp.data['code'] == 0) {
        return rsp.data['data'];
      }
      throw rsp.data['msg'];
    } on DioError catch (e) {
      print(e.message);
      Fluttertoast.showToast(msg: e.message);
      throw e.message;
    }
  }
}
