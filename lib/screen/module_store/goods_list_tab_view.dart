import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:idol/models/appstate.dart';
import 'package:idol/models/goods_list.dart';
import 'package:idol/net/request/store.dart';
import 'package:idol/res/colors.dart';
import 'package:idol/store/actions/actions.dart';
import 'package:idol/store/actions/supply.dart';
import 'package:idol/utils/global.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:redux/redux.dart';

class GoodsListTabView extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _GoodsListTabViewState();
}

class _GoodsListTabViewState extends State<GoodsListTabView>
    with AutomaticKeepAliveClientMixin<GoodsListTabView> {
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
        if (store.state.myInfoGoodsListState is MyInfoGoodsListInitial) {
          store.dispatch(MyInfoGoodsListAction(
              MyInfoGoodsListRequest(Global.getUser(context).id, 0, 1)));
        }
      },
      distinct: true,
      onWillChange: (oldVM, newVM) {
        _onMyInfoGoodsListStateChanged(newVM == null
            ? oldVM._myInfoGoodsListState
            : newVM._myInfoGoodsListState);
      },
      builder: (context, vm) {
        return Container(
          padding: EdgeInsets.only(left: 15, right: 15, bottom: 65),
          color: Colours.color_F8F8F8,
          child: SmartRefresher(
            enablePullDown: true,
            enablePullUp: enablePullUp,
            header: WaterDropHeader(),
            child: GridView.count(
              crossAxisCount: 3,
              crossAxisSpacing: 10.0,
              mainAxisSpacing: 10.0,
              childAspectRatio: 1.0,
              physics: NeverScrollableScrollPhysics(),
              children: goodsList
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
            onRefresh: () => vm._load(Global.getUser(context).id, 1),
            onLoading: () =>
                vm._load(Global.getUser(context).id, currentPage + 1),
            controller: _refreshController,
          ),
        );
      },
    );
  }

  void _shareOrRemoveGoods(Goods goods) {
    // TODO
  }

  void _goodsDetail(Goods goods) {
    // TODO
  }

  void _onMyInfoGoodsListStateChanged(MyInfoGoodsListState state) {
    if (state is FollowingLoading) {
      _refreshController.requestRefresh();
    } else if (state is MyInfoGoodsListSuccess) {
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
    } else if (state is MyInfoGoodsListFailure) {
      _refreshController.refreshCompleted();
      EasyLoading.showToast((state).message);
    }
  }

  @override
  bool get wantKeepAlive => true;
}

class _ViewModel {
  final MyInfoGoodsListState _myInfoGoodsListState;
  final Function(String, int) _load;

  _ViewModel(this._myInfoGoodsListState, this._load);

  static _ViewModel fromStore(Store<AppState> store) {
    void _load(String userId, int page) {
      store.dispatch(
          MyInfoGoodsListAction(MyInfoGoodsListRequest(userId, 0, page)));
    }

    return _ViewModel(store.state.myInfoGoodsListState, _load);
  }
}
