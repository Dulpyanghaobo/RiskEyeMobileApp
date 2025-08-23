import 'package:flutter/material.dart';
import '../../theme/colors.dart';

/// Placeholder for donut score chart.
class DonutScoreChart extends StatelessWidget {
  const DonutScoreChart({super.key, required this.score});

  final int score;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 120,
      height: 120,
      child: Stack(
        alignment: Alignment.center,
        children: [
          CircularProgressIndicator(
            value: score / 1000,
            backgroundColor: dividerColor,
            color: primaryColor,
            strokeWidth: 8,
          ),
          Text('$score'),
        ],
      ),
    );
  }
}
