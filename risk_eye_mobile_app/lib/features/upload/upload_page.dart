import 'package:flutter/material.dart';
import '../../widgets/app_bar.dart';
import '../../widgets/uploader_tile.dart';
import '../../widgets/buttons.dart';
import '../evaluating/evaluating_page.dart';

class UploadPage extends StatelessWidget {
  const UploadPage({super.key});

  static const String routeName = '/upload';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const RiskAppBar(title: '上传资料'),
      body: GridView.count(
        padding: const EdgeInsets.all(16),
        crossAxisCount: 2,
        childAspectRatio: 1.2,
        children: const [
          UploaderTile(icon: Icons.credit_card, title: '身份证', status: '未上传'),
          UploaderTile(icon: Icons.account_balance, title: '银行流水', status: '未上传'),
          UploaderTile(icon: Icons.home, title: '房产证', status: '未上传'),
          UploaderTile(icon: Icons.insert_drive_file, title: '其他证明', status: '未上传'),
        ],
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16),
        child: PrimaryButton(
          label: '开始风险评估',
          onPressed: () {
            Navigator.pushNamed(context, EvaluatingPage.routeName);
          },
        ),
      ),
    );
  }
}
