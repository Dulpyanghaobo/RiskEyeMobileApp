import 'package:flutter_test/flutter_test.dart';
import 'package:risk_eye_mobile_app/app.dart';

void main() {
  testWidgets('Home tab shows', (tester) async {
    await tester.pumpWidget(const MyApp());
    expect(find.text('首页'), findsOneWidget);
  });
}
