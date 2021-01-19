import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:idol/res/colors.dart';
import 'package:idol/router.dart';
import 'package:idol/screen/module_supply/following.dart';
import 'package:idol/screen/module_supply/foryou.dart';

class SupplyPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _SupplyPageState();
}

class _SupplyPageState extends State<SupplyPage>
    with SingleTickerProviderStateMixin<SupplyPage> {
  TabController _supplyTabController;

  static const List<String> _SupportTabValues = [
    'Following',
    'For You',
  ];

  @override
  void initState() {
    _supplyTabController = TabController(
      length: _SupportTabValues.length,
      vsync: this, //ScrollableState(),
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        color: Colours.color_F8F8F8,
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            Stack(
              alignment: Alignment.center,
              children: [
                AppBar(
                  actions: [
                    IconButton(
                        icon: Icon(
                          Icons.search,
                          color: Colours.color_444648,
                        ),
                        onPressed: () => IdolRoute.startSupplySearch(context)),
                  ],
                  elevation: 0,
                  title: SizedBox(child:TabBar(
                      tabs: _SupportTabValues.map((value) {
                        return Text(
                          value,
                        );
                      }).toList(),
                      isScrollable: true,
                      controller: _supplyTabController,
                      indicatorColor: Colours.color_EA5228,
                      indicatorSize: TabBarIndicatorSize.label,
                      labelColor: Colours.color_0F1015,
                      unselectedLabelColor: Colours.color_C4C5CD,
                      labelStyle:
                      TextStyle(fontSize: 20, color: Colours.color_0F1015),
                      unselectedLabelStyle:
                      TextStyle(fontSize: 16, color: Colours.color_C4C5CD),
                    ),
                    height: 30,
                  ),
                  centerTitle: true,
                ),
              ],
            ),
            // Expanded(child: Text('data')),
            Expanded(
              child: TabBarView(
                controller: _supplyTabController,
                children: [
                  FollowingTabView(),
                  ForYouTabView(),
                ].toList(),
              ),
            ),
          ],
        ),
      );
  }
}