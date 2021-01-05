import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:idol/models/dashboard.dart';
import 'package:idol/net/api.dart';
import 'package:idol/net/request/base.dart';
import 'package:idol/store/actions/actions_dashboard.dart';
import 'package:redux/redux.dart';
import 'package:idol/models/models.dart';

List<Middleware<AppState>> createStoreMiddleware() {
  return [
    TypedMiddleware<AppState, RequestDashboardDataAction>(
        requestDashboardDataMiddleware),
  ];
}

final Middleware<AppState> requestDashboardDataMiddleware =
    (Store<AppState> store, action, NextDispatcher next) {
  BaseRequest req = (action as RequestDashboardDataAction).request;
  DioClient.getInstance()
      .dashboard('/dashboard', baseRequest: req)
      .then((data) => {
            store.dispatch(
                RequestDashboardDataSuccessAction(Dashboard.fromJson(data)))
          })
      .catchError((err) {
    print(err.toString());
    EasyLoading.showToast(err.toString());
    // store.dispatch(
    //     RequestDashboardDataErrorAction(err is String ? err : '_TypeError'));
  });
  next(action);
};
