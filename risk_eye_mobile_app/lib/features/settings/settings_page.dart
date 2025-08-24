import 'package:flutter/material.dart';
import 'package:risk_eye_mobile_app/models/export_format.dart';
import '../../widgets/app_bar.dart';
import '../../widgets/cards.dart';
import '../../state/providers.dart';
import 'export_format_page.dart';
import 'about_page.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const RiskAppBar(title: '设置'),
      body: AnimatedBuilder(
        animation: settingsState,
        builder: (context, _) {
          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              const ListItemCard(icon: Icons.folder, title: '存储路径'),
              ListItemCard(
                icon: Icons.picture_as_pdf,
                title: '导出格式',
                subtitle: settingsState.exportFormat.label,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const ExportFormatPage()),
                  );
                },
              ),
              const ListItemCard(icon: Icons.lock, title: '本地加密'),
              ListItemCard(
                icon: Icons.info,
                title: '关于',
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const AboutPage()),
                  );
                },
              ),
            ],
          );
        },
      ),
    );
  }
}
