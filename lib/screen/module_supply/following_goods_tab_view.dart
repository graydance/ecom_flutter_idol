import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:idol/models/appstate.dart';
import 'package:idol/models/goods_detail.dart';
import 'package:idol/net/request/supply.dart';
import 'package:idol/screen/module_supply/supply_goods_list_item.dart';
import 'package:idol/store/actions/supply.dart';
import 'package:idol/widgets/error.dart';
import 'package:idol/widgets/screen_loading.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:redux/redux.dart';

class FollowingTabView extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _FollowingTabViewState();
}

class _FollowingTabViewState extends State<FollowingTabView>
    with AutomaticKeepAliveClientMixin<FollowingTabView> {
  List<GoodsDetail> goodsDetail = const [];
  RefreshController _refreshController;
  bool enablePullUp = false;
  int currentPage = 1;

  @override
  bool get wantKeepAlive => true;

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
        if (store.state.followingState is FollowingInitial) {
          store.dispatch(FollowingAction(FollowingForYouRequest(0, 1)));
        }
      },
      distinct: true,
      onWillChange: (oldVM, newVM) {
        _onFollowingStateChanged(
            newVM == null ? oldVM._followingState : newVM._followingState);
      },
      builder: (context, vm) {
        return _buildWidget(vm);
      },
    );
  }

  Widget _buildWidget(_ViewModel vm){
    if(vm._followingState is FollowingInitial || vm._followingState is FollowingLoading){
      return ScreenLoadingWidget();
    }else if(vm._followingState is FollowingSuccess){
      return Container(
        child: SmartRefresher(
          enablePullDown: true,
          enablePullUp: enablePullUp,
          header: WaterDropHeader(),
          child: ListView.separated(
            scrollDirection: Axis.vertical,
            separatorBuilder: (context, index) {
              return Divider(
                height: 10,
                color: Colors.transparent,
              );
            },
            itemCount: goodsDetail.length,
            itemBuilder: (context, index) => FollowingGoodsListItem(
              goodsDetail: goodsDetail[index],
              onProductAddedStoreListener: (product) {
                goodsDetail.remove(product);
                setState(() {});
              },
            ),
          ),
          onRefresh: () => vm._load(1),
          onLoading: () => vm._load(currentPage + 1),
          controller: _refreshController,
        ),
      );
    }else {
      return IdolErrorWidget((){
        vm._load(1);
      });
    }
  }

  void _onFollowingStateChanged(FollowingState state) {
    if (state is FollowingLoading) {
      _refreshController.requestRefresh();
    } else if (state is FollowingSuccess) {
      setState(() {
        if ((state).goodsDetailList.currentPage == 1) {
          goodsDetail = (state).goodsDetailList.list;
        } else {
          goodsDetail.addAll((state).goodsDetailList.list);
        }
        currentPage = (state).goodsDetailList.currentPage;
        enablePullUp = (state).goodsDetailList.currentPage != (state).goodsDetailList.totalPage;
      });
      _refreshController.refreshCompleted();
    } else if (state is FollowingFailure) {
      _refreshController.refreshCompleted();
      EasyLoading.showToast((state).message);
    }
  }
}

class _ViewModel {
  final FollowingState _followingState;
  final Function(int) _load;

  _ViewModel(this._followingState, this._load);

  static _ViewModel fromStore(Store<AppState> store) {
    void _load(int page) {
      store.dispatch(
          FollowingAction(FollowingForYouRequest(0, page, limit: 10)));
    }

    return _ViewModel(store.state.followingState, _load);
  }
}
