import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:redux/redux.dart';

import 'package:idol/event/app_event.dart';
import 'package:idol/models/appstate.dart';
import 'package:idol/models/models.dart';
import 'package:idol/net/request/supply.dart';
import 'package:idol/res/colors.dart';
import 'package:idol/screen/module_supply/supply_goods_list_item.dart';
import 'package:idol/store/actions/supply.dart';
import 'package:idol/utils/event_bus.dart';
import 'package:idol/utils/share.dart';

class ForYouTabView extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _ForYouTabViewState();
}

class _ForYouTabViewState extends State<ForYouTabView>
    with AutomaticKeepAliveClientMixin<ForYouTabView> {
  RefreshController _refreshController;
  int _currentPage = 1;
  List<GoodsDetail> _list = [];

  var eventBusFn;

  Set<String> _reportedIds = {};

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    _refreshController = RefreshController(initialRefresh: true);
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {});

    // 注册监听器，订阅 eventBus
    eventBusFn = eventBus.on<SupplyRefresh>().listen((event) {
      // ignore: deprecated_member_use
      _refreshController.scrollController.animateTo(0,
          duration: Duration(milliseconds: 800), curve: Curves.ease);
    });
  }

  @override
  void dispose() {
    super.dispose();
    //取消订阅
    eventBusFn.cancel();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return StoreConnector<AppState, _ViewModel>(
      converter: _ViewModel.fromStore,
      builder: (context, vm) {
        return _buildWidget(vm);
      },
    );
  }

  Widget _buildWidget(_ViewModel vm) {
    return Container(
      child: SmartRefresher(
        enablePullDown: true,
        enablePullUp: true,
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
          itemCount: _list.length,
          itemBuilder: (context, index) {
            final model = _list[index];
            if (!_reportedIds.contains(model.id)) {
              _reportedIds.add(model.id);
              AppEvent.shared.report(
                event: AnalyticsEvent.grid_display_b,
                parameters: {AnalyticsEventParameter.id: model.id},
              );
            }

            return FollowingGoodsListItem(
              key: ValueKey(model.id),
              idx: index,
              goodsDetail: model,
              onProductAddedStoreListener: (goodsDetail) {
                ShareManager.showShareGoodsDialog(
                  context,
                  goodsDetail.goods,
                  goodsDetail.shareText,
                );
              },
            );
          },
        ),
        onRefresh: () async {
          final completer = Completer();
          completer.future.then((value) {
            final GoodsDetailList model = value;
            _currentPage = model.currentPage;
            _list = model.list;
            if (mounted) setState(() {});
            _refreshController.refreshCompleted();
            _refreshController.resetNoData();
          }).catchError((error) {
            _refreshController.refreshFailed();
          });
          final action = ForYouAction(FollowingForYouRequest(1, 1), completer);
          StoreProvider.of<AppState>(context).dispatch(action);
        },
        onLoading: () async {
          final completer = Completer();
          completer.future.then((value) {
            final GoodsDetailList model = value;
            _currentPage = model.currentPage;
            _list.addAll(model.list);
            if (mounted) setState(() {});

            if (model.currentPage < model.totalPage) {
              _refreshController.loadComplete();
            } else {
              _refreshController.loadNoData();
            }
          }).catchError((error) {
            _refreshController.loadFailed();
          });
          final action = ForYouAction(
              FollowingForYouRequest(1, _currentPage + 1), completer);
          StoreProvider.of<AppState>(context).dispatch(action);
        },
        controller: _refreshController,
      ),
    );
  }
}

class _ViewModel {
  static _ViewModel fromStore(Store<AppState> store) {
    return _ViewModel();
  }
}
