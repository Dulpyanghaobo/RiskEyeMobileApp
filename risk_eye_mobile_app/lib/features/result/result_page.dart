import 'package:flutter/material.dart';
import '../../widgets/app_bar.dart';
import '../../widgets/charts/donut.dart';
import '../../services/analytics_service.dart';
import '../../state/providers.dart';
import '../history/history_page.dart';

class ResultPage extends StatefulWidget {
  const ResultPage({super.key});

  static const String routeName = '/result';

  @override
  State<ResultPage> createState() => _ResultPageState();
}

class _ResultPageState extends State<ResultPage> {
  @override
  void initState() {
    super.initState();
    AnalyticsService.logEvent('result_view');
  }

  @override
  Widget build(BuildContext context) {
    final result = appState.lastResult;
    final historyItem = appState.history.isNotEmpty ? appState.history.last : null;

    if (result == null || historyItem == null) {
      return const Scaffold(
        appBar: RiskAppBar(title: '评估结果'),
        body: Center(child: Text('暂无结果')),
      );
    }

    Color decisionColor;
    if (result.score >= 720) {
      decisionColor = Colors.green;
    } else if (result.score >= 600) {
      decisionColor = Colors.orange;
    } else {
      decisionColor = Colors.red;
    }

    return Scaffold(
      appBar: const RiskAppBar(title: '评估结果'),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(child: DonutScoreChart(score: result.score)),
            const SizedBox(height: 16),
            Text('决策：${result.decision}', style: TextStyle(color: decisionColor)),
            Text('等级：${result.grade}'),
            const SizedBox(height: 4),
            Text('评估时间：${historyItem.createdAt}'),
            Text('模型版本：${result.modelVersion}'),
            const SizedBox(height: 16),
            if (result.strengths.isNotEmpty) ...[
              const Text('优势'),
              for (final s in result.strengths.take(3)) Text('• $s'),
              const SizedBox(height: 16),
            ],
            if (result.risks.isNotEmpty) ...[
              const Text('风险'),
              for (final r in result.risks.take(3)) Text('• $r'),
              const SizedBox(height: 16),
            ],
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      AnalyticsService.logEvent('export_click');
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('已保存结果')),
                      );
                    },
                    child: const Text('保存结果'),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      AnalyticsService.logEvent('trend_click');
                      Navigator.pushNamed(context, HistoryPage.routeName);
                    },
                    child: const Text('查看历史趋势'),
                  ),
                ),
              ],
            ),
            if (result.decision == '人工审核') ...[
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  AnalyticsService.logEvent('review_request');
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('已提交人工审核')),
                  );
                },
                child: const Text('提交人工审核'),
              ),
            ] else if (result.decision == '失败') ...[
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  AnalyticsService.logEvent('result_retry');
                  Navigator.pop(context);
                },
                child: const Text('重试'),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
