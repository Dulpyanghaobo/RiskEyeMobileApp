import 'package:flutter/foundation.dart';

import '../models/score_resp.dart';
import '../repositories/loan_repository.dart';
import '../services/toast_service.dart';

class LoanViewModel extends ChangeNotifier {
  final LoanRepository repository;

  bool loading = false;
  String? errorMsg;
  ScoreResp? score;

  LoanViewModel(this.repository);

  Future<void> getLatestScore(String userId) async {
    loading = true;
    notifyListeners();
    final result = await repository.getLatestScore(userId);
    result.when(
      success: (data) {
        score = data;
        errorMsg = null;
      },
      failure: (e) {
        errorMsg = e.message;
        ToastService.showToast(e.message);
      },
    );
    loading = false;
    notifyListeners();
  }

  Future<void> triggerScore(String userId) async {
    loading = true;
    notifyListeners();
    final result = await repository.triggerScore(userId);
    result.when(
      success: (data) {
        score = data;
        errorMsg = null;
        ToastService.showToast('评分成功');
      },
      failure: (e) {
        errorMsg = e.message;
        ToastService.showToast(e.message);
      },
    );
    loading = false;
    notifyListeners();
  }
}
