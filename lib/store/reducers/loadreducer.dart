import 'package:idol/store/actions.dart';
import 'package:redux/redux.dart';

final loadingReducer = combineReducers<bool>([
  TypedReducer<bool, HotsLoadedAction>(_setLoaded),
  TypedReducer<bool, HotsNotLoadedAction>(_setLoaded),
]);

bool _setLoaded(bool state, action) {
  return action is HotsLoadedAction;
}
