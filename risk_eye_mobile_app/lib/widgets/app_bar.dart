import 'package:flutter/material.dart';
import '../theme/colors.dart';

class RiskAppBar extends StatelessWidget implements PreferredSizeWidget {
  const RiskAppBar({super.key, required this.title, this.actions});

  final String title;
  final List<Widget>? actions;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(title),
      backgroundColor: primaryColor,
      foregroundColor: Colors.white,
      actions: actions,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
