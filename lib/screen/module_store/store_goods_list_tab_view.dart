import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:idol/models/appstate.dart';
import 'package:idol/models/models.dart';
import 'package:idol/net/request/store.dart';
import 'package:idol/res/colors.dart';
import 'package:idol/router.dart';
import 'package:idol/store/actions/actions.dart';
import 'package:idol/utils/global.dart';
import 'package:idol/widgets/error.dart';
import 'package:idol/widgets/loading.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:redux/redux.dart';

class GoodsListTabView extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _GoodsListTabViewState();
}

class _GoodsListTabViewState extends State<GoodsListTabView>
    with AutomaticKeepAliveClientMixin<GoodsListTabView> {
  List<StoreGoods> _storeGoodsList = const [];
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
        store.dispatch(MyInfoGoodsListAction(
          MyInfoGoodsListRequest(Global.getUser(context).id, 0, 1),
          Completer(),
        ));
      },
      distinct: true,
      builder: (context, vm) {
        return _buildWidget(vm);
      },
    );
  }

  Widget _buildWidget(_ViewModel vm) {
    return Container(
      padding: EdgeInsets.only(left: 15, right: 15, bottom: 65),
      color: Colours.color_F8F8F8,
      child: SmartRefresher(
        enablePullDown: true,
        enablePullUp: _enablePullUp,
        header: MaterialClassicHeader(
          color: Colours.color_EA5228,
        ),
        child: GridView.count(
          crossAxisCount: 3,
          crossAxisSpacing: 10.0,
          mainAxisSpacing: 10.0,
          childAspectRatio: 1.0,
          physics: NeverScrollableScrollPhysics(),
          children: _storeGoodsList
              .asMap()
              .map((index, goods) {
                return MapEntry(
                  index,
                  ClipRRect(
                    borderRadius: BorderRadius.all(Radius.circular(4)),
                    child: GestureDetector(
                      onLongPress: () => _shareOrRemoveGoods(goods),
                      onTap: () => _goodsDetail(goods),
                      child: Stack(
                        alignment: AlignmentDirectional.center,
                        children: [
                          Image(image: NetworkImage(goods.picture)),
                          // Image(image: image), TODO Sell out / Off the shelf / _shareOrRemoveGoods
                        ],
                      ),
                    ),
                  ),
                );
              })
              .values
              .toList(),
        ),
        onRefresh: () async {
          await Future(() {
            vm._load(Global.getUser(context).id, 1);
          });
        },
        onLoading: () async {
          await Future(() {
            vm._load(Global.getUser(context).id, _currentPage + 1);
          });
        },
        controller: _refreshController,
      ),
    );
  }

  void _shareOrRemoveGoods(StoreGoods storeGoods) {
    // TODO
  }

  void _goodsDetail(StoreGoods storeGoods) {
    IdolRoute.startGoodsDetail(context, storeGoods.supplierId, storeGoods.id);
  }

  // void _onMyInfoGoodsListStateChanged(MyInfoGoodsListState state) {
  //   if (state is MyInfoGoodsListSuccess) {
  //     setState(() {
  //       if ((state).storeGoodsList.currentPage == 1) {
  //         _storeGoodsList = (state).storeGoodsList.list;
  //       } else {
  //         _storeGoodsList.addAll((state).storeGoodsList.list);
  //       }
  //       _currentPage = (state).storeGoodsList.currentPage;
  //       _enablePullUp = (state).storeGoodsList.currentPage !=
  //               (state).storeGoodsList.totalPage &&
  //           (state).storeGoodsList.totalPage != 0;
  //       if (_currentPage == 1) {
  //         _refreshController.refreshCompleted(resetFooterState: true);
  //       } else {
  //         _refreshController.loadComplete();
  //       }
  //     });
  //   } else if (state is MyInfoGoodsListFailure) {
  //     if (_currentPage == 1) {
  //       _refreshController.refreshCompleted(resetFooterState: true);
  //     } else {
  //       _refreshController.loadComplete();
  //     }
  //     EasyLoading.showToast((state).message);
  //   }
  // }

  @override
  bool get wantKeepAlive => true;
}

class _ViewModel {
  // final MyInfoGoodsListState _myInfoGoodsListState;
  final Function(String, int) _load;

  _ViewModel(this._load);

  static _ViewModel fromStore(Store<AppState> store) {
    void _load(String userId, int page) {
      store.dispatch(MyInfoGoodsListAction(
          MyInfoGoodsListRequest(userId, 0, page), Completer()));
    }

    return _ViewModel(_load);
  }
}
