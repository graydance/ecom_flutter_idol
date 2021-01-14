import 'package:flustars/flustars.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:idol/models/dashboard.dart';
import 'package:idol/models/models.dart';
import 'package:idol/net/request/base.dart';
import 'package:idol/res/colors.dart';
import 'package:idol/router.dart';
import 'package:idol/store/actions/actions_dashboard.dart';
import 'package:redux/redux.dart';
import 'package:idol/models/appstate.dart';

class DashboardPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return DashboardPageState();
  }
}

class DashboardPageState extends State<DashboardPage>
    with SingleTickerProviderStateMixin, AutomaticKeepAliveClientMixin  {
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
    print('DashboardPageState build...');
    return StoreConnector<AppState, _ViewModel>(
      converter: _ViewModel.fromStore,
      distinct: true,
      onInit: (Store<AppState> store){
        StoreProvider.of<AppState>(context).dispatch(
            DashboardAction(BaseRequestImpl()));
      },
      builder: (context, vm) => Container(
        margin: EdgeInsets.only(top: 30),
        alignment: Alignment.topCenter,
        color: Colours.color_F8F8F8,
        child: _createChildWidgetByState(vm.dashboardState),
      ),
    );
  }

  Widget _createChildWidgetByState(DashboardState state) {
    if (state is DashboardInitial) {
      return Center(
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(Colours.color_EA5228),
        ),
      );
    } else if (state is DashboardSuccess) {
      var dashboard = (state).dashboard;
      return Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // $1,516.23
          GestureDetector(
            onTap: () => IdolRoute.startDashboardBalance(context),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  dashboard.monetaryUnit +
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
                  dashboard.monetaryUnit +
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
                  top: 20, left: 0, right: 0, bottom: 40),
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
    } else if (state is DashboardFailure) {
      Center(
        child: Text('Error!',style: TextStyle(color: Colours.color_ED3544, fontSize: 20),),
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
    return Container(
        padding: EdgeInsets.only(left: 20, right: 20, top: 24),
        child: ListView.separated(
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
        ));
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
                            color: Colours.color_555764,
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
                        reward.monetaryUnit +
                            TextUtil.formatDoubleComma3(
                                    reward.rewardCoins / 100)
                                .replaceAll(".0", ""),
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
                            Colours.color_F68A51,
                            Colours.color_EA5228,
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
  final List<PastSales> dataList;

  PastSalesTabView(this.dataList);

  @override
  State<StatefulWidget> createState() => _PastSalesTabViewSate(dataList);
}

class _PastSalesTabViewSate extends State<PastSalesTabView> {
  PageController _pageController;
  final List<PastSales> pastSales;

  _PastSalesTabViewSate(this.pastSales);

  var weekTableNames = const ['Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat'];
  var weekTableTextStyle = const TextStyle(
      fontSize: 12, color: Colours.color_0F1015, fontWeight: FontWeight.bold);

  List<Text> _getWeekText() {
    List<Text> weekTextList = [];
    weekTableNames.forEach((element) {
      weekTextList.add(Text(
        element,
        style: weekTableTextStyle,
      ));
    });
    return weekTextList;
  }

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colours.white,
      padding: EdgeInsets.only(top: 24),
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.only(top: 7, bottom: 7, left: 22, right: 22),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: _getWeekText(),
            ),
          ),
          Container(
            color: Colours.color_E7E8EC,
            padding: EdgeInsets.only(top: 7, bottom: 7, left: 22, right: 22),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'November 2020',
                  style: TextStyle(
                      color: Colours.color_0F1015,
                      fontSize: 14,
                      fontWeight: FontWeight.bold),
                ),
                Text(
                  '\$21,232.00',
                  style: TextStyle(
                      color: Colours.color_EA5228,
                      fontSize: 14,
                      fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
          Expanded(
            // PageView | ListView等可滑动的列表需要外层确定高度，否则会抛出 Vertical viewport was given unbounded height.异常
            child: PageView.builder(
              controller: _pageController,
              scrollDirection: Axis.vertical,
              physics: PageScrollPhysics(parent: BouncingScrollPhysics()),
              //onPageChanged: _,
              itemCount: pastSales.length,
              itemBuilder: (context, index) {
                return _buildCalendarPage(pastSales[index]);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCalendarPage(PastSales pastSales) {
    return Padding(
      padding: EdgeInsets.all(11),
      child: GridView.count(
        crossAxisCount: 7,
        crossAxisSpacing: 0.0,
        mainAxisSpacing: 0.0,
        childAspectRatio: 1.0,
        physics: NeverScrollableScrollPhysics(),
        children: pastSales.dailySales
            .asMap()
            .map((index, dailySale) {
              return MapEntry(
                  index,
                  Container(
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: Colours.white, //Colours.color_10EA5228,
                      shape: BoxShape.circle,
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          (index + 1).toString(),
                          style: TextStyle(
                            color: Colours.color_575859,
                            fontSize: 14,
                          ),
                        ),
                        Text(
                          pastSales.monetaryUnit +
                              TextUtil.formatDoubleComma3(dailySale / 100),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            color: Colours.color_C3C4C6,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ));
            })
            .values
            .toList(),
      ),
    );
  }

  void _onPageChanged() {}
}

class _ViewModel {
  final DashboardState dashboardState;

  _ViewModel(this.dashboardState);

  static _ViewModel fromStore(Store<AppState> store) {
    return _ViewModel(store.state.dashboardState);
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is _ViewModel &&
          runtimeType == other.runtimeType &&
          dashboardState == other.dashboardState;

  @override
  int get hashCode => dashboardState.hashCode;
}
