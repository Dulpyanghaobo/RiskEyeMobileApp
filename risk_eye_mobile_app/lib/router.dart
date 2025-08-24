import 'package:flutter/material.dart';

import 'features/upload/upload_page.dart';
import 'features/evaluating/evaluating_page.dart';
import 'features/result/result_page.dart';
import 'features/history/history_page.dart';

/// Centralized app route generator.
class AppRouter {
  static Route<dynamic>? onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case UploadPage.routeName:
        return MaterialPageRoute(builder: (_) => const UploadPage());
      case EvaluatingPage.routeName:
        return MaterialPageRoute(builder: (_) => const EvaluatingPage());
      case ResultPage.routeName:
        return MaterialPageRoute(builder: (_) => const ResultPage());
      case HistoryPage.routeName:
        return MaterialPageRoute(builder: (_) => const HistoryPage());
      default:
        return null;
    }
  }
}
