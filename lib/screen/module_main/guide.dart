import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/html_parser.dart';
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
    'Start, grow and boost your\nonline business with Olaak.com\n',
    'With our free, Easy-to-Use\nTools, build-in supply\nchains, after-sale service',
    'Start selling today in your socials -\nNo Inventory Required, risk-free',
  ];

  static const List<String> guideClick = [
    'Next page',
    'Next page',
    'Land',
  ];

  SwiperController controllrer = SwiperController();

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final height = size.height;
    debugPrint("$height");
    return Scaffold(
        body: Stack(
      children: [
        Container(
            decoration: BoxDecoration(
              image:
                  DecorationImage(image: R.image.guid_bg(), fit: BoxFit.cover),
            ),
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
                alignment: Alignment.center,
                margin: EdgeInsets.fromLTRB(0, 340, 0, 0),
                builder: RoundRectSwiperPaginationBuilder(
                    //点之间的间隔
                    space: 5,
                    // 没选中时的大小
                    size: Size(30, 4),
                    // 选中时的大小
                    activeSize: Size(30, 4),
                    // 没选中时的颜色
                    color: Colours.color_black45,
                    //选中时的颜色
                    activeColor: Colors.white),
              ),
            )),
        Column(
          children: [
            Spacer(),
            Center(
                child: Visibility(
                    maintainState: true,
                    maintainAnimation: true,
                    maintainSize: true,
                    visible: _showGetStarted,
                    child: GestureDetector(
                      onTap: () {
                        IdolRoute.startIndex(context);
                      },
                      child: Container(
                          margin: EdgeInsets.fromLTRB(0, 0, 0, 60),
                          decoration: BoxDecoration(
                            color: Colours.color_white30,
                            borderRadius: BorderRadius.all(
                              Radius.circular(4),
                            ),
                          ),
                          padding: EdgeInsets.only(
                              left: 30, top: 12, right: 30, bottom: 12),
                          child: Text(
                            'GET STARTED!',
                            style: TextStyle(color: Colors.white),
                          )),
                    )))
            // Center(
            //   child: Container(
            //     margin: EdgeInsets.fromLTRB(0, 0, 0, 36),
            //     child: Column(
            //       children: [
            //         Text(
            //           "By signing up, you also agree with our ",
            //           style:
            //               TextStyle(color: Colours.color_636365, fontSize: 12),
            //         ),
            //         RichText(
            //             text: TextSpan(children: [
            //           TextSpan(
            //               text: "Terms of Use",
            //               style: TextStyle(
            //                   color: Colours.color_4E9AE3, fontSize: 12),
            //               recognizer: TapGestureRecognizer()
            //                 ..onTap = () => print('click1')),
            //           TextSpan(
            //             text: " and ",
            //             style: TextStyle(
            //                 color: Colours.color_636365, fontSize: 12),
            //           ),
            //           TextSpan(
            //               text: "Privacy Policy",
            //               style: TextStyle(
            //                   color: Colours.color_4E9AE3, fontSize: 12),
            //               recognizer: TapGestureRecognizer()
            //                 ..onTap = () => print('click2'))
            //         ]))
            //       ],
            //     ),
            //   ),
            // )
          ],
        )
      ],
    ));
  }

  Widget _createSwiperItem(
      int index, BuildContext context, SwiperController controllrer) {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image(
            image: _getCurImage(index),
            height: 120,
            fit: BoxFit.contain,
          ),
          SizedBox(
            height: 100,
          ),
          Text(
            guideDesc[index],
            textAlign: TextAlign.center,
            style: TextStyle(
                color: Colours.white,
                fontSize: 20,
                fontWeight: FontWeight.normal),
          ),
          // Text(
          //   guideDesc[index],
          //   textAlign: TextAlign.center,
          //   style: TextStyle(color: Colours.color_white70, fontSize: 14),
          // ),
          // GestureDetector(
          //   onTap: () {
          //     if (index == 2)
          //       IdolRoute.startValidateEmail(context);
          //     else
          //       controllrer.next(animation: true);
          //   },
          //   child: Container(
          //     margin: EdgeInsets.fromLTRB(0, 35, 0, 0),
          //     //设置 child 居中
          //     alignment: Alignment(0, 0),
          //     height: 22,
          //     width: 76,
          //     //边框设置
          //     decoration: new BoxDecoration(
          //       //背景
          //       color: Colors.transparent,
          //       //设置四周圆角 角度 这里的角度应该为 父Container height 的一半
          //       borderRadius: BorderRadius.all(Radius.circular(5.0)),
          //       //设置四周边框
          //       border: new Border.all(width: 1, color: Colors.white),
          //     ),
          //     child: Text(guideClick[index],
          //         textAlign: TextAlign.center,
          //         style: new TextStyle(color: Colors.white, fontSize: 12)),
          //   ),
          // ),
        ],
      ),
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
