import 'package:flutter/material.dart';
import '../../widgets/app_bar.dart';
import '../../widgets/cards.dart';
import '../../services/analytics_service.dart';
import '../../state/providers.dart';
import '../upload/upload_page.dart';
import '../evaluating/evaluating_page.dart';
import '../settings/settings_page.dart';
import '../result/result_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
    AnalyticsService.logEvent('home_view');
    appState.addListener(_onStateChanged);
    appState.loadHistory();
  }

  void _onStateChanged() => setState(() {});

  @override
  void dispose() {
    appState.removeListener(_onStateChanged);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final hasHistory = appState.history.isNotEmpty;
    return Scaffold(
      appBar: RiskAppBar(
        title: '首页',
        actions: [
          IconButton(
            icon: const Icon(Icons.help_outline),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const SettingsPage()),
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '智能贷款风险评估工具',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 4),
            const Text('本地处理 · 隐私优先 · 秒级出分'),
            const SizedBox(height: 16),
            Card(
              child: ListTile(
                leading: const Icon(Icons.file_upload),
                title: const Text('上传资料开始评估'),
                subtitle: const Text('支持身份证、银行流水、房产等'),
                onTap: () {
                  AnalyticsService.logEvent('home_click_upload');
                  Navigator.pushNamed(context, UploadPage.routeName);
                },
              ),
            ),
            const SizedBox(height: 12),
            OutlinedButton(
              onPressed: hasHistory
                  ? () {
                      AnalyticsService.logEvent('home_click_quick_eval');
                      Navigator.pushNamed(context, EvaluatingPage.routeName);
                    }
                  : null,
              child: const Text('使用上次资料评估'),
            ),
            const SizedBox(height: 24),
            Text('最近评估', style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 8),
            if (hasHistory)
              ...appState.history.reversed.map((item) {
                final date =
                    item.createdAt.toLocal().toString().split('.').first;
                return ListItemCard(
                  icon: Icons.credit_score,
                  title: date,
                  subtitle: '分数 ${item.score} · ${item.decision}',
                  onTap: () {
                    AnalyticsService.logEvent('history_card_open');
                    Navigator.pushNamed(context, ResultPage.routeName);
                  },
                );
              })
            else
              ListItemCard(
                icon: Icons.credit_score,
                title: '示例评估',
                subtitle: '得分 720',
                onTap: () {
                  AnalyticsService.logEvent('history_card_open');
                  Navigator.pushNamed(context, ResultPage.routeName);
                },
              ),
          ],
        ),
      ),
    );
  }
}
