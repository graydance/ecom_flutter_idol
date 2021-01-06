import 'package:flustars/flustars.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:idol/models/dashboard.dart';
import 'package:idol/models/models.dart';
import 'package:idol/res/colors.dart';
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
        color: Colours.color_F8F8F8,
        child: vm.dashboard != null
            ? Column(
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
                          vm.dashboard.monetaryUnit +
                              _decimalFormat(vm.dashboard.lifetimeEarnings),
                          style: TextStyle(
                            fontSize: 16,
                            color: Colours.color_EA5228,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Invite frineds to receive extra earnings
                  Container(
                    padding:
                        EdgeInsets.only(left: 11, top: 4, right: 11, bottom: 4),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(13)),
                      color: Colours.color_FFD8B1,
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          padding: EdgeInsets.only(
                              left: 3, top: 2, right: 3, bottom: 2),
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
                          ' Invite frineds to receive extra earnings! >',
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
                      padding: EdgeInsets.only(
                          top: 20, left: 15, right: 15, bottom: 45),
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
              )
            : Center(
                child: CircularProgressIndicator(
                  valueColor:
                      AlwaysStoppedAnimation<Color>(Colours.color_EA5228),
                ),
              ),
      ),
    );
  }

  String _decimalFormat(double money) {
    /// 1,234,567.00
    return TextUtil.formatDoubleComma3(money);
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
  final Reward reward;

  const RewardsItem(this.reward);

  @override
  State<StatefulWidget> createState() => _RewardsItemState(reward);
}

class _RewardsItemState extends State<RewardsItem> {
  final Reward reward;

  _RewardsItemState(this.reward);

  bool _clickable() {
    return reward.rewardStatus == 1;
  }

  bool _unClickable() {
    return reward.rewardStatus == 2 || reward.rewardStatus == 3;
  }

  Color _cardBorderColor() {
    if (_clickable()) {
      return Colours.color_EA5228;
    }
    if (_unClickable()) {
      return Colours.color_EDEDF2;
    }
    return Colours.white;
  }

  Color _buttonBorderColor() {
    if (_unClickable()) {
      return Colours.color_EDEDF2;
    }
    return Colours.color_EA5228;
  }

  List<Color> _buttonLinearGradientColor() {
    if (_clickable()) {
      return [Colours.color_FA812B, Colours.color_F95453];
    }
    if (reward.rewardStatus == 0) {
      return [Colours.white, Colours.white];
    }
    return [Colours.color_EDEDF2, Colours.color_EDEDF2];
  }

  Color _buttonTextColor() {
    if (_clickable()) {
      return Colours.white;
    }
    if (reward.rewardStatus == 0) {
      return Colours.color_EA5228;
    }
    return Colours.color_B1B1B3;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Card(
        color: _unClickable() ? Colours.color_EDEDF2 : Colours.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(6)),
          side: BorderSide(
            color: _cardBorderColor(),
            width: 1,
          ),
        ),
        clipBehavior: Clip.antiAlias,
        // 抗锯齿
        elevation: 2,
        child: Stack(
          children: [
            Container(
              padding:
                  EdgeInsets.only(top: 15, bottom: 15, left: 20, right: 10),
              child: Row(
                children: [
                  ..._clickable()
                      ? [
                          Container(
                            margin: EdgeInsets.only(right: 10),
                            child: Icon(Icons.settings),
                          ),
                        ]
                      : [],
                  Expanded(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          reward.rewardTitle,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 14,
                            color: Color(0xFF555764),
                          ),
                        ),
                        Text(
                          reward.rewardDescription,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 14,
                            color: Colours.color_979AA9,
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
                        reward.rewardCoins,
                        style: TextStyle(
                          color: _buttonTextColor(),
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
                              colors: _buttonLinearGradientColor()),
                          border: Border.all(
                              color: _buttonBorderColor(), width: 1)),
                    ),
                  ),
                ],
              ),
            ),
            // 设置左上角Label
            ..._clickable()
                ? [
                    Container(
                      padding: EdgeInsets.only(
                          left: 10, top: 5, right: 10, bottom: 5),
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
                  ]
                : [],
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
