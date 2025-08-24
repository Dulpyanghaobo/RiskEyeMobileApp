import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../core/error/app_exception.dart';
import '../repositories/upload_repository.dart';
import '../services/analytics_service.dart';

class UploadViewModel extends ChangeNotifier {
  final UploadRepository repository;
  final ImagePicker _picker = ImagePicker();

  bool uploading = false;
  double progress = 0;
  String? error;

  File? idFront;
  File? idBack;
  final List<File> property = [];
  final List<File> others = [];

  UploadViewModel(this.repository);

  bool get isIdComplete => idFront != null && idBack != null;
  bool get canSubmit => isIdComplete && !uploading;

  String? get missingReason => isIdComplete ? null : '请上传身份证正反面';

  List<File> get idFiles {
    final files = <File>[];
    if (idFront != null) files.add(idFront!);
    if (idBack != null) files.add(idBack!);
    return files;
  }

  File? get idLastFile => idBack ?? idFront;
  File? get propertyLastFile => property.isNotEmpty ? property.last : null;
  File? get otherLastFile => others.isNotEmpty ? others.last : null;

  String get idStatus {
    if (isIdComplete) return '✅ 已完成';
    if (idFront != null || idBack != null) return '⚠️ 缺少另一面';
    return '未上传';
  }

  String get propertyStatus =>
      property.isNotEmpty ? '✅ ${property.length}张' : '未上传';

  String get otherStatus =>
      others.isNotEmpty ? '✅ ${others.length}张' : '未上传';

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
      await repository.uploadDocument(
        file,
        type: type,
        onSendProgress: (sent, total) {
          progress = total == 0 ? 0 : sent / total;
          notifyListeners();
        },
      );

      switch (type) {
        case 'id_front':
          idFront = file;
          break;
        case 'id_back':
          idBack = file;
          break;
        case 'property':
          property.add(file);
          break;
        case 'other':
          others.add(file);
          break;
      }
      error = null;
      Fluttertoast.showToast(msg: '上传成功');
      AnalyticsService.logEvent('upload_success');
    } on AppException catch (e) {
      error = e.message;
      Fluttertoast.showToast(msg: e.message);
      AnalyticsService.logEvent('error_upload_fail');
    } catch (e) {
      error = e.toString();
      Fluttertoast.showToast(msg: error!);
      AnalyticsService.logEvent('error_upload_fail');
    } finally {
      uploading = false;
      notifyListeners();
    }
  }

  void removeDocument(String type, int index) {
    switch (type) {
      case 'id_front':
        idFront = null;
        break;
      case 'id_back':
        idBack = null;
        break;
      case 'property':
        if (index >= 0 && index < property.length) property.removeAt(index);
        break;
      case 'other':
        if (index >= 0 && index < others.length) others.removeAt(index);
        break;
    }
    notifyListeners();
  }
}
