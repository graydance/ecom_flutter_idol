import 'package:flutter/material.dart';
import 'package:idol/r.g.dart';
import 'package:idol/res/colors.dart';
import 'package:idol/router.dart';
import 'package:idol/screen/module_supply/for_you_goods_tab_view.dart';

class SupplyMVPPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _SupplyMVPPageState();
}

class _SupplyMVPPageState extends State<SupplyMVPPage>
    with AutomaticKeepAliveClientMixin<SupplyMVPPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Container(
      color: Colours.color_F8F8F8,
      child: Column(
        mainAxisSize: MainAxisSize.max,
        children: [
          Stack(
            alignment: Alignment.center,
            children: [
              AppBar(
                elevation: 0,
                title: Text(
                  'Olaak',
                  style: TextStyle(color: Colours.color_0F1015, fontSize: 20),
                ),
                centerTitle: true,
                actions: [
                  GestureDetector(
                    onTap: () {
                      Navigator.of(context).pushNamed(RouterPath.goodsCategory);
                    },
                    child: Image(
                      image: R.image.icon_goods_category(),
                    ),
                  )
                ],
              ),
            ],
          ),
          // Expanded(child: Text('data')),
          Expanded(
            child: ForYouTabView(),
          ),
        ],
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
