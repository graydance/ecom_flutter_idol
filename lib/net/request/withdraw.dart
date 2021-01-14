import 'package:idol/net/request/base.dart';
/// 提现
class WithdrawRequest extends BaseRequest{
  final String withdrawTypeId;
  final String account;
  final int amount;
  final String password;

  WithdrawRequest(this.withdrawTypeId, this.account, this.amount, this.password);

  @override
  Map<String, dynamic> toMap({
    String keyMapper(String key),
  }) {
    keyMapper ??= (key) => key;

// ignore: unnecessary_cast
    return {
      keyMapper('withdrawTypeId'): this.withdrawTypeId,
      keyMapper('account'): this.account,
      keyMapper('amount'): this.amount,
      keyMapper('password'): this.password,
    } as Map<String, dynamic>;
  }
}