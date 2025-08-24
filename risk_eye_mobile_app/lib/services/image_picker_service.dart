import 'package:image_picker/image_picker.dart';

/// Wrapper around [ImagePicker].
class ImagePickerService {
  final ImagePicker _picker = ImagePicker();

  Future<XFile?> pickIdFront() => _picker.pickImage(source: ImageSource.camera);

  Future<XFile?> pickIdBack() => _picker.pickImage(source: ImageSource.camera);

  Future<XFile?> pickAny({ImageSource source = ImageSource.gallery}) =>
      _picker.pickImage(source: source);
}
