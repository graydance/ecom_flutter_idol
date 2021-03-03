import 'package:idol/models/arguments/arguments.dart';
import 'package:idol/models/arguments/rewards_detail.dart';
import 'package:redux/redux.dart';
import 'package:idol/models/arguments/base.dart';
import 'package:idol/models/models.dart';
import 'package:idol/store/actions/arguments.dart';

/// 当前文件下的所有Reducer用于页面传参，无需经过中间件middleware进行处理。

/// 提现验证密码页面所需参数
final withdrawVerifyArgumentsReducer = combineReducers<Arguments>([
  TypedReducer<Arguments, UpdateArgumentsAction<WithdrawVerifyArguments>>(
      _onUpdateWithdrawVerifyArguments),
]);

WithdrawVerifyArguments _onUpdateWithdrawVerifyArguments(Arguments arguments,
    UpdateArgumentsAction<WithdrawVerifyArguments> action) {
  return action.arguments;
}

/// 提现结果所需参数
final withdrawResultArgumentsReducer = combineReducers<Arguments>([
  TypedReducer<Arguments, UpdateArgumentsAction<WithdrawResultArguments>>(
      _onUpdateWithdrawResultArguments),
]);

WithdrawResultArguments _onUpdateWithdrawResultArguments(Arguments arguments,
    UpdateArgumentsAction<WithdrawResultArguments> action) {
  return action.arguments;
}

/// 任务详情所需参数
final rewardsDetailArgumentsReducer = combineReducers<Arguments>([
  TypedReducer<Arguments, UpdateArgumentsAction<RewardsDetailArguments>>(
      _onUpdateRewardsDetailArguments),
]);

RewardsDetailArguments _onUpdateRewardsDetailArguments(Arguments arguments,
    UpdateArgumentsAction<RewardsDetailArguments> action) {
  return action.arguments;
}

/// 任务详情所需参数
final imageCropArgumentsReducer = combineReducers<Arguments>([
  TypedReducer<Arguments, UpdateArgumentsAction<ImageCropArguments>>(
      _onUpdateImageCropArguments),
]);

ImageCropArguments _onUpdateImageCropArguments(Arguments arguments,
    UpdateArgumentsAction<ImageCropArguments> action) {
  return action.arguments;
}

/// 供应商详情页参数
final supplierDetailArgumentsReducer  = combineReducers<Arguments>([
  TypedReducer<Arguments, UpdateArgumentsAction<SupplierDetailArguments>>(
      _onUpdateSupplierDetailArguments),
]);

SupplierDetailArguments _onUpdateSupplierDetailArguments(Arguments arguments,
    UpdateArgumentsAction<SupplierDetailArguments> action){
  return action.arguments;
}

/// 产品详情所需参数
final goodsDetailArgumentsReducer = combineReducers<Arguments>([
  TypedReducer<Arguments, UpdateArgumentsAction<GoodsDetailArguments>>(
      _onUpdateGoodsDetailArguments),
]);

GoodsDetailArguments _onUpdateGoodsDetailArguments(Arguments arguments,
    UpdateArgumentsAction<GoodsDetailArguments> action){
  return action.arguments;
}

/// 登录注册所需参数
final signUpSignInArgumentsReducer = combineReducers<Arguments>([
  TypedReducer<Arguments, UpdateArgumentsAction<SignUpSignInArguments>>(
      _onUpdateSignUpSignInArguments),
]);
SignUpSignInArguments _onUpdateSignUpSignInArguments(Arguments arguments,
    UpdateArgumentsAction<SignUpSignInArguments> action){
  return action.arguments;
}

/// 查询单日销售历史记录
final salesHistoryArgumentsReducer = combineReducers<Arguments>([
  TypedReducer<Arguments, UpdateArgumentsAction<SalesHistoryArguments>>(
      _onUpdateSalesHistoryArguments),
]);
SalesHistoryArguments _onUpdateSalesHistoryArguments(Arguments arguments,
    UpdateArgumentsAction<SalesHistoryArguments> action){
  return action.arguments;
}

/// InnerWebView 参数
final innerWebViewArgumentsReducer = combineReducers<Arguments>([
  TypedReducer<Arguments, UpdateArgumentsAction<InnerWebViewArguments>>(
      _onInnerWebViewArguments),
]);
InnerWebViewArguments _onInnerWebViewArguments(Arguments arguments,
    UpdateArgumentsAction<InnerWebViewArguments> action){
  return action.arguments;
}