import 'package:flutter/foundation.dart';

/// Simple analytics service that logs events to console.
class AnalyticsService {
  AnalyticsService._();

  static void logEvent(String name) {
    debugPrint('analytics_event: ' + name);
  }
}
