import 'dart:io';

import 'package:dio/dio.dart';

import '../core/network/api_result.dart';
import '../core/network/dio_client.dart';
import '../models/file_upload_resp.dart';
import '../services/image_compress_service.dart';

class UploadRepository {
  final DioClient _client;
  final ImageCompressService _compress;

  UploadRepository(this._client, this._compress);

  Future<ApiResult<FileUploadResp>> uploadDoc(
    File file, {
    ProgressCallback? onSendProgress,
  }) async {
    final compressed = await _compress.compress(file);
    return _client.upload<FileUploadResp>(
      '/upload',
      file: compressed,
      onSendProgress: onSendProgress,
      parser: (json) => FileUploadResp.fromJson(json as Map<String, dynamic>),
    );
  }
}
