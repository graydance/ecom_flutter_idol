import 'package:idol/store/actions/dashboard.dart';
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
      _onWithdrawInfoSuccess),
  TypedReducer<WithdrawInfoState, WithdrawInfoFailureAction>(
      _onWithdrawInfoFailure),
]);

WithdrawInfoLoading _onWithdrawInfo(
    WithdrawInfoState state, WithdrawInfoAction action) {
  return WithdrawInfoLoading();
}

WithdrawInfoSuccess _onWithdrawInfoSuccess(
    WithdrawInfoState state, WithdrawInfoSuccessAction action) {
  return WithdrawInfoSuccess(action.withdrawInfo);
}

WithdrawInfoFailure _onWithdrawInfoFailure(
    WithdrawInfoState state, WithdrawInfoFailureAction action) {
  return WithdrawInfoFailure(action.message);
}

/// WithdrawReducer
final withdrawReducer = combineReducers<WithdrawState>([
  TypedReducer<WithdrawState, WithdrawAction>(_onWithdraw),
  TypedReducer<WithdrawState, WithdrawSuccessAction>(
      _onWithdrawSuccess),
  TypedReducer<WithdrawState, WithdrawFailureAction>(
      _onWithdrawFailure),
]);

WithdrawLoading _onWithdraw(WithdrawState state, WithdrawAction action){
  return WithdrawLoading();
}

WithdrawSuccess _onWithdrawSuccess(WithdrawState state, WithdrawSuccessAction action){
  return WithdrawSuccess();
}

WithdrawFailure _onWithdrawFailure(WithdrawState state, WithdrawFailureAction action){
  return WithdrawFailure(action.message);
}

/// WithdrawReducer
final completeRewardsReducer = combineReducers<CompleteRewardsState>([
  TypedReducer<CompleteRewardsState, CompleteRewardsAction>(_onCompleteRewards),
  TypedReducer<CompleteRewardsState, CompleteRewardsSuccessAction>(
      _onCompleteRewardsSuccess),
  TypedReducer<CompleteRewardsState, CompleteRewardsFailureAction>(
      _onCompleteRewardsFailure),
]);

CompleteRewardsLoading _onCompleteRewards(CompleteRewardsState state, CompleteRewardsAction action){
  return CompleteRewardsLoading();
}

CompleteRewardsSuccess _onCompleteRewardsSuccess(CompleteRewardsState state, CompleteRewardsSuccessAction action){
  return CompleteRewardsSuccess();
}

CompleteRewardsFailure _onCompleteRewardsFailure(CompleteRewardsState state, CompleteRewardsFailureAction action){
  return CompleteRewardsFailure(action.message);
}