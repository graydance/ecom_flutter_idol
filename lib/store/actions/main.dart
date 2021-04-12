import 'dart:async';

import 'package:idol/models/models.dart';
import 'package:idol/net/request/signup_signin.dart';

/// SignUpState
abstract class SignUpState {}

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
  final Completer completer;

  SignUpAction(this.request, this.completer);
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
  final String email;
  final String message;

  SignInFailureAction(this.email, this.message);
}

/// ValidateEmailState
abstract class ValidateEmailState {}

class ValidateEmailInitial implements ValidateEmailState {
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
  final String email;
  final ValidateEmail validateEmail;

  ValidateEmailSuccessAction(this.email, this.validateEmail);
}

class ValidateEmailFailureAction {
  final String message;

  ValidateEmailFailureAction(this.message);
}

/// UpdatePasswordState
abstract class UpdatePasswordState {}

class UpdatePasswordInitial implements UpdatePasswordState {
  const UpdatePasswordInitial();
}

class UpdatePasswordLoading implements UpdatePasswordState {}

class UpdatePasswordSuccess implements UpdatePasswordState {}

class UpdatePasswordFailure implements UpdatePasswordState {
  final String message;

  UpdatePasswordFailure(this.message);
}

class UpdatePasswordAction {
  final UpdatePasswordRequest request;
  final Completer completer;

  UpdatePasswordAction(this.request, this.completer);
}

class UpdatePasswordSuccessAction {
  UpdatePasswordSuccessAction();
}

class UpdatePasswordFailureAction {
  final String message;

  UpdatePasswordFailureAction(this.message);
}

class LogoutAction {}

/// ResetPasswordState
abstract class ResetPasswordState {}

class ResetPasswordInitial implements ResetPasswordState {
  const ResetPasswordInitial();
}

class ResetPasswordLoading implements ResetPasswordState {}

class ResetPasswordSuccess implements ResetPasswordState {}

class ResetPasswordFailure implements ResetPasswordState {
  final String message;

  ResetPasswordFailure(this.message);
}

class ResetPasswordAction {
  final ResetPasswordRequest request;
  final Completer completer;

  ResetPasswordAction(this.request, this.completer);
}

class ResetPasswordSuccessAction {
  ResetPasswordSuccessAction();
}

class ResetPasswordFailureAction {
  final String message;

  ResetPasswordFailureAction(this.message);
}
