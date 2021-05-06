import 'package:facebook_app_events/facebook_app_events.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:enum_to_string/enum_to_string.dart';
import 'package:firebase_analytics/observer.dart';
import 'package:flutter/foundation.dart';

class AppEvent {
  final List<AnalyticsProvider> providers;

  AppEvent(this.providers);

  static AppEvent get shared => AppEvent([
        FirebaseAnalyticsProvider(),
        FacebookAnalyticsProvider(),
      ]);

  Future<void> report(
      {@required AnalyticsEvent event,
      Map<AnalyticsEventParameter, dynamic> parameters}) {
    debugPrint('>>> AppEvent report: ${event.name} $parameters');
    return Future.wait(providers.map(
        (provider) => provider.report(event: event, parameters: parameters)));
  }

  FirebaseAnalyticsObserver get firebaseAnalyticsObserver {
    FirebaseAnalyticsProvider firebaseAnalyticsProvider =
        providers.firstWhere((element) => element is FirebaseAnalyticsProvider);
    if (firebaseAnalyticsProvider == null) {
      throw Exception('FirebaseAnalyticsProvider not found');
    }

    return FirebaseAnalyticsObserver(
        analytics: firebaseAnalyticsProvider.analytics);
  }
}

enum AnalyticsEvent {
  olaak_tab,
  grid_display_b,
  grid_click_b,
  pick_share,

  product_view_b,
  detail_pick_share,

  share_product_view,
  product_share_channel,

  dashboard_tab,
  balance_check,
  pastsale_view,
  bestsale_view,
  shoplink_tab,
  shoplink_copy_click,
  shoplink_share_channel,

  product_remove,
}

enum AnalyticsEventParameter {
  id,
  type,
}

extension AnalyticsEventExtension on AnalyticsEvent {
  String get name => EnumToString.convertToString(this);
}

extension AnalyticsEventParameterExtension on AnalyticsEventParameter {
  String get name => EnumToString.convertToString(this);
}

abstract class AnalyticsProvider {
  Future<void> report(
      {@required AnalyticsEvent event,
      Map<AnalyticsEventParameter, dynamic> parameters});
}

class FirebaseAnalyticsProvider extends AnalyticsProvider {
  final FirebaseAnalytics analytics = FirebaseAnalytics();

  @override
  Future<void> report(
      {AnalyticsEvent event,
      Map<AnalyticsEventParameter, dynamic> parameters}) {
    Map<String, dynamic> maps = {};
    if (parameters != null) {
      for (var key in parameters.keys) {
        maps.addAll({key.name: parameters[key]});
      }
    }
    return analytics.logEvent(name: event.name, parameters: maps);
  }
}

class FacebookAnalyticsProvider extends AnalyticsProvider {
  final FacebookAppEvents analytics = FacebookAppEvents();

  @override
  Future<void> report(
      {AnalyticsEvent event,
      Map<AnalyticsEventParameter, dynamic> parameters}) {
    Map<String, dynamic> maps = {};
    if (parameters != null) {
      for (var key in parameters.keys) {
        maps.addAll({key.name: parameters[key]});
      }
    }
    return analytics.logEvent(name: event.name, parameters: maps);
  }
}
