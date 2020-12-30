import 'package:idol/api.dart';
import 'package:idol/store/actions.dart';
import 'package:redux/redux.dart';
import 'package:idol/models/models.dart';

List<Middleware<AppState>> createStoreMiddleware() {
  final loadHots = _createLoadHots();

  return [
    TypedMiddleware<AppState, LoadHotsAction>(loadHots),
  ];
}

Middleware<AppState> _createLoadHots() {
  return (Store<AppState> store, action, NextDispatcher next) {
    api('/hots', {}, '').then(
      (hots) {
        store.dispatch(
            HotsLoadedAction(hots['idols'], hots['goods'], hots['cart']));
      },
    ).catchError((err) => store.dispatch(HotsNotLoadedAction(err.toString())));
    next(action);
  };
}
