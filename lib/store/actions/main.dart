import 'package:idol/models/models.dart';
import 'package:idol/net/request/login.dart';

abstract class LoginState {}

class LoginInitial implements LoginState {
  const LoginInitial();
}

class LoginLoading implements LoginState {}

class LoginSuccess implements LoginState {
  final User loginUser;

  LoginSuccess(this.loginUser);
}

class LoginFailure implements LoginState {
  final String message;

  LoginFailure(this.message);
}

class LoginAction {
  final LoginRequest request;

  LoginAction(this.request);
}

class LoginSuccessAction {
  final User loginUser;

  LoginSuccessAction(this.loginUser);
}

class LoginFailureAction {
  final String message;

  LoginFailureAction(this.message);
}
