import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import '../../services/analytics_service.dart';
import '../../viewmodels/upload_view_model.dart';
import '../evaluating/evaluating_page.dart';

class UploadPage extends StatefulWidget {
  const UploadPage({super.key});

  static const routeName = '/upload';

  @override
  State<UploadPage> createState() => _UploadPageState();
}

class _UploadPageState extends State<UploadPage> {
  @override
  void initState() {
    super.initState();
    AnalyticsService.logEvent('upload_view');
  }

  Future<String?> _selectIdSide() async {
    return showDialog<String>(
      context: context,
      builder: (context) => SimpleDialog(
        title: const Text('选择身份证面别'),
        children: [
          SimpleDialogOption(
            onPressed: () => Navigator.pop(context, 'front'),
            child: const Text('正面'),
          ),
          SimpleDialogOption(
            onPressed: () => Navigator.pop(context, 'back'),
            child: const Text('反面'),
          ),
        ],
      ),
    );
  }

  void _previewId(UploadViewModel vm) {
    showModalBottomSheet(
      context: context,
      builder: (_) => ListView(
        padding: const EdgeInsets.all(16),
        children: [
          if (vm.idFront != null)
            _previewItem(vm.idFront!, () {
              vm.removeDocument('id_front', 0);
              Navigator.pop(context);
            }, label: '正面'),
          if (vm.idBack != null)
            _previewItem(vm.idBack!, () {
              vm.removeDocument('id_back', 0);
              Navigator.pop(context);
            }, label: '反面'),
        ],
      ),
    );
  }

  void _previewGroup(List<File> files, String type, UploadViewModel vm) {
    showModalBottomSheet(
      context: context,
      builder: (_) => ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: files.length,
        itemBuilder: (_, i) => _previewItem(files[i], () {
          vm.removeDocument(type, i);
          Navigator.pop(context);
        }),
      ),
    );
  }

  Widget _previewItem(File file, VoidCallback onDelete, {String? label}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Stack(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (label != null) Text(label),
              if (label != null) const SizedBox(height: 4),
              Image.file(file),
            ],
          ),
          Positioned(
            right: 0,
            top: 0,
            child: IconButton(
              icon: const Icon(Icons.close, color: Colors.red),
              onPressed: onDelete,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGroupCard({
    required String title,
    required String status,
    required VoidCallback onCamera,
    required VoidCallback onFile,
    File? lastFile,
    VoidCallback? onPreview,
    int count = 0,
  }) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 8),
            Row(
              children: [
                ElevatedButton(
                  onPressed: onCamera,
                  child: const Text('拍照上传'),
                ),
                const SizedBox(width: 12),
                ElevatedButton(
                  onPressed: onFile,
                  child: const Text('文件选择'),
                ),
                const Spacer(),
                if (lastFile != null)
                  GestureDetector(
                    onTap: onPreview,
                    child: Image.file(
                      lastFile,
                      width: 60,
                      height: 60,
                      fit: BoxFit.cover,
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Text('已选择：$count'),
                const SizedBox(width: 12),
                Text(status),
              ],
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<UploadViewModel>();
    return Scaffold(
      appBar: AppBar(title: const Text('上传资料')),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  _buildGroupCard(
                    title: '身份证',
                    status: vm.idStatus,
                    onCamera: () async {
                      final side = await _selectIdSide();
                      if (side == null) return;
                      AnalyticsService.logEvent('click_camera_id');
                      vm.pickAndUpload(ImageSource.camera, type: 'id_$side');
                    },
                    onFile: () async {
                      final side = await _selectIdSide();
                      if (side == null) return;
                      AnalyticsService.logEvent('click_file_id');
                      vm.pickAndUpload(ImageSource.gallery, type: 'id_$side');
                    },
                    lastFile: vm.idLastFile,
                    onPreview: vm.idFiles.isEmpty ? null : () => _previewId(vm),
                    count: vm.idFiles.length,
                  ),
                  const SizedBox(height: 12),
                  _buildGroupCard(
                    title: '房产证',
                    status: vm.propertyStatus,
                    onCamera: () {
                      AnalyticsService.logEvent('click_camera_property');
                      vm.pickAndUpload(ImageSource.camera, type: 'property');
                    },
                    onFile: () {
                      AnalyticsService.logEvent('click_file_property');
                      vm.pickAndUpload(ImageSource.gallery, type: 'property');
                    },
                    lastFile: vm.propertyLastFile,
                    onPreview: vm.property.isEmpty
                        ? null
                        : () => _previewGroup(vm.property, 'property', vm),
                    count: vm.property.length,
                  ),
                  const SizedBox(height: 12),
                  _buildGroupCard(
                    title: '其他证明',
                    status: vm.otherStatus,
                    onCamera: () {
                      AnalyticsService.logEvent('click_camera_other');
                      vm.pickAndUpload(ImageSource.camera, type: 'other');
                    },
                    onFile: () {
                      AnalyticsService.logEvent('click_file_other');
                      vm.pickAndUpload(ImageSource.gallery, type: 'other');
                    },
                    lastFile: vm.otherLastFile,
                    onPreview: vm.others.isEmpty
                        ? null
                        : () => _previewGroup(vm.others, 'other', vm),
                    count: vm.others.length,
                  ),
                  if (vm.uploading) ...[
                    const SizedBox(height: 16),
                    LinearProgressIndicator(value: vm.progress),
                  ],
                  if (vm.error != null) ...[
                    const SizedBox(height: 8),
                    Text(vm.error!,
                        style: const TextStyle(color: Colors.red)),
                  ],
                ],
              ),
            ),
          ),
          if (vm.missingReason != null)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  vm.missingReason!,
                  style: const TextStyle(color: Colors.red),
                ),
              ),
            ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: vm.canSubmit
                    ? () {
                        AnalyticsService.logEvent(
                            'evaluate_start_from_upload');
                        Navigator.pushNamed(
                            context, EvaluatingPage.routeName);
                      }
                    : null,
                child: const Text('开始风险评估'),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
