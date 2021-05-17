import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:idol/event/app_event.dart';
import 'package:idol/event/supply_refresh.dart';
import 'package:idol/models/appstate.dart';
import 'package:idol/models/arguments/arguments.dart';
import 'package:idol/net/request/base.dart';
import 'package:idol/r.g.dart';
import 'package:idol/res/colors.dart';
import 'package:idol/screen/screens.dart';
import 'package:idol/store/actions/actions.dart';
import 'package:idol/utils/event_bus.dart';
import 'package:idol/utils/global.dart';
import 'package:idol/utils/keystore.dart';
import 'package:idol/utils/localStorage.dart';
import 'package:idol/widgets/SpeechBubble.dart';
import 'package:idol/widgets/dialog_welcome.dart';
import 'package:idol/widgets/tutorialOverlay.dart';
import 'package:redux/redux.dart';

/// 应用主页面
/// 对于当前页面缓存一级Page页面问题，可参考该[https://www.jb51.net/article/157680.htm]
class HomeScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with AutomaticKeepAliveClientMixin<HomeScreen>, TickerProviderStateMixin {
  int _selectedIndex = Global.homePageController.initialPage;
  int _lastClickTime = 0;
  final _storage = new FlutterSecureStorage();

  var _pages = [
    SupplyMVPPage(),
    DashboardMVPPage(),
    ShopLinkPage(),
    // InboxPage(),
    // BioLinksPage(),
    // StorePage(),
  ];

  static const _titles = <String>[
    'Olaak',
    'My Earnings',
    'Myshop',
    // 'Inbox',
    // 'Store'
  ];

  var _tabIconNormalPaths = <AssetImage>[
    R.image.ic_tab_supply_normal(),
    R.image.ic_tab_dashboard_normal(),
    R.image.ic_tab_biolinks_normal(),
    // R.image.ic_tab_inbox_normal(),
    // R.image.ic_tab_store_normal()
  ];

  var _tabIconSelectedPaths = <AssetImage>[
    R.image.ic_tab_supply_selected(),
    R.image.ic_tab_dashboard_selected(),
    R.image.ic_tab_biolinks_selected(),
    // R.image.ic_tab_inbox_selected(),
    // R.image.ic_tab_store_selected(),
  ];

  Widget _buildNavigationBarItemIcon(int index, bool active) {
    final imageView = index != 2
        ? Image(
            image: active
                ? _tabIconSelectedPaths[index]
                : _tabIconNormalPaths[index],
            width: 30,
            height: 30,
          )
        : ScaleTransition(
            scale: _scaleMyShop,
            child: Image(
              image: active
                  ? _tabIconSelectedPaths[index]
                  : _tabIconNormalPaths[index],
              width: 30,
              height: 30,
            ),
          );
    return Column(children: [
      imageView,
      Text(
        _titles[index],
        style: active
            ? Theme.of(context).textTheme.caption.copyWith(color: Colors.black)
            : Theme.of(context).textTheme.caption,
      )
    ]);
  }

  var lastPopTime = DateTime.now();

  void intervalClick(int needTime, int index) {
    // 防重复提交
    if (lastPopTime == null ||
        DateTime.now().difference(lastPopTime) > Duration(seconds: needTime)) {
      print(lastPopTime);
      lastPopTime = DateTime.now();

      eventBus.fire(SupplyRefresh(SupplyRefreshEvent(index)));
    }
  }

  AnimationController _animationController;
  String _pickImageURL = '';
  StreamSubscription<StartPickAnimation> eventBusFn;

  Animation<double> _scaleMyShop;
  AnimationController _myShopAnimationController;

  @override
  void initState() {
    _guideInit();
    super.initState();
    AppEvent.shared.report(event: AnalyticsEvent.dashboard_tab);

    _animationController = AnimationController(
      duration: Duration(milliseconds: 1500),
      vsync: this,
    );

    eventBusFn = eventBus.on<StartPickAnimation>().listen((event) {
      if (!mounted) return;
      _animationController.reset();
      setState(() {
        _pickImageURL = event.imageURL;
      });
      _animationController.forward();
    });

    _animationController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _myShopAnimationController.reset();
        _myShopAnimationController
            .forward()
            .then((value) => _myShopAnimationController.reverse());
      }
    });

    _myShopAnimationController = AnimationController(
      duration: Duration(milliseconds: 100),
      vsync: this,
    );

    _scaleMyShop = Tween(begin: 1.0, end: 1.4).animate(
      CurvedAnimation(
        parent: _myShopAnimationController,
        curve: Interval(
          0.0,
          1.0,
          curve: Curves.easeOut,
        ),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    eventBusFn.cancel();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return StoreConnector<AppState, _ViewModel>(
      converter: _ViewModel.fromStore,
      builder: (context, vm) => Scaffold(
        extendBodyBehindAppBar: true,
        extendBody: false,
        body: WillPopScope(
          child: Stack(
            children: [
              _createBody(),
              Positioned(
                bottom: -10,
                right: 25,
                child: StaggerAnimation(
                  controller: _animationController,
                  url: _pickImageURL,
                ),
              ),
              // Positioned(
              //   top: 50,
              //   child: TextButton(
              //     onPressed: () {
              //       _animationController.reset();
              //       _animationController.forward();
              //     },
              //     child: Text('Start'),
              //   ),
              // ),
            ],
          ),
          onWillPop: () async {
            var durTime =
                (DateTime.now().microsecondsSinceEpoch - _lastClickTime) / 1000;
            if (durTime > 2000) {
              _lastClickTime = DateTime.now().microsecondsSinceEpoch;
              EasyLoading.showToast("Tap again to exit");
              debugPrint("first click");
              return false;
            } else {
              debugPrint("second click");
              return true;
            }
          },
        ),
        bottomNavigationBar: _createBottomNavigationBar(),
      ),
    );
  }

  Widget _createBody() {
    return Container(
      //padding: EdgeInsets.only(bottom: 15,),
      child: PageView(
        controller: Global.homePageController,
        onPageChanged: (index) async {
          setState(() {
            _selectedIndex = index;
          });
          String guildValue = await _storage.read(key: KeyStore.GUIDE_STEP);
          if (index == 1) {
            AppEvent.shared.report(event: AnalyticsEvent.dashboard_tab);

            StoreProvider.of<AppState>(context)
                .dispatch(DashboardAction(BaseRequestImpl()));

            if (guildValue != "1" && guildValue != "6") {
              await _storage.write(key: KeyStore.GUIDE_STEP, value: "6");
            }
          } else if (index == 2) {
            AppEvent.shared.report(event: AnalyticsEvent.shoplink_tab);

            // (_pages[index] as ShopLinkPage).refreshData();
            if (guildValue != "2" && guildValue != "4" && guildValue != "6") {
              await _storage.write(key: KeyStore.GUIDE_STEP, value: "6");
            }
          } else if (index == 0) {
            AppEvent.shared.report(event: AnalyticsEvent.olaak_tab);

            if (guildValue != "3" && guildValue != "5" && guildValue != "6") {
              await _storage.write(key: KeyStore.GUIDE_STEP, value: "6");
            }
            _storage.read(key: KeyStore.GUIDE_STEP).then((value) => value == "5"
                ? showDialog(
                    context: context,
                    builder: (context) {
                      return FirstDialog(
                        onClose: () {
                          _storage.write(key: KeyStore.GUIDE_STEP, value: "6");
                        },
                      );
                    },
                    barrierDismissible: false,
                  )
                : "");
          }
        },
        children: _pages,
        physics: NeverScrollableScrollPhysics(),
      ),
    );
  }

  void _guideInit() async {
    String step = await _storage.read(key: KeyStore.GUIDE_STEP);
    if (step == "1" || step == "4") {
      Global.tokShopLink.currentState.show();
    }
  }

  Widget _createBottomNavigationBar() {
    return Container(
      decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
                offset: Offset(0, -2.0),
                color: Colours.color_10777777,
                blurRadius: 1.0,
                spreadRadius: 1.0),
          ],
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(30), topRight: Radius.circular(30))),
      child: BottomNavigationBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: _buildNavigationBarItemIcon(0, false), // Dashboard
            activeIcon: _buildNavigationBarItemIcon(0, true),
            label: _titles[0],
          ),
          BottomNavigationBarItem(
            icon: _buildNavigationBarItemIcon(1, false), // Supply
            activeIcon: _buildNavigationBarItemIcon(1, true),
            label: _titles[1],
          ),
          BottomNavigationBarItem(
            icon: TutorialOverlay(
                key: Global.tokShopLink,
                handPosition: Position.LEFT,
                bubbleText: 'Click to check shopfront.',
                bubbleNipPosition: NipLocation.BOTTOM_RIGHT,
                clipCircle: true,
                clipBg: Colors.white,
                bubbleWidth: 200,
                clipPadding: 10,
                clipCircleOnTap: () async {
                  Global.tokShopLink.currentState.hide();
                  String step = await _storage.read(key: KeyStore.GUIDE_STEP);
                  if (step == "1") {
                    await _storage.write(key: KeyStore.GUIDE_STEP, value: "2");
                    Future.delayed(Duration(milliseconds: 100), () {
                      Global.tokAddAndShare.currentState.show();
                    });
                  } else {
                    await _storage.write(key: KeyStore.GUIDE_STEP, value: "4");
                    Future.delayed(Duration(milliseconds: 100), () {
                      Global.tokCopy.currentState.show();
                    });
                  }

                  Global.homePageController.jumpToPage(2);
                },
                builder: (ctx) =>
                    _buildNavigationBarItemIcon(2, false)), // Inbox
            activeIcon: _buildNavigationBarItemIcon(2, true),
            label: _titles[2],
          ),
          /*BottomNavigationBarItem(
            icon: _buildNavigationBarItemIcon(3, false), // BioLinks
            activeIcon: _buildNavigationBarItemIcon(3, true),
            label: _titles[3],
          ),
          BottomNavigationBarItem(
            icon: _buildNavigationBarItemIcon(4, false), // Store
            activeIcon: _buildNavigationBarItemIcon(4, true),
            label: _titles[4],
          ),*/
        ],
        type: BottomNavigationBarType.fixed,
        showSelectedLabels: false,
        showUnselectedLabels: false,
        unselectedItemColor: Colours.color_979AA9,
        unselectedFontSize: 0,
        selectedItemColor: Colours.color_0F1015,
        selectedFontSize: 0,
        currentIndex: _selectedIndex,
        onTap: (index) {
          if (index == 0 && _selectedIndex == 0) {
            intervalClick(1, index);
          }

          Global.homePageController.jumpToPage(index);
        },
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}

class _ViewModel {
  final HomeTabArguments _homeTabArguments;

  _ViewModel(this._homeTabArguments);

  static _ViewModel fromStore(Store<AppState> store) {
    return _ViewModel(store.state.homeTabArguments);
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is _ViewModel &&
          runtimeType == other.runtimeType &&
          _homeTabArguments == other._homeTabArguments;

  @override
  int get hashCode => _homeTabArguments.hashCode;
}

// ignore: must_be_immutable
class StaggerAnimation extends StatelessWidget {
  StaggerAnimation({Key key, this.controller, this.url}) : super(key: key) {
    scale = Tween(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: controller,
        curve: Interval(
          0.0, 0.3, //间隔，前40%的动画时间
          curve: Curves.easeOutBack,
        ),
      ),
    );

    bottom = Tween(begin: 20.0, end: -50.0).animate(
      CurvedAnimation(
        parent: controller,
        curve: Interval(
          0.9, 1.0, //间隔，后20%的动画时间
          curve: Curves.easeOut,
        ),
      ),
    );
  }

  final AnimationController controller;
  final String url;
  Animation<double> opacity;
  Animation<double> bottom;
  Animation<double> scale;

  Widget _buildAnimation(BuildContext context, Widget child) {
    return Container(
      height: 100,
      width: 50,
      child: Stack(
        children: [
          Positioned(
            bottom: bottom.value,
            child: Transform.scale(
              scale: scale.value,
              child: Container(
                decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black54,
                      offset: Offset(3.0, 3.0),
                      blurRadius: 10.0, // 阴影模糊程度
                      spreadRadius: 1.0, // 阴影扩散程度
                    ),
                  ],
                ),
                child: CachedNetworkImage(
                  imageUrl: url,
                  width: 40,
                  height: 40,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      builder: _buildAnimation,
      animation: controller,
    );
  }
}
