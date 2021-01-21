import 'package:flutter/material.dart';
import 'package:idol/screen/module_dashboard/withdraw_verify.dart';
import 'package:idol/screen/screens.dart';
import 'package:idol/utils/global.dart';

class RouterPath {
  static const String splash = '/splash';
  static const String login = '/login';
  static const String home = '/home';
  static const String dashboard$RewardsDetail = '/dashboard/rewards_detail';
  static const String dashboard$Balance = '/dashboard/balance';
  static const String dashboard$Withdraw = '/dashboard/withdraw';
  static const String dashboard$VerifyPassword = '/dashboard/verify_password';
  static const String dashboard$WithdrawResult = '/dashboard/withdraw_result';
  static const String supply$Search = '/supply/search';
}

class IdolRoute {
  static Map<String, WidgetBuilder> routes() {
    return {
      RouterPath.splash: (context) => SplashScreen(),
      RouterPath.login: (context) => LoginScreen(),
      RouterPath.home: (context) => HomeScreen(),
      RouterPath.dashboard$RewardsDetail: (context) => RewardsDetailScreen(),
      RouterPath.dashboard$Balance: (context) => BalanceScreen(),
      RouterPath.dashboard$Withdraw: (context) => WithdrawScreen(),
      RouterPath.dashboard$VerifyPassword: (context) => VerifyPasswordScreen(),
      RouterPath.dashboard$WithdrawResult: (context) => WithdrawResultScreen(),
    };
  }

  static void pop(BuildContext context) {
    Navigator.of(context).pop();
  }

  static void popAndResult(BuildContext context) {
    Navigator.of(context).pop(-1);
  }

  static Future<Object> start(String routePath) {
    if (routePath == RouterPath.login ||
        routePath == RouterPath.home) {
      return Navigator.of(Global.navigatorKey.currentContext)
          .pushReplacementNamed(routePath);
    } else {
      return Navigator.of(Global.navigatorKey.currentContext)
          .pushNamed(routePath);
    }
  }

  static Future<Object> startSignUpOrSignIn(BuildContext context) {
    return Navigator.of(context)
        .pushReplacementNamed(RouterPath.login);
  }

  static Future<Object> startHome(BuildContext context) {
    return Navigator.of(context).pushReplacementNamed(RouterPath.home);
  }

  static Future<Object> startDashboardRewardsDetail(BuildContext context){
    return Navigator.of(context).pushNamed(RouterPath.dashboard$RewardsDetail);
  }

  static Future<Object> startDashboardBalance(BuildContext context) {
    return Navigator.of(context).pushNamed(RouterPath.dashboard$Balance);
  }

  static Future<Object> startDashboardWithdraw(BuildContext context) {
    return Navigator.of(context).pushNamed(RouterPath.dashboard$Withdraw);
  }

  static Future<Object> startDashboardWithdrawVerifyPassword(
      BuildContext context) {
    return Navigator.of(context).pushNamed(RouterPath.dashboard$VerifyPassword);
  }

  static Future<Object> startDashboardWithdrawResult(BuildContext context) {
    return Navigator.of(context).pushNamed(RouterPath.dashboard$WithdrawResult);
  }

  static Future<Object> startSupplySearch(BuildContext context) {
    return Navigator.of(context).pushNamed(RouterPath.dashboard$WithdrawResult);
  }
}
