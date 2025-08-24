import 'package:flutter_test/flutter_test.dart';
import 'package:risk_eye_mobile_app/app.dart';

void main() {
  testWidgets('Home tab shows', (tester) async {
    await tester.pumpWidget(const MyApp());
    expect(find.text('首页'), findsOneWidget);
  });

  testWidgets('History page empty state', (tester) async {
    await tester.pumpWidget(const MyApp());
    await tester.tap(find.text('记录'));
    await tester.pumpAndSettle();
    expect(find.text('历史记录'), findsOneWidget);
    expect(find.text('暂无历史记录'), findsOneWidget);
  });
}
