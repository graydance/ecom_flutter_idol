import 'package:idol/net/request/base.dart';

/// 完成任务领取奖励
class CompleteRewardsRequest extends BaseRequest {
  final String rewardId;

  CompleteRewardsRequest(this.rewardId);

  Map<String, dynamic> toMap({
    String keyMapper(String key),
  }) {
    keyMapper ??= (key) => key;

// ignore: unnecessary_cast
    return {
      keyMapper('rewardId'): this.rewardId,
    } as Map<String, dynamic>;
  }
}

/// 提现
class WithdrawRequest extends BaseRequest {
  final String withdrawTypeId;
  final String account;
  final int amount;
  final String password;

  WithdrawRequest(
      this.withdrawTypeId, this.account, this.amount, this.password);

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

class BestSalesRequest extends BaseRequest{
  final int type;

  BestSalesRequest(this.type);

  Map<String, dynamic> toMap({
    String keyMapper(String key),
  }) {
    keyMapper ??= (key) => key;

    return {
      keyMapper('type'): this.type,
    };
  }
}
class SalesHistoryRequest extends BaseRequest{
  final String date;

  SalesHistoryRequest(this.date);

  Map<String, dynamic> toMap({
    String keyMapper(String key),
  }) {
    keyMapper ??= (key) => key;

    return {
      keyMapper('date'): this.date,
    };
  }
}