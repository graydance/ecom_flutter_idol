import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:idol/screen/module_dashboard/dashboard_page.dart';
import 'package:idol/screen/module_supply/supply_page.dart';
import 'package:idol/screen/module_inbox/inbox_page.dart';
import 'package:idol/screen/module_biolinks/biolinks_page.dart';
import 'package:idol/screen/module_store/store_page.dart';

class HomeScreen extends StatefulWidget {
  final void Function() onInit;
  HomeScreen({this.onInit});
  @override
  State<StatefulWidget> createState() {
    return HomeScreenState();
  }
}

class HomeScreenState extends State<HomeScreen>
    with AutomaticKeepAliveClientMixin {
  PageController _pageController;

  int _selectedIndex = 0;

  static const TextStyle optionStyle =
      TextStyle(fontSize: 30, fontWeight: FontWeight.bold);

  var _pages = <Widget>[
    DashboardPage(),
    SupplyPage(),
    InboxPage(),
    BioLinksPage(),
    StorePage(),
  ];

  static const _titles = <String>[
    'Dashboard',
    'Supply',
    'Inbox',
    'BioLinks',
    'Store'
  ];

  static const _tabIconNormalPaths = <String>[
    'assets/images/ic_tab_dashboard_normal.png',
    'assets/images/ic_tab_supply_normal.png',
    'assets/images/ic_tab_inbox_normal.png',
    'assets/images/ic_tab_biolinks_normal.png',
    'assets/images/ic_tab_store_normal.png'
  ];

  static const _tabIconSelectedPaths = <String>[
    'assets/images/ic_tab_dashboard_selected.png',
    'assets/images/ic_tab_supply_selected.png',
    'assets/images/ic_tab_inbox_selected.png',
    'assets/images/ic_tab_biolinks_selected.png',
    'assets/images/ic_tab_store_selected.png'
  ];

  Widget _buildNavigationBarItemIcon(int index, bool active) {
    return Image.asset(
      active ? _tabIconSelectedPaths[index] : _tabIconNormalPaths[index],
      width: 24,
      height: 24,
    );
  }

  @override
  void initState() {
    if (widget.onInit != null) widget.onInit();
    super.initState();
    _pageController = PageController();
  }

  @override
  void dispose() {
    super.dispose();
    _pageController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(_titles[_selectedIndex]),
        elevation: 0,
      ),
      extendBodyBehindAppBar: false, // 禁止延伸body至底部
      extendBody: true, // 延伸body至底部
      body: _pages[_selectedIndex],
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
            color: Colors.red,
            boxShadow: [
              BoxShadow(
                  offset: Offset(1.0, -1.0),
                  color: Colors.grey,
                  blurRadius: 1.0,
                  spreadRadius: -3.0),
            ],
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(30), topRight: Radius.circular(30))),
        child: BottomNavigationBar(
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
              icon: _buildNavigationBarItemIcon(2, false), // Inbox
              activeIcon: _buildNavigationBarItemIcon(2, true),
              label: _titles[2],
            ),
            BottomNavigationBarItem(
              icon: _buildNavigationBarItemIcon(3, false), // BioLinks
              activeIcon: _buildNavigationBarItemIcon(3, true),
              label: _titles[3],
            ),
            BottomNavigationBarItem(
              icon: _buildNavigationBarItemIcon(4, false), // Store
              activeIcon: _buildNavigationBarItemIcon(4, true),
              label: _titles[4],
            ),
          ],
          type: BottomNavigationBarType.fixed,
          showSelectedLabels: false,
          showUnselectedLabels: false,
          currentIndex: _selectedIndex,
          onTap: (index) => setState(() => _selectedIndex = index),
        ),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
