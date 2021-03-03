import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:idol/models/models.dart';
import 'package:idol/net/request/dashboard.dart';
import 'package:idol/r.g.dart';
import 'package:idol/res/colors.dart';
import 'package:idol/router.dart';
import 'package:idol/store/actions/actions.dart';
import 'package:idol/widgets/button.dart';
import 'package:idol/widgets/error.dart';
import 'package:idol/widgets/loading.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:idol/models/best_sales_list.dart';
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
  bool _enablePullUp = false;

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    _refreshController = RefreshController();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return StoreConnector<AppState, _ViewModel>(
      converter: _ViewModel.fromStore,
      onInit: (store) {
        store.dispatch(BestSalesAction(BestSalesRequest(_type)));
      },
      distinct: true,
      onWillChange: (oldVM, newVM) {
        _onBestSalesStateChanged(
            newVM == null ? oldVM._bestSalesState : newVM._bestSalesState);
      },
      builder: (context, vm) {
        return _buildWidget(vm);
      },
    );
  }

  void _onBestSalesStateChanged(BestSalesState state) {
    if (state is BestSalesSuccess) {
      if(state.bestSalesList != null && state.bestSalesList.list != null){
        _bestSalesList = state.bestSalesList.list;
      }
    } else if (state is BestSalesFailure) {
      EasyLoading.showError(state.message);
    }
  }

  Widget _buildWidget(_ViewModel vm) {
    if ((vm._bestSalesState is BestSalesInitial ||
            vm._bestSalesState is BestSalesLoading) &&
        _bestSalesList.isEmpty) {
      return IdolLoadingWidget();
    } else if (vm._bestSalesState is BestSalesFailure) {
      return IdolErrorWidget(() {
        vm._load(_type);
      });
    }else {
      return Container(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            PopupMenuButton<int>(
              onSelected: (index) {
                setState(() {
                  debugPrint('onSelect >>> $index');
                  _type = index;
                });
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
                      style:
                          TextStyle(color: Colours.color_C4C5CD, fontSize: 10),
                    ),
                    value: 0,
                  ),
                  PopupMenuItem(
                    child: Text(
                      'Last 30 days',
                      style:
                          TextStyle(color: Colours.color_C4C5CD, fontSize: 10),
                    ),
                    value: 1,
                  ),
                ].toList();
              },
            ),
            Expanded(
              child: SmartRefresher(
                enablePullDown: true,
                enablePullUp: _enablePullUp,
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
                  itemCount: _bestSalesList.length == 0 ? 1 : _bestSalesList.length,
                  itemBuilder: (context, index) => _bestSalesList.isEmpty
                      ? _bestSalesEmptyWidget()
                      : _BestSalesItem(_bestSalesList[index]),
                ),
                onRefresh: () async {
                  await Future(() {
                    vm._load(_type);
                  });
                },
                onLoading: () async {
                  await Future(() {
                    vm._load(_type);
                  });
                },
                controller: _refreshController,
              ),
            ),
          ],
        ),
      );
    }
  }

  Widget _bestSalesEmptyWidget() {
    return Container(
      margin: EdgeInsets.all(40),
      child: Column(
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Image(
            image: R.image.bg_default_empty_sales_history_webp(),
            width: 170,
            height: 195,
          ),
          SizedBox(
            height: 20,
          ),
          Text(
            'Temporarily no data',
            style: TextStyle(color: Colours.color_0F1015, fontSize: 16),
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
            fit: BoxFit.cover,
          ),
          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.bestSales.goodsName,
                  style: TextStyle(color: Colours.color_0F1015, fontSize: 12),
                ),
                SizedBox(
                  height: 4,
                ),
                Text(
                  'Sales',
                  style: TextStyle(color: Colours.color_0F1015, fontSize: 12),
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
              Text(
                widget.bestSales.soldNum.toString(),
                style: TextStyle(color: Colours.color_0F1015, fontSize: 12),
              ),
              SizedBox(
                height: 4,
              ),
              Text(
                widget.bestSales.earningPriceStr,
                style: TextStyle(color: Colours.color_0F1015, fontSize: 12),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _ViewModel {
  final BestSalesState _bestSalesState;
  Function(int) _load;

  _ViewModel(this._bestSalesState, this._load);

  static _ViewModel fromStore(Store<AppState> store) {
    void _load(int type) {
      store.dispatch(BestSalesAction(BestSalesRequest(type)));
    }

    return _ViewModel(store.state.bestSalesState, _load);
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
