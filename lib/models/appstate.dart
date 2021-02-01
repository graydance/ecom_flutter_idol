import 'package:idol/models/arguments/rewards_detail.dart';
import 'package:idol/models/arguments/supplier_detail.dart';
import 'package:idol/models/models.dart';
import 'package:idol/store/actions/actions.dart';
import 'package:idol/store/actions/main.dart';
import 'package:meta/meta.dart';
import 'arguments/arguments.dart';

@immutable
class AppState {
  final LoginState loginState;
  final DashboardState dashboardState;
  final WithdrawInfoState withdrawInfoState;
  final WithdrawState withdrawState;
  final CompleteRewardsState completeRewardsState;
  final WithdrawVerifyArguments withdrawVerifyArguments;
  final WithdrawResultArguments withdrawResultArguments;
  final RewardsDetailArguments rewardsDetailArguments;
  final FollowingState followingState;
  final ForYouState forYouState;
  final MyInfoState myInfoState;
  final EditStoreState editStoreState;
  final MyInfoGoodsListState myInfoGoodsListState;
  final MyInfoGoodsCategoryListState myInfoGoodsCategoryListState;
  final ImageCropArguments imageCropArguments;
  final SupplierDetailArguments supplierDetailArguments;
  final SupplierInfoState supplierInfoState;
  final SupplierHotGoodsListState supplierHotGoodsListState;
  final SupplierNewGoodsListState supplierNewGoodsListState;
  final GoodsDetailState goodsDetailState;
  final GoodsDetailArguments goodsDetailArguments;

  AppState({
    this.dashboardState = const DashboardInitial(),
    this.loginState = const LoginInitial(),
    this.withdrawInfoState = const WithdrawInfoInitial(),
    this.withdrawState = const WithdrawInitial(),
    this.completeRewardsState = const CompleteRewardsInitial(),
    this.withdrawVerifyArguments = const WithdrawVerifyArguments(),
    this.withdrawResultArguments = const WithdrawResultArguments(),
    this.rewardsDetailArguments = const RewardsDetailArguments(),
    this.followingState = const FollowingInitial(),
    this.forYouState = const ForYouInitial(),
    this.myInfoState = const MyInfoInitial(),
    this.editStoreState = const EditStoreInitial(),
    this.myInfoGoodsListState = const MyInfoGoodsListInitial(),
    this.myInfoGoodsCategoryListState = const MyInfoGoodsCategoryListInitial(),
    this.imageCropArguments = const ImageCropArguments(''),
    this.supplierDetailArguments = const SupplierDetailArguments('', ''),
    this.supplierInfoState = const SupplierInfoInitial(),
    this.supplierHotGoodsListState = const SupplierHotGoodsListInitial(),
    this.supplierNewGoodsListState = const SupplierNewGoodsListInitial(),
    this.goodsDetailState = const GoodsDetailInitial(),
    this.goodsDetailArguments = const GoodsDetailArguments(''),
  });

  AppState copyWith({
    LoginState loginState,
    DashboardState dashboardState,
    WithdrawInfoState withdrawInfoState,
    WithdrawState withdrawState,
    CompleteRewardsState completeRewardsState,
    WithdrawVerifyArguments withdrawVerifyArguments,
    WithdrawResultArguments withdrawResultArguments,
    RewardsDetailArguments rewardsDetailArguments,
    FollowingState followingState,
    ForYouState forYouState,
    MyInfoState myInfoState,
    EditStoreState editStoreState,
    MyInfoGoodsListState myInfoGoodsListState,
    MyInfoGoodsCategoryListState myInfoGoodsCategoryListState,
    ImageCropArguments imageCropArguments,
    SupplierDetailArguments supplierDetailArgument,
    SupplierInfoState supplierInfoState,
    SupplierHotGoodsListState supplierHotGoodsListState,
    SupplierNewGoodsListState supplierNewGoodsListState,
    GoodsDetailState goodsDetailState,
    GoodsDetailArguments goodsDetailArguments,
  }) {
    if ((loginState == null || identical(loginState, this.loginState)) &&
        (dashboardState == null ||
            identical(dashboardState, this.dashboardState)) &&
        (withdrawInfoState == null ||
            identical(withdrawInfoState, this.withdrawInfoState)) &&
        (withdrawState == null ||
            identical(withdrawState, this.withdrawState)) &&
        (completeRewardsState == null ||
            identical(completeRewardsState, this.completeRewardsState)) &&
        (withdrawVerifyArguments == null ||
            identical(withdrawVerifyArguments, this.withdrawVerifyArguments)) &&
        (withdrawResultArguments == null ||
            identical(withdrawResultArguments, this.withdrawResultArguments)) &&
        (rewardsDetailArguments == null ||
            identical(rewardsDetailArguments, this.rewardsDetailArguments)) &&
        (followingState == null ||
            identical(followingState, this.followingState)) &&
        (forYouState == null || identical(forYouState, this.forYouState)) &&
        (myInfoState == null || identical(myInfoState, this.myInfoState)) &&
        (editStoreState == null ||
            identical(editStoreState, this.editStoreState)) &&
        (myInfoGoodsListState == null ||
            identical(myInfoGoodsListState, this.myInfoGoodsListState)) &&
        (myInfoGoodsCategoryListState == null ||
            identical(myInfoGoodsCategoryListState,
                this.myInfoGoodsCategoryListState)) &&
        (imageCropArguments == null ||
            identical(imageCropArguments, this.imageCropArguments)) &&
        (supplierDetailArgument == null ||
            identical(supplierDetailArgument, this.supplierDetailArguments)) &&
        (supplierInfoState == null ||
            identical(supplierInfoState, this.supplierInfoState)) &&
        (supplierHotGoodsListState == null ||
            identical(
                supplierHotGoodsListState, this.supplierHotGoodsListState)) &&
        (supplierNewGoodsListState == null ||
            identical(
                supplierNewGoodsListState, this.supplierNewGoodsListState)) &&
        (goodsDetailState == null ||
            identical(goodsDetailState, this.goodsDetailState)) &&
        (goodsDetailArguments == null ||
            identical(goodsDetailArguments, this.goodsDetailArguments))) {
      return this;
    }

    return AppState(
      loginState: loginState ?? this.loginState,
      dashboardState: dashboardState ?? this.dashboardState,
      withdrawInfoState: withdrawInfoState ?? this.withdrawInfoState,
      withdrawState: withdrawState ?? this.withdrawState,
      completeRewardsState: completeRewardsState ?? this.completeRewardsState,
      withdrawVerifyArguments:
          withdrawVerifyArguments ?? this.withdrawVerifyArguments,
      withdrawResultArguments:
          withdrawResultArguments ?? this.withdrawResultArguments,
      rewardsDetailArguments:
          rewardsDetailArguments ?? this.rewardsDetailArguments,
      followingState: followingState ?? this.followingState,
      forYouState: forYouState ?? this.forYouState,
      myInfoState: myInfoState ?? this.myInfoState,
      editStoreState: editStoreState ?? this.editStoreState,
      myInfoGoodsListState: myInfoGoodsListState ?? this.myInfoGoodsListState,
      myInfoGoodsCategoryListState:
          myInfoGoodsCategoryListState ?? this.myInfoGoodsCategoryListState,
      imageCropArguments: imageCropArguments ?? this.imageCropArguments,
      supplierDetailArguments:
          supplierDetailArgument ?? this.supplierDetailArguments,
      supplierInfoState: supplierInfoState ?? this.supplierInfoState,
      supplierHotGoodsListState:
          supplierHotGoodsListState ?? this.supplierHotGoodsListState,
      supplierNewGoodsListState:
          supplierNewGoodsListState ?? this.supplierNewGoodsListState,
      goodsDetailState: goodsDetailState ?? this.goodsDetailState,
      goodsDetailArguments: goodsDetailArguments ?? this.goodsDetailArguments,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AppState &&
          runtimeType == other.runtimeType &&
          loginState == other.loginState &&
          dashboardState == other.dashboardState &&
          withdrawInfoState == other.withdrawInfoState &&
          withdrawState == other.withdrawState &&
          completeRewardsState == other.completeRewardsState &&
          withdrawVerifyArguments == other.withdrawVerifyArguments &&
          withdrawResultArguments == other.withdrawResultArguments &&
          rewardsDetailArguments == other.rewardsDetailArguments &&
          followingState == other.followingState &&
          forYouState == other.forYouState &&
          myInfoState == other.myInfoState &&
          editStoreState == other.editStoreState &&
          myInfoGoodsListState == other.myInfoGoodsListState &&
          myInfoGoodsCategoryListState == other.myInfoGoodsCategoryListState &&
          imageCropArguments == other.imageCropArguments &&
          supplierDetailArguments == other.supplierDetailArguments &&
          supplierInfoState == other.supplierInfoState &&
          supplierHotGoodsListState == other.supplierHotGoodsListState &&
          supplierNewGoodsListState == other.supplierNewGoodsListState &&
          goodsDetailState == other.goodsDetailState &&
          goodsDetailArguments == other.goodsDetailArguments;

  @override
  int get hashCode =>
      loginState.hashCode ^
      dashboardState.hashCode ^
      withdrawInfoState.hashCode ^
      withdrawState.hashCode ^
      completeRewardsState.hashCode ^
      withdrawVerifyArguments.hashCode ^
      withdrawResultArguments.hashCode ^
      rewardsDetailArguments.hashCode ^
      followingState.hashCode ^
      forYouState.hashCode ^
      myInfoState.hashCode ^
      editStoreState.hashCode ^
      myInfoGoodsListState.hashCode ^
      myInfoGoodsCategoryListState.hashCode ^
      imageCropArguments.hashCode ^
      supplierDetailArguments.hashCode ^
      supplierInfoState.hashCode ^
      supplierHotGoodsListState.hashCode ^
      supplierNewGoodsListState.hashCode ^
      goodsDetailState.hashCode ^
      goodsDetailArguments.hashCode;
}
