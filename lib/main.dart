import 'package:flutter/cupertino.dart';
import 'package:idol/app.dart';
import 'package:idol/models/appstate.dart';
import 'package:idol/store/middleware.dart';
import 'package:idol/store/reducers/appreducers.dart';
import 'package:redux/redux.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(ReduxApp(
    store: Store<AppState>(
      appReducer,
      initialState: AppState.loading(),
      middleware: createStoreMiddleware(),
    ),
  ));
}
