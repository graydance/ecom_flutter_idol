import 'package:idol/store/actions.dart';
import 'package:redux/redux.dart';

final cartReducer = combineReducers<int>([
  TypedReducer<int, HotsLoadedAction>(_setCart),
]);

int _setCart(int state, HotsLoadedAction action) {
  return action.cart;
}
