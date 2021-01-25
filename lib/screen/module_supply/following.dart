import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:idol/models/appstate.dart';
import 'package:idol/models/supply.dart';
import 'package:idol/net/request/supply.dart';
import 'package:idol/screen/module_supply/product_item.dart';
import 'package:idol/store/actions/supply.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:redux/redux.dart';

class FollowingTabView extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _FollowingTabViewState();
}

class _FollowingTabViewState extends State<FollowingTabView>
    with AutomaticKeepAliveClientMixin<FollowingTabView> {
  List<Product> products = const [];
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
              itemCount: products.length,
              itemBuilder: (context, index) => ProductItemWidget(
                product: products[index],
                onProductAddedStoreListener: (product) {
                  products.remove(product);
                  setState(() {});
                },
              ),
            ),
            onRefresh: () => vm._load(1),
            onLoading: () => vm._load(currentPage + 1),
            controller: _refreshController,
          ),
        );
      },
    );
  }

  void _onFollowingStateChanged(FollowingState state) {
    if (state is FollowingLoading) {
      _refreshController.requestRefresh();
    } else if (state is FollowingSuccess) {
      setState(() {
        if ((state).supply.currentPage == 1) {
          products = (state).supply.list;
        } else {
          products.addAll((state).supply.list);
        }
        currentPage = (state).supply.currentPage;
        enablePullUp = (state).supply.currentPage != (state).supply.totalPage;
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
