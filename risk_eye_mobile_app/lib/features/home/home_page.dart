import 'package:flutter/material.dart';
import '../../widgets/app_bar.dart';
import '../../widgets/buttons.dart';
import '../../widgets/cards.dart';
import '../upload/upload_page.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const RiskAppBar(title: '首页'),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('智能贷款风险评估工具'),
            const SizedBox(height: 16),
            PrimaryButton(
              label: '上传资料',
              onPressed: () {
                Navigator.pushNamed(context, UploadPage.routeName);
              },
            ),
            const SizedBox(height: 24),
            const Text('最近评估'),
            const SizedBox(height: 8),
            Expanded(
              child: ListView(
                children: const [
                  ListItemCard(
                    icon: Icons.credit_score,
                    title: '示例评估',
                    subtitle: '得分 720',
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
