import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:idol/models/best_sales_list.dart';
import 'package:idol/models/models.dart';
import 'package:idol/net/request/dashboard.dart';
import 'package:idol/r.g.dart';
import 'package:idol/res/colors.dart';
import 'package:idol/store/actions/actions.dart';
import 'package:idol/utils/global.dart';
import 'package:idol/widgets/button.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:redux/redux.dart';

class BestSalesTabView extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _BestSalesTabViewState();
}

class _BestSalesTabViewState extends State<BestSalesTabView>
    with AutomaticKeepAliveClientMixin<BestSalesTabView> {
  List<BestSales> _bestSalesList = const [];
  RefreshController _refreshController;
  int _type = 0; // 0 最近7天 1 最近30天

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    _refreshController = RefreshController(initialRefresh: true);
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return StoreConnector<AppState, _ViewModel>(
      converter: _ViewModel.fromStore,
      distinct: true,
      builder: (context, vm) {
        return _buildWidget(vm);
      },
    );
  }

  Widget _buildWidget(_ViewModel vm) {
    print("bestSales:" + _bestSalesList.toString());
    return Container(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          PopupMenuButton<int>(
            onSelected: (index) {
              _type = index;
              _refreshController.requestRefresh();
            },
            child: Padding(
              padding:
                  EdgeInsets.only(left: 16, top: 10, right: 16, bottom: 10),
              child: Text(
                _type == 0 ? 'Last 7 days ▼' : 'Last 30 days ▼',
                style: TextStyle(color: Colours.color_555764, fontSize: 12),
              ),
            ),
            itemBuilder: (context) {
              return <PopupMenuEntry<int>>[
                PopupMenuItem(
                  child: Text(
                    'Last 7 days',
                    style: TextStyle(color: Colours.color_C4C5CD, fontSize: 10),
                  ),
                  value: 0,
                  height: 24,
                ),
                PopupMenuDivider(
                  height: 2,
                ),
                PopupMenuItem(
                  child: Text(
                    'Last 30 days',
                    style: TextStyle(color: Colours.color_C4C5CD, fontSize: 10),
                  ),
                  value: 1,
                  height: 24,
                ),
              ].toList();
            },
          ),
          Expanded(
            child: SmartRefresher(
              controller: _refreshController,
              enablePullDown: true,
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
                itemCount:
                    _bestSalesList.length == 0 ? 1 : _bestSalesList.length,
                itemBuilder: (context, index) => _bestSalesList.isEmpty
                    ? _bestSalesEmptyWidget()
                    : _BestSalesItem(_bestSalesList[index]),
              ),
              onRefresh: () async {
                final completer = Completer();
                StoreProvider.of<AppState>(context).dispatch(
                    BestSalesAction(BestSalesRequest(_type), completer));
                try {
                  var list = await completer.future;
                  _refreshController.refreshCompleted();
                  setState(() {
                    _bestSalesList = list.list;
                  });
                } catch (error) {
                  _refreshController.loadFailed();
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _bestSalesEmptyWidget() {
    return Container(
      margin: EdgeInsets.all(20),
      child: Column(
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          GestureDetector(
            onTap: () {
              StoreProvider.of<AppState>(context)
                  .dispatch(ChangeHomePageAction(0));
            },
            child: Image(
              image: R.image.bg_default_empty_sales_history_webp(),
              width: 170,
              height: 195,
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Text(
            'No sales history.\nAdd and Share products now.',
            style: TextStyle(
              color: Colours.color_0F1015,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(
            height: 12,
          ),
          IdolButton(
            'Add and share',
            status: IdolButtonStatus.enable,
            listener: (status) {
              // go supply.
              StoreProvider.of<AppState>(context)
                  .dispatch(ChangeHomePageAction(0));
            },
          ),
        ],
      ),
    );
  }
}

class _BestSalesItem extends StatefulWidget {
  final BestSales bestSales;

  _BestSalesItem(this.bestSales);

  @override
  State<StatefulWidget> createState() => _BestSalesItemState();
}

class _BestSalesItemState extends State<_BestSalesItem> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Image(
            image: NetworkImage(
              widget.bestSales.goodsPicture,
            ),
            width: 70,
            height: 70,
            fit: BoxFit.contain,
          ),
          SizedBox(
            width: 8,
          ),
          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(right: 20.0),
                  child: Text(
                    widget.bestSales.goodsName,
                    style: TextStyle(
                      color: Colours.color_0F1015,
                      fontSize: 12,
                    ),
                  ),
                ),
                SizedBox(
                  height: 4,
                ),
                Row(
                  children: [
                    Text(
                      'Sales',
                      style: TextStyle(
                        color: Colours.color_0F1015,
                        fontSize: 12,
                      ),
                    ),
                    Spacer(),
                    Text(
                      widget.bestSales.soldNum.toString(),
                      style: TextStyle(
                        color: Colours.color_0F1015,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 4,
                ),
                Row(
                  children: [
                    Text(
                      'Earnings',
                      style:
                          TextStyle(color: Colours.color_0F1015, fontSize: 12),
                    ),
                    Spacer(),
                    Text(
                      Global.getUser(context).monetaryUnit +
                          widget.bestSales.earningPriceStr,
                      style:
                          TextStyle(color: Colours.color_0F1015, fontSize: 12),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ViewModel {
  final BestSalesState _bestSalesState;

  _ViewModel(this._bestSalesState);

  static _ViewModel fromStore(Store<AppState> store) {
    return _ViewModel(store.state.bestSalesState);
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is _ViewModel &&
          runtimeType == other.runtimeType &&
          _bestSalesState == other._bestSalesState;

  @override
  int get hashCode => _bestSalesState.hashCode;
}
