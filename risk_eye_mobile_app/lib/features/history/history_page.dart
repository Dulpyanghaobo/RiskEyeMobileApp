import 'package:flutter/material.dart';

import '../../models/history_item.dart';
import '../../services/analytics_service.dart';
import '../../state/providers.dart';
import '../../widgets/app_bar.dart';
import '../../widgets/cards.dart';
import '../result/result_page.dart';
import '../upload/upload_page.dart';

/// History list page showing past evaluations with filtering and sorting.
class HistoryPage extends StatefulWidget {
  const HistoryPage({super.key});

  static const String routeName = '/history';

  @override
  State<HistoryPage> createState() => _HistoryPageState();
}

enum _SortOption { latest, scoreDesc, scoreAsc }

class _HistoryPageState extends State<HistoryPage> {
  String? _decisionFilter;
  _SortOption _sortOption = _SortOption.latest;

  @override
  void initState() {
    super.initState();
    AnalyticsService.logEvent('history_view');
    appState.addListener(_onStateChanged);
    appState.loadHistory();
  }

  void _onStateChanged() => setState(() {});

  @override
  void dispose() {
    appState.removeListener(_onStateChanged);
    super.dispose();
  }

  Future<void> _openFilter() async {
    AnalyticsService.logEvent('history_filter_open');
    final result = await showModalBottomSheet<_FilterResult>(
      context: context,
      builder: (context) {
        String? decision = _decisionFilter;
        _SortOption sort = _sortOption;
        return StatefulBuilder(
          builder: (context, setStateSheet) {
            return Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('决策状态'),
                  DropdownButton<String?>(
                    value: decision,
                    isExpanded: true,
                    items: const [
                      DropdownMenuItem(value: null, child: Text('全部')),
                      DropdownMenuItem(value: '通过', child: Text('通过')),
                      DropdownMenuItem(value: '拒绝', child: Text('拒绝')),
                      DropdownMenuItem(value: '需人工', child: Text('需人工')),
                      DropdownMenuItem(value: '需补件', child: Text('需补件')),
                      DropdownMenuItem(value: '进行中', child: Text('进行中')),
                      DropdownMenuItem(value: '失败', child: Text('失败')),
                    ],
                    onChanged: (v) => setStateSheet(() => decision = v),
                  ),
                  const SizedBox(height: 16),
                  const Text('排序'),
                  RadioListTile<_SortOption>(
                    title: const Text('最新优先'),
                    value: _SortOption.latest,
                    groupValue: sort,
                    onChanged: (v) => setStateSheet(() => sort = v!),
                  ),
                  RadioListTile<_SortOption>(
                    title: const Text('分数从高到低'),
                    value: _SortOption.scoreDesc,
                    groupValue: sort,
                    onChanged: (v) => setStateSheet(() => sort = v!),
                  ),
                  RadioListTile<_SortOption>(
                    title: const Text('分数从低到高'),
                    value: _SortOption.scoreAsc,
                    groupValue: sort,
                    onChanged: (v) => setStateSheet(() => sort = v!),
                  ),
                  const SizedBox(height: 8),
                  Align(
                    alignment: Alignment.centerRight,
                    child: ElevatedButton(
                      onPressed: () =>
                          Navigator.pop(context, _FilterResult(decision, sort)),
                      child: const Text('应用'),
                    ),
                  )
                ],
              ),
            );
          },
        );
      },
    );
    if (result != null) {
      setState(() {
        _decisionFilter = result.decision;
        _sortOption = result.sort;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    List<HistoryItem> items = List.from(appState.history);
    if (_decisionFilter != null) {
      items = items.where((e) => e.decision == _decisionFilter).toList();
    }
    switch (_sortOption) {
      case _SortOption.latest:
        items.sort((a, b) => b.createdAt.compareTo(a.createdAt));
        break;
      case _SortOption.scoreDesc:
        items.sort((a, b) => b.score.compareTo(a.score));
        break;
      case _SortOption.scoreAsc:
        items.sort((a, b) => a.score.compareTo(b.score));
        break;
    }

    return Scaffold(
      appBar: RiskAppBar(
        title: '历史记录',
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: _openFilter,
          ),
        ],
      ),
      body: items.isEmpty
          ? Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text('暂无历史记录'),
                  const SizedBox(height: 8),
                  ElevatedButton(
                    onPressed: () =>
                        Navigator.pushNamed(context, UploadPage.routeName),
                    child: const Text('去上传资料评估'),
                  ),
                ],
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: items.length,
              itemBuilder: (context, index) {
                final item = items[index];
                final date =
                    item.createdAt.toLocal().toString().split('.').first;
                return ListItemCard(
                  icon: Icons.history,
                  title: date,
                  subtitle: '分数 ${item.score} · ${item.decision}',
                  onTap: () {
                    AnalyticsService.logEvent('history_item_open');
                    Navigator.pushNamed(context, ResultPage.routeName);
                  },
                );
              },
            ),
    );
  }
}

class _FilterResult {
  const _FilterResult(this.decision, this.sort);

  final String? decision;
  final _SortOption sort;
}

