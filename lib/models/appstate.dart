import 'package:idol/models/arguments/rewards_detail.dart';
import 'package:idol/models/arguments/supplier_detail.dart';
import 'package:idol/models/models.dart';
import 'package:idol/store/actions/actions.dart';
import 'package:idol/store/actions/main.dart';
import 'package:meta/meta.dart';
import 'arguments/arguments.dart';

@immutable
class AppState {
  final SignUpState signUpState;
  final SignInState signInState;
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
  final BioLinksState bioLinksState;
  final AddBioLinksState addBioLinksState;
  final EditBioLinksState editBioLinksState;
  final DeleteBioLinksState deleteBioLinksState;
  final UpdateUserInfoState updateUserInfoState;
  final DeleteGoodsState deleteGoodsState;
  final ValidateEmailState validateEmailState;
  final SignUpSignInArguments signUpSignInArguments;
  final BestSalesState bestSalesState;
  final SalesHistoryState salesHistoryState;
  final SalesHistoryArguments salesHistoryArguments;
  final HomeTabArguments homeTabArguments;
  final UpdatePasswordState updatePasswordState;
  final InnerWebViewArguments innerWebViewArguments;

  AppState({
    this.signUpState = const SignUpInitial(),
    this.signInState = const SignInInitial(),
    this.dashboardState = const DashboardInitial(),
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
    this.goodsDetailArguments = const GoodsDetailArguments('', ''),
    this.bioLinksState = const BioLinksInitial(),
    this.addBioLinksState = const AddBioLinksInitial(),
    this.editBioLinksState = const EditBioLinksInitial(),
    this.deleteBioLinksState = const DeleteBioLinksInitial(),
    this.updateUserInfoState = const UpdateUserInfoInitial(),
    this.deleteGoodsState = const DeleteGoodsInitial(),
    this.validateEmailState = const ValidateEmailInitial(),
    this.signUpSignInArguments = const SignUpSignInArguments(''),
    this.bestSalesState = const BestSalesInitial(),
    this.salesHistoryState = const SalesHistoryInitial(),
    this.salesHistoryArguments = const SalesHistoryArguments('', ''),
    this.homeTabArguments = const HomeTabArguments(),
    this.updatePasswordState = const UpdatePasswordInitial(),
    this.innerWebViewArguments = const InnerWebViewArguments('', ''),
  });

  AppState copyWith({
    SignUpState signUpState,
    SignInState signInState,
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
    SupplierDetailArguments supplierDetailArguments,
    SupplierInfoState supplierInfoState,
    SupplierHotGoodsListState supplierHotGoodsListState,
    SupplierNewGoodsListState supplierNewGoodsListState,
    GoodsDetailState goodsDetailState,
    GoodsDetailArguments goodsDetailArguments,
    BioLinksState bioLinksState,
    AddBioLinksState addBioLinksState,
    EditBioLinksState editBioLinksState,
    DeleteBioLinksState deleteBioLinksState,
    UpdateUserInfoState updateUserInfoState,
    DeleteGoodsState deleteGoodsState,
    ValidateEmailState validateEmailState,
    SignUpSignInArguments signUpSignInArguments,
    BestSalesState bestSalesState,
    SalesHistoryState salesHistoryState,
    SalesHistoryArguments salesHistoryArguments,
    HomeTabArguments homeTabArguments,
    UpdatePasswordState updatePasswordState,
    InnerWebViewArguments innerWebViewArguments,
  }) {
    if ((signUpState == null || identical(signUpState, this.signUpState)) &&
        (signInState == null || identical(signInState, this.signInState)) &&
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
        (supplierDetailArguments == null ||
            identical(supplierDetailArguments, this.supplierDetailArguments)) &&
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
            identical(goodsDetailArguments, this.goodsDetailArguments)) &&
        (bioLinksState == null ||
            identical(bioLinksState, this.bioLinksState)) &&
        (addBioLinksState == null ||
            identical(addBioLinksState, this.addBioLinksState)) &&
        (editBioLinksState == null ||
            identical(editBioLinksState, this.editBioLinksState)) &&
        (deleteBioLinksState == null ||
            identical(deleteBioLinksState, this.deleteBioLinksState)) &&
        (updateUserInfoState == null ||
            identical(updateUserInfoState, this.updateUserInfoState)) &&
        (deleteGoodsState == null ||
            identical(deleteGoodsState, this.deleteGoodsState)) &&
        (validateEmailState == null ||
            identical(validateEmailState, this.validateEmailState)) &&
        (signUpSignInArguments == null ||
            identical(signUpSignInArguments, this.signUpSignInArguments)) &&
        (bestSalesState == null ||
            identical(bestSalesState, this.bestSalesState)) &&
        (salesHistoryState == null ||
            identical(salesHistoryState, this.salesHistoryState)) &&
        (salesHistoryArguments == null ||
            identical(salesHistoryArguments, this.salesHistoryArguments)) &&
        (homeTabArguments == null ||
            identical(homeTabArguments, this.homeTabArguments)) &&
        (updatePasswordState == null ||
            identical(updatePasswordState, this.updatePasswordState)) &&
        (innerWebViewArguments == null ||
            identical(innerWebViewArguments, this.innerWebViewArguments))) {
      return this;
    }

    return AppState(
      signUpState: signUpState ?? this.signUpState,
      signInState: signInState ?? this.signInState,
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
          supplierDetailArguments ?? this.supplierDetailArguments,
      supplierInfoState: supplierInfoState ?? this.supplierInfoState,
      supplierHotGoodsListState:
          supplierHotGoodsListState ?? this.supplierHotGoodsListState,
      supplierNewGoodsListState:
          supplierNewGoodsListState ?? this.supplierNewGoodsListState,
      goodsDetailState: goodsDetailState ?? this.goodsDetailState,
      goodsDetailArguments: goodsDetailArguments ?? this.goodsDetailArguments,
      bioLinksState: bioLinksState ?? this.bioLinksState,
      addBioLinksState: addBioLinksState ?? this.addBioLinksState,
      editBioLinksState: editBioLinksState ?? this.editBioLinksState,
      deleteBioLinksState: deleteBioLinksState ?? this.deleteBioLinksState,
      updateUserInfoState: updateUserInfoState ?? this.updateUserInfoState,
      deleteGoodsState: deleteGoodsState ?? this.deleteGoodsState,
      validateEmailState: validateEmailState ?? this.validateEmailState,
      signUpSignInArguments:
          signUpSignInArguments ?? this.signUpSignInArguments,
      bestSalesState: bestSalesState ?? this.bestSalesState,
      salesHistoryState: salesHistoryState ?? this.salesHistoryState,
      salesHistoryArguments:
          salesHistoryArguments ?? this.salesHistoryArguments,
      homeTabArguments: homeTabArguments ?? this.homeTabArguments,
      updatePasswordState: updatePasswordState ?? this.updatePasswordState,
      innerWebViewArguments:
          innerWebViewArguments ?? this.innerWebViewArguments,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AppState &&
          runtimeType == other.runtimeType &&
          signUpState == other.signUpState &&
          signInState == other.signInState &&
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
          goodsDetailArguments == other.goodsDetailArguments &&
          bioLinksState == other.bioLinksState &&
          addBioLinksState == other.addBioLinksState &&
          editBioLinksState == other.editBioLinksState &&
          deleteBioLinksState == other.deleteBioLinksState &&
          updateUserInfoState == other.updateUserInfoState &&
          deleteGoodsState == other.deleteGoodsState &&
          validateEmailState == other.validateEmailState &&
          signUpSignInArguments == other.signUpSignInArguments &&
          bestSalesState == other.bestSalesState &&
          salesHistoryState == other.salesHistoryState &&
          salesHistoryArguments == other.salesHistoryArguments &&
          homeTabArguments == other.homeTabArguments &&
          updatePasswordState == other.updatePasswordState &&
          innerWebViewArguments == other.innerWebViewArguments;

  @override
  int get hashCode =>
      signUpState.hashCode ^
      signInState.hashCode ^
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
      goodsDetailArguments.hashCode ^
      bioLinksState.hashCode ^
      addBioLinksState.hashCode ^
      editBioLinksState.hashCode ^
      deleteBioLinksState.hashCode ^
      updateUserInfoState.hashCode ^
      deleteGoodsState.hashCode ^
      validateEmailState.hashCode ^
      signUpSignInArguments.hashCode ^
      bestSalesState.hashCode ^
      salesHistoryState.hashCode ^
      salesHistoryArguments.hashCode ^
      homeTabArguments.hashCode ^
      updatePasswordState.hashCode ^
      innerWebViewArguments.hashCode;
}
