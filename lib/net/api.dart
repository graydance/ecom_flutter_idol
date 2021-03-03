import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:idol/env.dart';
import 'package:idol/net/interceptor.dart';
import 'package:idol/net/request/base.dart';
import 'package:idol/utils/global.dart';

class DioClient {
  static DioClient _instance;
  Dio _dio;
  BaseOptions _options = BaseOptions(
    baseUrl: apiEntry,
    connectTimeout: 30000,
    receiveTimeout: 10000,
    contentType: "application/json; charset=utf-8",
    responseType: ResponseType.json,
    headers: {
      'x-token': '',
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

  Future<Map<String, dynamic>> post(String path,
      {BaseRequest baseRequest}) async {
    try {
      var data = baseRequest.toMap();
      debugPrint('api post body => $data');
      Response rsp = await _dio.post(path, data: data);
      if (rsp.data['code'] == 0) {
        return rsp.data['data'];
      }
      throw rsp.data['msg'];
    } on DioError catch (e) {
      print(e.message);
      throw e.message;
    }
  }

  Future<Map<String, dynamic>> upload(String path, File file,
      {ProgressCallback onSendProgress}) async {
    try {
      _dio.options.headers[Headers.contentLengthHeader] = file.lengthSync();
      FormData formData = FormData.fromMap({
        'file': await MultipartFile.fromFile(file.path),
      });
      Response rsp =
          await _dio.post(path, data: formData, onSendProgress: onSendProgress);
      if (rsp.data['code'] == 0) {
        return rsp.data['data'];
      }
      throw rsp.data['msg'];
    } on DioError catch (e) {
      print(e.message);
      throw e.message;
    }
  }

  Future<String> download(String url, savePath,
      {Function(int, int) progressCallback}) async {
    CancelToken cancelToken = CancelToken();
    try {
      await _dio.download(url, savePath,
          onReceiveProgress: progressCallback, cancelToken: cancelToken);
      return savePath;
    } catch (e) {
      debugPrint(e);
      throw e.message;
    }
  }

  void showDownloadProgress(int received, int total) {
    if (total != -1) {
      debugPrint("File download progress >>> " +
          (received / total * 100).toStringAsFixed(0) +
          "%");
    }
  }
}
