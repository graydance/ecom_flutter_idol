import 'package:flutter/material.dart';

class Keys{
  /// 在拿不到context的地方通过navigatorKey进行路由跳转：
  /// https://stackoverflow.com/questions/52962112/how-to-navigate-without-context-in-flutter-app
  static final GlobalKey<NavigatorState> navigatorKey = new GlobalKey<NavigatorState>();
}