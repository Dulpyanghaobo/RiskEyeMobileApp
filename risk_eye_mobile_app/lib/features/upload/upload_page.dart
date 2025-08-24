import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../viewmodels/upload_view_model.dart';

class UploadPage extends StatelessWidget {
  const UploadPage({super.key});

  static const routeName = '/upload';

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<UploadViewModel>();
    return Scaffold(
      appBar: AppBar(title: const Text('上传示例')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (vm.loading) LinearProgressIndicator(value: vm.progress),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: vm.loading ? null : vm.pickAndUpload,
              child: const Text('选择图片并上传'),
            ),
            if (vm.errorMsg != null) ...[
              const SizedBox(height: 16),
              Text(vm.errorMsg!, style: const TextStyle(color: Colors.red)),
            ],
          ],
        ),
      ),
    );
  }
}
