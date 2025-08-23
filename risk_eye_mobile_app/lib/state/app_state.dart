import 'package:flutter/foundation.dart';
import '../models/upload_sources.dart';
import '../models/history_item.dart';
import '../models/score_result.dart';
import '../services/storage_local.dart';
import '../services/scoring_engine.dart';

/// Simple application state holder.
class AppState extends ChangeNotifier {
  AppState({StorageLocal? storage, ScoringEngine? engine})
      : _storage = storage ?? StorageLocal(),
        _engine = engine ?? ScoringEngine();

  final StorageLocal _storage;
  final ScoringEngine _engine;

  List<HistoryItem> _history = [];
  List<HistoryItem> get history => _history;

  Future<void> loadHistory() async {
    _history = await _storage.loadHistory();
    notifyListeners();
  }

  Future<ScoreResult> startEvaluation() async {
    final result = await _engine.evaluate();
    final item = HistoryItem(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      createdAt: DateTime.now(),
      score: result.score,
      grade: result.grade,
      decision: result.decision,
      reasonCodes: result.reasonCodes.map((e) => e.code).toList(),
      sources: const UploadSources(
        idCard: true,
        bankStatement: true,
        propertyDoc: false,
      ),
      modelVersion: result.modelVersion,
    );
    await _storage.saveHistory(item);
    _history.add(item);
    notifyListeners();
    return result;
  }
}
