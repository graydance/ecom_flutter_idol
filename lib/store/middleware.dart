import 'package:flutter/material.dart';
import 'package:idol/models/biolinks.dart';
import 'package:idol/models/validate_email.dart';
import 'package:idol/net/api.dart';
import 'package:idol/net/api_path.dart';
import 'package:idol/store/actions/actions.dart';
import 'package:idol/utils/global.dart';
import 'package:redux/redux.dart';
import 'package:idol/models/models.dart';

List<Middleware<AppState>> createStoreMiddleware() {
  return [
    TypedMiddleware<AppState, ValidateEmailAction>(validateEmailMiddleware),
    TypedMiddleware<AppState, SignUpAction>(signUpSignInMiddleware),
    TypedMiddleware<AppState, SignInAction>(signUpSignInMiddleware),
    TypedMiddleware<AppState, DashboardAction>(dashboardMiddleware),
    TypedMiddleware<AppState, WithdrawAction>(withdrawMiddleware),
    TypedMiddleware<AppState, WithdrawInfoAction>(withdrawInfoMiddleware),
    TypedMiddleware<AppState, CompleteRewardsAction>(completeRewardsMiddleware),
    TypedMiddleware<AppState, FollowingAction>(supplyGoodsListMiddleware),
    TypedMiddleware<AppState, ForYouAction>(supplyGoodsListMiddleware),
    TypedMiddleware<AppState, MyInfoAction>(myInfoMiddleware),
    TypedMiddleware<AppState, EditStoreAction>(editStoreMiddleware),
    TypedMiddleware<AppState, MyInfoGoodsListAction>(storeGoodsListMiddleware),
    TypedMiddleware<AppState, MyInfoGoodsCategoryListAction>(
        storeGoodsListMiddleware),
    TypedMiddleware<AppState, SupplierInfoAction>(supplierInfoMiddleware),
    TypedMiddleware<AppState, SupplierHotGoodsListAction>(
        supplierGoodsListMiddleware),
    TypedMiddleware<AppState, SupplierNewGoodsListAction>(
        supplierGoodsListMiddleware),
    TypedMiddleware<AppState, GoodsDetailAction>(goodsDetailMiddleware),
    TypedMiddleware<AppState, BioLinksAction>(bioLinksMiddleware),
    TypedMiddleware<AppState, AddBioLinksAction>(addBioLinksMiddleware),
    TypedMiddleware<AppState, EditBioLinksAction>(editBioLinksMiddleware),
    TypedMiddleware<AppState, DeleteBioLinksAction>(deleteBioLinksMiddleware),
    TypedMiddleware<AppState, UpdateUserInfoAction>(updateUserInfoMiddleware),
    TypedMiddleware<AppState, DeleteGoodsAction>(deleteGoodsMiddleware),
    TypedMiddleware<AppState, BestSalesAction>(bestSalesMiddleware),
    TypedMiddleware<AppState, SalesHistoryAction>(salesHistoryMiddleware),
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

final Middleware<AppState> validateEmailMiddleware =
    (Store<AppState> store, action, NextDispatcher next) {
  if (action is ValidateEmailAction) {
    DioClient.getInstance()
        .post(ApiPath.whiteList, baseRequest: action.request)
        .whenComplete(() => null)
        .then((data) {
      store.dispatch(ValidateEmailSuccessAction(ValidateEmail.fromMap(data)));
    }).catchError((err) {
      print(err.toString());
      store.dispatch(ValidateEmailFailureAction(err.toString()));
    });
    next(action);
  }
};

final Middleware<AppState> signUpSignInMiddleware =
    (Store<AppState> store, action, NextDispatcher next) {
  if (action is SignInAction || action is SignUpAction) {
    DioClient.getInstance()
        .post(ApiPath.login, baseRequest: action.request)
        .whenComplete(() => null)
        .then((data) {
      // save login user data
      Global.saveToken(User.fromMap(data).token);
      Global.saveUserAccount(action.request.email, action.request.password);
      debugPrint(
          'SignUp/SignIn success, write data to sp >>> email:${action.request.email}, '
          'pwd:${action.request.password}, token:${User.fromMap(data).token}');
      // dispatch
      store.dispatch(
          action is SignUpAction
              ? SignUpSuccessAction(User.fromMap(data))
              : SignInSuccessAction(User.fromMap(data)));
    }).catchError((err) {
      print(err.toString());
      store.dispatch(
          action is SignUpAction
              ? SignUpFailureAction(err.toString())
              : SignInFailureAction(err.toString()));
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

final Middleware<AppState> bestSalesMiddleware =
    (Store<AppState> store, action, NextDispatcher next) {
  if (action is BestSalesAction) {
    DioClient.getInstance()
        .post(ApiPath.bestSales, baseRequest: action.request)
        .whenComplete(() => null)
        .then((data) =>
    {store.dispatch(BestSalesSuccessAction(BestSalesList.fromMap(data)))})
        .catchError((err) {
      print(err.toString());
      store.dispatch(BestSalesFailureAction(err.toString()));
    });
    next(action);
  }
};

final Middleware<AppState> salesHistoryMiddleware =
    (Store<AppState> store, action, NextDispatcher next) {
  if (action is SalesHistoryAction) {
    DioClient.getInstance()
        .post(ApiPath.salesHistory, baseRequest: action.request)
        .whenComplete(() => null)
        .then((data) =>
    {store.dispatch(SalesHistorySuccessAction(SalesHistoryList.fromMap(data)))})
        .catchError((err) {
      print(err.toString());
      store.dispatch(SalesHistoryFailureAction(err.toString()));
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

final Middleware<AppState> supplyGoodsListMiddleware =
    (Store<AppState> store, action, NextDispatcher next) {
  if (action is FollowingAction || action is ForYouAction) {
    DioClient.getInstance()
        .post(ApiPath.supplyGoodsList, baseRequest: action.request)
        .whenComplete(() => null)
        .then((data) => {
              store.dispatch(action is FollowingAction
                  ? FollowingSuccessAction(GoodsDetailList.fromMap(data))
                  : ForYouSuccessAction(GoodsDetailList.fromMap(data)))
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

final Middleware<AppState> storeGoodsListMiddleware =
    (Store<AppState> store, action, NextDispatcher next) {
  if (action is MyInfoGoodsListAction ||
      action is MyInfoGoodsCategoryListAction) {
    DioClient.getInstance()
        .post(ApiPath.storeGoodsList, baseRequest: action.request)
        .whenComplete(() => null)
        .then((data) {
      store.dispatch(action is MyInfoGoodsListAction
          ? MyInfoGoodsListSuccessAction(StoreGoodsList.fromMap(data))
          : MyInfoGoodsCategoryListSuccessAction(StoreGoodsList.fromMap(data)));
    }).catchError((err) {
      print(err.toString());
      store.dispatch(action is MyInfoGoodsListAction
          ? MyInfoGoodsListFailureAction(err.toString())
          : MyInfoGoodsCategoryListFailureAction(err.toString()));
    });
    next(action);
  }
};

final Middleware<AppState> supplierInfoMiddleware =
    (Store<AppState> store, action, NextDispatcher next) {
  if (action is SupplierInfoAction) {
    DioClient.getInstance()
        .post(ApiPath.supplierInfo, baseRequest: action.request)
        .whenComplete(() => null)
        .then((data) {
      store.dispatch(SupplierInfoSuccessAction(Supplier.fromMap(data)));
    }).catchError((err) {
      print(err.toString());
      store.dispatch(SupplierInfoFailureAction(err.toString()));
    });
    next(action);
  }
};

final Middleware<AppState> supplierGoodsListMiddleware =
    (Store<AppState> store, action, NextDispatcher next) {
  if (action is SupplierHotGoodsListAction ||
      action is SupplierNewGoodsListAction) {
    DioClient.getInstance()
        .post(ApiPath.supplierGoodsList, baseRequest: action.request)
        .whenComplete(() => null)
        .then((data) => {
              store.dispatch(action is SupplierHotGoodsListAction
                  ? SupplierHotGoodsListSuccessAction(
                      GoodsList.fromMap(data), 0)
                  : SupplierNewGoodsListSuccessAction(
                      GoodsList.fromMap(data), 1))
            })
        .catchError((err) {
      print(err.toString());
      store.dispatch(action is SupplierHotGoodsListAction
          ? SupplierHotGoodsListFailureAction(err.toString())
          : SupplierNewGoodsListFailureAction(err.toString()));
    });
    next(action);
  }
};

//GoodsDetail
final Middleware<AppState> goodsDetailMiddleware =
    (Store<AppState> store, action, NextDispatcher next) {
  if (action is GoodsDetailAction) {
    DioClient.getInstance()
        .post(ApiPath.goodsDetail, baseRequest: action.request)
        .whenComplete(() => null)
        .then((data) {
      store.dispatch(GoodsDetailSuccessAction(GoodsDetail.fromMap(data)));
    }).catchError((err) {
      print(err.toString());
      store.dispatch(GoodsDetailFailureAction(err.toString()));
    });
    next(action);
  }
};

//BioLinks
final Middleware<AppState> bioLinksMiddleware =
    (Store<AppState> store, action, NextDispatcher next) {
  if (action is BioLinksAction) {
    DioClient.getInstance()
        .post(ApiPath.bioLinks, baseRequest: action.request)
        .whenComplete(() => null)
        .then((data) {
      store.dispatch(BioLinksSuccessAction(BioLinks.fromMap(data)));
    }).catchError((err) {
      print(err.toString());
      store.dispatch(BioLinksFailureAction(err.toString()));
    });
    next(action);
  }
};

final Middleware<AppState> addBioLinksMiddleware =
    (Store<AppState> store, action, NextDispatcher next) {
  if (action is AddBioLinksAction) {
    DioClient.getInstance()
        .post(ApiPath.addBioLinks, baseRequest: action.request)
        .whenComplete(() => null)
        .then((data) {
      store.dispatch(AddBioLinksSuccessAction());
    }).catchError((err) {
      print(err.toString());
      store.dispatch(AddBioLinksFailureAction(err.toString()));
    });
    next(action);
  }
};

final Middleware<AppState> editBioLinksMiddleware =
    (Store<AppState> store, action, NextDispatcher next) {
  if (action is EditBioLinksAction) {
    DioClient.getInstance()
        .post(ApiPath.editBioLinks, baseRequest: action.request)
        .whenComplete(() => null)
        .then((data) {
      store.dispatch(EditBioLinksSuccessAction());
    }).catchError((err) {
      print(err.toString());
      store.dispatch(EditBioLinksFailureAction(err.toString()));
    });
    next(action);
  }
};

final Middleware<AppState> deleteBioLinksMiddleware =
    (Store<AppState> store, action, NextDispatcher next) {
  if (action is DeleteBioLinksAction) {
    DioClient.getInstance()
        .post(ApiPath.deleteBioLinks, baseRequest: action.request)
        .whenComplete(() => null)
        .then((data) {
      store.dispatch(DeleteBioLinksSuccessAction());
    }).catchError((err) {
      print(err.toString());
      store.dispatch(DeleteBioLinksFailureAction(err.toString()));
    });
    next(action);
  }
};

final Middleware<AppState> updateUserInfoMiddleware =
    (Store<AppState> store, action, NextDispatcher next) {
  if (action is UpdateUserInfoAction) {
    DioClient.getInstance()
        .post(ApiPath.updateUserInfo, baseRequest: action.request)
        .whenComplete(() => null)
        .then((data) {
      store.dispatch(UpdateUserInfoSuccessAction());
    }).catchError((err) {
      print(err.toString());
      store.dispatch(UpdateUserInfoFailureAction(err.toString()));
    });
    next(action);
  }
};

final Middleware<AppState> deleteGoodsMiddleware =
    (Store<AppState> store, action, NextDispatcher next) {
  if (action is DeleteGoodsAction) {
    DioClient.getInstance()
        .post(ApiPath.deleteGoods, baseRequest: action.request)
        .whenComplete(() => null)
        .then((data) {
      store.dispatch(DeleteGoodsSuccessAction());
    }).catchError((err) {
      print(err.toString());
      store.dispatch(DeleteGoodsFailureAction(err.toString()));
    });
    next(action);
  }
};
