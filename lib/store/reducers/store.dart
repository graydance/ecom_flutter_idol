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

MyInfoSuccess _onMyInfoSuccess(
    MyInfoState state, MyInfoSuccessAction action) {
  return MyInfoSuccess(action.myInfo);
}

MyInfoFailure _onMyInfoFailure(
    MyInfoState state, MyInfoFailureAction action) {
  return MyInfoFailure(action.message);
}

/// MyInfoGoodsListReducer
final userDetailGoodsListReducer = combineReducers<MyInfoGoodsListState>([
  TypedReducer<MyInfoGoodsListState, MyInfoGoodsListAction>(_onMyInfoGoodsList),
  TypedReducer<MyInfoGoodsListState, MyInfoGoodsListSuccessAction>(_onMyInfoGoodsListSuccess),
  TypedReducer<MyInfoGoodsListState, MyInfoGoodsListFailureAction>(_onMyInfoGoodsListFailure),
]);

MyInfoGoodsListLoading _onMyInfoGoodsList(MyInfoGoodsListState state, MyInfoGoodsListAction action) {
  return MyInfoGoodsListLoading();
}

MyInfoGoodsListSuccess _onMyInfoGoodsListSuccess(
    MyInfoGoodsListState state, MyInfoGoodsListSuccessAction action) {
  return MyInfoGoodsListSuccess(action.goodsList);
}

MyInfoGoodsListFailure _onMyInfoGoodsListFailure(
    MyInfoGoodsListState state, MyInfoGoodsListFailureAction action) {
  return MyInfoGoodsListFailure(action.message);
}

/// MyInfoGoodsCategoryList
final userDetailGoodsCategoryListReducer = combineReducers<MyInfoGoodsCategoryListState>([
  TypedReducer<MyInfoGoodsCategoryListState, MyInfoGoodsCategoryListAction>(_onMyInfoGoodsCategoryList),
  TypedReducer<MyInfoGoodsCategoryListState, MyInfoGoodsCategoryListSuccessAction>(_onMyInfoGoodsCategoryListSuccess),
  TypedReducer<MyInfoGoodsCategoryListState, MyInfoGoodsCategoryListFailureAction>(_onMyInfoGoodsCategoryListFailure),
]);

MyInfoGoodsCategoryListLoading _onMyInfoGoodsCategoryList(MyInfoGoodsCategoryListState state, MyInfoGoodsCategoryListAction action) {
  return MyInfoGoodsCategoryListLoading();
}

MyInfoGoodsCategoryListSuccess _onMyInfoGoodsCategoryListSuccess(
    MyInfoGoodsCategoryListState state, MyInfoGoodsCategoryListSuccessAction action) {
  return MyInfoGoodsCategoryListSuccess(action.goodsList);
}

MyInfoGoodsCategoryListFailure _onMyInfoGoodsCategoryListFailure(
    MyInfoGoodsCategoryListState state, MyInfoGoodsCategoryListFailureAction action) {
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