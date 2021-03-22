import 'package:idol/models/store_goods_list.dart';
import 'package:idol/store/actions/actions.dart';
import 'package:redux/redux.dart';

/// MyInfoReducer
final myInfoReducer = combineReducers<MyInfoState>([
  TypedReducer<MyInfoState, MyInfoAction>(_onMyInfo),
  TypedReducer<MyInfoState, MyInfoSuccessAction>(_onMyInfoSuccess),
  TypedReducer<MyInfoState, MyInfoFailureAction>(_onMyInfoFailure),
]);

MyInfoLoading _onMyInfo(MyInfoState state, MyInfoAction action) {
  return MyInfoLoading();
}

MyInfoSuccess _onMyInfoSuccess(MyInfoState state, MyInfoSuccessAction action) {
  return MyInfoSuccess(action.myInfo);
}

MyInfoFailure _onMyInfoFailure(MyInfoState state, MyInfoFailureAction action) {
  return MyInfoFailure(action.message);
}

// /// MyInfoGoodsListReducer
// final userDetailGoodsListReducer = combineReducers<MyInfoGoodsListState>([
//   TypedReducer<MyInfoGoodsListState, MyInfoGoodsListAction>(_onMyInfoGoodsList),
//   TypedReducer<MyInfoGoodsListState, MyInfoGoodsListSuccessAction>(
//       _onMyInfoGoodsListSuccess),
//   TypedReducer<MyInfoGoodsListState, MyInfoGoodsListFailureAction>(
//       _onMyInfoGoodsListFailure),
//   TypedReducer<MyInfoGoodsListState, DeleteGoodsSuccessAction>((state, action) {
//     state
//     var store = (state as MyInfoGoodsListSuccess).storeGoodsList;
//     return MyInfoGoodsListSuccess(StoreGoodsList(
//         totalPage: store.totalPage,
//         currentPage: store.currentPage,
//         list:
//             store.list.where((goods) => goods.id != action.goodsId).toList()));
//   }),
// ]);

// MyInfoGoodsListLoading _onMyInfoGoodsList(
//     MyInfoGoodsListState state, MyInfoGoodsListAction action) {
//   return MyInfoGoodsListLoading();
// }

// MyInfoGoodsListSuccess _onMyInfoGoodsListSuccess(
//     MyInfoGoodsListState state, MyInfoGoodsListSuccessAction action) {
//   return MyInfoGoodsListSuccess(action.storeGoodsList);
// }

// MyInfoGoodsListFailure _onMyInfoGoodsListFailure(
//     MyInfoGoodsListState state, MyInfoGoodsListFailureAction action) {
//   return MyInfoGoodsListFailure(action.message);
// }

/// MyInfoGoodsCategoryList
final userDetailGoodsCategoryListReducer =
    combineReducers<MyInfoGoodsCategoryListState>([
  TypedReducer<MyInfoGoodsCategoryListState, MyInfoGoodsCategoryListAction>(
      _onMyInfoGoodsCategoryList),
  TypedReducer<MyInfoGoodsCategoryListState,
      MyInfoGoodsCategoryListSuccessAction>(_onMyInfoGoodsCategoryListSuccess),
  TypedReducer<MyInfoGoodsCategoryListState,
      MyInfoGoodsCategoryListFailureAction>(_onMyInfoGoodsCategoryListFailure),
]);

MyInfoGoodsCategoryListLoading _onMyInfoGoodsCategoryList(
    MyInfoGoodsCategoryListState state, MyInfoGoodsCategoryListAction action) {
  return MyInfoGoodsCategoryListLoading();
}

MyInfoGoodsCategoryListSuccess _onMyInfoGoodsCategoryListSuccess(
    MyInfoGoodsCategoryListState state,
    MyInfoGoodsCategoryListSuccessAction action) {
  return MyInfoGoodsCategoryListSuccess(action.storeGoodsList);
}

MyInfoGoodsCategoryListFailure _onMyInfoGoodsCategoryListFailure(
    MyInfoGoodsCategoryListState state,
    MyInfoGoodsCategoryListFailureAction action) {
  return MyInfoGoodsCategoryListFailure(action.message);
}

/// EditStoreReducer
final editStoreReducer = combineReducers<EditStoreState>([
  TypedReducer<EditStoreState, EditStoreAction>(_onEditStore),
  TypedReducer<EditStoreState, EditStoreSuccessAction>(_onEditStoreSuccess),
  TypedReducer<EditStoreState, EditStoreFailureAction>(_onEditStoreFailure),
]);

EditStoreLoading _onEditStore(EditStoreState state, EditStoreAction action) {
  return EditStoreLoading();
}

EditStoreSuccess _onEditStoreSuccess(
    EditStoreState state, EditStoreSuccessAction action) {
  return EditStoreSuccess();
}

EditStoreFailure _onEditStoreFailure(
    EditStoreState state, EditStoreFailureAction action) {
  return EditStoreFailure(action.message);
}

/// UpdateUserInfoReducer
final updateUserInfoReducer = combineReducers<UpdateUserInfoState>([
  TypedReducer<UpdateUserInfoState, UpdateUserInfoAction>(_onUpdateUserInfo),
  TypedReducer<UpdateUserInfoState, UpdateUserInfoSuccessAction>(
      _onUpdateUserInfoSuccess),
  TypedReducer<UpdateUserInfoState, UpdateUserInfoFailureAction>(
      _onUpdateUserInfoFailure),
]);

UpdateUserInfoLoading _onUpdateUserInfo(
    UpdateUserInfoState state, UpdateUserInfoAction action) {
  return UpdateUserInfoLoading();
}

UpdateUserInfoSuccess _onUpdateUserInfoSuccess(
    UpdateUserInfoState state, UpdateUserInfoSuccessAction action) {
  return UpdateUserInfoSuccess();
}

UpdateUserInfoFailure _onUpdateUserInfoFailure(
    UpdateUserInfoState state, UpdateUserInfoFailureAction action) {
  return UpdateUserInfoFailure(action.message);
}

final myStoreGoodsReducer = combineReducers<StoreGoodsList>([
  TypedReducer<StoreGoodsList, OnUpdateMyStoreGoods>(_onUpdateMyStoreGoods),
]);

StoreGoodsList _onUpdateMyStoreGoods(
    StoreGoodsList state, OnUpdateMyStoreGoods action) {
  return action.model;
}
