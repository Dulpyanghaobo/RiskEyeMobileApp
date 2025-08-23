import 'package:flutter/material.dart';

import 'router.dart';
import 'theme/colors.dart';
import 'theme/typography.dart';
import 'features/home/home_page.dart';
import 'features/history/history_page.dart';
import 'features/settings/settings_page.dart';

/// Root application widget with bottom navigation.
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Risk Eye',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: primaryColor),
        textTheme: appTextTheme,
        scaffoldBackgroundColor: backgroundColor,
        useMaterial3: true,
      ),
      onGenerateRoute: AppRouter.onGenerateRoute,
      home: const RootNavigation(),
    );
  }
}

class RootNavigation extends StatefulWidget {
  const RootNavigation();

  @override
  State<RootNavigation> createState() => _RootNavigationState();
}

class _RootNavigationState extends State<RootNavigation> {
  int _index = 0;

  Widget _buildBody() {
    switch (_index) {
      case 0:
        return const HomePage();
      case 1:
        return const HistoryPage();
      case 3:
        return const SettingsPage();
      default:
        return const SizedBox.shrink();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _buildBody(),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _index,
        selectedItemColor: primaryColor,
        onTap: (i) => setState(() => _index = i),
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: '首页'),
          BottomNavigationBarItem(icon: Icon(Icons.history), label: '记录'),
          BottomNavigationBarItem(icon: Icon(Icons.settings), label: '设置'),
        ],
      ),
    );
  }
}
