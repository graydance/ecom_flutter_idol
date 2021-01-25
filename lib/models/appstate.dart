import 'package:idol/models/arguments/rewards_detail.dart';
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
    CheckNameState checkStoreNameState,
    CheckNameState checkUserNameState,
    MyInfoGoodsListState myInfoGoodsListState,
    MyInfoGoodsCategoryListState myInfoGoodsCategoryListState,
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
                this.myInfoGoodsCategoryListState))) {
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
          myInfoGoodsCategoryListState == other.myInfoGoodsCategoryListState;

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
      myInfoGoodsCategoryListState.hashCode;
}
