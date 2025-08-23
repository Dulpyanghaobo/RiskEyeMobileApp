import 'package:flutter/material.dart';
import '../../widgets/app_bar.dart';
import '../../widgets/cards.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const RiskAppBar(title: '设置'),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: const [
          ListItemCard(
            icon: Icons.folder,
            title: '存储路径',
          ),
          ListItemCard(
            icon: Icons.picture_as_pdf,
            title: '导出格式',
          ),
          ListItemCard(
            icon: Icons.lock,
            title: '本地加密',
          ),
          ListItemCard(
            icon: Icons.info,
            title: '关于',
          ),
        ],
      ),
    );
  }
}
