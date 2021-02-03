import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:idol/models/appstate.dart';
import 'package:idol/models/goods.dart';
import 'package:idol/net/request/supply.dart';
import 'package:idol/res/colors.dart';
import 'package:idol/router.dart';
import 'package:idol/screen/module_supply/supplier_goods_list_item.dart';
import 'package:idol/store/actions/actions.dart';
import 'package:idol/utils/global.dart';
import 'package:idol/widgets/error.dart';
import 'package:idol/widgets/loading.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:redux/redux.dart';
import 'package:flutter_redux/flutter_redux.dart';

class SupplierGoodsTabView extends StatefulWidget {
  final String supplier;

  // 0: 热度排序 1: 时间排序
  final int type;

  SupplierGoodsTabView(this.supplier, this.type);

  @override
  State<StatefulWidget> createState() => _SupplierGoodsTabViewState();
}

class _SupplierGoodsTabViewState extends State<SupplierGoodsTabView>
    with AutomaticKeepAliveClientMixin<SupplierGoodsTabView> {
  List<Goods> _goodsList = const [];
  RefreshController _refreshController;
  int _currentPage = 1;
  bool _enablePullUp = false;

  @override
  void initState() {
    super.initState();
    _refreshController = RefreshController();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      debugPrint('Following build complete.');
    });
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return StoreConnector<AppState, _ViewModel>(
      converter: _ViewModel.fromStore,
      onInit: (store) {
        store.dispatch(SupplierHotGoodsListAction(
            SupplierGoodsListRequest(widget.supplier, 0, 1)));
      },
      distinct: true,
      onWillChange: (oldVM, newVM) {
        _onSupplierGoodsListStateChanged(newVM == null
            ? (widget.type == 0
                ? oldVM._supplierHotGoodsListState
                : oldVM._supplierNewGoodsListState)
            : (widget.type == 0
                ? newVM._supplierHotGoodsListState
                : newVM._supplierNewGoodsListState));
      },
      builder: (context, vm) {
        return _buildWidget(vm);
      },
    );
  }

  Widget _buildWidget(_ViewModel vm) {
    var state = widget.type == 0
        ? vm._supplierHotGoodsListState
        : vm._supplierNewGoodsListState;
    if (state is SupplierHotGoodsListInitial ||
        state is SupplierNewGoodsListInitial ||
        state is SupplierHotGoodsListLoading ||
        state is SupplierNewGoodsListLoading) {
      return IdolLoadingWidget();
    } else if (state is SupplierHotGoodsListFailure ||
        state is SupplierNewGoodsListFailure) {
      return IdolErrorWidget(() {
        vm._load(widget.type, Global.getUser(context).id, 1);
      });
    } else {
      return Container(
        //padding: EdgeInsets.only(left: 15, right: 15, bottom: 65),
        color: Colours.color_F8F8F8,
        child: SmartRefresher(
          enablePullDown: true,
          enablePullUp: _enablePullUp,
          header: MaterialClassicHeader(
            color: Colours.color_EA5228,
          ),
          child: StaggeredGridView.countBuilder(
              padding: EdgeInsets.all(15),
              itemCount: _goodsList.length,
              crossAxisCount: 2,
              crossAxisSpacing: 15.0,
              mainAxisSpacing: 15.0,
              staggeredTileBuilder: (int index) {
                // TODO 通过Goods的数据来动态设置宽高比权重...
                return StaggeredTile.count(1, 1.5);
              },
              // physics: NeverScrollableScrollPhysics(),
              itemBuilder: (context, index) {
                return SupplierGoodsListItem(
                  _goodsList[index],
                  onItemClickCallback: () {
                    // goods detail
                    IdolRoute.startGoodsDetail(context, widget.supplier,_goodsList[index].id);
                  },
                  onItemShareClickCallback: () {
                    // TODO share
                  },
                );
              }),
          onRefresh: () async {
            await Future(() {
              vm._load(widget.type, Global.getUser(context).id, 1);
            });
          },
          onLoading: () async {
            await Future(() {
              vm._load(
                  widget.type, Global.getUser(context).id, _currentPage + 1);
            });
          },
          controller: _refreshController,
        ),
      );
    }
  }

  void _onSupplierGoodsListStateChanged(dynamic state) {
    if (state is SupplierNewGoodsListSuccess ||
        state is SupplierHotGoodsListSuccess) {
      setState(() {
        if ((state).storeGoodsList.currentPage == 1) {
          _goodsList = (state).storeGoodsList.list;
        } else {
          _goodsList.addAll((state).storeGoodsList.list);
        }
        _currentPage = (state).storeGoodsList.currentPage;
        _enablePullUp = (state).storeGoodsList.currentPage !=
                (state).storeGoodsList.totalPage &&
            (state).storeGoodsList.totalPage != 0;
      });
      if (_currentPage == 1) {
        _refreshController.refreshCompleted(resetFooterState: true);
      } else {
        _refreshController.loadComplete();
      }
    } else if (state is SupplierHotGoodsListFailure ||
        state is SupplierNewGoodsListFailure) {
      if (_currentPage == 1) {
        _refreshController.refreshCompleted(resetFooterState: true);
      } else {
        _refreshController.loadComplete();
      }
      EasyLoading.showToast((state).message);
    }
  }

  @override
  bool get wantKeepAlive => true;
}

class _ViewModel {
  final SupplierHotGoodsListState _supplierHotGoodsListState;
  final SupplierNewGoodsListState _supplierNewGoodsListState;

  final Function(int, String, int) _load;

  _ViewModel(this._supplierHotGoodsListState, this._supplierNewGoodsListState,
      this._load);

  static _ViewModel fromStore(Store<AppState> store) {
    void _load(int type, String supplierId, int page) {
      if (type == 0) {
        store.dispatch(SupplierHotGoodsListAction(
            SupplierGoodsListRequest(supplierId, 0, page)));
      } else {
        store.dispatch(SupplierNewGoodsListAction(
            SupplierGoodsListRequest(supplierId, 1, page)));
      }
    }

    return _ViewModel(store.state.supplierHotGoodsListState,
        store.state.supplierNewGoodsListState, _load);
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is _ViewModel &&
          runtimeType == other.runtimeType &&
          _supplierHotGoodsListState == other._supplierHotGoodsListState &&
          _supplierNewGoodsListState == other._supplierNewGoodsListState;

  @override
  int get hashCode =>
      _supplierHotGoodsListState.hashCode ^ _supplierNewGoodsListState.hashCode;
}
