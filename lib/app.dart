import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:idol/models/appstate.dart';
import 'package:idol/res/colors.dart';
import 'package:idol/screen/screens.dart';
import 'package:idol/store/actions/actions_dashboard.dart';
import 'package:redux/redux.dart';
import 'net/request/dashboard.dart';

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
          initialRoute: '/',
          routes: {
            '/': (context) => HomeScreen(
                  onInit: () {
                    StoreProvider.of<AppState>(context).dispatch(
                        RequestDashboardDataAction(
                            DashboardRequest('test Params')));
                  },
                ),
            '/home': (context) => HomeScreen(
                  onInit: () {
                    StoreProvider.of<AppState>(context).dispatch(
                        RequestDashboardDataAction(
                            DashboardRequest('test Params')));
                  },
                ),
          },
        ));
  }
}
