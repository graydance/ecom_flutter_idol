import 'package:redux/redux.dart';
import 'package:idol/store/actions/main.dart';
/// validateEmailReducer
final validateEmailReducer = combineReducers<ValidateEmailState>([
  TypedReducer<ValidateEmailState, ValidateEmailAction>(_onValidateEmail),
  TypedReducer<ValidateEmailState, ValidateEmailSuccessAction>(_onValidateEmailSuccess),
  TypedReducer<ValidateEmailState, ValidateEmailFailureAction>(_onValidateEmailFailure),
]);

ValidateEmailLoading _onValidateEmail(ValidateEmailState state, ValidateEmailAction action){
  return ValidateEmailLoading();
}

ValidateEmailSuccess _onValidateEmailSuccess(ValidateEmailState state, ValidateEmailSuccessAction action) {
  return ValidateEmailSuccess(action.validateEmail);
}

ValidateEmailFailure _onValidateEmailFailure(ValidateEmailState state, ValidateEmailFailureAction action){
  return ValidateEmailFailure(action.message);
}

/// signUpReducer
final signUpReducer = combineReducers<SignUpState>([
  TypedReducer<SignUpState, SignUpAction>(_onSignUp),
  TypedReducer<SignUpState, SignUpSuccessAction>(_onSignUpSuccess),
  TypedReducer<SignUpState, SignUpFailureAction>(_onSignUpFailure),
]);

SignUpLoading _onSignUp(SignUpState state, SignUpAction action){
  return SignUpLoading();
}

SignUpSuccess _onSignUpSuccess(SignUpState state, SignUpSuccessAction action) {
  return SignUpSuccess(action.signUpUser);
}

SignUpFailure _onSignUpFailure(SignUpState state, SignUpFailureAction action){
  return SignUpFailure(action.message);
}

/// loginReducer
final signInReducer = combineReducers<SignInState>([
  TypedReducer<SignInState, SignInAction>(_onSignIn),
  TypedReducer<SignInState, SignInSuccessAction>(_onSignInSuccess),
  TypedReducer<SignInState, SignInFailureAction>(_onSignInFailure),
]);

SignInLoading _onSignIn(SignInState state, SignInAction action){
  return SignInLoading();
}

SignInSuccess _onSignInSuccess(SignInState state, SignInSuccessAction action) {
  return SignInSuccess(action.signInUser);
}

SignInFailure _onSignInFailure(SignInState state, SignInFailureAction action){
  return SignInFailure(action.message);
}

final updatePasswordReducer = combineReducers<UpdatePasswordState>([
  TypedReducer<UpdatePasswordState, UpdatePasswordAction>(_onUpdatePassword),
  TypedReducer<UpdatePasswordState, UpdatePasswordSuccessAction>(_onUpdatePasswordSuccess),
  TypedReducer<UpdatePasswordState, UpdatePasswordFailureAction>(_onUpdatePasswordFailure),
]);

UpdatePasswordLoading _onUpdatePassword(UpdatePasswordState state, UpdatePasswordAction action){
  return UpdatePasswordLoading();
}

UpdatePasswordSuccess _onUpdatePasswordSuccess(UpdatePasswordState state, UpdatePasswordSuccessAction action) {
  return UpdatePasswordSuccess();
}

UpdatePasswordFailure _onUpdatePasswordFailure(UpdatePasswordState state, UpdatePasswordFailureAction action){
  return UpdatePasswordFailure(action.message);
}