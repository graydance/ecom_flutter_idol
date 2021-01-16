import 'package:flustars/flustars.dart';
import 'package:idol/models/dashboard.dart';
import 'package:idol/models/withdraw_info.dart';
import 'package:idol/net/api.dart';
import 'package:idol/store/actions/dashboard.dart';
import 'package:idol/store/actions/main.dart';
import 'package:idol/utils/keystore.dart';
import 'package:redux/redux.dart';
import 'package:idol/models/models.dart';

List<Middleware<AppState>> createStoreMiddleware() {
  return [
    TypedMiddleware<AppState, LoginAction>(loginMiddleware),
    TypedMiddleware<AppState, DashboardAction>(dashboardMiddleware),
    TypedMiddleware<AppState, WithdrawAction>(withdrawMiddleware),
    TypedMiddleware<AppState, WithdrawInfoAction>(withdrawInfoMiddleware),
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
///
final Middleware<AppState> loginMiddleware =
    (Store<AppState> store, action, NextDispatcher next) {
  if (action is LoginAction) {
    DioClient.getInstance()
        .post('/user/login', baseRequest: action.request)
        .whenComplete(() => null)
        .then((data) {
      // save login user data
      SpUtil.putString(KeyStore.EMAIL, action.request.email);
      SpUtil.putString(KeyStore.PASSWORD, action.request.password);
      SpUtil.putString(KeyStore.TOKEN, User.fromMap(data).token);
      SpUtil.putString(KeyStore.USER, data.toString());
      // dispatch
      store.dispatch(LoginSuccessAction(User.fromMap(data)));
    }).catchError((err) {
      print(err.toString());
      store.dispatch(LoginFailureAction(err.toString()));
    });
    next(action);
  }
};

final Middleware<AppState> dashboardMiddleware =
    (Store<AppState> store, action, NextDispatcher next) {
  if (action is DashboardAction) {
    DioClient.getInstance()
        .post('/idol/home', baseRequest: action.request)
        .whenComplete(() => null)
        .then((data) =>
            {store.dispatch(DashboardSuccessAction(Dashboard.fromMap(data)))})
        .catchError((err) {
      print(err.toString());
      store.dispatch(DashboardFailureAction(err.toString()));
    });
    next(action);
  }
};

final Middleware<AppState> withdrawInfoMiddleware = (Store<AppState> store, action, NextDispatcher next){
  if(action is WithdrawInfoAction){
    DioClient.getInstance()
        .post('/idol/withdrawInfo', baseRequest: action.request)
        .whenComplete(() => null)
        .then((data){
          store.dispatch(WithdrawInfoSuccessAction(WithdrawInfo.fromMap(data)));
        })
        .catchError((err) {
      print(err.toString());
      store.dispatch(WithdrawInfoFailureAction(err.toString()));
    });
    next(action);
  }
};

final Middleware<AppState> withdrawMiddleware =
    (Store<AppState> store, action, NextDispatcher next) {
  if (action is WithdrawAction) {
    DioClient.getInstance()
        .post('/idol/withdraw', baseRequest: action.request)
        .whenComplete(() => null)
        .then((data) => {store.dispatch(WithdrawSuccessAction())})
        .catchError((err) {
      print(err.toString());
      store.dispatch(WithdrawFailureAction(err.toString()));
    });
    next(action);
  }
};
