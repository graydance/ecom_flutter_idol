import 'dart:async';

import 'package:flustars/flustars.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:idol/utils/localStorage.dart';
import 'package:idol/conf.dart';
import 'package:idol/models/models.dart';
import 'package:idol/net/request/base.dart';
import 'package:idol/net/request/dashboard.dart';
import 'package:idol/r.g.dart';
import 'package:idol/res/colors.dart';
import 'package:idol/router.dart';
import 'package:idol/screen/module_dashboard/best_sales_tab_view.dart';
import 'package:idol/screen/module_dashboard/pastsales_tab_view.dart';
import 'package:idol/store/actions/actions.dart';
import 'package:idol/store/actions/dashboard.dart';
import 'package:idol/utils/global.dart';
import 'package:idol/utils/keystore.dart';
import 'package:idol/widgets/dialog_tips_guide.dart';
import 'package:idol/widgets/error.dart';
import 'package:idol/widgets/loading.dart';
import 'package:redux/redux.dart';
import 'package:idol/models/appstate.dart';
import 'package:super_tooltip/super_tooltip.dart';

class DashboardMVPPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _DashboardMVPPageState();
}

class _DashboardMVPPageState extends State<DashboardMVPPage>
    with
        AutomaticKeepAliveClientMixin<DashboardMVPPage>,
        SingleTickerProviderStateMixin {
  TabController _tabController;
  bool _isShowedHowToMakeMoneyDialog = false;

  static final _storage = new FlutterSecureStorage();
  SuperTooltip _tooltip;
  Timer _toopTipTimer;

  final List<String> _tabValues = [
    'Past Sales',
    'Best Sales',
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
        store.dispatch(DashboardAction(BaseRequestImpl()));
      },
      onWillChange: (oldVM, newVM) {
        _onStateChanged(
            newVM == null ? newVM._dashboardState : oldVM._dashboardState,
            newVM == null
                ? newVM._completeRewardsState
                : oldVM._completeRewardsState);
      },
      builder: (context, vm) => WillPopScope(
        onWillPop: _willPopCallback,
        child: Container(
          color: Colours.color_F8F8F8,
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              AppBar(
                title: Text('Dashboard'),
                centerTitle: true,
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

  void _showHowToMakeMoneyDialog(bool check) async {
    String neverShowHowToMakeDialog =
        await _storage.read(key: KeyStore.NEVER_SHOW_HOW_TO_MAKE_MONEY_DIALOG);
    if (check &&
        (_isShowedHowToMakeMoneyDialog || 'true' == neverShowHowToMakeDialog)) {
      debugPrint(
          '_showHowToMakeMoneyDialog >>> $_isShowedHowToMakeMoneyDialog | $neverShowHowToMakeDialog');
      return;
    }
    _isShowedHowToMakeMoneyDialog = true;
    showDialog(
      context: context,
      builder: (context) {
        return TipsGuideDialog(
          KeyStore.NEVER_SHOW_HOW_TO_MAKE_MONEY_DIALOG,
          'How to make money\nwith Olaak',
          '1. Select and add products in Supply panel.\n2. Add Shop Link to your bio in Socials.\n3. Share great post in your socials.\n4. Get your earnings after sales.(we cover all shopping and service)',
          videoUrls[0],
          buttonText: 'Select Now',
          onTap: () {
            IdolRoute.pop(context);
            StoreProvider.of<AppState>(context)
                .dispatch(ChangeHomePageAction(0));
          },
          onClose: () {
            IdolRoute.pop(context);
          },
        );
      },
      barrierDismissible: false,
    );
  }

  Future<bool> _willPopCallback() async {
    // If the tooltip is open we don't pop the page on a backbutton press
    // but close the ToolTip
    if (_tooltip.isOpen) {
      _tooltip.close();
      _cancelToolTipTimer();
      return false;
    }
    return true;
  }

  void _showEarningTip(BuildContext context) {
    _cancelToolTipTimer();

    if (_tooltip != null && _tooltip.isOpen) {
      _tooltip.close();
      return;
    }

    var renderBox = context.findRenderObject() as RenderBox;
    final overlay = Overlay.of(context).context.findRenderObject() as RenderBox;

    var targetGlobalCenter = renderBox
        .localToGlobal(renderBox.size.center(Offset.zero), ancestor: overlay);

    // We create the tooltip on the first use
    _tooltip = SuperTooltip(
      popupDirection: TooltipDirection.down,
      arrowTipDistance: 20.0,
      arrowBaseWidth: 8.0,
      arrowLength: 4.0,
      borderWidth: 0,
      borderColor: Colors.white,
      shadowColor: Colours.color_black15,
      maxWidth: 200.0,
      showCloseButton: ShowCloseButton.none,
      hasShadow: true,
      touchThrougArea: Rect.fromLTWH(targetGlobalCenter.dx - 70,
          targetGlobalCenter.dy + 100, 140.0, 160.0),
      touchThroughAreaShape: ClipAreaShape.rectangle,
      content: Text(
        'The total amount of money you’ve earned on this app.',
        style: TextStyle(
          color: Colors.black,
          fontSize: 12,
          decoration: TextDecoration.none,
        ),
        softWrap: true,
      ),
    );

    _tooltip.show(context);
    _toopTipTimer = Timer(Duration(seconds: 3), () {
      if (_tooltip != null && _tooltip.isOpen) {
        _tooltip.close();
      }
    });
  }

  _cancelToolTipTimer() {
    if (_toopTipTimer != null) _toopTipTimer.cancel();
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
                // 切换到Supply
                IdolRoute.sendArguments(context, HomeTabArguments(tabIndex: 0));
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
                Icon(
                  Icons.keyboard_arrow_right,
                  color: Colours.color_979AA9,
                )
              ],
            ),
          ),

          // Lifetime Earnings
          Builder(
            builder: (ctx) => GestureDetector(
              onTap: () {
                _showEarningTip(ctx);
              },
              child: Container(
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
                    Padding(
                      padding: const EdgeInsets.only(
                        left: 4,
                        right: 8,
                      ),
                      child: Image(
                        image: R.image.ic_earnings_tip(),
                        width: 15,
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
            ),
          ),

          // Invite friends to receive extra earnings
          GestureDetector(
            onTap: () {
              _showHowToMakeMoneyDialog(false);
            },
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'How to make money with Olaak',
                  style: TextStyle(
                    color: Colours.color_0F1015,
                    fontSize: 12,
                  ),
                ),
                SizedBox(
                  width: 4,
                ),
                Image(
                  image: R.image.ic_help(),
                  width: 15,
                ),
              ],
            ),
          ),

          // Rewards | Past Sales
          Expanded(
            child: Container(
              margin: EdgeInsets.only(top: 33),
              padding: EdgeInsets.only(top: 20),
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
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TabBar(
                    tabs: _tabValues.map((title) {
                      return Text(
                        title,
                        style: TextStyle(fontWeight: FontWeight.bold),
                      );
                    }).toList(),
                    isScrollable: true,
                    controller: _tabController,
                    indicatorColor: Colours.color_EA5228,
                    indicatorSize: TabBarIndicatorSize.label,
                    unselectedLabelColor: Colours.color_B1B1B3,
                    labelColor: Colours.color_29292B,
                    labelStyle: TextStyle(fontSize: 16),
                  ),
                  Expanded(
                    child: TabBarView(
                      controller: _tabController,
                      children: [
                        PastSalesTabView(
                          dashboard.pastSales,
                        ),
                        BestSalesTabView(),
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
      EasyLoading.showToast(
          (_viewModel._dashboardState as DashboardFailure).message);
      return IdolErrorWidget(() {
        _viewModel._load();
      });
    } else {
      return IdolLoadingWidget();
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
  final Function _load;
  final CompleteRewardsState _completeRewardsState;
  final Function(String) _completeRewards;

  _ViewModel(this._dashboardState, this._completeRewardsState,
      this._completeRewards, this._load);

  static _ViewModel fromStore(Store<AppState> store) {
    void _completeRewards(String rewardId) {
      store.dispatch(CompleteRewardsAction(CompleteRewardsRequest(rewardId)));
    }

    void _load() {
      store.dispatch(DashboardAction(BaseRequestImpl()));
    }

    return _ViewModel(store.state.dashboardState,
        store.state.completeRewardsState, _completeRewards, _load);
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is _ViewModel &&
          runtimeType == other.runtimeType &&
          _dashboardState == other._dashboardState &&
          _completeRewardsState == other._completeRewardsState &&
          _completeRewards == other._completeRewards;

  @override
  int get hashCode =>
      _dashboardState.hashCode ^
      _completeRewardsState.hashCode ^
      _completeRewards.hashCode;
}
