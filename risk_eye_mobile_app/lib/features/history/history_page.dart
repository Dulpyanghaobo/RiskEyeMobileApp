import 'package:flutter/material.dart';
import '../../widgets/app_bar.dart';
import '../../widgets/cards.dart';
import '../result/result_page.dart';

class HistoryPage extends StatelessWidget {
  const HistoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const RiskAppBar(title: '历史记录'),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          ListItemCard(
            icon: Icons.history,
            title: '2025-08-23',
            subtitle: '分数 720 · 通过',
            onTap: () {
              Navigator.pushNamed(context, ResultPage.routeName);
            },
          ),
        ],
      ),
    );
  }
}
