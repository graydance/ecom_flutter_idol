import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

class MockDio extends Mock implements Dio {}

void main() {
  test('mock', () {
    expect(1 + 1, 2);
  });
  // testWidgets('basic', (WidgetTester tester) async {
  //    var mockDio = MockDio();

  //   when(mockDio.post('https://127.0.0.1:10080/hots',
  //           data: anyNamed('data'),
  //           queryParameters: anyNamed('queryParameters'),
  //           options: anyNamed('options'),
  //           cancelToken: anyNamed('cancelToken'),
  //           onSendProgress: anyNamed('onSendProgress'),
  //           onReceiveProgress: anyNamed('onReceiveProgress')))
  //       .thenAnswer((_) async => Response(
  //           data: {"code": 100, "msg": 'error test'}, statusCode: 200));
  //   // throwOnMissingStub(mockDio);
  //   DioClient.getInstance().setApiIO(mockDio);

  //   final logger = new Logger('redux');
  //   logger.onRecord
  //       .where((record) => record.loggerName == logger.name)
  //       .listen((loggingMiddlewareRecord) => print(loggingMiddlewareRecord));
  //   final middleware = new LoggingMiddleware(logger: logger);

  //   await tester.pumpWidget(ReduxApp(
  //     store: Store<AppState>(
  //       appReducer,
  //       initialState: AppState(),
  //       middleware: [...createStoreMiddleware(), middleware],
  //     ),
  //   ));

  //   await tester.pumpAndSettle();

  //   expect(find.text('error test'), findsOneWidget);
  // });

  // group('fetchDashboard', (){
  //   test('fetch dashboard data success', () async {
  //     when(mockDio.post('/dashboard'))
  //         .thenAnswer((_) async => Response(data: {"code":0,"msg":"success","data":{"available_balance":1516.23,"lifetime_earnings":11294.34,"monetary_unit":"\$","reward_list":[{"reward_status":0,"reward_title":"Rewards title1","reward_description":"Rewards description1","reward_coins":"\$1"},{"reward_status":1,"reward_title":"Rewards title2","reward_description":"Rewards description2","reward_coins":"\$2"},{"reward_status":2,"reward_title":"Rewards title3","reward_description":"Rewards description3","reward_coins":"\$3"},{"reward_status":3,"reward_title":"Rewards title4","reward_description":"Rewards description4","reward_coins":"\$4"},{"reward_status":2,"reward_title":"Rewards title5","reward_description":"Rewards description5","reward_coins":"\$5"},{"reward_status":0,"reward_title":"Rewards title6","reward_description":"Rewards description6","reward_coins":"\$6"},{"reward_status":1,"reward_title":"Rewards title7","reward_description":"Rewards description7","reward_coins":"\$7"},{"reward_status":3,"reward_title":"Rewards title8","reward_description":"Rewards description8","reward_coins":"\$8"},{"reward_status":0,"reward_title":"Rewards title9","reward_description":"Rewards description9","reward_coins":"\$9"},{"reward_status":3,"reward_title":"Rewards title10","reward_description":"Rewards description10","reward_coins":"\$10"},{"reward_status":2,"reward_title":"Rewards title11","reward_description":"Rewards description11","reward_coins":"\$11"},{"reward_status":1,"reward_title":"Rewards title12","reward_description":"Rewards description12","reward_coins":"\$12"},{"reward_status":1,"reward_title":"Rewards title13","reward_description":"Rewards description13","reward_coins":"\$13"},{"reward_status":1,"reward_title":"Rewards title14","reward_description":"Rewards description14","reward_coins":"\$14"},{"reward_status":0,"reward_title":"Rewards title15","reward_description":"Rewards description15","reward_coins":"\$15"},{"reward_status":2,"reward_title":"Rewards title16","reward_description":"Rewards description16","reward_coins":"\$16"},{"reward_status":3,"reward_title":"Rewards title17","reward_description":"Rewards description17","reward_coins":"\$17"},{"reward_status":2,"reward_title":"Rewards title18","reward_description":"Rewards description18","reward_coins":"\$18"},{"reward_status":3,"reward_title":"Rewards title19","reward_description":"Rewards description19","reward_coins":"\$19"},{"reward_status":0,"reward_title":"Rewards title20","reward_description":"Rewards description20","reward_coins":"\$20"}],"past_sals":[{"date":202001,"monetary_unit":"\$","month_sales":10242.22,"daily_sales":[128.04,111.32,0,333,980.9,12.01,123.45,45.67,67.89,99.12,33,99.44,320.77,10,200.9,600,700,800,900,200,0,22.11,23.23,24.24,25,26.78,270.05,280,29.11,300.1,31.25]},{"date":202002,"monetary_unit":"\$","month_sales":10242.22,"daily_sales":[128.04,111.32,0,333,980.9,12.01,123.45,45.67,67.89,99.12,33,99.44,320.77,10,200.9,600,700,800,900,200,0,22.11,23.23,24.24,25,26.78,270.05,280,29.11]},{"date":202003,"monetary_unit":"\$","month_sales":10242.22,"daily_sales":[128.04,111.32,0,333,980.9,12.01,123.45,45.67,67.89,99.12,33,99.44,320.77,10,200.9,600,700,800,900,200,0,22.11,23.23,24.24,25,26.78,270.05,280,29.11,300.1,31.25]},{"date":202004,"monetary_unit":"\$","month_sales":10242.22,"daily_sales":[128.04,111.32,0,333,980.9,12.01,123.45,45.67,67.89,99.12,33,99.44,320.77,10,200.9,600,700,800,900,200,0,22.11,23.23,24.24,25,26.78,270.05,280,29.11,300.1]},{"date":202005,"monetary_unit":"\$","month_sales":10242.22,"daily_sales":[128.04,111.32,0,333,980.9,12.01,123.45,45.67,67.89,99.12,33,99.44,320.77,10,200.9,600,700,800,900,200,0,22.11,23.23,24.24,25,26.78,270.05,280,29.11,300.1,31.25]},{"date":202006,"monetary_unit":"\$","month_sales":10242.22,"daily_sales":[128.04,111.32,0,333,980.9,12.01,123.45,45.67,67.89,99.12,33,99.44,320.77,10,200.9,600,700,800,900,200,0,22.11,23.23,24.24,25,26.78,270.05,280,29.11,300.1]},{"date":202007,"monetary_unit":"\$","month_sales":10242.22,"daily_sales":[128.04,111.32,0,333,980.9,12.01,123.45,45.67,67.89,99.12,33,99.44,320.77,10,200.9,600,700,800,900,200,0,22.11,23.23,24.24,25,26.78,270.05,280,29.11,300.1,31.25]},{"date":202008,"monetary_unit":"\$","month_sales":10242.22,"daily_sales":[128.04,111.32,0,333,980.9,12.01,123.45,45.67,67.89,99.12,33,99.44,320.77,10,200.9,600,700,800,900,200,0,22.11,23.23,24.24,25,26.78,270.05,280,29.11,300.1,31.99]},{"date":202009,"monetary_unit":"\$","month_sales":10242.22,"daily_sales":[128.04,111.32,0,333,980.9,12.01,123.45,45.67,67.89,99.12,33,99.44,320.77,10,200.9,600,700,800,900,200,0,22.11,23.23,24.24,25,26.78,270.05,280,29.11,300.1]},{"date":202010,"monetary_unit":"\$","month_sales":10242.22,"daily_sales":[128.04,111.32,0,333,980.9,12.01,123.45,45.67,67.89,99.12,33,99.44,320.77,10,200.9,600,700,800,900,200,0,22.11,23.23,24.24,25,26.78,270.05,280,29.11,300.1,31.25]},{"date":202011,"monetary_unit":"\$","month_sales":10242.22,"daily_sales":[128.04,111.32,0,333,980.9,12.01,123.45,45.67,67.89,99.12,33,99.44,320.77,10,200.9,600,700,800,900,200,0,22.11,23.23,24.24,25,26.78,270.05,280,29.11,300.1]},{"date":202012,"monetary_unit":"\$","month_sales":10242.22,"daily_sales":[128.04,111.32,0,333,980.9,12.01,123.45,45.67,67.89,99.12,33,99.44,320.77,10,200.9,600,700,800,900,200,0,22.11,23.23,24.24,25,26.78,270.05,280,29.11,300.1,31.25]}]}}, statusCode: 200));
  //     //expect(await, matcher);
  //   });
  //
  //   test('fetch dashboard data failure', () async {
  //     when(mockDio.post('/dashboard'))
  //         .thenAnswer((_) async => Response(data: {"code":-500, "msg":"server error"}, statusCode: 500));
  //     //expect(await, matcher);
  //   });
  //
  //   test('fetch dashboard data success, but rewardList is empty', (){
  //     when(mockDio.post('/dashboard'))
  //         .thenAnswer((_) async => Response(data: {"code":0, "msg":"success", "data":{"available_balance":1516.23,"lifetime_earnings":11294.34,"monetary_unit":"\$","reward_list":[]}}, statusCode: 200));
  //     // expect();
  //   });
  // });
}
