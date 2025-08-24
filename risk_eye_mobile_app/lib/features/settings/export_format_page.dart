import 'package:flutter/material.dart';
import '../../widgets/app_bar.dart';
import '../../state/providers.dart';
import '../../models/export_format.dart';

class ExportFormatPage extends StatelessWidget {
  const ExportFormatPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const RiskAppBar(title: '导出格式'),
      body: AnimatedBuilder(
        animation: settingsState,
        builder: (context, _) {
          return ListView(
            children: ExportFormat.values.map((format) {
              return RadioListTile<ExportFormat>(
                title: Text(format.label),
                value: format,
                groupValue: settingsState.exportFormat,
                onChanged: (value) {
                  if (value != null) {
                    settingsState.setExportFormat(value);
                  }
                },
              );
            }).toList(),
          );
        },
      ),
    );
  }
}
