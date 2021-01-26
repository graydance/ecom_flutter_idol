import 'package:flustars/flustars.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:idol/models/arguments/rewards_detail.dart';
import 'package:idol/models/models.dart';
import 'package:idol/net/request/base.dart';
import 'package:idol/net/request/dashboard.dart';
import 'package:idol/res/colors.dart';
import 'package:idol/router.dart';
import 'package:idol/screen/module_dashboard/pastsales_tab_view.dart';
import 'package:idol/screen/module_dashboard/rewards_tab_view.dart';
import 'package:idol/store/actions/actions.dart';
import 'package:idol/store/actions/dashboard.dart';
import 'package:idol/utils/global.dart';
import 'package:redux/redux.dart';
import 'package:idol/models/appstate.dart';

class DashboardPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage>
    with
        AutomaticKeepAliveClientMixin<DashboardPage>,
        SingleTickerProviderStateMixin {
  TabController _tabController;

  final List<String> _tabValues = [
    'Rewards',
    'Past Sales',
  ];

  @override
  void initState() {
    _tabController = TabController(
      length: _tabValues.length,
      vsync: this, //ScrollableState(),
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return StoreConnector<AppState, _ViewModel>(
      converter: _ViewModel.fromStore,
      distinct: true,
      onInit: (Store<AppState> store) {
        StoreProvider.of<AppState>(context)
            .dispatch(DashboardAction(BaseRequestImpl()));
      },
      onWillChange: (oldVM, newVM) {
        _onStateChanged(
            newVM == null ? newVM._dashboardState : oldVM._dashboardState,
            newVM == null
                ? newVM._completeRewardsState
                : oldVM._completeRewardsState);
      },
      builder: (context, vm) => Container(
        color: Colours.color_F8F8F8,
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            AppBar(
              title: Text('Dashboard'),
              elevation: 0,
              primary: true,
            ),
            SizedBox(
              height: 30,
            ),
            Expanded(child: _createChildWidgetByState(vm)),
          ],
        ),
      ),
    );
  }

  void _onStateChanged(DashboardState state, CompleteRewardsState state2) {
    if (state is DashboardFailure) {
      EasyLoading.showToast((state).message);
    }
    if (state2 is CompleteRewardsFailure) {
      EasyLoading.showToast((state2).message);
    }
  }

  Widget _createChildWidgetByState(_ViewModel _viewModel) {
    if (_viewModel._dashboardState is DashboardSuccess) {
      var dashboard =
          (_viewModel._dashboardState as DashboardSuccess).dashboard;
      return Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // $1,516.23
          GestureDetector(
            onTap: () => IdolRoute.startDashboardBalance(context).then((value) {
              if (value != null) {
                // TODO 切换到选品页

              }
            }),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  Global.getUser(context).monetaryUnit +
                      _decimalFormat(dashboard.availableBalance),
                  style: TextStyle(
                    fontSize: 35,
                    fontWeight: FontWeight.bold,
                    color: Colours.color_EA5228,
                  ),
                ),
                Icon(Icons.keyboard_arrow_right)
              ],
            ),
          ),

          // Lifetime Earnings
          Container(
            margin: EdgeInsets.only(top: 20, bottom: 20),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Lifetime Earnings',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colours.color_A9A9A9,
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(left: 8, right: 16),
                  child: Icon(
                    Icons.help,
                    size: 15,
                  ),
                ),
                Text(
                  Global.getUser(context).monetaryUnit +
                      _decimalFormat(dashboard.lifetimeEarnings),
                  style: TextStyle(
                    fontSize: 16,
                    color: Colours.color_EA5228,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),

          // Invite friends to receive extra earnings
          Container(
            padding: EdgeInsets.only(left: 11, top: 4, right: 11, bottom: 4),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(13)),
              color: Colours.color_FFD8B1,
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding:
                      EdgeInsets.only(left: 3, top: 2, right: 3, bottom: 2),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        Colours.color_EA5228,
                        Colours.color_FFD8B1,
                      ],
                    ),
                    borderRadius: BorderRadius.only(
                        topRight: Radius.circular(11),
                        bottomLeft: Radius.circular(11)),
                  ),
                  child: Text(
                    'Early Bird',
                    style: TextStyle(color: Colors.white, fontSize: 8),
                  ),
                ),
                Text(
                  ' Invite friends to receive extra earnings! >',
                  style: TextStyle(
                    color: Colours.color_555764,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),

          // Rewards | Past Sales
          Expanded(
            child: Container(
              margin: EdgeInsets.only(top: 33),
              padding: EdgeInsets.only(top: 20, left: 0, right: 0, bottom: 40),
              decoration: BoxDecoration(
                color: Colors.white,
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colours.white,
                    Colours.color_F8F8F8,
                  ],
                ),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(35),
                  topRight: Radius.circular(35),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colours.color_10777777,
                    offset: Offset(0.0, -1.0),
                    blurRadius: 10.0, // 阴影模糊程度
                    spreadRadius: 0.0, // 阴影扩散程度
                  ),
                ],
              ),
              child: Column(
                children: [
                  Container(
                    margin: EdgeInsets.only(left: 20, right: 20),
                    child: TabBar(
                      tabs: _tabValues.map((title) {
                        return Text(
                          title,
                          style: TextStyle(fontWeight: FontWeight.bold),
                        );
                      }).toList(),
                      isScrollable: false,
                      controller: _tabController,
                      indicatorColor: Colours.color_EA5228,
                      indicatorSize: TabBarIndicatorSize.label,
                      unselectedLabelColor: Colours.color_B1B1B3,
                      labelColor: Colours.color_29292B,
                      labelStyle: TextStyle(fontSize: 16),
                    ),
                  ),
                  Expanded(
                    child: TabBarView(
                      controller: _tabController,
                      children: [
                        RewardsTabView(
                          dashboard.rewardList,
                          (rewards) {
                            // 任务详情页
                            IdolRoute.startDashboardRewardsDetail(context, RewardsDetailArguments(reward: rewards));
                          },
                          (rewards) {
                            // 任务领取
                            _viewModel._completeRewards(rewards.id);
                          },
                        ),
                        PastSalesTabView(
                          dashboard.pastSales,
                        ),
                      ].toList(),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      );
    } else if (_viewModel._dashboardState is DashboardFailure) {
      // TODO 展示请求错误页面（包含重试按钮），待UI设计
      EasyLoading.showToast(
          (_viewModel._dashboardState as DashboardFailure).message);
      return Center(
        child: Text(
          (_viewModel._dashboardState as DashboardFailure).message,
          style: TextStyle(color: Colours.color_ED3544, fontSize: 20),
        ),
      );
    } else {
      return Center(
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(Colours.color_EA5228),
        ),
      );
    }
  }

  String _decimalFormat(int money) {
    /// 1,234,567.00
    return TextUtil.formatDoubleComma3(money / 100);
  }

  @override
  bool get wantKeepAlive => true;
}

class _ViewModel {
  final DashboardState _dashboardState;
  final CompleteRewardsState _completeRewardsState;
  final Function(String) _completeRewards;

  _ViewModel(this._dashboardState, this._completeRewardsState,
      this._completeRewards);

  static _ViewModel fromStore(Store<AppState> store) {
    _completeRewards(String rewardId) {
      store.dispatch(CompleteRewardsAction(CompleteRewardsRequest(rewardId)));
    }

    return _ViewModel(
        store.state.dashboardState,
        store.state.completeRewardsState,
        _completeRewards);
  }
}
