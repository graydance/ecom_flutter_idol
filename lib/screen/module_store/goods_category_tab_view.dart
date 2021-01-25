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

class GoodsCategoryTabView extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _GoodsCategoryTabViewState();
}

class _GoodsCategoryTabViewState extends State<GoodsCategoryTabView>
    with AutomaticKeepAliveClientMixin<GoodsCategoryTabView> {
  List<Goods> goodsCategoryList = const [];
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
        if (store.state.myInfoGoodsCategoryListState
            is MyInfoGoodsCategoryListInitial) {
          store.dispatch(MyInfoGoodsCategoryListAction(
              MyInfoGoodsListRequest(Global.getUser(context).id, 1, 1)));
        }
      },
      distinct: true,
      onWillChange: (oldVM, newVM) {
        _onMyInfoGoodsCategoryListStateChanged(newVM == null
            ? oldVM._userDetailGoodsCategoryListState
            : newVM._userDetailGoodsCategoryListState);
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
              crossAxisCount: 2,
              crossAxisSpacing: 20.0,
              mainAxisSpacing: 20.0,
              childAspectRatio: 144.0 / 174.0,
              physics: NeverScrollableScrollPhysics(),
              children: goodsCategoryList
                  .asMap()
                  .map((index, goods) {
                    return MapEntry(
                      index,
                      GestureDetector(
                        onTap: () => _goodsCategory(goods),
                        child: Stack(
                          children: [
                            ClipRRect(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(4)),
                              child: Container(
                                margin: EdgeInsets.only(left: 8),
                                color: Colours.color_EDEEF0,
                                constraints: BoxConstraints(
                                    maxHeight: 144, maxWidth: 144),
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
            onRefresh: () => vm._load(Global.getUser(context).id, 1),
            onLoading: () =>
                vm._load(Global.getUser(context).id, currentPage + 1),
            controller: _refreshController,
          ),
        );
      },
    );
  }

  void _goodsCategory(Goods goods) {
    // TODO
  }

  void _onMyInfoGoodsCategoryListStateChanged(
      MyInfoGoodsCategoryListState state) {
    if (state is FollowingLoading) {
      _refreshController.requestRefresh();
    } else if (state is MyInfoGoodsCategoryListSuccess) {
      setState(() {
        if ((state).goodsList.currentPage == 1) {
          goodsCategoryList = (state).goodsList.list;
        } else {
          goodsCategoryList.addAll((state).goodsList.list);
        }
        currentPage = (state).goodsList.currentPage;
        enablePullUp =
            (state).goodsList.currentPage != (state).goodsList.totalPage && (state).goodsList.totalPage != 0;
      });
      _refreshController.refreshCompleted();
    } else if (state is MyInfoGoodsCategoryListFailure) {
      _refreshController.refreshCompleted();
      EasyLoading.showToast((state).message);
    }
  }

  @override
  bool get wantKeepAlive => true;
}

class _ViewModel {
  final MyInfoGoodsCategoryListState _userDetailGoodsCategoryListState;
  final Function(String, int) _load;

  _ViewModel(this._userDetailGoodsCategoryListState, this._load);

  static _ViewModel fromStore(Store<AppState> store) {
    void _load(String userId, int page) {
      store.dispatch(
          MyInfoGoodsListAction(MyInfoGoodsListRequest(userId, 1, page)));
    }

    return _ViewModel(store.state.myInfoGoodsCategoryListState, _load);
  }
}
