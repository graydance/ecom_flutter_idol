import 'package:idol/models/models.dart';
import 'package:idol/store/reducers/dashboard_reducer.dart';

AppState appReducer(AppState state, action) {
  return AppState(
    dashboard: requestDashboardDataSuccessReducer(state.dashboard, action),
  );
}
