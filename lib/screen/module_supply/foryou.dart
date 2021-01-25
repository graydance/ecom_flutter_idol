import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:idol/models/appstate.dart';
import 'package:idol/models/supply.dart';
import 'package:idol/net/request/supply.dart';
import 'package:idol/store/actions/supply.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:redux/redux.dart';
import 'package:idol/screen/module_supply/product_item.dart';

class ForYouTabView extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _ForYouTabViewState();
}

class _ForYouTabViewState extends State<ForYouTabView>
    with AutomaticKeepAliveClientMixin<ForYouTabView> {
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
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return StoreConnector<AppState, _ViewModel>(
      converter: _ViewModel.fromStore,
      onInit: (store) {
        if (store.state.forYouState is ForYouInitial) {
          store.dispatch(FollowingAction(FollowingForYouRequest(1, 1)));
        }
      },
      distinct: true,
      onWillChange: (oldVM, newVM) {
        _onFollowingStateChanged(
            newVM == null ? oldVM._forYouState : newVM._forYouState);
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
              itemBuilder: (context, index) =>
                  ProductItemWidget(product: products[index]),
            ),
            onRefresh: () => vm._load(1),
            onLoading: () => vm._load(currentPage + 1),
            controller: _refreshController,
          ),
        );
      },
    );
  }

  void _onFollowingStateChanged(ForYouState state) {
    if(state is ForYouInitial){
      _refreshController.requestRefresh();
    }else if (state is ForYouSuccess) {
      setState(() {
        if ((state).supply.currentPage == 1) {
          products = (state).supply.list;
        } else {
          products.addAll((state).supply.list);
        }
        currentPage = (state).supply.currentPage;
        enablePullUp = (state).supply.currentPage !=
            (state).supply.totalPage;
      });
      _refreshController.refreshCompleted();
    } else if (state is ForYouFailure) {
      _refreshController.refreshCompleted();
      EasyLoading.showToast((state).message);
    }
  }
}

class _ViewModel {
  final ForYouState _forYouState;
  final Function(int) _load;

  _ViewModel(this._forYouState, this._load);

  static _ViewModel fromStore(Store<AppState> store) {
    void _load(int page) {
      store.dispatch(ForYouAction(FollowingForYouRequest(1, page, limit: 10)));
    }

    return _ViewModel(store.state.forYouState, _load);
  }
}
