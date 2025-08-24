import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../models/history_item.dart';

/// Local storage wrapper based on [SharedPreferences].
class StorageLocal {
  SharedPreferences? _prefs;

  Future<SharedPreferences> get _instance async =>
      _prefs ??= await SharedPreferences.getInstance();

  Future<void> setString(String key, String value) async {
    final prefs = await _instance;
    await prefs.setString(key, value);
  }

  Future<String?> getString(String key) async {
    final prefs = await _instance;
    return prefs.getString(key);
  }

  Future<void> setBool(String key, bool value) async {
    final prefs = await _instance;
    await prefs.setBool(key, value);
  }

  Future<bool?> getBool(String key) async {
    final prefs = await _instance;
    return prefs.getBool(key);
  }

  Future<void> setJson(String key, Map<String, dynamic> value) async {
    final prefs = await _instance;
    await prefs.setString(key, jsonEncode(value));
  }

  Future<Map<String, dynamic>?> getJson(String key) async {
    final prefs = await _instance;
    final str = prefs.getString(key);
    return str == null ? null : jsonDecode(str) as Map<String, dynamic>;
  }

  static const _tokenKey = 'access_token';
  Future<void> setToken(String token) => setString(_tokenKey, token);
  Future<String?> getToken() => getString(_tokenKey);
  Future<void> clearToken() async {
    final prefs = await _instance;
    await prefs.remove(_tokenKey);
  }

  // --- Existing history helpers ---
  static const _historyKey = 'history_items';
  Future<void> saveHistory(HistoryItem item) async {
    final list = await loadHistory();
    list.add(item);
    final prefs = await _instance;
    final jsonList = list.map((e) => e.toJson()).toList();
    await prefs.setString(_historyKey, jsonEncode(jsonList));
  }

  Future<List<HistoryItem>> loadHistory() async {
    final prefs = await _instance;
    final str = prefs.getString(_historyKey);
    if (str == null) return [];
    final data = jsonDecode(str) as List<dynamic>;
    return data
        .map((e) => HistoryItem.fromJson(e as Map<String, dynamic>))
        .toList();
  }
}
