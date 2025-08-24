import 'dart:io';

import 'package:flutter_image_compress/flutter_image_compress.dart';

/// Compress images using [flutter_image_compress].
class ImageCompressService {
  Future<File> compress(
    File file, {
    int quality = 80,
  }) async {
    final targetPath = '${file.path}_cmp.jpg';
    final result = await FlutterImageCompress.compressAndGetFile(
      file.absolute.path,
      targetPath,
      quality: quality,
    );
    return File(result?.path ?? file.path);
  }
}
