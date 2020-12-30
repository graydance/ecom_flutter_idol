import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:idol/api.dart';
import 'package:idol/app.dart';
import 'package:idol/models/models.dart';
import 'package:idol/store/middleware.dart';
import 'package:idol/store/reducers/appreducers.dart';
import 'package:logging/logging.dart';
import 'package:mockito/mockito.dart';
import 'package:redux/redux.dart';
import 'package:redux_logging/redux_logging.dart';

class MockDio extends Mock implements Dio {}

void main() {
  testWidgets('basic', (WidgetTester tester) async {
    var mockDio = MockDio();

    when(mockDio.post('https://127.0.0.1:10080/hots',
            data: anyNamed('data'),
            queryParameters: anyNamed('queryParameters'),
            options: anyNamed('options'),
            cancelToken: anyNamed('cancelToken'),
            onSendProgress: anyNamed('onSendProgress'),
            onReceiveProgress: anyNamed('onReceiveProgress')))
        .thenAnswer((_) async => Response(
            data: {"code": 100, "msg": 'error test'}, statusCode: 200));
    // throwOnMissingStub(mockDio);
    setApiIO(mockDio);

    final logger = new Logger('redux');
    logger.onRecord
        .where((record) => record.loggerName == logger.name)
        .listen((loggingMiddlewareRecord) => print(loggingMiddlewareRecord));
    final middleware = new LoggingMiddleware(logger: logger);

    await tester.pumpWidget(ReduxApp(
      store: Store<AppState>(
        appReducer,
        initialState: AppState.loading(),
        middleware: [...createStoreMiddleware(), middleware],
      ),
    ));

    await tester.pumpAndSettle();

    expect(find.text('error test'), findsOneWidget);
  });
}
