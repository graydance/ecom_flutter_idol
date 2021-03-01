import 'package:flutter/material.dart';
import 'package:idol/models/appstate.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:idol/models/arguments/supplier_detail.dart';
import 'package:idol/screen/module_main/validate_email.dart';
import 'package:idol/store/actions/arguments.dart';
import 'package:idol/models/arguments/arguments.dart';
import 'package:idol/screen/screens.dart';
import 'package:idol/utils/global.dart';

class RouterPath {
  static const String splash = '/splash';
  static const String guide = '/guide';
  static const String validateEmail = '/validate_email';
  static const String signUp = '/sign_up';
  static const String signIn = '/sign_in';
  static const String home = '/home';
  static const String imageCrop = '/image_crop';
  static const String dashboard$RewardsDetail = '/dashboard/rewards_detail';
  static const String dashboard$Balance = '/dashboard/balance';
  static const String dashboard$Withdraw = '/dashboard/withdraw';
  static const String dashboard$VerifyPassword = '/dashboard/verify_password';
  static const String dashboard$WithdrawResult = '/dashboard/withdraw_result';
  static const String dashboard$SalesHistory = '/dashboard/sales_history';
  static const String supply$SupplierDetail = '/supply/supplier_detail';
  static const String goodsDetail = '/goods_detail';
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
      RouterPath.guide: (context) => GuideScreen(),
      RouterPath.validateEmail: (context) => ValidateEmailScreen(),
      RouterPath.signUp: (context) => SignUpScreen(),
      RouterPath.signIn: (context) => SignInScreen(),
      RouterPath.home: (context) => HomeScreen(),
      RouterPath.imageCrop: (context) => ImageCropScreen(),
      RouterPath.dashboard$RewardsDetail: (context) => RewardsDetailScreen(),
      RouterPath.dashboard$Balance: (context) => BalanceScreen(),
      RouterPath.dashboard$Withdraw: (context) => WithdrawScreen(),
      RouterPath.dashboard$VerifyPassword: (context) => VerifyPasswordScreen(),
      RouterPath.dashboard$WithdrawResult: (context) => WithdrawResultScreen(),
      RouterPath.dashboard$SalesHistory: (context) => SalesHistoryScreen(),
      RouterPath.settings: (context) => SettingsScreen(),
      RouterPath.store$EditStore: (context) => EditStoreScreen(),
      RouterPath.supply$SupplierDetail: (context) => SupplierDetailScreen(),
      RouterPath.goodsDetail: (context) => GoodsDetailScreen(),
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
    if (routePath == RouterPath.signIn ||
        routePath == RouterPath.home) {
      return Navigator.of(Global.navigatorKey.currentContext)
          .pushReplacementNamed(routePath);
    } else {
      return Navigator.of(Global.navigatorKey.currentContext)
          .pushNamed(routePath);
    }
  }
  static Future<Object> startGuide(BuildContext context) {
    return Navigator.of(context)
        .pushReplacementNamed(RouterPath.guide);
  }

  static Future<Object> startValidateEmail(BuildContext context) {
    return Navigator.of(context)
        .pushReplacementNamed(RouterPath.validateEmail);
  }

  static Future<Object> startSignUp(BuildContext context, SignUpSignInArguments arguments) {
    StoreProvider.of<AppState>(context).dispatch(UpdateArgumentsAction<SignUpSignInArguments>(arguments));
    return Navigator.of(context)
        .pushReplacementNamed(RouterPath.signUp);
  }

  static Future<Object> startSignIn(BuildContext context, SignUpSignInArguments arguments) {
    StoreProvider.of<AppState>(context).dispatch(UpdateArgumentsAction<SignUpSignInArguments>(arguments));
    return Navigator.of(context)
        .pushReplacementNamed(RouterPath.signIn);
  }

  static Future<Object> startHome(BuildContext context) {
    return Navigator.of(context).pushNamedAndRemoveUntil(RouterPath.home, (Route<dynamic> route) => false);
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

  static Future<Object> startDashboardSalesHistory(BuildContext context, SalesHistoryArguments arguments) {
    StoreProvider.of<AppState>(context).dispatch(
        UpdateArgumentsAction<SalesHistoryArguments>(arguments));
    return Navigator.of(context).pushNamed(RouterPath.dashboard$WithdrawResult);
  }

  static Future<Object> startSupplySupplierDetail(BuildContext context, String supplierId, String supplierName){
    StoreProvider.of<AppState>(context)
        .dispatch(UpdateArgumentsAction<SupplierDetailArguments>(SupplierDetailArguments(supplierId, supplierName)));
    return Navigator.of(context).pushNamed(RouterPath.supply$SupplierDetail);
  }

  static Future<Object> startGoodsDetail(BuildContext context, String supplierId, String goodsId){
    StoreProvider.of<AppState>(context)
        .dispatch(UpdateArgumentsAction<GoodsDetailArguments>(GoodsDetailArguments(supplierId, goodsId)));
    return Navigator.of(context).pushNamed(RouterPath.goodsDetail);
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
