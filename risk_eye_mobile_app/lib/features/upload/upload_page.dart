import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import '../../viewmodels/upload_view_model.dart';

class UploadPage extends StatelessWidget {
  const UploadPage({super.key});

  static const routeName = '/upload';

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<UploadViewModel>();
    return Scaffold(
      appBar: AppBar(title: const Text('上传资料')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () => context
                      .read<UploadViewModel>()
                      .pickAndUpload(ImageSource.camera, type: 'id'),
                  child: const Text('拍照上传'),
                ),
                ElevatedButton(
                  onPressed: () => context
                      .read<UploadViewModel>()
                      .pickAndUpload(ImageSource.gallery, type: 'id'),
                  child: const Text('相册选择上传'),
                ),
              ],
            ),
            const SizedBox(height: 20),
            if (vm.uploading) LinearProgressIndicator(value: vm.progress),
            if (vm.result != null) Text('上传成功: ${vm.result!.url}'),
            if (vm.error != null)
              Text(vm.error!, style: const TextStyle(color: Colors.red)),
          ],
        ),
      ),
    );
  }
}
