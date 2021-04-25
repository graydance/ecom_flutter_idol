import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:idol/event/app_event.dart';
import 'package:idol/models/appstate.dart';
import 'package:idol/net/request/supply.dart';
import 'package:idol/res/colors.dart';
import 'package:idol/screen/module_supply/supply_goods_list_item.dart';
import 'package:idol/store/actions/supply.dart';
import 'package:idol/utils/event_bus.dart';
import 'package:idol/utils/share.dart';
import 'package:idol/widgets/error.dart';
import 'package:idol/widgets/loading.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:redux/redux.dart';

class ForYouTabView extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _ForYouTabViewState();
}

class _ForYouTabViewState extends State<ForYouTabView>
    with AutomaticKeepAliveClientMixin<ForYouTabView> {
  RefreshController _refreshController;
  int _currentPage = 1;
  bool _enablePullUp = false;
  var eventBusFn;

  Set<String> _reportedIds = {};

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    _refreshController = RefreshController();
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
    // TODO: implement dispose
    super.dispose();
    //取消订阅
    eventBusFn.cancel();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return StoreConnector<AppState, _ViewModel>(
      converter: _ViewModel.fromStore,
      onInit: (store) {
        store.dispatch(ForYouAction(FollowingForYouRequest(1, 1)));
      },
      builder: (context, vm) {
        return _buildWidget(vm);
      },
    );
  }

  Widget _buildWidget(_ViewModel vm) {
    if ((vm._forYouState is ForYouInitial ||
        vm._forYouState is ForYouLoading)) {
      return IdolLoadingWidget();
    } else if (vm._forYouState is ForYouFailure) {
      return IdolErrorWidget(() {
        vm._load(1);
      });
    } else {
      return Container(
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
            itemCount:
                (vm._forYouState as ForYouSuccess).goodsDetailList.list.length,
            itemBuilder: (context, index) {
              final model = (vm._forYouState as ForYouSuccess)
                  .goodsDetailList
                  .list[index];
              if (!_reportedIds.contains(model.id)) {
                _reportedIds.add(model.id);
                AppEvent.shared.report(
                  event: AnalyticsEvent.grid_display_b,
                  parameters: {AnalyticsEventParameter.id: model.id},
                );
              }

              return FollowingGoodsListItem(
                idx: index,
                goodsDetail: model,
                onProductAddedStoreListener: (goodsDetail) {
                  ShareManager.showShareGoodsDialog(
                      context, goodsDetail.goods[0]);
                },
              );
            },
          ),
          onRefresh: () async {
            await Future(() {
              vm._load(1);
            });
          },
          onLoading: () async {
            await Future(() {
              vm._load(_currentPage + 1);
            });
          },
          controller: _refreshController,
        ),
      );
    }
  }
}

class _ViewModel {
  final ForYouState _forYouState;
  final Function(int) _load;

  _ViewModel(this._forYouState, this._load);

  static _ViewModel fromStore(Store<AppState> store) {
    void _load(int page) {
      store.dispatch(ForYouAction(FollowingForYouRequest(1, page, limit: 50)));
    }

    return _ViewModel(store.state.forYouState, _load);
  }
}
