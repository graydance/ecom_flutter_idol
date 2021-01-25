import 'package:flutter/material.dart';
import 'package:idol/models/dashboard.dart';
import 'package:idol/models/goods_list.dart';
import 'package:idol/models/supply.dart';
import 'package:idol/models/withdraw_info.dart';
import 'package:idol/net/api.dart';
import 'package:idol/net/api_path.dart';
import 'package:idol/store/actions/actions.dart';
import 'package:idol/store/actions/dashboard.dart';
import 'package:idol/store/actions/main.dart';
import 'package:idol/utils/global.dart';
import 'package:redux/redux.dart';
import 'package:idol/models/models.dart';

List<Middleware<AppState>> createStoreMiddleware() {
  return [
    TypedMiddleware<AppState, LoginAction>(loginMiddleware),
    TypedMiddleware<AppState, DashboardAction>(dashboardMiddleware),
    TypedMiddleware<AppState, WithdrawAction>(withdrawMiddleware),
    TypedMiddleware<AppState, WithdrawInfoAction>(withdrawInfoMiddleware),
    TypedMiddleware<AppState, CompleteRewardsAction>(completeRewardsMiddleware),
    TypedMiddleware<AppState, FollowingAction>(supplyMiddleware),
    TypedMiddleware<AppState, ForYouAction>(supplyMiddleware),
    TypedMiddleware<AppState, MyInfoAction>(myInfoMiddleware),
    TypedMiddleware<AppState, EditStoreAction>(editStoreMiddleware),
    TypedMiddleware<AppState, MyInfoGoodsListAction>(goodsListMiddleware),
    TypedMiddleware<AppState, MyInfoGoodsCategoryListAction>(goodsListMiddleware),
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
        .post(ApiPath.login, baseRequest: action.request)
        .whenComplete(() => null)
        .then((data) {
      // save login user data
      Global.saveUserAccount(action.request.email, action.request.password);
      Global.saveToken(User.fromMap(data).token);
      debugPrint('Login success, write data to sp >>> email:${action.request.email}, '
              'pwd:${action.request.password}, token:${User.fromMap(data).token}');
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
        .post(ApiPath.home, baseRequest: action.request)
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

final Middleware<AppState> withdrawInfoMiddleware =
    (Store<AppState> store, action, NextDispatcher next) {
  if (action is WithdrawInfoAction) {
    DioClient.getInstance()
        .post(ApiPath.withdrawInfo, baseRequest: action.request)
        .whenComplete(() => null)
        .then((data) {
      store.dispatch(WithdrawInfoSuccessAction(WithdrawInfo.fromMap(data)));
    }).catchError((err) {
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
        .post(ApiPath.withdraw, baseRequest: action.request)
        .whenComplete(() => null)
        .then((data) => {store.dispatch(WithdrawSuccessAction())})
        .catchError((err) {
      print(err.toString());
      store.dispatch(WithdrawFailureAction(err.toString()));
    });
    next(action);
  }
};

final Middleware<AppState> completeRewardsMiddleware =
    (Store<AppState> store, action, NextDispatcher next) {
  if (action is CompleteRewardsAction) {
    DioClient.getInstance()
        .post(ApiPath.completeRewards, baseRequest: action.request)
        .whenComplete(() => null)
        .then((data) => {store.dispatch(CompleteRewardsSuccessAction())})
        .catchError((err) {
      print(err.toString());
      store.dispatch(CompleteRewardsFailureAction(err.toString()));
    });
    next(action);
  }
};

final Middleware<AppState> supplyMiddleware =
    (Store<AppState> store, action, NextDispatcher next) {
  if (action is FollowingAction || action is ForYouAction) {
    DioClient.getInstance()
        .post(ApiPath.following, baseRequest: action.request)
        .whenComplete(() => null)
        .then((data) => {
              store.dispatch(action is FollowingAction
                  ? FollowingSuccessAction(Supply.fromMap(data))
                  : ForYouSuccessAction(Supply.fromMap(data)))
            })
        .catchError((err) {
      print(err.toString());
      store.dispatch(action is FollowingAction
          ? FollowingFailureAction(err.toString())
          : ForYouFailureAction(err.toString()));
    });
    next(action);
  }
};

final Middleware<AppState> myInfoMiddleware =
    (Store<AppState> store, action, NextDispatcher next) {
  if (action is MyInfoAction) {
    DioClient.getInstance()
        .post(ApiPath.myInfo, baseRequest: action.request)
        .whenComplete(() => null)
        .then((data) {
      // dispatch
      store.dispatch(MyInfoSuccessAction(User.fromMap(data)));
    }).catchError((err) {
      print(err.toString());
      store.dispatch(MyInfoFailureAction(err.toString()));
    });
    next(action);
  }
};

final Middleware<AppState> editStoreMiddleware =
    (Store<AppState> store, action, NextDispatcher next) {
  if (action is EditStoreAction) {
    DioClient.getInstance()
        .post(ApiPath.editStore, baseRequest: action.request)
        .whenComplete(() => null)
        .then((data) {
      // dispatch
      store.dispatch(EditStoreSuccessAction());
    }).catchError((err) {
      print(err.toString());
      store.dispatch(EditStoreFailureAction(err.toString()));
    });
    next(action);
  }
};

final Middleware<AppState> goodsListMiddleware =
    (Store<AppState> store, action, NextDispatcher next) {
  if (action is MyInfoGoodsListAction || action is MyInfoGoodsCategoryListAction) {
    DioClient.getInstance()
        .post(ApiPath.goodsList, baseRequest: action.request)
        .whenComplete(() => null)
        .then((data) => {
      store.dispatch(action is MyInfoGoodsListAction
          ? MyInfoGoodsListSuccessAction(GoodsList.fromMap(data))
          : MyInfoGoodsCategoryListSuccessAction(GoodsList.fromMap(data)))
    })
        .catchError((err) {
      print(err.toString());
      store.dispatch(action is FollowingAction
          ? MyInfoGoodsListFailureAction(err.toString())
          : MyInfoGoodsCategoryListFailureAction(err.toString()));
    });
    next(action);
  }
};