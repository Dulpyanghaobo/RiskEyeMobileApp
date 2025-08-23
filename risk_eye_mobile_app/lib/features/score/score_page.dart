import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../viewmodels/loan_view_model.dart';

class ScorePage extends StatelessWidget {
  const ScorePage({super.key});

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<LoanViewModel>();
    final score = vm.score;
    return Scaffold(
      appBar: AppBar(title: const Text('评分结果')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                ElevatedButton(
                  onPressed: () => context
                      .read<LoanViewModel>()
                      .fetchLatestScore('user123'),
                  child: const Text('获取最近评分'),
                ),
                const SizedBox(width: 16),
                ElevatedButton(
                  onPressed: () => context
                      .read<LoanViewModel>()
                      .triggerScore('user123'),
                  child: const Text('触发评分'),
                ),
              ],
            ),
            const SizedBox(height: 20),
            if (vm.loading) const Center(child: CircularProgressIndicator()),
            if (score != null) ...[
              Text('Score: ${score.score}'),
              Text('Decision: ${score.decision.name}'),
              Text('ModelVersion: ${score.modelVersion}'),
              Text('ReasonCodes: ${score.reasonCodes.join(', ')}'),
              Text('Time: ${DateFormat.yMd().add_jm().format(score.createdAt)}'),
            ],
            if (vm.error != null)
              Text(vm.error!, style: const TextStyle(color: Colors.red)),
          ],
        ),
      ),
    );
  }
}
