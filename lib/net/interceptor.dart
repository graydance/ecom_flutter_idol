import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:idol/net/api_path.dart';
import 'package:idol/router.dart';
import 'package:idol/utils/global.dart';
import 'package:idol/utils/keystore.dart';

class TokenInterceptors extends InterceptorsWrapper {
  final Dio dio;

  TokenInterceptors(this.dio);

  @override
  Future onRequest(RequestOptions options) async {
    Global.logger.fine(
        "TokenInterceptors REQUEST[${options?.method}] => PATH: ${options?.path}");
    // 登录成功后，写入token到headers中
    String token = options.headers['x-token'];
    if (token == null || token.isEmpty) {
      final storage = new FlutterSecureStorage();
      String token = await storage.read(key: KeyStore.TOKEN);
      options.headers['x-token'] = token;
      debugPrint('cacheToken >>> $token');
    }
    if (options.path == ApiPath.upload) {
      options.headers[Headers.contentTypeHeader] = 'multipart/form-data';
    } else {
      options.headers[Headers.contentTypeHeader] =
          'application/json; charset=utf-8';
    }
    return super.onRequest(options);
  }

  @override
  Future onResponse(Response response) {
    Global.logger.fine(
        "TokenInterceptors RESPONSE[${response?.statusCode}] => PATH: ${response?.request?.path}");
    if (response.data['code'] != 0) {
      int code = response.data['code'];
      if (code != null) {
        if (code >= 400 && code < 500) {
          if (code == 402) {
            // Need login.
            IdolRoute.start(RouterPath.signIn);
          }
        } else if (code >= 500) {
          // Unified handling
          response.data['msg'] = 'The network is busy, please try again later!';
        }
      } else {
        debugPrint('Data structure error!');
        throw 'Data structure error!';
      }
    }
    return super.onResponse(response);
  }

  @override
  Future onError(DioError err) {
    Global.logger.fine(
        "TokenInterceptors ERROR[${err?.response?.statusCode}] => PATH: ${err?.request?.path}");
    return super.onError(err);
  }
}
