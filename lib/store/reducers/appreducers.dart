import 'package:idol/models/models.dart';
import 'package:idol/store/reducers/dashboard_reducer.dart';
import 'package:idol/store/reducers/main_reducer.dart';

AppState appReducer(AppState state, action) {
  return AppState(
    loginState: loginReducer(state.loginState, action),
    dashboardState: dashboardReducer(state.dashboardState, action),
    withdrawInfoState: withdrawInfoReducer(state.withdrawInfoState, action),
  );
}
