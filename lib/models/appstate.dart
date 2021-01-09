import 'package:idol/models/dashboard.dart';
import 'package:idol/models/models.dart';
import 'package:meta/meta.dart';

@immutable
class AppState {

  final Dashboard dashboard;

  AppState({this.dashboard = const Dashboard()});

  AppState copyWith({Dashboard dashboard}) {
    return AppState(dashboard: dashboard ?? this.dashboard);
  }

  @override
  int get hashCode => dashboard.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AppState &&
          runtimeType == other.runtimeType &&
          dashboard == other.dashboard;

  @override
  String toString() {
    return 'AppState{dashboardResponse:$dashboard}';
  }
}
