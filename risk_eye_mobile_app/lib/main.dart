import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'app.dart'; // 引入主题/路由以及 RootNavigation
import 'core/network/dio_client.dart';
import 'repositories/loan_repository.dart';
import 'repositories/upload_repository.dart';
import 'viewmodels/loan_view_model.dart';
import 'viewmodels/upload_view_model.dart';
import 'router.dart';
import 'theme/colors.dart';
import 'theme/typography.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final prefs = await SharedPreferences.getInstance();
  final dio = DioClient(prefs);
  runApp(RootApp(dio));
}

class RootApp extends StatelessWidget {
  final DioClient dio;
  const RootApp(this.dio, {super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => LoanViewModel(LoanRepository(dio)),
        ),
        ChangeNotifierProvider(
          create: (_) => UploadViewModel(UploadRepository(dio)),
        ),
      ],
      child: MaterialApp(
        title: 'Risk Eye',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: primaryColor),
          textTheme: appTextTheme,
          scaffoldBackgroundColor: backgroundColor,
          useMaterial3: true,
        ),
        onGenerateRoute: AppRouter.onGenerateRoute,
        home: const RootNavigation(), // ← 用回 app.dart 的底部导航（含 HomePage）
      ),
    );
  }
}
