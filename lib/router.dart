import 'package:flutter/material.dart';
import 'package:idol/models/appstate.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:idol/store/actions/arguments.dart';
import 'package:idol/models/arguments/arguments.dart';
import 'package:idol/screen/screens.dart';
import 'package:idol/utils/global.dart';

class RouterPath {
  static const String splash = '/splash';
  static const String login = '/login';
  static const String home = '/home';
  static const String imageCrop = '/image_crop';
  static const String dashboard$RewardsDetail = '/dashboard/rewards_detail';
  static const String dashboard$Balance = '/dashboard/balance';
  static const String dashboard$Withdraw = '/dashboard/withdraw';
  static const String dashboard$VerifyPassword = '/dashboard/verify_password';
  static const String dashboard$WithdrawResult = '/dashboard/withdraw_result';
  static const String supply$Search = '/supply/search';
  static const String settings = '/settings';
  static const String store$EditStore = '/store/edit_store';
}

enum Command{
  pop,
  refreshMyInfo,
}

class IdolRoute {
  static Map<String, WidgetBuilder> routes() {
    return {
      RouterPath.splash: (context) => SplashScreen(),
      RouterPath.login: (context) => LoginScreen(),
      RouterPath.home: (context) => HomeScreen(),
      RouterPath.imageCrop: (context) => ImageCropScreen(),
      RouterPath.dashboard$RewardsDetail: (context) => RewardsDetailScreen(),
      RouterPath.dashboard$Balance: (context) => BalanceScreen(),
      RouterPath.dashboard$Withdraw: (context) => WithdrawScreen(),
      RouterPath.dashboard$VerifyPassword: (context) => VerifyPasswordScreen(),
      RouterPath.dashboard$WithdrawResult: (context) => WithdrawResultScreen(),
      RouterPath.settings: (context) => SettingsScreen(),
      RouterPath.store$EditStore: (context) => EditStoreScreen(),
    };
  }

  static void pop(BuildContext context) {
    Navigator.of(context).pop();
  }

  static void popAndExit(BuildContext context) {
    Navigator.of(context).pop(Command.pop);
  }

  static void popWithCommand(BuildContext context, Command command){
    Navigator.of(context).pop(command);
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

  static Future<Object> startSettings(BuildContext context) {
    return Navigator.of(context).pushReplacementNamed(RouterPath.settings);
  }

  static Future<Object> startDashboardRewardsDetail(BuildContext context, RewardsDetailArguments arguments){
    StoreProvider.of<AppState>(context).dispatch(UpdateArgumentsAction<RewardsDetailArguments>(arguments));
    return Navigator.of(context).pushNamed(RouterPath.dashboard$RewardsDetail);
  }

  static Future<Object> startDashboardBalance(BuildContext context) {
    return Navigator.of(context).pushNamed(RouterPath.dashboard$Balance);
  }

  static Future<Object> startDashboardWithdraw(BuildContext context) {
    return Navigator.of(context).pushNamed(RouterPath.dashboard$Withdraw);
  }

  static Future<Object> startDashboardWithdrawVerifyPassword(
      BuildContext context, WithdrawVerifyArguments arguments) {
    StoreProvider.of<AppState>(context).dispatch(UpdateArgumentsAction<WithdrawVerifyArguments>(arguments));
    return Navigator.of(context).pushNamed(RouterPath.dashboard$VerifyPassword);
  }

  static Future<Object> startDashboardWithdrawResult(BuildContext context, WithdrawResultArguments arguments) {
    StoreProvider.of<AppState>(context).dispatch(
        UpdateArgumentsAction<WithdrawResultArguments>(arguments));
    return Navigator.of(context).pushNamed(RouterPath.dashboard$WithdrawResult);
  }

  static Future<Object> startSupplySearch(BuildContext context) {
    return Navigator.of(context).pushNamed(RouterPath.dashboard$WithdrawResult);
  }
  static Future<Object> startStoreEditStore(BuildContext context) {
    return Navigator.of(context).pushNamed(RouterPath.store$EditStore);
  }

  static Future<Object> startImageCrop(BuildContext context, ImageCropArguments arguments){
    StoreProvider.of<AppState>(context).dispatch(UpdateArgumentsAction<ImageCropArguments>(arguments));
    return Navigator.of(context).pushNamed(RouterPath.imageCrop);
  }
}
