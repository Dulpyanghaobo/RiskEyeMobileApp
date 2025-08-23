import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'core/network/dio_client.dart';
import 'repositories/loan_repository.dart';
import 'repositories/upload_repository.dart';
import 'viewmodels/loan_view_model.dart';
import 'viewmodels/upload_view_model.dart';
import 'features/score/score_page.dart';
import 'features/upload/upload_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final prefs = await SharedPreferences.getInstance();
  final dio = DioClient(prefs);
  runApp(MyApp(dio));
}

class MyApp extends StatelessWidget {
  final DioClient dio;
  const MyApp(this.dio, {super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
            create: (_) => LoanViewModel(LoanRepository(dio))),
        ChangeNotifierProvider(
            create: (_) => UploadViewModel(UploadRepository(dio))),
      ],
      child: const MaterialApp(
        title: 'Risk Eye',
        home: _HomePage(),
      ),
    );
  }
}

class _HomePage extends StatefulWidget {
  const _HomePage();

  @override
  State<_HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<_HomePage> {
  int index = 0;
  final pages = const [ScorePage(), UploadPage()];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: pages[index],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: index,
        onTap: (i) => setState(() => index = i),
        items: const [
          BottomNavigationBarItem(
              icon: Icon(Icons.assessment), label: '评分'),
          BottomNavigationBarItem(
              icon: Icon(Icons.cloud_upload), label: '上传'),
        ],
      ),
    );
  }
}
