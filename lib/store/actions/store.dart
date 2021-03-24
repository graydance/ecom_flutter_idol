import 'dart:async';

import 'package:idol/models/store_goods_list.dart';
import 'package:idol/models/user.dart';
import 'package:idol/net/request/base.dart';
import 'package:idol/net/request/store.dart';

/// MyInfoState
abstract class MyInfoState {}

class MyInfoInitial implements MyInfoState {
  const MyInfoInitial();
}

class MyInfoLoading implements MyInfoState {}

class MyInfoSuccess implements MyInfoState {
  final User myInfo;

  MyInfoSuccess(this.myInfo);
}

class MyInfoFailure implements MyInfoState {
  final String message;

  MyInfoFailure(this.message);
}

/// MyInfoAction
class MyInfoAction {
  final BaseRequest request;

  MyInfoAction(this.request);
}

class MyInfoSuccessAction {
  final User myInfo;

  MyInfoSuccessAction(this.myInfo);
}

class MyInfoFailureAction {
  final String message;

  MyInfoFailureAction(this.message);
}

// /// MyInfoGoodsListState
// abstract class MyInfoGoodsListState {}

// class MyInfoGoodsListInitial implements MyInfoGoodsListState {
//   const MyInfoGoodsListInitial();
// }

// class MyInfoGoodsListLoading implements MyInfoGoodsListState {}

// class MyInfoGoodsListSuccess implements MyInfoGoodsListState {
//   final StoreGoodsList storeGoodsList;

//   MyInfoGoodsListSuccess(this.storeGoodsList);
// }

// class MyInfoGoodsListFailure implements MyInfoGoodsListState {
//   final String message;

//   MyInfoGoodsListFailure(this.message);
// }

/// MyInfoGoodsListAction
class MyInfoGoodsListAction {
  final MyInfoGoodsListRequest request;
  final Completer completer;

  MyInfoGoodsListAction(this.request, this.completer);
}

class OnUpdateMyStoreGoods {
  final StoreGoodsList model;

  OnUpdateMyStoreGoods(this.model);
}

class MyInfoGoodsListSuccessAction {
  final StoreGoodsList storeGoodsList;

  MyInfoGoodsListSuccessAction(this.storeGoodsList);
}

class MyInfoGoodsListFailureAction {
  final String message;

  MyInfoGoodsListFailureAction(this.message);
}

/// MyInfoGoodsListState
abstract class MyInfoGoodsCategoryListState {}

class MyInfoGoodsCategoryListInitial implements MyInfoGoodsCategoryListState {
  const MyInfoGoodsCategoryListInitial();
}

class MyInfoGoodsCategoryListLoading implements MyInfoGoodsCategoryListState {}

class MyInfoGoodsCategoryListSuccess implements MyInfoGoodsCategoryListState {
  final StoreGoodsList storeGoodsList;

  MyInfoGoodsCategoryListSuccess(this.storeGoodsList);
}

class MyInfoGoodsCategoryListFailure implements MyInfoGoodsCategoryListState {
  final String message;

  MyInfoGoodsCategoryListFailure(this.message);
}

/// MyInfoGoodsCategoryListAction
class MyInfoGoodsCategoryListAction {
  final MyInfoGoodsListRequest request;

  MyInfoGoodsCategoryListAction(this.request);
}

class MyInfoGoodsCategoryListSuccessAction {
  final StoreGoodsList storeGoodsList;

  MyInfoGoodsCategoryListSuccessAction(this.storeGoodsList);
}

class MyInfoGoodsCategoryListFailureAction {
  final String message;

  MyInfoGoodsCategoryListFailureAction(this.message);
}

///
abstract class EditStoreState {}

class EditStoreInitial implements EditStoreState {
  const EditStoreInitial();
}

class EditStoreLoading implements EditStoreState {}

class EditStoreSuccess implements EditStoreState {}

class EditStoreFailure implements EditStoreState {
  final String message;

  EditStoreFailure(this.message);
}

/// EditStoreAction
class EditStoreAction {
  final EditStoreRequest request;

  EditStoreAction(this.request);
}

class EditStoreSuccessAction {}

class EditStoreFailureAction {
  final String message;
  EditStoreFailureAction(this.message);
}

///
abstract class CheckNameState {}

class CheckNameInitial implements CheckNameState {
  const CheckNameInitial();
}

class CheckNameLoading implements CheckNameState {}

class CheckNameSuccess implements CheckNameState {}

class CheckNameFailure implements CheckNameState {
  final String message;

  CheckNameFailure(this.message);
}

/// CheckNameAction
class CheckNameAction {
  final CheckNameRequest request;

  CheckNameAction(this.request);
}

class CheckNameSuccessAction {}

class CheckNameFailureAction {
  final String message;
  CheckNameFailureAction(this.message);
}

/// DeleteGoods
abstract class DeleteGoodsState {}

class DeleteGoodsInitial implements DeleteGoodsState {
  const DeleteGoodsInitial();
}

class DeleteGoodsLoading implements DeleteGoodsState {}

class DeleteGoodsSuccess implements DeleteGoodsState {}

class DeleteGoodsFailure implements DeleteGoodsState {
  final String message;

  DeleteGoodsFailure(this.message);
}

/// DeleteGoodsAction
class DeleteGoodsAction {
  final DeleteGoodsRequest request;
  final Completer completer;

  DeleteGoodsAction(this.request, this.completer);
}
