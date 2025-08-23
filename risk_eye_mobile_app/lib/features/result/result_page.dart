import 'package:flutter/material.dart';
import '../../widgets/app_bar.dart';
import '../../widgets/charts/donut.dart';
import '../../widgets/charts/radar.dart';
import '../../widgets/charts/bar.dart';

class ResultPage extends StatelessWidget {
  const ResultPage({super.key});

  static const String routeName = '/result';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const RiskAppBar(title: '评估结果（已保存）'),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            Center(child: DonutScoreChart(score: 720)),
            SizedBox(height: 16),
            Text('决策：通过'),
            SizedBox(height: 16),
            Text('优势'),
            Text('• 收入稳定'),
            Text('• 流水连续'),
            SizedBox(height: 16),
            Text('风险'),
            Text('• 近3月消费波动偏高'),
            SizedBox(height: 16),
            RadarChart(),
            SizedBox(height: 16),
            BarChart(),
          ],
        ),
      ),
    );
  }
}
