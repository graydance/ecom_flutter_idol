import 'package:flustars/flustars.dart';
import 'package:flutter/material.dart';
import 'package:idol/models/dashboard.dart';
import 'package:idol/res/colors.dart';
import 'package:idol/utils/global.dart';

class PastSalesTabView extends StatefulWidget {
  final List<PastSales> dataList;

  PastSalesTabView(this.dataList);

  @override
  State<StatefulWidget> createState() => _PastSalesTabViewSate(dataList);
}

class _PastSalesTabViewSate extends State<PastSalesTabView>
    with AutomaticKeepAliveClientMixin<PastSalesTabView> {
  PageController _pageController;
  final List<PastSales> pastSales;

  _PastSalesTabViewSate(this.pastSales);

  var _selectedYear = '';
  var _selectedMonth = '';
  var _selectedMonthSales = '';

  var _monthMap = const {
    '01': 'January',
    '02': 'February',
    '03': 'March',
    '04': 'April',
    '05': 'May',
    '06': 'June',
    '07': 'July',
    '08': 'August',
    '09': 'September',
    '10': 'October',
    '11': 'November',
    '12': 'December',
  };
  var _weekTableNames = const ['Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat'];
  var _weekTableTextStyle = const TextStyle(
      fontSize: 12, color: Colours.color_0F1015, fontWeight: FontWeight.bold);

  List<Text> _getWeekText() {
    List<Text> weekTextList = [];
    _weekTableNames.forEach((element) {
      weekTextList.add(Text(
        element,
        style: _weekTableTextStyle,
      ));
    });
    return weekTextList;
  }

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    DateTime.now().month;
    DateTime.now().day;
    DateTime.now().weekday;
    _selectedYear = pastSales[0].date.substring(0, 4);
    _selectedMonth =
        _monthMap[pastSales[0].date.substring(4, pastSales[0].date.length)];
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
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
                  '$_selectedMonth $_selectedYear',
                  style: TextStyle(
                      color: Colours.color_0F1015,
                      fontSize: 14,
                      fontWeight: FontWeight.bold),
                ),
                Text(
                  _selectedMonthSales,
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
              onPageChanged: (index) => _onPageChanged(pastSales[index]),
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
    // 当前月份第一天对应的是周几
    int firstDayWeekday = DateTime.parse(pastSales.date + '01').weekday;
    if (firstDayWeekday != DateTime.sunday) {
      //如果是周日，则无需移动元素。否则填充 firstDayWeekday 个空白占位
      for (int i = 0; i < firstDayWeekday; i++) {
        pastSales.dailySales.insert(0, '');
      }
      debugPrint("firstDayWeekday: $firstDayWeekday" + pastSales.dailySales.toString());
    }
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
                      color: _isToday(
                              pastSales.date,
                              firstDayWeekday == DateTime.sunday
                                  ? index + 1
                                  : index + 1 - firstDayWeekday)
                          ? Colours.color_10EA5228
                          : Colours.white,
                      shape: BoxShape.circle,
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          (firstDayWeekday == DateTime.sunday
                                  ? index + 1
                                  : (index + 1 - firstDayWeekday <= 0 ? '' : index + 1 - firstDayWeekday))
                              .toString(),
                          style: TextStyle(
                            color: Colours.color_575859,
                            fontSize: 14,
                          ),
                        ),
                        Text(
                          dailySale,
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

  // pastSalesDate：yyyyMM [202101]
  // pastSalesDay：dayOfMonth [1,2,3...]
  bool _isToday(String pastSalesDate, int pastSalesDay) {
    String currentYearMonth = DateTime.now().year.toString() +
        (DateTime.now().month.bitLength == 1
            ? '0' + DateTime.now().month.toString()
            : DateTime.now().month.toString());
    debugPrint(
        'currentYearMonth >>> $currentYearMonth, pastSalesDate >>> $pastSalesDate, pastSalesDay >>> $pastSalesDay');
    return currentYearMonth == pastSalesDate &&
        DateTime.now().day == pastSalesDay;
  }

  void _onPageChanged(PastSales pastSales) {
    if (pastSales.date.isNotEmpty) {
      setState(() {
        // 更新月份
        _selectedYear = pastSales.date.substring(0, 4);
        String month = pastSales.date.substring(4, pastSales.date.length);
        _selectedMonth = _monthMap[month];
        _selectedMonthSales = Global.getUser(context).monetaryUnit +
            TextUtil.formatDoubleComma3(pastSales.monthSales / 100);
        debugPrint(
            'current select year：$_selectedYear, month：$_selectedMonth, monthSales：$_selectedMonthSales');
      });
    }
  }

  @override
  bool get wantKeepAlive => true;
}
