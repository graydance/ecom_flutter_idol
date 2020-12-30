import 'package:idol/models/models.dart';
import 'package:idol/store/reducers/cartreducer.dart';
import 'package:idol/store/reducers/hot_goods_reducer.dart';
import 'package:idol/store/reducers/hot_idols_reducer.dart';
import 'package:idol/store/reducers/hot_load_error_reducer.dart';
import 'package:idol/store/reducers/loadreducer.dart';

AppState appReducer(AppState state, action) {
  return AppState(
    isLoading: loadingReducer(state.isLoading, action),
    hotLoadError: hotLoadErrReducer(state.hotLoadError, action),
    hotIdols: hotIdolsReducer(state.hotIdols, action),
    hotGoods: hotGoodsReducer(state.hotGoods, action),
    cart: cartReducer(state.cart, action),
  );
}
