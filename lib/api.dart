import 'package:dio/dio.dart';

var version = '';
var entry = 'https://127.0.0.1:10080';
var dio = Dio();

void setApiIO(io) {
  dio = io;
}

Future<Map<String, dynamic>> api(path, data, session) async {
  Response rsp = await dio.post('$entry$path',
      data: data, options: Options(headers: {'x-session': session}));
  if (rsp.data['code'] == 0) {
    return rsp.data['data'];
  }
  throw rsp.data['msg'];
}
