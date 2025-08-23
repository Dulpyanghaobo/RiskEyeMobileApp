import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../core/error/app_exception.dart';
import '../models/loan_score.dart';
import '../repositories/loan_repository.dart';

class LoanViewModel extends ChangeNotifier {
  final LoanRepository repository;

  bool loading = false;
  LoanScore? score;
  String? error;

  LoanViewModel(this.repository);

  Future<void> fetchLatestScore(String userId) async {
    loading = true;
    notifyListeners();
    try {
      score = await repository.getLatestScore(userId);
      error = null;
    } catch (e) {
      error = _mapError(e);
      Fluttertoast.showToast(msg: error!);
    } finally {
      loading = false;
      notifyListeners();
    }
  }

  Future<void> triggerScore(String userId) async {
    loading = true;
    notifyListeners();
    try {
      score = await repository.triggerScore(userId);
      error = null;
      Fluttertoast.showToast(msg: '评分成功');
    } catch (e) {
      error = _mapError(e);
      Fluttertoast.showToast(msg: error!);
    } finally {
      loading = false;
      notifyListeners();
    }
  }

  String _mapError(Object e) {
    if (e is AppException) {
      return e.message;
    }
    return '未知错误';
  }
}
