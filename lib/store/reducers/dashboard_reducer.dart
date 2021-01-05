import 'package:idol/models/dashboard.dart';
import 'package:idol/store/actions/actions_dashboard.dart';
import 'package:redux/redux.dart';

final requestDashboardDataSuccessReducer = combineReducers<Dashboard>([
  TypedReducer<Dashboard, RequestDashboardDataSuccessAction>(_updateDashboard),
]);

Dashboard _updateDashboard(
    Dashboard dashboard, RequestDashboardDataSuccessAction action) {
  return action.dashboard;
}
