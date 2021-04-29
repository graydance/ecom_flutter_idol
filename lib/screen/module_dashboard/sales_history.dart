// import 'package:flutter/material.dart';
// import 'package:flutter_easyloading/flutter_easyloading.dart';
// import 'package:flutter_redux/flutter_redux.dart';
// import 'package:idol/models/appstate.dart';
// import 'package:idol/models/arguments/arguments.dart';
// import 'package:idol/models/models.dart';
// import 'package:idol/net/request/dashboard.dart';
// import 'package:idol/res/colors.dart';
// import 'package:idol/store/actions/actions.dart';
// import 'package:idol/widgets/error.dart';
// import 'package:idol/widgets/loading.dart';
// import 'package:idol/widgets/ui.dart';
// import 'package:pull_to_refresh/pull_to_refresh.dart';
// import 'package:redux/redux.dart';
//
// class SalesHistoryScreen extends StatefulWidget {
//   @override
//   State<StatefulWidget> createState() => _SalesHistoryScreenState();
// }
//
// class _SalesHistoryScreenState extends State<SalesHistoryScreen> {
//   List<SalesHistory> _salesHistoryList = const [];
//   SalesHistoryArguments _arguments;
//   RefreshController _refreshController;
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: IdolUI.appBar(context, 'SalesHistory'),
//       body: StoreConnector<AppState, _ViewModel>(
//         converter: _ViewModel.fromStore,
//         distinct: true,
//         onInit: (store) {
//           store.dispatch(
//               SalesHistoryAction(SalesHistoryRequest(_arguments.date)));
//         },
//         onWillChange: (oldVM, newVM) {
//           _onSalesHistoryStateChanged(newVM._salesHistoryState);
//         },
//         builder: (context, vm) {
//           return _buildWidget(vm);
//         },
//       ),
//     );
//   }
//
//   void _onSalesHistoryStateChanged(SalesHistoryState state) {
//     if (state is SalesHistorySuccess) {
//       _salesHistoryList = state.salesHistoryList.list;
//     } else if (state is SalesHistoryFailure) {
//       EasyLoading.showError(state.message);
//     }
//   }
//
//   Widget _buildWidget(_ViewModel vm) {
//     return Container(
//       child: Column(
//         mainAxisSize: MainAxisSize.max,
//         crossAxisAlignment: CrossAxisAlignment.center,
//         children: [
//           Container(
//             padding: EdgeInsets.only(left: 16, top: 12, right: 16, bottom: 12),
//             color: Colours.color_10EA5228,
//             child: Row(
//               mainAxisSize: MainAxisSize.min,
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Expanded(
//                   child: Text(
//                     _arguments.date,
//                     style: TextStyle(color: Colours.color_0F1015, fontSize: 14),
//                   ),
//                 ),
//                 Text(
//                   _arguments.money,
//                   style: TextStyle(color: Colours.color_0F1015, fontSize: 14),
//                 ),
//               ],
//             ),
//           ),
//           Expanded(
//             child: _createWidgetByStatus(vm),
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget _createWidgetByStatus(_ViewModel vm) {
//     if (vm._salesHistoryState is SalesHistoryInitial ||
//         vm._salesHistoryState is SalesHistoryLoading) {
//       return IdolLoadingWidget();
//     } else if (vm._salesHistoryState is SalesHistoryFailure &&
//         (_salesHistoryList == null || _salesHistoryList.isEmpty)) {
//       return IdolErrorWidget(
//         () {
//           vm._load(_arguments.date);
//         },
//         tipsText: (vm._salesHistoryState as SalesHistoryFailure).message,
//       );
//     } else {
//       return SmartRefresher(
//         enablePullDown: true,
//         enablePullUp: false,
//         header: MaterialClassicHeader(
//           color: Colours.color_EA5228,
//         ),
//         child: ListView.separated(
//           scrollDirection: Axis.vertical,
//           separatorBuilder: (context, index) {
//             return Divider(
//               height: 10,
//               color: Colors.transparent,
//             );
//           },
//           itemCount: _salesHistoryList.length,
//           itemBuilder: (context, index) =>
//               _SalesHistoryItem(_salesHistoryList[index]),
//         ),
//         onRefresh: () async {
//           await Future(() {
//             vm._load(_arguments.date);
//           });
//         },
//         onLoading: () async {
//           await Future(() {
//             vm._load(_arguments.date);
//           });
//         },
//         controller: _refreshController,
//       );
//     }
//   }
//
//   @override
//   void initState() {
//     super.initState();
//     _refreshController = RefreshController();
//     _arguments = StoreProvider.of<AppState>(context, listen: false)
//         .state
//         .salesHistoryArguments;
//   }
// }
//
// class _SalesHistoryItem extends StatefulWidget {
//   final SalesHistory salesHistory;
//
//   _SalesHistoryItem(this.salesHistory);
//
//   @override
//   State<StatefulWidget> createState() => _SalesHistoryItemState();
// }
//
// class _SalesHistoryItemState extends State<_SalesHistoryItem> {
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       child: Row(
//         mainAxisSize: MainAxisSize.min,
//         crossAxisAlignment: CrossAxisAlignment.center,
//         children: [
//           Image(
//             image: NetworkImage(
//               widget.salesHistory.goodsPicture,
//             ),
//             width: 70,
//             height: 70,
//             fit: BoxFit.cover,
//           ),
//           Expanded(
//             child: Column(
//               mainAxisSize: MainAxisSize.min,
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(
//                   widget.salesHistory.goodsName,
//                   style: TextStyle(color: Colours.color_0F1015, fontSize: 12),
//                 ),
//                 SizedBox(
//                   height: 4,
//                 ),
//                 Text(
//                   'Sales',
//                   style: TextStyle(color: Colours.color_0F1015, fontSize: 12),
//                 ),
//                 SizedBox(
//                   height: 4,
//                 ),
//                 Text(
//                   'Earnings',
//                   style: TextStyle(color: Colours.color_0F1015, fontSize: 12),
//                 ),
//               ],
//             ),
//           ),
//           Column(
//             mainAxisSize: MainAxisSize.min,
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Text(
//                 '',
//                 style: TextStyle(color: Colours.color_0F1015, fontSize: 12),
//               ),
//               SizedBox(
//                 height: 4,
//               ),
//               Text(
//                 widget.salesHistory.soldNum.toString(),
//                 style: TextStyle(color: Colours.color_0F1015, fontSize: 12),
//               ),
//               SizedBox(
//                 height: 4,
//               ),
//               Text(
//                 widget.salesHistory.earningPriceStr,
//                 style: TextStyle(color: Colours.color_0F1015, fontSize: 12),
//               ),
//             ],
//           ),
//         ],
//       ),
//     );
//   }
// }
//
// class _ViewModel {
//   final SalesHistoryState _salesHistoryState;
//   final Function(String) _load;
//   int _currentPage = 1;
//   bool _enablePullUp = false;
//
//   _ViewModel(this._salesHistoryState, this._load);
//
//   static _ViewModel fromStore(Store<AppState> store) {
//     void _load(String date) {
//       store.dispatch(SalesHistoryAction(SalesHistoryRequest(date)));
//     }
//
//     return _ViewModel(store.state.salesHistoryState, _load);
//   }
//
//   @override
//   bool operator ==(Object other) =>
//       identical(this, other) ||
//       other is _ViewModel &&
//           runtimeType == other.runtimeType &&
//           _salesHistoryState == other._salesHistoryState &&
//           _load == other._load;
//
//   @override
//   int get hashCode => _salesHistoryState.hashCode ^ _load.hashCode;
// }
