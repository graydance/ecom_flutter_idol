import 'package:idol/models/supply.dart';
import 'package:idol/net/request/supply.dart';

/// Following
abstract class FollowingState {}

class FollowingInitial implements FollowingState {
  const FollowingInitial();
}

class FollowingLoading implements FollowingState {}

class FollowingSuccess implements FollowingState {
  final Supply supply;

  FollowingSuccess(this.supply);
}

class FollowingFailure implements FollowingState {
  final String message;

  FollowingFailure(this.message);
}

class FollowingAction {
  final FollowingForYouRequest request;

  FollowingAction(this.request);
}

class FollowingSuccessAction {
  final Supply supply;
  FollowingSuccessAction(this.supply);
}

class FollowingFailureAction {
  final String message;

  FollowingFailureAction(this.message);
}

/// For You
abstract class ForYouState {}

class ForYouInitial implements ForYouState {
  const ForYouInitial();
}

class ForYouLoading implements ForYouState {}

class ForYouSuccess implements ForYouState {
  final Supply supply;

  ForYouSuccess(this.supply);
}

class ForYouFailure implements ForYouState {
  final String message;

  ForYouFailure(this.message);
}

class ForYouAction {
  final FollowingForYouRequest request;

  ForYouAction(this.request);
}

class ForYouSuccessAction {
  final Supply supply;

  ForYouSuccessAction(this.supply);
}

class ForYouFailureAction {
  final String message;

  ForYouFailureAction(this.message);
}
