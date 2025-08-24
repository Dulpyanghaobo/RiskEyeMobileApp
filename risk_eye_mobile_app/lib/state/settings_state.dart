import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/export_format.dart';

class SettingsState extends ChangeNotifier {
  SettingsState() {
    _load();
  }

  static const _keyExportFormat = 'default_export_format';
  late SharedPreferences _prefs;
  ExportFormat _exportFormat = ExportFormat.pdf;

  ExportFormat get exportFormat => _exportFormat;

  Future<void> _load() async {
    _prefs = await SharedPreferences.getInstance();
    final value = _prefs.getString(_keyExportFormat);
    _exportFormat = ExportFormatX.fromName(value);
    notifyListeners();
  }

  Future<void> setExportFormat(ExportFormat format) async {
    _exportFormat = format;
    await _prefs.setString(_keyExportFormat, format.name);
    notifyListeners();
  }
}
