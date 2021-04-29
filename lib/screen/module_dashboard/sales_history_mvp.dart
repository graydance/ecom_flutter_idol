import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:idol/models/models.dart';
import 'package:idol/net/request/dashboard.dart';
import 'package:idol/res/colors.dart';
import 'package:idol/store/actions/actions.dart';
import 'package:idol/widgets/ui.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:redux/redux.dart';

import '../../r.g.dart';

class SalesHistoryTabView extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _SalesHistoryTabViewState();
}

class _SalesHistoryTabViewState extends State<SalesHistoryTabView>
    with AutomaticKeepAliveClientMixin<SalesHistoryTabView> {
  List<SalesHistory> _salesHistoryList = const [];
  SalesHistoryArguments _arguments;
  RefreshController _refreshController;

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    _refreshController = RefreshController(initialRefresh: true);
    _arguments = StoreProvider.of<AppState>(context, listen: false)
        .state
        .salesHistoryArguments;
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
        appBar: IdolUI.appBar(context, 'SalesHistory'),
        body: StoreConnector<AppState, _ViewModel>(
          converter: _ViewModel.fromStore,
          distinct: true,
          builder: (context, vm) {
            return _buildWidget(vm);
          },
        ));
  }

  Widget _buildWidget(_ViewModel vm) {
    return Container(
      child: Column(
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            padding: EdgeInsets.only(left: 16, top: 12, right: 16, bottom: 12),
            color: Colours.color_8000000,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Text(
                    _arguments.dateStr,
                    style: TextStyle(color: Colours.color_0F1015, fontSize: 14),
                  ),
                ),
                Text(
                  "\$" + _arguments.money,
                  style: TextStyle(color: Colours.color_EA5228, fontSize: 14),
                ),
              ],
            ),
          ),
          Expanded(
            child: _createWidgetByStatus(vm),
          ),
        ],
      ),
    );
  }

  Widget _createWidgetByStatus(_ViewModel vm) {
    return SmartRefresher(
      enablePullDown: _salesHistoryList.isEmpty ? false : true,
      enablePullUp: false,
      header: MaterialClassicHeader(
        color: Colours.color_EA5228,
      ),
      child: ListView.separated(
        scrollDirection: Axis.vertical,
        separatorBuilder: (context, index) {
          return Divider(
            height: 10,
            color: Colors.transparent,
          );
        },
        itemCount: _salesHistoryList.length == 0 ? 1 : _salesHistoryList.length,
        itemBuilder: (context, index) => _salesHistoryList.isEmpty
            ? _salesHistoryEmptyItem(context)
            : _SalesHistoryItem(_salesHistoryList[index]),
      ),
      onRefresh: () async {
        final completer = Completer();
        StoreProvider.of<AppState>(context).dispatch(SalesHistoryAction(
            SalesHistoryRequest(_arguments.date), completer));
        try {
          var list = await completer.future;
          _refreshController.refreshCompleted();
          setState(() {
            _salesHistoryList = list.list;
          });
        } catch (error) {
          _refreshController.loadFailed();
        }
      },
      onLoading: () async {
        final completer = Completer();
        StoreProvider.of<AppState>(context).dispatch(SalesHistoryAction(
            SalesHistoryRequest(_arguments.date), completer));
        try {
          var list = await completer.future;
          _refreshController.refreshCompleted();
          setState(() {
            _salesHistoryList = list.list;
          });
        } catch (error) {
          _refreshController.loadFailed();
        }
      },
      controller: _refreshController,
    );
  }
}

Widget _salesHistoryEmptyItem(BuildContext context) {
  return Container(
      margin: EdgeInsets.only(top: 100),
      child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image(
              image: R.image.bg_default_empty_sales_history_webp(),
              width: 170,
              height: 195,
            ),
          ]));
}

class _SalesHistoryItem extends StatefulWidget {
  final SalesHistory salesHistory;

  _SalesHistoryItem(this.salesHistory);

  @override
  State<StatefulWidget> createState() => _SalesHistoryItemState();
}

class _SalesHistoryItemState extends State<_SalesHistoryItem> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
              margin: EdgeInsets.all(10),
              width: 101.89,
              height: 73.78,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(6),
                child: FadeInImage.assetNetwork(
                  placeholder: '', //占位图
                  image: widget.salesHistory.goodsPicture,
                  fit: BoxFit.cover,
                ),
              )),
          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.salesHistory.goodsName,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(color: Colours.color_0F1015, fontSize: 12),
                ),
                SizedBox(
                  height: 4,
                ),
                Text(
                  'Sales',
                  style: TextStyle(color: Colours.color_B1B2B3, fontSize: 12),
                ),
                SizedBox(
                  height: 4,
                ),
                Text(
                  'Earnings',
                  style: TextStyle(color: Colours.color_0F1015, fontSize: 12),
                ),
              ],
            ),
          ),
          Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '',
                style: TextStyle(color: Colours.color_0F1015, fontSize: 12),
              ),
              SizedBox(
                height: 4,
              ),
              Container(
                margin: EdgeInsets.only(right: 15),
                child: Text(
                  widget.salesHistory.soldNum.toString(),
                  style: TextStyle(color: Colours.color_B1B2B3, fontSize: 12),
                ),
              ),
              SizedBox(
                height: 4,
              ),
              Container(
                margin: EdgeInsets.only(right: 15),
                child: Text(
                  "\$" + widget.salesHistory.earningPriceStr,
                  style: TextStyle(color: Colours.color_0F1015, fontSize: 12),
                ),
              )
            ],
          ),
        ],
      ),
    );
  }
}

class _ViewModel {
  final SalesHistoryState _salesHistoryState;

  _ViewModel(this._salesHistoryState);

  static _ViewModel fromStore(Store<AppState> store) {
    return _ViewModel(store.state.salesHistoryState);
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is _ViewModel &&
          runtimeType == other.runtimeType &&
          _salesHistoryState == other._salesHistoryState;

  @override
  int get hashCode => _salesHistoryState.hashCode;
}
