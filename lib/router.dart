import 'package:flutter/material.dart';
import 'package:idol/screen/module_dashboard/withdraw_verify.dart';
import 'package:idol/screen/screens.dart';

/// Bind route path and screen.
var routes = {
  RouterPath.splash: (context, {arguments}) => SplashScreen(),
  RouterPath.signUpOrSignIn: (context, {arguments}) => SignUpSignInScreen(),
  RouterPath.home: (context, {arguments}) => HomeScreen(),
  RouterPath.dashboard$Balance: (context, {arguments}) => BalanceScreen(),
  RouterPath.dashboard$Withdraw: (context, {arguments}) => WithdrawScreen(arguments),
  RouterPath.dashboard$VerifyPassword: (context, {arguments}) =>
      VerifyPasswordScreen(arguments),
  RouterPath.dashboard$WithdrawResult: (context, {arguments}) => WithdrawResult(arguments),
};

// ignore: top_level_function_literal_block
var onGenerateRoute = (RouteSettings settings) {
  var pageBuilder = routes[settings.name];
  if (pageBuilder != null) {
    if (settings.arguments != null) {
      return MaterialPageRoute(
          builder: (context) =>
              pageBuilder(context, arguments: settings.arguments));
    } else {
      return MaterialPageRoute(builder: (context) => pageBuilder(context));
    }
  }
  return MaterialPageRoute(builder: (context) => HomeScreen());
};

class RouterPath {
  static const String splash = '/splash';
  static const String signUpOrSignIn = '/signUpOrSignIn';
  static const String home = '/home';
  static const String dashboard$Balance = '/dashboard/balance';
  static const String dashboard$Withdraw = '/dashboard/withdraw';
  static const String dashboard$VerifyPassword = '/dashboard/verifyPassowrd';
  static const String dashboard$WithdrawResult = '/dashboard/withdrawResult';
}

class IdolRoute {
/*  static PageRoute onGenerateRoute(){
      var pageBuilder = routes[settings.name];
      if (pageBuilder != null) {
        if (settings.arguments != null) {
          return MaterialPageRoute(
              builder: (context) =>
                  pageBuilder(context, arguments: settings.arguments));
        } else {
          return MaterialPageRoute(builder: (context) => pageBuilder(context));
        }
      }
      return MaterialPageRoute(
          builder: (context) => HomeScreen(
            onInit: () {
              StoreProvider.of<AppState>(context).dispatch(
                  RequestDashboardDataAction(DashboardRequest('test Params')));
            },
          ));
  }*/

  static void pop(BuildContext context) {
    Navigator.of(context).pop();
  }

  static void popAndResult(BuildContext context) {
    Navigator.of(context).pop(-1);
  }

  static Future<Object> startSignUpOrSignIn(BuildContext context) {
    return Navigator.of(context)
        .pushReplacementNamed(RouterPath.signUpOrSignIn);
  }

  static Future<Object> startHome(BuildContext context) {
    return Navigator.of(context).pushReplacementNamed(RouterPath.home);
  }

  static Future<Object> startDashboardBalance(BuildContext context) {
    return Navigator.of(context).pushNamed(RouterPath.dashboard$Balance);
  }

  static Future<Object> startDashboardWithdraw(BuildContext context, int availableAmount) {
    return Navigator.of(context).pushNamed(RouterPath.dashboard$Withdraw,
        arguments: {"availableAmount":availableAmount});
  }

  static Future<Object> startVerifyPassword(BuildContext context,
      String withdrawTypeId, String account, int amount, String password) {
    var argument = {
      "withdrawTypeId": withdrawTypeId,
      "account": account,
      "amount": amount,
      "password": password
    };
    return Navigator.of(context)
        .pushNamed(RouterPath.dashboard$VerifyPassword, arguments: argument);
  }

  static Future<Object> startDashboardWithdrawResult(
      BuildContext context, int withdrawStatus) {
    return Navigator.of(context).pushNamed(RouterPath.dashboard$WithdrawResult,
        arguments: {"withdrawStatus": withdrawStatus});
  }
}
