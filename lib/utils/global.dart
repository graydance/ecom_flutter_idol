import 'package:flustars/flustars.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:idol/models/models.dart';
import 'package:idol/store/actions/actions.dart';
import 'package:idol/utils/keystore.dart';
import 'package:logging/logging.dart';

/// 存储一些全局公共参数或初始化一些配置
class Global {
  static final logger = Logger('idol');

  static final GlobalKey<NavigatorState> navigatorKey =
      new GlobalKey<NavigatorState>();

  static final isRelease = const bool.fromEnvironment('dart.vm.product');

  static Future init() async {
    SpUtil.getInstance();
    _configLogging();
    _configLoading();
  }

  static User getUser(BuildContext context) {
    SignUpState signUpState =
        StoreProvider.of<AppState>(context, listen: false).state?.signUpState;
    SignInState signInState =
        StoreProvider.of<AppState>(context, listen: false).state?.signInState;
    return signUpState is SignUpSuccess
        ? signUpState.signUpUser
        : (signInState as SignInSuccess).signInUser;
  }

  static saveUserAccount(String email, String password) {
    SpUtil.putString(KeyStore.EMAIL, email);
    SpUtil.putString(KeyStore.PASSWORD, password);
  }

  static saveToken(String token){
    Future<bool> success = SpUtil.putString(KeyStore.TOKEN, token);
    print('token cache success > $success > ${SpUtil.getString(KeyStore.TOKEN)}');
  }

  static String get token => SpUtil.getString(KeyStore.TOKEN);

  static void _configLogging() {
    Logger.root.onRecord.listen((LogRecord r) {
      print('${r.time}\t${r.loggerName}\t[${r.level.name}]:\t${r.message}');
    });
    Logger.root.level = Level.FINEST;
    // Add redux middleware log listener.
    logger.onRecord
        .where((event) => event.loggerName == logger.name)
        .listen((loggingMiddlewareRecord) => print(loggingMiddlewareRecord));
  }

  static void _configLoading() {
    EasyLoading.instance
      ..displayDuration = const Duration(milliseconds: 2000)
      ..indicatorType = EasyLoadingIndicatorType.fadingCircle
      ..loadingStyle = EasyLoadingStyle.dark
      ..indicatorSize = 40.0
      ..radius = 5.0
      // ..progressColor = Colors.white
      // ..backgroundColor = Colors.green
      // ..indicatorColor = Colors.white
      // ..textColor = Colors.white
      // ..maskColor = Colors.blue.withOpacity(0.5)
      ..userInteractions = true
      ..dismissOnTap = false;
  }
}
