import 'package:idol/store/actions/supply.dart';
import 'package:redux/redux.dart';

/// FollowingReducer
final followingReducer = combineReducers<FollowingState>([
  TypedReducer<FollowingState, FollowingAction>(_onFollowing),
  TypedReducer<FollowingState, FollowingSuccessAction>(_onFollowingSuccess),
  TypedReducer<FollowingState, FollowingFailureAction>(_onFollowingFailure),
]);

FollowingLoading _onFollowing(FollowingState state, FollowingAction action) {
  return FollowingLoading();
}

FollowingSuccess _onFollowingSuccess(
    FollowingState state, FollowingSuccessAction action) {
  return FollowingSuccess(action.goodsDetailList);
}

FollowingFailure _onFollowingFailure(
    FollowingState state, FollowingFailureAction action) {
  return FollowingFailure(action.message);
}

/// For You
final forYouReducer = combineReducers<ForYouState>([
  TypedReducer<ForYouState, ForYouAction>(_onForYou),
  TypedReducer<ForYouState, ForYouSuccessAction>(_onForYouSuccess),
  TypedReducer<ForYouState, ForYouFailureAction>(_onForYouFailure),
]);

ForYouLoading _onForYou(ForYouState state, ForYouAction action) {
  return ForYouLoading();
}

ForYouSuccess _onForYouSuccess(
    ForYouState state, ForYouSuccessAction action) {
  return ForYouSuccess(action.goodsDetailList);
}

ForYouFailure _onForYouFailure(
    ForYouState state, ForYouFailureAction action) {
  return ForYouFailure(action.message);
}

/// SupplierInfoReducer
final supplierInfoReducer = combineReducers<SupplierInfoState>([
  TypedReducer<SupplierInfoState, SupplierInfoAction>(_onSupplierInfo),
  TypedReducer<SupplierInfoState, SupplierInfoSuccessAction>(_onSupplierInfoSuccess),
  TypedReducer<SupplierInfoState, SupplierInfoFailureAction>(_onSupplierInfoFailure),
]);

SupplierInfoLoading _onSupplierInfo(SupplierInfoState state, SupplierInfoAction action) {
  return SupplierInfoLoading();
}

SupplierInfoSuccess _onSupplierInfoSuccess(
    SupplierInfoState state, SupplierInfoSuccessAction action) {
  return SupplierInfoSuccess(action.supplier);
}

SupplierInfoFailure _onSupplierInfoFailure(
    SupplierInfoState state, SupplierInfoFailureAction action) {
  return SupplierInfoFailure(action.message);
}

/// SupplierHotGoodsListReducer
final supplierHotGoodsListReducer = combineReducers<SupplierHotGoodsListState>([
  TypedReducer<SupplierHotGoodsListState, SupplierHotGoodsListAction>(_onSupplierHotGoodsList),
  TypedReducer<SupplierHotGoodsListState, SupplierHotGoodsListSuccessAction>(_onSupplierHotGoodsListSuccess),
  TypedReducer<SupplierHotGoodsListState, SupplierHotGoodsListFailureAction>(_onSupplierHotGoodsListFailure),
]);

SupplierHotGoodsListLoading _onSupplierHotGoodsList(SupplierHotGoodsListState state, SupplierHotGoodsListAction action) {
  return SupplierHotGoodsListLoading();
}

SupplierHotGoodsListSuccess _onSupplierHotGoodsListSuccess(
    SupplierHotGoodsListState state, SupplierHotGoodsListSuccessAction action) {
  return SupplierHotGoodsListSuccess(action.goodsList);
}

SupplierHotGoodsListFailure _onSupplierHotGoodsListFailure(
    SupplierHotGoodsListState state, SupplierHotGoodsListFailureAction action) {
  return SupplierHotGoodsListFailure(action.message);
}


/// SupplierNewGoodsListReducer
final supplierNewGoodsListReducer = combineReducers<SupplierNewGoodsListState>([
  TypedReducer<SupplierNewGoodsListState, SupplierNewGoodsListAction>(_onSupplierNewGoodsList),
  TypedReducer<SupplierNewGoodsListState, SupplierNewGoodsListSuccessAction>(_onSupplierNewGoodsListSuccess),
  TypedReducer<SupplierNewGoodsListState, SupplierNewGoodsListFailureAction>(_onSupplierNewGoodsListFailure),
]);

SupplierNewGoodsListLoading _onSupplierNewGoodsList(SupplierNewGoodsListState state, SupplierNewGoodsListAction action) {
  return SupplierNewGoodsListLoading();
}

SupplierNewGoodsListSuccess _onSupplierNewGoodsListSuccess(
    SupplierNewGoodsListState state, SupplierNewGoodsListSuccessAction action) {
  return SupplierNewGoodsListSuccess(action.goodsList);
}

SupplierNewGoodsListFailure _onSupplierNewGoodsListFailure(
    SupplierNewGoodsListState state, SupplierNewGoodsListFailureAction action) {
  return SupplierNewGoodsListFailure(action.message);
}

/// GoodsDetailReducer
final goodsDetailReducer = combineReducers<GoodsDetailState>([
  TypedReducer<GoodsDetailState, GoodsDetailAction>(_onGoodsDetail),
  TypedReducer<GoodsDetailState, GoodsDetailSuccessAction>(_onGoodsDetailSuccess),
  TypedReducer<GoodsDetailState, GoodsDetailFailureAction>(_onGoodsDetailFailure),
]);

GoodsDetailLoading _onGoodsDetail(GoodsDetailState state, GoodsDetailAction action) {
  return GoodsDetailLoading();
}

GoodsDetailSuccess _onGoodsDetailSuccess(
    GoodsDetailState state, GoodsDetailSuccessAction action) {
  return GoodsDetailSuccess(action.goodsDetail);
}

GoodsDetailFailure _onGoodsDetailFailure(
    GoodsDetailState state, GoodsDetailFailureAction action) {
  return GoodsDetailFailure(action.message);
}