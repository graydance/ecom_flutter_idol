import 'package:idol/models/product.dart';
import 'package:idol/net/request/supply.dart';

/// Following
abstract class FollowingState {}

class FollowingInitial implements FollowingState {
  const FollowingInitial();
}

class FollowingLoading implements FollowingState {}

class FollowingSuccess implements FollowingState {
  final ProductResponse productResponse;

  FollowingSuccess(this.productResponse);
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
  final ProductResponse productResponse;
  FollowingSuccessAction(this.productResponse);
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
  final ProductResponse productResponse;

  ForYouSuccess(this.productResponse);
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
  final ProductResponse productResponse;

  ForYouSuccessAction(this.productResponse);
}

class ForYouFailureAction {
  final String message;

  ForYouFailureAction(this.message);
}
