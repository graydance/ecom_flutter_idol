import 'package:idol/models/dashboard.dart';
import 'package:idol/models/models.dart';
import 'package:idol/store/actions/actions.dart';
import 'package:idol/store/actions/actions_main.dart';
import 'package:meta/meta.dart';

@immutable
class AppState {
  final LoginState loginState;
  final DashboardState dashboardState;
  final WithdrawInfoState withdrawInfoState;

  AppState(
      {this.dashboardState = const DashboardInitial(),
      this.loginState = const LoginInitial(),
      this.withdrawInfoState = const WithdrawInfoInitial()});

  AppState copyWith({Dashboard dashboard}) {
    return AppState(
        dashboardState: dashboardState ?? this.dashboardState,
        loginState: loginState ?? this.loginState,
        withdrawInfoState: withdrawInfoState ?? this.withdrawInfoState);
  }

  @override
  int get hashCode =>
      dashboardState.hashCode ^
      loginState.hashCode ^
      withdrawInfoState.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AppState &&
          runtimeType == other.runtimeType &&
          dashboardState == other.dashboardState &&
          loginState == other.loginState &&
          withdrawInfoState == other.withdrawInfoState;

  @override
  String toString() {
    return 'AppState{dashboardResponse:$dashboardState}, loginState:$loginState, withdrawInfoState:$withdrawInfoState';
  }
}
