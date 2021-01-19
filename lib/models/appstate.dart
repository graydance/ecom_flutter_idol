import 'package:idol/models/models.dart';
import 'package:idol/store/actions/actions.dart';
import 'package:idol/store/actions/main.dart';
import 'package:meta/meta.dart';
import 'arguments/arguments.dart';

@immutable
class AppState {
  final LoginState loginState;
  final DashboardState dashboardState;
  final WithdrawInfoState withdrawInfoState;
  final WithdrawState withdrawState;
  final WithdrawVerifyArguments withdrawVerifyArguments;
  final WithdrawResultArguments withdrawResultArguments;
  final FollowingState followingState;
  final ForYouState forYouState;

  AppState({
    this.dashboardState = const DashboardInitial(),
    this.loginState = const LoginInitial(),
    this.withdrawInfoState = const WithdrawInfoInitial(),
    this.withdrawState = const WithdrawInitial(),
    this.withdrawVerifyArguments = const WithdrawVerifyArguments(),
    this.withdrawResultArguments = const WithdrawResultArguments(),
    this.followingState = const FollowingInitial(),
    this.forYouState = const ForYouInitial(),
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AppState &&
          runtimeType == other.runtimeType &&
          loginState == other.loginState &&
          dashboardState == other.dashboardState &&
          withdrawInfoState == other.withdrawInfoState &&
          withdrawState == other.withdrawState &&
          withdrawVerifyArguments == other.withdrawVerifyArguments &&
          withdrawResultArguments == other.withdrawResultArguments &&
          followingState == other.followingState &&
          forYouState == other.forYouState;

  @override
  int get hashCode =>
      loginState.hashCode ^
      dashboardState.hashCode ^
      withdrawInfoState.hashCode ^
      withdrawState.hashCode ^
      withdrawVerifyArguments.hashCode ^
      withdrawResultArguments.hashCode ^
      followingState.hashCode ^
      forYouState.hashCode;

  AppState copyWith({
    LoginState loginState,
    DashboardState dashboardState,
    WithdrawInfoState withdrawInfoState,
    WithdrawState withdrawState,
    WithdrawVerifyArguments withdrawVerifyArguments,
    WithdrawResultArguments withdrawResultArguments,
    FollowingState supplyState,
    ForYouState forYouState,
  }) {
    if ((loginState == null || identical(loginState, this.loginState)) &&
        (dashboardState == null ||
            identical(dashboardState, this.dashboardState)) &&
        (withdrawInfoState == null ||
            identical(withdrawInfoState, this.withdrawInfoState)) &&
        (withdrawState == null ||
            identical(withdrawState, this.withdrawState)) &&
        (withdrawVerifyArguments == null ||
            identical(withdrawVerifyArguments, this.withdrawVerifyArguments)) &&
        (withdrawResultArguments == null ||
            identical(withdrawResultArguments, this.withdrawResultArguments)) &&
        (supplyState == null || identical(supplyState, this.followingState)) &&
        (forYouState == null || identical(forYouState, this.forYouState))) {
      return this;
    }

    return AppState(
      loginState: loginState ?? this.loginState,
      dashboardState: dashboardState ?? this.dashboardState,
      withdrawInfoState: withdrawInfoState ?? this.withdrawInfoState,
      withdrawState: withdrawState ?? this.withdrawState,
      withdrawVerifyArguments:
          withdrawVerifyArguments ?? this.withdrawVerifyArguments,
      withdrawResultArguments:
          withdrawResultArguments ?? this.withdrawResultArguments,
      followingState: supplyState ?? this.followingState,
      forYouState: forYouState ?? this.forYouState,
    );
  }
}
