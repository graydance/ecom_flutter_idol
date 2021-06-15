import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:idol/res/colors.dart';
import 'package:idol/res/theme.dart';
import 'package:idol/router.dart';
import 'package:idol/store/actions/actions.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:redux/redux.dart';

import 'package:idol/models/models.dart';

class GoodsCategoryScreen extends StatefulWidget {
  GoodsCategoryScreen({Key key}) : super(key: key);

  @override
  _GoodsCategoryScreenState createState() => _GoodsCategoryScreenState();
}

class _GoodsCategoryScreenState extends State<GoodsCategoryScreen> {
  final _controller = RefreshController(initialRefresh: true);

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, _ViewModel>(
        converter: _ViewModel.fromStore,
        builder: (context, vm) {
          return Scaffold(
            backgroundColor: Colors.white,
            appBar: AppBar(
              title: Text(
                'All Categories',
                style: TextStyle(
                  fontSize: 20,
                  color: Colours.color_0F1015,
                  fontWeight: FontWeight.w600,
                ),
              ),
              centerTitle: true,
              elevation: 0,
            ),
            body: SmartRefresher(
              controller: _controller,
              onRefresh: () {
                final completer = Completer();
                completer.future
                    .then((value) => _controller.refreshCompleted())
                    .catchError((e) => _controller.refreshFailed());
                StoreProvider.of<AppState>(context)
                    .dispatch(FetchGoodsCategoryAction(completer));
              },
              child: ListView.builder(
                itemBuilder: (ctx, i) {
                  return _buildExpansionItem(vm.list[i]);
                },
                itemCount: vm.list.length,
              ),
            ),
          );
        });
  }

  _buildExpansionItem(GoodsCategory model) {
    return ExpansionTile(
      title: Text(
        model.name,
        style: TextStyle(
          color: AppTheme.color0F1015,
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
      ),
      children: [
        ListView.builder(
          itemBuilder: (ctx, i) {
            return InkWell(
              onTap: () {
                Navigator.of(context).pushNamed(RouterPath.goodsCategoryFilter,
                    arguments: model.childrenList[i]);
              },
              child: ListTile(
                title: Padding(
                  padding: const EdgeInsets.only(left: 4),
                  child: Text(
                    model.childrenList[i].name,
                    style: TextStyle(
                      color: AppTheme.color555764,
                      fontSize: 14,
                    ),
                  ),
                ),
              ),
            );
          },
          itemCount: model.childrenList.length,
          itemExtent: 50,
          physics: NeverScrollableScrollPhysics(),
          shrinkWrap: true,
        ),
      ],
    );
  }
}

class _ViewModel {
  final List<GoodsCategory> list;

  _ViewModel(this.list);

  static _ViewModel fromStore(Store<AppState> store) {
    final list = store.state.goodsCategory.categoryList;
    final filterList = list.where((e) => e.childrenList.isNotEmpty).toList();
    return _ViewModel(filterList);
  }
}
