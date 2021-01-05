import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:idol/app.dart';
import 'package:idol/models/appstate.dart';
import 'package:idol/store/middleware.dart';
import 'package:idol/store/reducers/appreducers.dart';
import 'package:logging/logging.dart';
import 'package:redux/redux.dart';

import 'models/appstate.dart';

final logger = Logger('idol');

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  initLogging();
  initLoading();
  runApp(ReduxApp(
    store: Store<AppState>(
      appReducer,
      initialState: AppState(),
      middleware: createStoreMiddleware(),
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
}

void initLogging() {
  Logger.root.onRecord.listen((LogRecord r) {
    print('${r.time}\t${r.loggerName}\t[${r.level.name}]:\t${r.message}');
  });

  Logger.root.level = Level.FINEST;
}

void initLoading() {
  EasyLoading.instance
    ..indicatorType = EasyLoadingIndicatorType.ring
    ..loadingStyle = EasyLoadingStyle.dark;
}
