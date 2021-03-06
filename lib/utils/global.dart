import 'dart:io';

import 'package:flustars/flustars.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:idol/conf.dart';
import 'package:idol/models/models.dart';
import 'package:idol/store/actions/actions.dart';
import 'package:idol/utils/keystore.dart';
import 'package:idol/utils/localStorage.dart';
import 'package:idol/widgets/tutorialOverlay.dart';
import 'package:logging/logging.dart';
import 'package:url_launcher/url_launcher.dart';

/// 存储一些全局公共参数或初始化一些配置
class Global {
  static final logger = Logger('idol');

  static final GlobalKey<NavigatorState> navigatorKey =
      new GlobalKey<NavigatorState>();
  static final tokAddAndShare = GlobalKey<TutorialOverlayState>();
  static final tokShopLink = GlobalKey<TutorialOverlayState>();
  static final tokPikAndSell = GlobalKey<TutorialOverlayState>();
  static final tokCopy = GlobalKey<TutorialOverlayState>();
  static final tokGoods = GlobalKey<TutorialOverlayState>();

  static final isRelease = const bool.fromEnvironment('dart.vm.product');
  static final storage = new FlutterSecureStorage();
  static final homePageController = PageController(initialPage: 1);

  static Future init() async {
    await SpUtil.getInstance();
    // Create storage
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

  static User getStateUser(AppState state) {
    SignUpState signUpState = state.signUpState;
    SignInState signInState = state.signInState;
    return signUpState is SignUpSuccess
        ? signUpState.signUpUser
        : (signInState as SignInSuccess).signInUser;
  }

  static void clearAccountInfo() {
    storage.delete(key: KeyStore.TOKEN);
    storage.delete(key: KeyStore.PASSWORD);
  }

  static saveUserAccount(String email, String password) {
    // SpUtil.putString(KeyStore.EMAIL, email);
    // SpUtil.putString(KeyStore.PASSWORD, password);
    storage.write(key: KeyStore.EMAIL, value: email);
    storage.write(key: KeyStore.PASSWORD, value: password);
  }

  static saveToken(String token) async {
    // Write value
    await storage.write(key: KeyStore.TOKEN, value: token);
    //Future<bool> success = SpUtil.putString(KeyStore.TOKEN, token);
    //print('token cache success > $success > ${SpUtil.getString(KeyStore.TOKEN)}');
  }

  static Future<String> getToken() async {
    return await storage.read(key: KeyStore.TOKEN);
  }

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

  static void launchWhatsApp() {
    final uri = Platform.isIOS ? whatsAppUri2 : whatsAppUri;
    launchURL(
        uri, 'Please check whether you have WhatsApp application installed');
  }

  static void launchCustomerService() {
    final uri = customerService;
    launchURL(uri, '');
  }

  static void launchURL(String url, String errorMsg) async =>
      await canLaunch(url) ? launch(url) : EasyLoading.showToast(errorMsg);
}

bool validatePassowrd(String text) {
  if (text == null) return false;
  return RegExp(r"(?=.{8,}).*").hasMatch(text);
}

bool validateUserName(String text) {
  if (text == null) return false;
  return RegExp(r"^[a-z0-9_.]{5,100}$", caseSensitive: false).hasMatch(text);
}
