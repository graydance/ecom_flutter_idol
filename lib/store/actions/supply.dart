import 'package:idol/models/goods_detail.dart';
import 'package:idol/models/goods_list.dart';
import 'package:idol/models/models.dart';
import 'package:idol/models/supplier.dart';
import 'package:idol/net/request/supply.dart';

/// Following
abstract class FollowingState {}

class FollowingInitial implements FollowingState {
  const FollowingInitial();
}

class FollowingLoading implements FollowingState {}

class FollowingSuccess implements FollowingState {
  final GoodsDetailList goodsDetailList;

  FollowingSuccess(this.goodsDetailList);
}

class FollowingFailure implements FollowingState {
  final String message;

  FollowingFailure(this.message);
}

class FollowingAction {
  final FollowingForYouRequest request;

  FollowingAction(this.request);
}

class FollowingSuccessAction {
  final GoodsDetailList goodsDetailList;
  FollowingSuccessAction(this.goodsDetailList);
}

class FollowingFailureAction {
  final String message;

  FollowingFailureAction(this.message);
}

/// For You
abstract class ForYouState {}

class ForYouInitial implements ForYouState {
  const ForYouInitial();
}

class ForYouLoading implements ForYouState {}

class ForYouSuccess implements ForYouState {
  final GoodsDetailList goodsDetailList;

  ForYouSuccess(this.goodsDetailList);
}

class ForYouFailure implements ForYouState {
  final String message;

  ForYouFailure(this.message);
}

class ForYouAction {
  final FollowingForYouRequest request;

  ForYouAction(this.request);
}

class ForYouSuccessAction {
  final GoodsDetailList goodsDetailList;

  ForYouSuccessAction(this.goodsDetailList);
}

class ForYouFailureAction {
  final String message;

  ForYouFailureAction(this.message);
}

/// SupplierInfoState
abstract class SupplierInfoState {}

class SupplierInfoInitial implements SupplierInfoState {
  const SupplierInfoInitial();
}

class SupplierInfoLoading implements SupplierInfoState {}

class SupplierInfoSuccess implements SupplierInfoState {
  final Supplier supplier;

  SupplierInfoSuccess(this.supplier);
}

class SupplierInfoFailure implements SupplierInfoState {
  final String message;

  SupplierInfoFailure(this.message);
}

/// SupplierInfoAction
class SupplierInfoAction {
  final SupplierInfoRequest request;

  SupplierInfoAction(this.request);
}

class SupplierInfoSuccessAction {
  final Supplier supplier;

  SupplierInfoSuccessAction(this.supplier);
}

class SupplierInfoFailureAction {
  final String message;

  SupplierInfoFailureAction(this.message);
}

/// SupplierHotGoodsListState
abstract class SupplierHotGoodsListState {}

class SupplierHotGoodsListInitial implements SupplierHotGoodsListState {
  const SupplierHotGoodsListInitial();
}

class SupplierHotGoodsListLoading implements SupplierHotGoodsListState {}

class SupplierHotGoodsListSuccess implements SupplierHotGoodsListState {
  final GoodsList goodsList;

  SupplierHotGoodsListSuccess(this.goodsList);
}

class SupplierHotGoodsListFailure implements SupplierHotGoodsListState {
  final String message;

  SupplierHotGoodsListFailure(this.message);
}

/// SupplierHotGoodsListAction
class SupplierHotGoodsListAction {
  final SupplierGoodsListRequest request;

  SupplierHotGoodsListAction(this.request);
}

class SupplierHotGoodsListSuccessAction {
  final GoodsList goodsList;
  final int type;

  SupplierHotGoodsListSuccessAction(this.goodsList, this.type);
}

class SupplierHotGoodsListFailureAction {
  final String message;

  SupplierHotGoodsListFailureAction(this.message);
}

/// SupplierNewGoodsListState
abstract class SupplierNewGoodsListState {}

class SupplierNewGoodsListInitial implements SupplierNewGoodsListState {
  const SupplierNewGoodsListInitial();
}

class SupplierNewGoodsListLoading implements SupplierNewGoodsListState {}

class SupplierNewGoodsListSuccess implements SupplierNewGoodsListState {
  final GoodsList goodsList;

  SupplierNewGoodsListSuccess(this.goodsList);
}

class SupplierNewGoodsListFailure implements SupplierNewGoodsListState {
  final String message;

  SupplierNewGoodsListFailure(this.message);
}

/// SupplierNewGoodsListAction
class SupplierNewGoodsListAction {
  final SupplierGoodsListRequest request;

  SupplierNewGoodsListAction(this.request);
}

class SupplierNewGoodsListSuccessAction {
  final GoodsList goodsList;
  final int type;

  SupplierNewGoodsListSuccessAction(this.goodsList, this.type);
}

class SupplierNewGoodsListFailureAction {
  final String message;

  SupplierNewGoodsListFailureAction(this.message);
}

/// GoodsDetailState
abstract class GoodsDetailState {}

class GoodsDetailInitial implements GoodsDetailState {
  const GoodsDetailInitial();
}

class GoodsDetailLoading implements GoodsDetailState {}

class GoodsDetailSuccess implements GoodsDetailState {
  final GoodsDetail goodsDetail;

  GoodsDetailSuccess(this.goodsDetail);
}

class GoodsDetailFailure implements GoodsDetailState {
  final String message;

  GoodsDetailFailure(this.message);
}

/// GoodsDetailAction
class GoodsDetailAction {
  final GoodsDetailRequest request;

  GoodsDetailAction(this.request);
}

class GoodsDetailSuccessAction {
  final GoodsDetail goodsDetail;

  GoodsDetailSuccessAction(this.goodsDetail);
}

class GoodsDetailFailureAction {
  final String message;

  GoodsDetailFailureAction(this.message);
}

class AddToStoreAction {
  final GoodsDetail goods;
  AddToStoreAction(this.goods);
}

class AddToStoreActionSuccessAction {
  final GoodsDetail goods;
  AddToStoreActionSuccessAction(this.goods);
}

class AddToStoreActionFailAction {
  final String error;
  AddToStoreActionFailAction(this.error);
}

class ShowGoodsDetailAction {
  final GoodsDetail detail;
  ShowGoodsDetailAction(this.detail);
}
