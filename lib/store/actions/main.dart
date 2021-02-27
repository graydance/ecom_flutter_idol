import 'package:idol/models/models.dart';
import 'package:idol/net/request/signup_signin.dart';

/// SignUpState
abstract class SignUpState{}

class SignUpInitial implements SignUpState {
  const SignUpInitial();
}

class SignUpLoading implements SignUpState {}

class SignUpSuccess implements SignUpState {
  final User signUpUser;

  SignUpSuccess(this.signUpUser);
}

class SignUpFailure implements SignUpState {
  final String message;

  SignUpFailure(this.message);
}

class SignUpAction {
  final SignUpRequest request;

  SignUpAction(this.request);
}

class SignUpSuccessAction {
  final User signUpUser;

  SignUpSuccessAction(this.signUpUser);
}

class SignUpFailureAction {
  final String message;

  SignUpFailureAction(this.message);
}

/// LoginState
abstract class SignInState {}

class SignInInitial implements SignInState {
  const SignInInitial();
}

class SignInLoading implements SignInState {}

class SignInSuccess implements SignInState {
  final User signInUser;

  SignInSuccess(this.signInUser);
}

class SignInFailure implements SignInState {
  final String message;

  SignInFailure(this.message);
}

class SignInAction {
  final SignUpSignInRequest request;

  SignInAction(this.request);
}

class SignInSuccessAction {
  final User signInUser;

  SignInSuccessAction(this.signInUser);
}

class SignInFailureAction {
  final String message;

  SignInFailureAction(this.message);
}

/// ValidateEmailState
abstract class ValidateEmailState{}

class ValidateEmailInitial implements ValidateEmailState{
  const ValidateEmailInitial();
}

class ValidateEmailLoading implements ValidateEmailState {}

class ValidateEmailSuccess implements ValidateEmailState {
  final ValidateEmail validateEmail;

  ValidateEmailSuccess(this.validateEmail);
}

class ValidateEmailFailure implements ValidateEmailState {
  final String message;

  ValidateEmailFailure(this.message);
}

class ValidateEmailAction {
  final ValidateEmailRequest request;

  ValidateEmailAction(this.request);
}

class ValidateEmailSuccessAction {
  final ValidateEmail validateEmail;

  ValidateEmailSuccessAction(this.validateEmail);
}

class ValidateEmailFailureAction {
  final String message;

  ValidateEmailFailureAction(this.message);
}
