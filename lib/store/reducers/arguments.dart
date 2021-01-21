import 'package:idol/models/arguments/arguments.dart';
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
