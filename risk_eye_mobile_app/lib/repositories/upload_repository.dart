import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';

import '../core/network/dio_client.dart';
import '../core/error/app_exception.dart';
import '../models/upload_result.dart';

class UploadRepository {
  final DioClient _client;
  UploadRepository(this._client);

  Future<UploadResult> uploadDocument(
    File file, {
    required String type,
    ProgressCallback? onSendProgress,
  }) async {
    File uploadFile = file;
    if (file.lengthSync() > 1024 * 1024) {
      final targetPath = '${file.path}_compressed.jpg';
      final compressed = await FlutterImageCompress.compressAndGetFile(
        file.absolute.path,
        targetPath,
        quality: 80,
      );
      if (compressed != null) {
        uploadFile = compressed;
      }
    }

    final formData = FormData.fromMap({
      'type': type,
      'file': await MultipartFile.fromFile(uploadFile.path),
    });

    try {
      final res = await _client.client.post(
        '/upload',
        data: formData,
        onSendProgress: onSendProgress,
      );
      return UploadResult.fromJson(res.data as Map<String, dynamic>);
    } on DioException catch (e) {
      throw e.error is AppException ? e.error : AppException.fromDio(e);
    }
  }
}
