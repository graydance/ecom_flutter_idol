import 'package:flutter/material.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:idol/r.g.dart';
import 'package:idol/res/colors.dart';
import 'package:idol/router.dart';

class GuideScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _GuideScreenState();
}

class _GuideScreenState extends State<GuideScreen> {
  bool _showGetStarted = false;

  static const List<String> guideTitle = [
    'Big discounts, good\n deals,flash sales',
    'To provide you with\n better suppliers',
    'Quality & service\n guarantee',
  ];

  static const List<String> guideDesc = [
    'Your fully-powered\nonline shop is ready after\nsign-up',
    'Your supply chain is ready\njust pick what your favarite\nto sell',
    'Boost faster sales and fans\ngrowth with built-in\nmarketing tools',
  ];

  static const List<String> guideClick = [
    'Next page',
    'Next page',
    'Land',
  ];

  SwiperController controllrer = SwiperController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(image: R.image.guid_bg(), fit: BoxFit.cover),
        ),
        child: SafeArea(
          child: Swiper(
            itemCount: guideTitle.length,
            autoplay: false,
            viewportFraction: 1,
            loop: false,
            outer: false,
            scale: 1,
            controller: controllrer,
            onIndexChanged: (index) {
              setState(() {
                _showGetStarted = index == guideTitle.length - 1;
              });
            },
            itemBuilder: (context, index) {
              return _createSwiperItem(index, context, controllrer);
            },
            pagination: SwiperPagination(
              alignment: Alignment.topCenter,
              margin: EdgeInsets.only(top: 430),
              builder: RoundRectSwiperPaginationBuilder(
                //点之间的间隔
                space: 5,
                // 没选中时的大小
                size: Size(30, 4),
                // 选中时的大小
                activeSize: Size(30, 4),
                // 没选中时的颜色
                color: Colors.white30,
                //选中时的颜色
                activeColor: Colors.white,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _createSwiperItem(
      int index, BuildContext context, SwiperController controllrer) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      // mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Image(
          image: _getCurImage(index),
          height: 420,
          fit: BoxFit.contain,
        ),
        SizedBox(
          height: 60,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 8,
          ),
          child: Text(
            guideDesc[index],
            textAlign: TextAlign.center,
            style: TextStyle(
                color: Colours.white,
                fontSize: 25,
                fontWeight: FontWeight.w800,
                height: 1.2),
          ),
        ),
        Visibility(
          maintainState: true,
          maintainAnimation: true,
          maintainSize: true,
          visible: _showGetStarted,
          child: GestureDetector(
            onTap: () {
              IdolRoute.startIndex(context);
            },
            child: Container(
              margin: EdgeInsets.only(top: 30),
              decoration: BoxDecoration(
                color: Colours.color_white30,
                borderRadius: BorderRadius.all(
                  Radius.circular(4),
                ),
              ),
              padding:
                  EdgeInsets.only(left: 30, top: 12, right: 30, bottom: 12),
              child: Text(
                'GET STARTED!',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

_getCurImage(int index) {
  switch (index) {
    case 0:
      return R.image.guid_1();
    case 1:
      return R.image.guid_2();
    case 2:
      return R.image.guid_3();
    case 3:
      return null;
  }
}

class RoundRectSwiperPaginationBuilder extends SwiperPlugin {
  final Color activeColor;

  ///,if set null , will be Theme.of(context).scaffoldBackgroundColor
  final Color color;

  ///Size of the rect when activate
  final Size activeSize;

  ///Size of the rect
  final Size size;

  /// Space between rects
  final double space;

  final Key key;

  const RoundRectSwiperPaginationBuilder(
      {this.activeColor,
      this.color,
      this.key,
      this.size: const Size(10.0, 2.0),
      this.activeSize: const Size(10.0, 2.0),
      this.space: 3.0});

  @override
  Widget build(BuildContext context, SwiperPluginConfig config) {
    ThemeData themeData = Theme.of(context);
    Color activeColor = this.activeColor ?? themeData.primaryColor;
    Color color = this.color ?? themeData.scaffoldBackgroundColor;

    List<Widget> list = [];

    if (config.itemCount > 20) {
      print(
          "The itemCount is too big, we suggest use FractionPaginationBuilder instead of DotSwiperPaginationBuilder in this sitituation");
    }

    int itemCount = config.itemCount;
    int activeIndex = config.activeIndex;

    for (int i = 0; i < itemCount; ++i) {
      bool active = i == activeIndex;
      Size size = active ? this.activeSize : this.size;
      list.add(Container(
        margin: EdgeInsets.fromLTRB(space, 0, space, 0),
        width: size.width,
        height: size.height,
        //边框设置
        decoration: new BoxDecoration(
          //背景
          color: active ? activeColor : color,
          //设置四周圆角 角度
          borderRadius: BorderRadius.all(Radius.circular(4.0)),
        ),
      ));
    }

    if (config.scrollDirection == Axis.vertical) {
      return new Column(
        key: key,
        mainAxisSize: MainAxisSize.min,
        children: list,
      );
    } else {
      return new Row(
        key: key,
        mainAxisSize: MainAxisSize.min,
        children: list,
      );
    }
  }
}
