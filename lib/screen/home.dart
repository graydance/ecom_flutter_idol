import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:idol/models/models.dart';
import 'package:redux/redux.dart';

class HomeScreen extends StatefulWidget {
  final void Function() onInit;
  HomeScreen({this.onInit});
  @override
  State<StatefulWidget> createState() {
    return HomeScreenState();
  }
}

class HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    if (widget.onInit != null) widget.onInit();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, _ViewModel>(
      converter: _ViewModel.fromStore,
      builder: (ctx, model) => CupertinoPageScaffold(
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ...model.loading ? [CircularProgressIndicator()] : [],
              Text('${model.error}')
            ],
          ),
        ),
      ),
    );
  }
}

class _ViewModel {
  final bool loading;
  final String error;
  _ViewModel(this.loading, this.error);
  static _ViewModel fromStore(Store<AppState> store) {
    return _ViewModel(store.state.isLoading, store.state.hotLoadError);
  }
}
