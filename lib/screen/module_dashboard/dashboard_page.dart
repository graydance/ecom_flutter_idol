import 'package:flustars/flustars.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:idol/models/dashboard.dart';
import 'package:idol/models/models.dart';
import 'package:redux/redux.dart';
import 'package:idol/models/appstate.dart';

class DashboardPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return DashboardPageState();
  }
}

class DashboardPageState extends State<DashboardPage>
    with SingleTickerProviderStateMixin {
  TabController _tabController;

  final List<String> _tabValues = [
    'Rewards',
    'Past Sales',
  ];

  @override
  void initState() {
    if (widget == null) {
      EasyLoading.show(status: 'loading...');
    }
    _tabController = TabController(
      length: _tabValues.length,
      vsync: this, //ScrollableState(),
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    print('DashboardPageState build...');
    return StoreConnector<AppState, _ViewModel>(
      converter: _ViewModel.fromStore,
      builder: (context, vm) => Container(
        margin: EdgeInsets.only(top: 30),
        alignment: Alignment.topCenter,
        color: Color(0xFFF8F8F8),
        child: vm.dashboard == null
            ? null
            : Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // $1,516.23
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        vm.dashboard.monetaryUnit +
                            _decimalFormat(vm.dashboard.availableBalance),
                        style: TextStyle(
                          fontSize: 35,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFFEA5228),
                        ),
                      ),
                      Icon(Icons.keyboard_arrow_right)
                    ],
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
                            color: Color(0xFFA9A9A9),
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
                          vm.dashboard.monetaryUnit +
                              _decimalFormat(vm.dashboard.lifetimeEarnings),
                          style: TextStyle(
                            fontSize: 16,
                            color: Color(0xFFEA5228),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Invite frineds to receive extra earnings
                  Container(
                    padding:
                        EdgeInsets.only(left: 16, top: 4, right: 16, bottom: 4),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(13)),
                      color: Color(0xFFFFD8B1),
                    ),
                    child: Text(
                      'Invite frineds to receive extra earnings! >',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                      ),
                    ),
                  ),

                  // Rewards | Past Sales
                  Expanded(
                    child: Container(
                      margin: EdgeInsets.only(top: 33),
                      padding: EdgeInsets.only(
                          top: 20, left: 15, right: 15, bottom: 45),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(35),
                          topRight: Radius.circular(35),
                        ),
                      ),
                      child: Column(
                        children: [
                          TabBar(
                            tabs: _tabValues.map((title) {
                              return Text(
                                title,
                                style: TextStyle(fontWeight: FontWeight.bold),
                              );
                            }).toList(),
                            isScrollable: false,
                            controller: _tabController,
                            indicatorColor: Color(0xFFEA5228),
                            indicatorSize: TabBarIndicatorSize.label,
                            unselectedLabelColor: Color(0xFFB1B1B3),
                            labelColor: Color(0xFF29292B),
                            labelStyle: TextStyle(fontSize: 16),
                          ),
                          Expanded(
                            child: Container(
                              margin: EdgeInsets.only(top: 24),
                              child: TabBarView(
                                controller: _tabController,
                                children: [
                                  RewardsTabView(
                                    vm.dashboard.rewardList,
                                  ),
                                  PastSalesTabView(),
                                ].toList(),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
      ),
    );
  }

  String _decimalFormat(double money) {
    /// 1,234,567.00
    return TextUtil.formatComma3(money);
  }
}

class RewardsTabView extends StatefulWidget {
  final List<Reward> list;

  const RewardsTabView(this.list);

  @override
  State<StatefulWidget> createState() => _RewardsTabViewState(list);
}

class _RewardsTabViewState extends State<RewardsTabView> {
  final List<Reward> list;
  _RewardsTabViewState(this.list);

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      scrollDirection: Axis.vertical,
      separatorBuilder: (context, index) {
        return Divider(
          height: 10,
          color: Colors.transparent,
        );
      },
      itemCount: list.length,
      itemBuilder: (context, index) {
        return RewardsItem(list[index]);
      },
    );
  }
}

class RewardsItem extends StatefulWidget {
  final Reward data;

  const RewardsItem(this.data);

  @override
  State<StatefulWidget> createState() => _RewardsItemState(data);
}

class _RewardsItemState extends State<RewardsItem> {
  final Reward data;

  _RewardsItemState(this.data);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Card(
        color: Color(0xFFF1F1F6),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(6)),
          side: BorderSide(
            color: Color(0xFFF27945),
            width: 1,
          ),
        ),
        clipBehavior: Clip.antiAlias, // 抗锯齿
        elevation: 2,
        child: Stack(
          children: [
            Container(
              padding:
                  EdgeInsets.only(top: 15, bottom: 15, left: 20, right: 10),
              child: Row(
                children: [
                  Container(
                    margin: EdgeInsets.only(right: 10),
                    child: Icon(Icons.settings),
                  ),
                  Expanded(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          data.rewardTitle,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 14,
                            color: Color(0xFF555764),
                          ),
                        ),
                        Text(
                          data.rewardDescription,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 14,
                            color: Color(0xFF979AA9),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    height: 36,
                    child: VerticalDivider(
                      width: 1,
                      color: Colors.grey,
                    ),
                    margin: EdgeInsets.only(left: 36),
                  ),
                  Container(
                    child: Container(
                      child: Text(
                        data.rewardCoins,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                        ),
                      ),
                      margin: EdgeInsets.only(left: 10),
                      padding: EdgeInsets.only(
                          left: 14, top: 4, right: 14, bottom: 4),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(12)),
                        gradient: LinearGradient(
                            begin: Alignment.centerLeft,
                            end: Alignment.centerRight,
                            colors: [Color(0xFFFA812B), Color(0xFFF95453)]),
                        color: Colors.green,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            // 设置左上角Label
            Container(
              padding: EdgeInsets.only(left: 10, top: 5, right: 10, bottom: 5),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Color(0xFFF68A51),
                    Color(0XFFEA5228),
                  ],
                ),
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(8),
                    bottomRight: Radius.circular(100)),
              ),
              child: Text(
                'COLLECT',
                style: TextStyle(color: Colors.white, fontSize: 8),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class PastSalesTabView extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _PastSalesTabViewSate();
}

class _PastSalesTabViewSate extends State<PastSalesTabView> {
  @override
  Widget build(BuildContext context) {
    return Text('TODO');
  }
}

class _ViewModel {
  final Dashboard dashboard;

  _ViewModel(this.dashboard);

  static _ViewModel fromStore(Store<AppState> store) {
    return _ViewModel(store.state.dashboard);
  }
}
