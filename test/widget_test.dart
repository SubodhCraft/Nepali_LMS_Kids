import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nepali_kids_lms/main.dart';

void main() {
  testWidgets('App boots up test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const ProviderScope(child: NepaliKidsLmsApp()));
    await tester.pumpAndSettle();

    // Verify that our home text is found.
    expect(find.text('Nepali Kids LMS - Home'), findsOneWidget);
  });
}
