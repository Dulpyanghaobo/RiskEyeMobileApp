import 'package:flutter/foundation.dart';
import 'package:package_info_plus/package_info_plus.dart';

/// Simple analytics wrapper.
class AnalyticsService {
  static PackageInfo? _info;

  static Future<void> init() async {
    _info = await PackageInfo.fromPlatform();
  }

  static String get appName => _info?.appName ?? '';
  static String get version => _info?.version ?? '';
  static String get buildNumber => _info?.buildNumber ?? '';

  static void logEvent(String name, [Map<String, dynamic>? params]) {
    debugPrint('event: $name ${params ?? {}}');
  }
}
