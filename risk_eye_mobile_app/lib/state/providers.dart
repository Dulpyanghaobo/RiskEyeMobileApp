import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../core/network/dio_client.dart';
import '../repositories/loan_repository.dart';
import '../repositories/upload_repository.dart';
import '../services/image_compress_service.dart';
import '../services/image_picker_service.dart';
import '../services/storage_local.dart';
import '../viewmodels/loan_view_model.dart';
import '../viewmodels/upload_view_model.dart';
import 'app_state.dart';
import 'settings_state.dart';

/// Global app state instance (simplified).
final AppState appState = AppState();

/// Global settings state instance.
final SettingsState settingsState = SettingsState();

/// Build providers for dependency injection.
Future<List<SingleChildWidget>> createProviders() async {
  // Ensure SharedPreferences is initialized.
  await SharedPreferences.getInstance();
  final storage = StorageLocal();
  final dio = DioClient(storage: storage);
  return [
    Provider<StorageLocal>.value(value: storage),
    Provider<DioClient>.value(value: dio),
    ChangeNotifierProvider(
      create: (_) => UploadViewModel(
        repository: UploadRepository(dio, ImageCompressService()),
        picker: ImagePickerService(),
      ),
    ),
    ChangeNotifierProvider(
      create: (_) => LoanViewModel(LoanRepository(dio)),
    ),
  ];
}
