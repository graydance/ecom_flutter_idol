import 'package:idol/models/dashboard.dart';
import 'package:idol/models/models.dart';
import 'package:idol/models/withdraw_info.dart';
import 'package:idol/net/request/base.dart';
import 'package:idol/net/request/withdraw.dart';

/// DashboardState
abstract class DashboardState {}

class DashboardInitial implements DashboardState {
  const DashboardInitial();
}

class DashboardLoading implements DashboardState {}

class DashboardSuccess implements DashboardState {
  final Dashboard dashboard;

  DashboardSuccess(this.dashboard);
}

class DashboardFailure implements DashboardState {
  final String message;

  DashboardFailure(this.message);
}

/// DashboardAction
class DashboardAction {
  final BaseRequest request;

  DashboardAction(this.request);
}

class DashboardFailureAction {
  final String message;

  DashboardFailureAction(this.message);
}

class DashboardSuccessAction {
  final Dashboard dashboard;

  DashboardSuccessAction(this.dashboard);
}

/// WithdrawInfoState
abstract class WithdrawInfoState {}

class WithdrawInfoInitial implements WithdrawInfoState {
  const WithdrawInfoInitial();
}

class WithdrawInfoLoading implements WithdrawInfoState {}

class WithdrawInfoSuccess implements WithdrawInfoState {
  WithdrawInfo withdrawInfo;

  WithdrawInfoSuccess(this.withdrawInfo);
}

class WithdrawInfoFailure implements WithdrawInfoState {
  final String message;

  WithdrawInfoFailure(this.message);
}

/// WithdrawInfoAction
class WithdrawInfoAction {
  final BaseRequest request;

  WithdrawInfoAction(this.request);
}

class WithdrawInfoSuccessAction {
  WithdrawInfo withdrawInfo;

  WithdrawInfoSuccessAction(this.withdrawInfo);
}

class WithdrawInfoFailureAction {
  final String message;

  WithdrawInfoFailureAction(this.message);
}

/// WithdrawState
abstract class WithdrawState {}

class WithdrawInitial implements WithdrawState {
  const WithdrawInitial();
}

class WithdrawLoading implements WithdrawState {}

class WithdrawFailure implements WithdrawState {
  final String message;

  WithdrawFailure(this.message);
}

class WithdrawSuccess implements WithdrawState {}

/// WithdrawAction
class WithdrawAction {
  final WithdrawRequest request;

  WithdrawAction(this.request);
}

class WithdrawFailureAction {
  final String message;

  WithdrawFailureAction(this.message);
}

class WithdrawSuccessAction {}
