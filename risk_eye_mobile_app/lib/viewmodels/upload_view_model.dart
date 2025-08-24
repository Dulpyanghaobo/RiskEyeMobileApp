import 'dart:io';

import 'package:flutter/foundation.dart';

import '../repositories/upload_repository.dart';
import '../services/image_picker_service.dart';
import '../services/toast_service.dart';

class UploadViewModel extends ChangeNotifier {
  final UploadRepository repository;
  final ImagePickerService picker;

  bool loading = false;
  double progress = 0;
  String? errorMsg;

  UploadViewModel({required this.repository, required this.picker});

  Future<void> pickAndUpload() async {
    final xfile = await picker.pickAny();
    if (xfile == null) return;
    loading = true;
    progress = 0;
    notifyListeners();
    final file = File(xfile.path);
    final result = await repository.uploadDoc(
      file,
      onSendProgress: (sent, total) {
        progress = total == 0 ? 0 : sent / total;
        notifyListeners();
      },
    );
    result.when(
      success: (_) {
        errorMsg = null;
        ToastService.showToast('上传成功');
      },
      failure: (e) {
        errorMsg = e.message;
        ToastService.showToast(e.message);
      },
    );
    loading = false;
    notifyListeners();
  }
}
