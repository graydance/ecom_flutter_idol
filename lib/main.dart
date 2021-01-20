import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:idol/app.dart';
import 'package:idol/models/appstate.dart';
import 'package:idol/store/middleware.dart';
import 'package:idol/store/reducers/appreducers.dart';
import 'package:idol/utils/global.dart';
import 'package:redux/redux.dart';
import 'package:redux_logging/redux_logging.dart';
import 'models/appstate.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Global.init().whenComplete(() {
    runApp(ReduxApp(
      store: Store<AppState>(
        appReducer,
        initialState: AppState(),
        middleware: [
          ...createStoreMiddleware(),
          LoggingMiddleware(logger: Global.logger)
        ],
      ),
    ));
    if (Platform.isAndroid) {
      SystemUiOverlayStyle systemUiOverlayStyle = SystemUiOverlayStyle(
        systemNavigationBarColor: Colors.transparent,
        systemNavigationBarDividerColor: null,
        statusBarColor: Colors.transparent,
        systemNavigationBarIconBrightness: Brightness.light,
        statusBarIconBrightness: Brightness.dark,
        statusBarBrightness: Brightness.light,
      );
      SystemChrome.setSystemUIOverlayStyle(systemUiOverlayStyle);
    }
  });
}
