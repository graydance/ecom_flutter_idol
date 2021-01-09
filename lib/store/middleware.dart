import 'package:idol/models/dashboard.dart';
import 'package:idol/net/api.dart';
import 'package:idol/store/actions/actions_dashboard.dart';
import 'package:redux/redux.dart';
import 'package:idol/models/models.dart';

List<Middleware<AppState>> createStoreMiddleware() {
  return [
    TypedMiddleware<AppState, RequestDashboardDataAction>(
        requestDashboardDataMiddleware),
  ];
}

/// 定义Middlware的两种方式
/// class DashboardMiddleware implements MiddlewareClass<AppState>{
///   @override
///   call(Store<AppState> store, action, next) {
///     if (action is RequestDashboardDataAction) {
///       DioClient.getInstance()
///           .dashboard('/dashboard', baseRequest: action.request)
///           .then((data) => {
///         store.dispatch(
///             RequestDashboardDataSuccessAction(Dashboard.fromJson(data)))
///       })
///           .catchError((err) {
///         print(err.toString());
///       });
///       next(action);
///     }
///   }
/// }
final Middleware<AppState> requestDashboardDataMiddleware =
    (Store<AppState> store, action, NextDispatcher next) {
  if (action is RequestDashboardDataAction) {
    DioClient.getInstance()
        .dashboard('/dashboard', baseRequest: action.request)
        .whenComplete(() => null)
        .then((data) => {
              store.dispatch(
                  RequestDashboardDataSuccessAction(Dashboard.fromJson(data)))
            })
        .catchError((err) {
      print(err.toString());
    });
    next(action);
  }
};
