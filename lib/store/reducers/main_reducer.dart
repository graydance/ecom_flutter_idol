import 'package:redux/redux.dart';
import 'package:idol/store/actions/actions_main.dart';

final loginReducer = combineReducers<LoginState>([
  TypedReducer<LoginState, LoginAction>(_onLogin),
  TypedReducer<LoginState, LoginSuccessAction>(_onLoginSuccess),
  TypedReducer<LoginState, LoginFailureAction>(_onLoginFailure),
]);

LoginLoading _onLogin(LoginState state, LoginAction action){
  return LoginLoading();
}

LoginSuccess _onLoginSuccess(LoginState state, LoginSuccessAction action) {
  return LoginSuccess(action.loginUser);
}

LoginFailure _onLoginFailure(LoginState state, LoginFailureAction action){
  return LoginFailure(action.message);
}
