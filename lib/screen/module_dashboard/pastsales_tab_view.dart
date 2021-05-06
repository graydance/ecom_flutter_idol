import 'package:flustars/flustars.dart';
import 'package:flutter/material.dart';
import 'package:idol/models/arguments/sales_history.dart';
import 'package:idol/models/dashboard.dart';
import 'package:idol/res/colors.dart';
import 'package:idol/router.dart';
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
        mainAxisSize: MainAxisSize.min,
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
              physics: BouncingScrollPhysics(),
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

  Widget _buildCalendarPage(PastSales pastSale) {
    // 当前月份第一天对应的是周几
    int firstDayWeekday = DateTime.parse(pastSale.date + '01').weekday;
    var calvalues = pastSale.dailySales
        .asMap()
        .map((index, value) => MapEntry(index, {
              "day": index + 1,
              "value": value,
            }))
        .values
        .toList();
    if (firstDayWeekday != DateTime.sunday) {
      //如果是周日，则无需移动元素。否则填充 firstDayWeekday 个空白占位
      for (int i = 0; i < firstDayWeekday; i++) {
        calvalues.insert(0, {"day": -1, "value": ""});
      }
    }
    return GridView.count(
      padding: const EdgeInsets.all(12),
      crossAxisCount: 7,
      physics: NeverScrollableScrollPhysics(),
      children: calvalues
          .map((day) => InkWell(
                onTap: () {
                  int clickDay = day['day'];
                  if (clickDay < 0) return;
                  String date;
                  String showDay;
                  if (0 < clickDay && clickDay < 10) {
                    date = pastSale.date + '0' + clickDay.toString();
                    showDay = '0' + clickDay.toString();
                  } else {
                    date = pastSale.date + clickDay.toString();
                    showDay = clickDay.toString();
                  }
                  String month = _monthMap[pastSales[0].date.substring(4, 6)]
                          .substring(0, 3) +
                      '.' +
                      showDay.toString();
                  IdolRoute.startDashboardSalesHistory(context,
                      SalesHistoryArguments(date, day['value'], month));
                },
                child: Container(
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: _isToday(pastSale.date, day['day'])
                        ? Colours.color_10EA5228
                        : Colors.white,
                    shape: BoxShape.circle,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        (day['day'] as int) > 0 ? day['day'].toString() : '',
                        style: TextStyle(
                          color: Colours.color_575859,
                          fontSize: 14,
                        ),
                      ),
                      ...day['value'] == ""
                          ? []
                          : [
                              Text(
                                Global.getUser(context).monetaryUnit +
                                    day['value'],
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  color: Colours.color_C3C4C6,
                                  fontSize: 12,
                                ),
                              )
                            ],
                    ],
                  ),
                ),
              ))
          .toList(),
    );
  }

  // pastSalesDate：yyyyMM [202101]
  // pastSalesDay：dayOfMonth [1,2,3...]
  bool _isToday(String pastSalesDate, int pastSalesDay) {
    String currentYearMonth = DateTime.now().year.toString() +
        (DateTime.now().month < 10
            ? '0' + DateTime.now().month.toString()
            : DateTime.now().month.toString());
    var result =
        currentYearMonth == pastSalesDate && DateTime.now().day == pastSalesDay;
    // debugPrint(
    // 'currentYearMonth $result >>> $currentYearMonth, pastSalesDate >>> $pastSalesDate, pastSalesDay >>> ${DateTime.now().day} $pastSalesDay');
    return result;
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
        // debugPrint(
        //     'current select year：$_selectedYear, month：$_selectedMonth, monthSales：$_selectedMonthSales');
      });
    }
  }

  @override
  bool get wantKeepAlive => true;
}
