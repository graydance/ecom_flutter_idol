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
    'Discount for a limited time\n to obtain more goods at a more favorable',
    'Selected global major suppliers,\n to provide better service, a large number\n of goods arbitrary selection.',
    'We can guarantee a much higher revenue compared with others.',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
              image: R.image.launch_background_webp(), fit: BoxFit.cover),
        ),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                height: 330,
                padding:
                    EdgeInsets.only(top: 70, left: 16, right: 16, bottom: 40),
                color: Colours.color_white20,
                child: Swiper(
                  itemCount: guideTitle.length,
                  autoplay: false,
                  viewportFraction: 1,
                  loop: false,
                  scale: 1,
                  onIndexChanged: (index) {
                    setState(() {
                      _showGetStarted = index == guideTitle.length - 1;
                    });
                  },
                  itemBuilder: (context, index) {
                    return _createSwiperItem(index);
                  },
                  pagination: SwiperPagination(
                    alignment: Alignment.bottomCenter,
                    builder: DotSwiperPaginationBuilder(
                      // 点之间的间隔
                        space: 2,
                        // 没选中时的大小
                        size: 6,
                        // 选中时的大小
                        activeSize: 8,
                        // 没选中时的颜色
                        color: Colours.color_black45,
                        //选中时的颜色
                        activeColor: Colors.white),
                  ),
                ),
              ),
              Visibility(
                maintainState: true,
                maintainAnimation: true,
                maintainSize: true,
                child: GestureDetector(
                  onTap: () {
                    IdolRoute.startValidateEmail(context);
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colours.color_white30,
                      borderRadius: BorderRadius.all(
                        Radius.circular(4),
                      ),
                    ),
                    padding: EdgeInsets.only(
                        left: 30, top: 12, right: 30, bottom: 12),
                    margin: EdgeInsets.only(left: 90, right: 90, top: 50),
                    child: Text(
                      'GET STARTED!',
                      style:
                          TextStyle(fontSize: 18, color: Colours.color_FFFFF0),
                    ),
                  ),
                ),
                visible: _showGetStarted,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _createSwiperItem(int index) {
    return Container(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            guideTitle[index],
            textAlign: TextAlign.center,
            style: TextStyle(
                color: Colours.white,
                fontSize: 26,
                fontWeight: FontWeight.bold),
          ),
          SizedBox(
            height: 28,
          ),
          Text(
            guideDesc[index],
            textAlign: TextAlign.center,
            style: TextStyle(color: Colours.color_white70, fontSize: 16),
          ),
          SizedBox(
            height: 70,
          ),
        ],
      ),
    );
  }
}
