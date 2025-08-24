import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

import 'app.dart';
import 'core/config/app_config.dart';
import 'router.dart';
import 'theme/colors.dart';
import 'theme/typography.dart';
import 'services/analytics_service.dart';
import 'state/providers.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  debugPrint('Running env: ${AppConfig.env}');
  await AnalyticsService.init();
  final providers = await createProviders();
  runApp(RootApp(providers));
}

class RootApp extends StatelessWidget {
  final List<SingleChildWidget> providers;
  const RootApp(this.providers, {super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: providers,
      child: MaterialApp(
        title: 'Risk Eye',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: primaryColor),
          textTheme: appTextTheme,
          scaffoldBackgroundColor: backgroundColor,
          useMaterial3: true,
        ),
        onGenerateRoute: AppRouter.onGenerateRoute,
        home: const RootNavigation(),
      ),
    );
  }
}
