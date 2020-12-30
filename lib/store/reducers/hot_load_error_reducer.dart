import 'package:idol/store/actions.dart';
import 'package:redux/redux.dart';

final hotLoadErrReducer = combineReducers<String>([
  TypedReducer<String, HotsNotLoadedAction>(_setError),
]);

String _setError(String state, HotsNotLoadedAction action) {
  return action.msg;
}
