import 'package:dio/dio.dart';
import 'package:idol/main.dart';

class TokenInterceptors extends InterceptorsWrapper {
  final Dio dio;

  TokenInterceptors(this.dio);

  @override
  Future onRequest(RequestOptions options) async {
    logger.fine(
        "TokenInterceptors REQUEST[${options?.method}] => PATH: ${options?.path}");
    // String token = SpUtil.getString('token');
    // 进行token过期处理
    // if (token == null) {
    //   dio.lock();
    //   return DioClient.getInstance().login().then((d){
    //     options.headers['token'] = d.data['data']['token'];
    //     return options;
    //   }).whenComplete(() => dio.unlock());
    // }else{
    //   options.headers['token'] = token;
    // }
    return super.onRequest(options);
  }

  @override
  Future onResponse(Response response) {
    logger.fine(
        "TokenInterceptors RESPONSE[${response?.statusCode}] => PATH: ${response?.request?.path}");
    return super.onResponse(response);
  }

  @override
  Future onError(DioError err) {
    logger.fine(
        "TokenInterceptors ERROR[${err?.response?.statusCode}] => PATH: ${err?.request?.path}");
    return super.onError(err);
  }
}
