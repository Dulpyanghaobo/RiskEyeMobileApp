import 'package:flutter/material.dart';
import '../theme/colors.dart';

class UploaderTile extends StatelessWidget {
  const UploaderTile({
    super.key,
    required this.icon,
    required this.title,
    required this.status,
    this.onTap,
  });

  final IconData icon;
  final String title;
  final String status;
  final VoidCallback? onTap;

  Color _statusColor() {
    switch (status) {
      case '已上传':
        return successColor;
      case '失败':
        return riskColor;
      default:
        return dividerColor;
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        elevation: 0,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 40, color: primaryColor),
              const SizedBox(height: 8),
              Text(title),
              const SizedBox(height: 4),
              Text(
                status,
                style: TextStyle(color: _statusColor()),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
