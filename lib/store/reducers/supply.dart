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
  return FollowingSuccess(action.productResponse);
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
  return ForYouSuccess(action.productResponse);
}

ForYouFailure _onForYouFailure(
    ForYouState state, ForYouFailureAction action) {
  return ForYouFailure(action.message);
}