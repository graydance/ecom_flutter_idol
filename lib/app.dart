import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:idol/models/appstate.dart';
import 'package:idol/res/colors.dart';
import 'package:idol/router.dart';
import 'package:idol/utils/keys.dart';
import 'package:redux/redux.dart';

class ReduxApp extends StatelessWidget {
  final Store<AppState> store;

  const ReduxApp({this.store});

  @override
  Widget build(BuildContext context) {
    return StoreProvider<AppState>(
        store: store,
        child: MaterialApp(
          theme: ThemeData(
            primaryColor: Colors.white,
            errorColor: Colours.color_ED3544,
          ),
          initialRoute: RouterPath.splash,
          navigatorKey: Keys.navigatorKey,
          routes: IdolRoute.routes(),
          builder: EasyLoading.init(),
        ));
  }
}
