import 'package:flutter_test/flutter_test.dart';
import 'package:wazza3/main.dart';

void main() {
  testWidgets('App starts without errors', (WidgetTester tester) async {
    await tester.pumpWidget(const Wazza3App());
    expect(find.byType(Wazza3App), findsOneWidget);
  });
}
