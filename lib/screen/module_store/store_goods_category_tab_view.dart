import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:idol/models/appstate.dart';
import 'package:idol/models/store_goods_list.dart';
import 'package:idol/net/request/store.dart';
import 'package:idol/res/colors.dart';
import 'package:idol/store/actions/actions.dart';
import 'package:idol/utils/global.dart';
import 'package:idol/widgets/error.dart';
import 'package:idol/widgets/loading.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:redux/redux.dart';

class GoodsCategoryTabView extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _GoodsCategoryTabViewState();
}

class _GoodsCategoryTabViewState extends State<GoodsCategoryTabView>
    with AutomaticKeepAliveClientMixin<GoodsCategoryTabView> {
  List<StoreGoods> storeGoodsList = const [];
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
        store.dispatch(MyInfoGoodsCategoryListAction(
            MyInfoGoodsListRequest(Global.getUser(context).id, 1, 1)));
      },
      distinct: true,
      onWillChange: (oldVM, newVM) {
        _onMyInfoGoodsCategoryListStateChanged(newVM == null
            ? oldVM._myInfoGoodsCategoryListState
            : newVM._myInfoGoodsCategoryListState);
      },
      builder: (context, vm) {
        return _buildWidget(vm);
      },
    );
  }

  Widget _buildWidget(_ViewModel vm) {
    if (vm._myInfoGoodsCategoryListState is MyInfoGoodsCategoryListInitial ||
        vm._myInfoGoodsCategoryListState is MyInfoGoodsCategoryListLoading) {
      return IdolLoadingWidget();
    } else if (vm._myInfoGoodsCategoryListState
        is MyInfoGoodsCategoryListFailure) {
      return IdolErrorWidget(() {
        vm._load(Global.getUser(context).id, 1);
      });
    } else {
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
            crossAxisCount: 2,
            crossAxisSpacing: 20.0,
            mainAxisSpacing: 20.0,
            childAspectRatio: 144.0 / 174.0,
            physics: NeverScrollableScrollPhysics(),
            children: storeGoodsList
                .asMap()
                .map((index, goods) {
                  return MapEntry(
                    index,
                    GestureDetector(
                      onTap: () => _goodsCategory(goods),
                      child: Stack(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.all(Radius.circular(4)),
                            child: Container(
                              margin: EdgeInsets.only(left: 8),
                              color: Colours.color_EDEEF0,
                              constraints:
                                  BoxConstraints(maxHeight: 144, maxWidth: 144),
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.only(right: 8, top: 8),
                            child: ClipRRect(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(4)),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Image(image: NetworkImage(goods.picture)),
                                  SizedBox(
                                    height: 8,
                                  ),
                                  Text(
                                    goods.interestName ?? '',
                                    style: TextStyle(
                                        fontSize: 14,
                                        color: Colours.color_0F1015),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
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
  }

  void _goodsCategory(StoreGoods storeGoods) {
    // TODO
    EasyLoading.showToast('查看该Tag下的所有商品');
  }

  void _onMyInfoGoodsCategoryListStateChanged(
      MyInfoGoodsCategoryListState state) {
    if (state is MyInfoGoodsCategoryListSuccess) {
      setState(() {
        if ((state).storeGoodsList.currentPage == 1) {
          storeGoodsList = (state).storeGoodsList.list;
        } else {
          storeGoodsList.addAll((state).storeGoodsList.list);
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
    } else if (state is MyInfoGoodsCategoryListFailure) {
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
  final MyInfoGoodsCategoryListState _myInfoGoodsCategoryListState;
  final Function(String, int) _load;

  _ViewModel(this._myInfoGoodsCategoryListState, this._load);

  static _ViewModel fromStore(Store<AppState> store) {
    void _load(String userId, int page) {
      store.dispatch(
          MyInfoGoodsCategoryListAction(MyInfoGoodsListRequest(userId, 1, page)));
    }

    return _ViewModel(store.state.myInfoGoodsCategoryListState, _load);
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is _ViewModel &&
          runtimeType == other.runtimeType &&
          _myInfoGoodsCategoryListState == other._myInfoGoodsCategoryListState;

  @override
  int get hashCode => _myInfoGoodsCategoryListState.hashCode;
}
