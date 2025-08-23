import '../models/history_item.dart';

/// In-memory storage placeholder.
class StorageLocal {
  final List<HistoryItem> _history = [];

  Future<void> saveHistory(HistoryItem item) async {
    _history.add(item);
  }

  Future<List<HistoryItem>> loadHistory() async {
    return _history;
  }
}
