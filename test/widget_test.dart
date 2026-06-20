import 'package:eaze_me/app.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() {
  testWidgets('App builds and reaches auth flow', (WidgetTester tester) async {
    await tester.pumpWidget(const ProviderScope(child: EazeMeApp()));
    await tester.pump();

    expect(find.text('Eaze.me'), findsOneWidget);

    await tester.pump(const Duration(milliseconds: 2300));
    await tester.pump();

    expect(find.text('Welcome back'), findsOneWidget);
  });
}
