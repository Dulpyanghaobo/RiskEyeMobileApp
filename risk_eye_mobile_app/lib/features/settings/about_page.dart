import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';
import '../../widgets/app_bar.dart';

class AboutPage extends StatefulWidget {
  const AboutPage({super.key});

  @override
  State<AboutPage> createState() => _AboutPageState();
}

class _AboutPageState extends State<AboutPage> {
  String _version = '';

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final info = await PackageInfo.fromPlatform();
    setState(() {
      _version = info.version;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const RiskAppBar(title: '关于'),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          ListTile(
            leading: const Icon(Icons.info_outline),
            title: const Text('应用版本'),
            subtitle: Text(_version),
          ),
          ListTile(
            leading: const Icon(Icons.delete_outline),
            title: const Text('清理缓存'),
            onTap: () {
              // TODO: implement actual cache clearing
              ScaffoldMessenger.of(context)
                  .showSnackBar(const SnackBar(content: Text('缓存已清理')));
            },
          ),
        ],
      ),
    );
  }
}
