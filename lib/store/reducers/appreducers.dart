import 'package:idol/models/models.dart';
import 'package:idol/store/actions/actions.dart';
import 'package:idol/store/reducers/reducers.dart';

AppState appReducer(AppState state, action) {
  if (action == LogoutAction) {
    return AppState();
  }
  return AppState(
    goodsDetailPage: goodsDetailPageReducer(state.goodsDetailPage, action),
    validateEmailState: validateEmailReducer(state.validateEmailState, action),
    signUpSignInArguments:
        signUpSignInArgumentsReducer(state.signUpSignInArguments, action),
    signInState: signInReducer(state.signInState, action),
    signUpState: signUpReducer(state.signUpState, action),
    dashboardState: dashboardReducer(state.dashboardState, action),
    withdrawInfoState: withdrawInfoReducer(state.withdrawInfoState, action),
    withdrawState: withdrawReducer(state.withdrawState, action),
    completeRewardsState:
        completeRewardsReducer(state.completeRewardsState, action),
    withdrawVerifyArguments:
        withdrawVerifyArgumentsReducer(state.withdrawVerifyArguments, action),
    withdrawResultArguments:
        withdrawResultArgumentsReducer(state.withdrawResultArguments, action),
    rewardsDetailArguments:
        rewardsDetailArgumentsReducer(state.rewardsDetailArguments, action),
    imageCropArguments:
        imageCropArgumentsReducer(state.imageCropArguments, action),
    followingState: followingReducer(state.followingState, action),
    forYouState: forYouReducer(state.forYouState, action),
    myInfoState: myInfoReducer(state.myInfoState, action),
    editStoreState: editStoreReducer(state.editStoreState, action),
    // myInfoGoodsListState:
    //     userDetailGoodsListReducer(state.myInfoGoodsListState, action),
    myInfoGoodsCategoryListState: userDetailGoodsCategoryListReducer(
        state.myInfoGoodsCategoryListState, action),
    supplierInfoState: supplierInfoReducer(state.supplierInfoState, action),
    supplierDetailArguments:
        supplierDetailArgumentsReducer(state.supplierDetailArguments, action),
    supplierHotGoodsListState:
        supplierHotGoodsListReducer(state.supplierHotGoodsListState, action),
    supplierNewGoodsListState:
        supplierNewGoodsListReducer(state.supplierNewGoodsListState, action),
    goodsDetailState: goodsDetailReducer(state.goodsDetailState, action),
    goodsDetailArguments:
        goodsDetailArgumentsReducer(state.goodsDetailArguments, action),
    bioLinksState: bioLinksReducer(state.bioLinksState, action),
    addBioLinksState: addAddBioLinksReducer(state.addBioLinksState, action),
    editBioLinksState: editBioLinksReducer(state.editBioLinksState, action),
    deleteBioLinksState:
        deleteBioLinksReducer(state.deleteBioLinksState, action),
    updateUserInfoState:
        updateUserInfoReducer(state.updateUserInfoState, action),
    bestSalesState: bestSalesReducer(state.bestSalesState, action),
    salesHistoryState: salesHistoryReducer(state.salesHistoryState, action),
    salesHistoryArguments:
        salesHistoryArgumentsReducer(state.salesHistoryArguments, action),
    updatePasswordState:
        updatePasswordReducer(state.updatePasswordState, action),
    innerWebViewArguments:
        innerWebViewArgumentsReducer(state.innerWebViewArguments, action),
    myStoreGoods: myStoreGoodsReducer(state.myStoreGoods, action),
    goodsCategory: categoryReducer(state.goodsCategory, action),
  );
}
