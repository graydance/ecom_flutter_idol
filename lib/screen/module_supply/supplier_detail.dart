import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:idol/models/arguments/supplier_detail.dart';
import 'package:idol/models/supplier.dart';
import 'package:idol/net/request/supply.dart';
import 'package:idol/r.g.dart';
import 'package:idol/res/colors.dart';
import 'package:idol/router.dart';
import 'package:idol/screen/module_supply/supplier_goods_tab_view.dart';
import 'package:idol/store/actions/supply.dart';
import 'package:idol/widgets/button.dart';
import 'package:idol/widgets/error.dart';
import 'package:redux/redux.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:idol/models/appstate.dart';
import 'package:idol/widgets/screen_loading.dart';

/// 供应商详情页
class SupplierDetailScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _SupplierDetailScreenState();
}

class _SupplierDetailScreenState extends State<SupplierDetailScreen>
    with SingleTickerProviderStateMixin<SupplierDetailScreen> {
  final GlobalKey _flexibleSpaceBarKey = GlobalKey();
  Size _sizeFlexibleSpaceBar;

  String _supplierId;
  TabController _tabController;
  int _currentTabIndex = 0;
  var _leftTabIcon = R.image.ic_tab_supplier_hot_product_selected();
  var _rightTabIcon = R.image.ic_tab_supplier_new_product_unselected();

  getSizeAndPosition() {
    RenderBox _cardBox = _flexibleSpaceBarKey.currentContext.findRenderObject();
    _sizeFlexibleSpaceBar = _cardBox.size;
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => getSizeAndPosition());
    Future.delayed(Duration(microseconds: 1)).then((value) {
      setState(() {});
    });
    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(() {
      if (_tabController.index != _currentTabIndex) {
        _currentTabIndex = _tabController.index;
        setState(() {
          if (_tabController.index == 0) {
            _leftTabIcon = R.image.ic_tab_supplier_hot_product_selected();
            _rightTabIcon = R.image.ic_tab_supplier_new_product_unselected();
          } else {
            _leftTabIcon = R.image.ic_tab_supplier_hot_product_unselected();
            _rightTabIcon = R.image.ic_tab_supplier_new_product_selected();
          }
        });
      }
    });
  }

  Widget _copyFlexibleSpaceWidget() {
    // 将头部控件设置为透明，通过短暂渲染显示获取到其他高度后再赋值
    return Opacity(
      key: _flexibleSpaceBarKey,
      opacity: 0.0,
      child: _buildFlexibleSpaceWidget(null),
    );
  }

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, _ViewModel>(
      converter: _ViewModel.fromStore,
      onInit: (store) {
        SupplierDetailArguments argument = store.state.supplierDetailArguments;
        if (argument.supplierId == null) {
          EasyLoading.showToast('SupplierId is null.');
          IdolRoute.pop(context);
        } else {
          _supplierId = argument.supplierId;
          store.dispatch(SupplierInfoAction(SupplierInfoRequest(_supplierId)));
        }
      },
      distinct: true,
      onWillChange: (oldVM, newVM) {
        _onSupplierDetailStateChanged(newVM == null
            ? oldVM._supplierInfoState
            : newVM._supplierInfoState);
      },
      builder: (context, vm) {
        return Scaffold(
          body: _buildBodyWidget(vm),
        );
      },
    );
  }

  Widget _buildBodyWidget(_ViewModel vm) {
    if (vm._supplierInfoState is SupplierInfoInitial ||
        vm._supplierInfoState is SupplierInfoLoading) {
      return Center(
        child: Stack(
          alignment: Alignment.center,
          children: [
            _copyFlexibleSpaceWidget(),
            ScreenLoadingWidget(),
          ],
        ),
      );
    } else if (vm._supplierInfoState is SupplierInfoFailure) {
      return IdolErrorWidget(() {
        // Retry supplierInfo.
        vm._supplierInfo(_supplierId);
      });
    } else {
      return NestedScrollView(
        headerSliverBuilder: (context, innerBoxIsScrolled) {
          return [
            SliverAppBar(
              leading: IconButton(
                icon: Icon(
                  Icons.arrow_back_ios,
                  color: Colours.color_444648,
                  size: 16,
                ),
                onPressed: () => IdolRoute.pop(context),
              ),
              titleSpacing: 0,
              elevation: 1,
              floating: true,
              pinned: true,
              snap: false,
              title: Text('Supplier',
                  style: TextStyle(
                    color: Colours.color_29292B,
                    fontSize: 16.0,
                  )),
              // 如何动态计算该高度，详情参考[https://github.com/flutter/flutter/issues/18345]
              expandedHeight: _sizeFlexibleSpaceBar.height,
              flexibleSpace: FlexibleSpaceBar(
                background: _buildFlexibleSpaceWidget(vm),
              ),
            ),
            SliverPersistentHeader(
              pinned: true,
              delegate: _SliverAppBarDelegate(
                TabBar(
                  controller: _tabController,
                  indicatorColor: Colours.color_1E2539,
                  tabs: [
                    Padding(
                      padding: EdgeInsets.only(top: 16, bottom: 10),
                      child: Image(
                        image: _leftTabIcon,
                        width: 20,
                        height: 20,
                        fit: BoxFit.cover,
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 16, bottom: 10),
                      child: Image(
                        image: _rightTabIcon,
                        width: 20,
                        height: 20,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ];
        },
        body: Container(
          child: TabBarView(
            controller: _tabController,
            children: [
              SupplierGoodsTabView(_supplierId, 0),
              SupplierGoodsTabView(_supplierId, 1),
            ].toList(),
          ),
        ),
      );
    }
  }

  double _getMarginTopHeight() {
    return MediaQuery.of(context).padding.top + kToolbarHeight;
  }

  Widget _buildFlexibleSpaceWidget(_ViewModel vm) {
    Supplier supplier = vm == null
        ? Supplier()
        : (vm._supplierInfoState as SupplierInfoSuccess).supplier;
    return Container(
      margin: EdgeInsets.only(top: _getMarginTopHeight()),
      padding: EdgeInsets.only(left: 16, right: 16, top: 13, bottom: 13),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            supplier.supplierName,
            style: TextStyle(color: Colours.color_29292B, fontSize: 20),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding:
                    EdgeInsets.only(left: 14, right: 14, top: 10, bottom: 10),
                child: Column(
                  children: [
                    Text(
                      supplier.products.toString() ?? '-',
                      style:
                          TextStyle(color: Colours.color_29292B, fontSize: 14),
                    ),
                    Text(
                      'Products',
                      style:
                          TextStyle(color: Colours.color_575859, fontSize: 12),
                    ),
                  ],
                ),
              ),
              Padding(
                padding:
                    EdgeInsets.only(left: 14, right: 14, top: 10, bottom: 10),
                child: Column(
                  children: [
                    Text(
                      supplier.follows.toString() ?? '-',
                      style:
                          TextStyle(color: Colours.color_29292B, fontSize: 14),
                    ),
                    Text(
                      'Followers',
                      style:
                          TextStyle(color: Colours.color_575859, fontSize: 12),
                    ),
                  ],
                ),
              ),
              Padding(
                padding:
                    EdgeInsets.only(left: 14, right: 14, top: 10, bottom: 10),
                child: Column(
                  children: [
                    Text(
                      supplier.sold.toString() ?? '-',
                      style:
                          TextStyle(color: Colours.color_29292B, fontSize: 14),
                    ),
                    Text(
                      'Sold',
                      style:
                          TextStyle(color: Colours.color_575859, fontSize: 12),
                    ),
                  ],
                ),
              ),
            ],
          ),
          Wrap(
            alignment: WrapAlignment.center,
            spacing: 10,
            children: supplier.tag.map((tag) {
              return Container(
                padding: EdgeInsets.only(left: 2, right: 2, top: 1, bottom: 1),
                decoration: BoxDecoration(
                  color: Colours.white,
                  borderRadius: BorderRadius.all(Radius.circular(4)),
                  border: Border.all(color: Colours.color_48B6EF, width: 1),
                ),
                child: Text(
                  tag.interestName,
                  style: TextStyle(color: Colours.color_48B6EF, fontSize: 12),
                ),
              );
            }).toList(),
          ),
          SizedBox(
            height: 10,
          ),
          Text(
            vm == null
                ? 'Test data, Test data,Test data, Test data,Test data, Test data,Test data, Test data,Test data, Test data,Test data, Test data,Test data, Test data,Test data, Test data,'
                : supplier.description ??
                    "The guy was lazy and didn't fill in anything",
            style: TextStyle(color: Colours.color_B1B2B3, fontSize: 12),
            textAlign: TextAlign.start,
          ),
          FollowButton(
            _supplierId,
            defaultFollowStatus: supplier.followStatus == 0
                ? FollowStatus.unFollow
                : FollowStatus.followed,
            width: 123,
            height: 30,
          ),
        ],
      ),
    );
  }

  void _onSupplierDetailStateChanged(SupplierInfoState state) {
    if (state is SupplierInfoFailure) {
      EasyLoading.showError((state).message);
    } else if (state is SupplierInfoInitial || state is SupplierInfoLoading) {
      EasyLoading.show(status: 'Loading...');
    } else if (state is SupplierInfoSuccess) {
      EasyLoading.dismiss();
    }
  }
}

class _SliverAppBarDelegate extends SliverPersistentHeaderDelegate {
  _SliverAppBarDelegate(this._tabBar);

  final TabBar _tabBar;

  @override
  double get minExtent => _tabBar.preferredSize.height;

  @override
  double get maxExtent => _tabBar.preferredSize.height;

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return new Container(
      color: Colours.white,
      child: _tabBar,
    );
  }

  @override
  bool shouldRebuild(_SliverAppBarDelegate oldDelegate) {
    return true;
  }
}

class _ViewModel {
  final SupplierInfoState _supplierInfoState;
  final Function(String) _supplierInfo;

  _ViewModel(this._supplierInfoState, this._supplierInfo);

  static _ViewModel fromStore(Store<AppState> store) {
    void _supplierInfo(String supplierId) {
      store.dispatch(SupplierInfoAction(SupplierInfoRequest(supplierId)));
    }

    return _ViewModel(store.state.supplierInfoState, _supplierInfo);
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is _ViewModel &&
          runtimeType == other.runtimeType &&
          _supplierInfoState == other._supplierInfoState &&
          _supplierInfo == other._supplierInfo;

  @override
  int get hashCode => _supplierInfoState.hashCode ^ _supplierInfo.hashCode;
}
