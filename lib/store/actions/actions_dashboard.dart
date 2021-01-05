import 'package:idol/models/dashboard.dart';
import 'package:idol/net/request/base.dart';

class RequestDashboardDataAction {
  final BaseRequest request;

  RequestDashboardDataAction(this.request);
}

class RequestDashboardDataErrorAction {
  final String error;

  RequestDashboardDataErrorAction(this.error);
}

class RequestDashboardDataSuccessAction {
  final Dashboard dashboard;

  RequestDashboardDataSuccessAction(this.dashboard);
}
