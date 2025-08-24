import 'package:flutter/material.dart';
import '../../widgets/app_bar.dart';
import '../../services/analytics_service.dart';
import '../../state/providers.dart';
import '../result/result_page.dart';

class EvaluatingPage extends StatefulWidget {
  const EvaluatingPage({super.key});

  static const String routeName = '/evaluating';

  @override
  State<EvaluatingPage> createState() => _EvaluatingPageState();
}

class _EvaluatingPageState extends State<EvaluatingPage> {
  @override
  void initState() {
    super.initState();
    AnalyticsService.logEvent('evaluate_start');
    Future.delayed(const Duration(seconds: 2), () async {
      await appState.startEvaluation();
      AnalyticsService.logEvent('evaluate_done');
      if (mounted) {
        Navigator.pushReplacementNamed(context, ResultPage.routeName);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      appBar: RiskAppBar(title: '评估中'),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(),
            SizedBox(height: 16),
            Text('正在分析您的信用风险…预计 3–5 秒'),
          ],
        ),
      ),
    );
  }
}
