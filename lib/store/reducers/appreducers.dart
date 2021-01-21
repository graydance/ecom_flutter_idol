import 'package:idol/models/models.dart';
import 'package:idol/store/reducers/arguments.dart';
import 'package:idol/store/reducers/dashboard.dart';
import 'package:idol/store/reducers/main.dart';
import 'package:idol/store/reducers/supply.dart';

AppState appReducer(AppState state, action) {
  return AppState(
    loginState: loginReducer(state.loginState, action),
    dashboardState: dashboardReducer(state.dashboardState, action),
    withdrawInfoState: withdrawInfoReducer(state.withdrawInfoState, action),
    withdrawState: withdrawReducer(state.withdrawState, action),
    completeRewardsState: completeRewardsReducer(state.completeRewardsState, action),
    withdrawVerifyArguments: withdrawVerifyArgumentsReducer(state.withdrawVerifyArguments, action),
    withdrawResultArguments: withdrawResultArgumentsReducer(state.withdrawResultArguments, action),
    followingState: followingReducer(state.followingState, action),
    forYouState: forYouReducer(state.forYouState, action),
  );
}
