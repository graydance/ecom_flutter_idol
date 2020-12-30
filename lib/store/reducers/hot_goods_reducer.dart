import 'package:idol/models/models.dart';
import 'package:idol/store/actions.dart';
import 'package:redux/redux.dart';

final hotGoodsReducer = combineReducers<List<Goods>>([
  TypedReducer<List<Goods>, HotsLoadedAction>(_setHotGoods),
]);

List<Goods> _setHotGoods(List<Goods> state, HotsLoadedAction action) {
  return List.from(action.hotGoods);
}
