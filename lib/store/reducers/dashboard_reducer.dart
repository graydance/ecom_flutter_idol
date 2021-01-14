import 'package:idol/store/actions/actions_dashboard.dart';
import 'package:redux/redux.dart';

/// DashboardReducer
final dashboardReducer = combineReducers<DashboardState>([
  TypedReducer<DashboardState, DashboardAction>(_onDashboard),
  TypedReducer<DashboardState, DashboardSuccessAction>(_onDashboardSuccess),
  TypedReducer<DashboardState, DashboardFailureAction>(_onDashboardFailure),
]);

DashboardLoading _onDashboard(DashboardState state, DashboardAction action) {
  return DashboardLoading();
}

DashboardSuccess _onDashboardSuccess(
    DashboardState state, DashboardSuccessAction action) {
  return DashboardSuccess(action.dashboard);
}

DashboardFailure _onDashboardFailure(
    DashboardState state, DashboardFailureAction action) {
  return DashboardFailure(action.message);
}

/// WithdrawInfoReducer
final withdrawInfoReducer = combineReducers<WithdrawInfoState>([
  TypedReducer<WithdrawInfoState, WithdrawInfoAction>(_onWithdrawInfo),
  TypedReducer<WithdrawInfoState, WithdrawInfoSuccessAction>(
      _onWithdrawSuccessInfo),
  TypedReducer<WithdrawInfoState, WithdrawInfoFailureAction>(
      _onWithdrawFailureInfo),
]);

WithdrawInfoLoading _onWithdrawInfo(
    WithdrawInfoState state, WithdrawInfoAction action) {
  return WithdrawInfoLoading();
}

WithdrawInfoSuccess _onWithdrawSuccessInfo(
    WithdrawInfoState state, WithdrawInfoSuccessAction action) {
  return WithdrawInfoSuccess(action.withdrawInfo);
}

WithdrawInfoFailure _onWithdrawFailureInfo(
    WithdrawInfoState state, WithdrawInfoFailureAction action) {
  return WithdrawInfoFailure(action.message);
}
