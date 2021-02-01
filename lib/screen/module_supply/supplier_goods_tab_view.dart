import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:idol/models/appstate.dart';
import 'package:idol/models/goods.dart';
import 'package:idol/net/request/supply.dart';
import 'package:idol/res/colors.dart';
import 'package:idol/screen/module_supply/supplier_goods_list_item.dart';
import 'package:idol/store/actions/actions.dart';
import 'package:idol/utils/global.dart';
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
  List<Goods> goodsList = const [];
  RefreshController _refreshController;
  bool enablePullUp = false;
  int currentPage = 1;

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
        if (store.state.supplierHotGoodsListState
            is SupplierHotGoodsListInitial) {
          store.dispatch(SupplierHotGoodsListAction(
              SupplierGoodsListRequest(widget.supplier, 0, 1)));
        }
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
        return Container(
          //padding: EdgeInsets.only(left: 15, right: 15, bottom: 65),
          color: Colours.color_F8F8F8,
          child: SmartRefresher(
            enablePullDown: true,
            enablePullUp: enablePullUp,
            header: WaterDropHeader(),
            child: StaggeredGridView.countBuilder(
              padding: EdgeInsets.all(15),
              itemCount: goodsList.length,
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
                  goodsList[index],
                  onItemClickCallback: () {
                    // TODO goods detail
                  },
                  onItemShareClickCallback: () {
                    // TODO share
                  },
                );
              }
            ),
            onRefresh: () =>
                vm._load(widget.type, Global.getUser(context).id, 1),
            onLoading: () => vm._load(
                widget.type, Global.getUser(context).id, currentPage + 1),
            controller: _refreshController,
          ),
        );
      },
    );
  }

  void _onSupplierGoodsListStateChanged(dynamic state) {
    if (state is SupplierNewGoodsListLoading ||
        state is SupplierHotGoodsListLoading) {
      _refreshController.requestRefresh();
    } else if (state is SupplierNewGoodsListSuccess ||
        state is SupplierHotGoodsListSuccess) {
      setState(() {
        if ((state).goodsList.currentPage == 1) {
          goodsList = (state).goodsList.list;
        } else {
          goodsList.addAll((state).goodsList.list);
        }
        currentPage = (state).goodsList.currentPage;
        enablePullUp =
            (state).goodsList.currentPage != (state).goodsList.totalPage &&
                (state).goodsList.totalPage != 0;
      });
      _refreshController.refreshCompleted();
    } else if (state is SupplierHotGoodsListFailure ||
        state is SupplierNewGoodsListFailure) {
      _refreshController.refreshCompleted();
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
}
