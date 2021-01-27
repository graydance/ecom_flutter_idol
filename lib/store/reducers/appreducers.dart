import 'package:idol/models/models.dart';
import 'package:idol/store/reducers/reducers.dart';

AppState appReducer(AppState state, action) {
  return AppState(
    loginState: loginReducer(state.loginState, action),
    dashboardState: dashboardReducer(state.dashboardState, action),
    withdrawInfoState: withdrawInfoReducer(state.withdrawInfoState, action),
    withdrawState: withdrawReducer(state.withdrawState, action),
    completeRewardsState: completeRewardsReducer(state.completeRewardsState, action),
    withdrawVerifyArguments: withdrawVerifyArgumentsReducer(state.withdrawVerifyArguments, action),
    withdrawResultArguments: withdrawResultArgumentsReducer(state.withdrawResultArguments, action),
    rewardsDetailArguments: rewardsDetailArgumentsReducer(state.rewardsDetailArguments, action),
    imageCropArguments: imageCropArgumentsReducer(state.imageCropArguments, action),
    followingState: followingReducer(state.followingState, action),
    forYouState: forYouReducer(state.forYouState, action),
    myInfoState: myInfoReducer(state.myInfoState, action),
    editStoreState: editStoreReducer(state.editStoreState, action),
    myInfoGoodsListState: userDetailGoodsListReducer(state.myInfoGoodsListState, action),
    myInfoGoodsCategoryListState: userDetailGoodsCategoryListReducer(state.myInfoGoodsCategoryListState, action),
  );
}
