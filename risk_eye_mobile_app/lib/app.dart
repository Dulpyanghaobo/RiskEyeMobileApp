import 'package:flutter/material.dart';

import 'router.dart';
import 'theme/colors.dart';
import 'theme/typography.dart';
import 'features/home/home_page.dart';
import 'features/history/history_page.dart';
import 'features/evaluating/evaluating_page.dart';
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
      home: const _RootNavigation(),
    );
  }
}

class _RootNavigation extends StatefulWidget {
  const _RootNavigation();

  @override
  State<_RootNavigation> createState() => _RootNavigationState();
}

class _RootNavigationState extends State<_RootNavigation> {
  int _index = 0;

  final _pages = const [
    HomePage(),
    HistoryPage(),
    EvaluatingPage(),
    SettingsPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _index,
        children: _pages,
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _index,
        selectedItemColor: primaryColor,
        onTap: (i) => setState(() => _index = i),
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: '首页',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.history),
            label: '记录',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.assessment),
            label: '评估',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: '设置',
          ),
        ],
      ),
    );
  }
}
