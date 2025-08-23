import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../core/error/app_exception.dart';
import '../models/upload_result.dart';
import '../repositories/upload_repository.dart';

class UploadViewModel extends ChangeNotifier {
  final UploadRepository repository;
  final ImagePicker _picker = ImagePicker();

  bool uploading = false;
  double progress = 0;
  UploadResult? result;
  String? error;

  UploadViewModel(this.repository);

  Future<void> pickAndUpload(ImageSource source, {required String type}) async {
    try {
      final XFile? picked = await _picker.pickImage(source: source);
      if (picked == null) {
        Fluttertoast.showToast(msg: '未选择图片');
        return;
      }
      uploading = true;
      progress = 0;
      notifyListeners();

      final file = File(picked.path);
      result = await repository.uploadDocument(
        file,
        type: type,
        onSendProgress: (sent, total) {
          progress = total == 0 ? 0 : sent / total;
          notifyListeners();
        },
      );
      error = null;
      Fluttertoast.showToast(msg: '上传成功');
    } on AppException catch (e) {
      error = e.message;
      Fluttertoast.showToast(msg: e.message);
    } catch (e) {
      error = e.toString();
      Fluttertoast.showToast(msg: error!);
    } finally {
      uploading = false;
      notifyListeners();
    }
  }
}
