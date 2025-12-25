// This is a basic Flutter widget test.

import 'package:flutter_test/flutter_test.dart';

import 'package:cuatro_patas/main.dart';

void main() {
  testWidgets('App smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const PetCareApp());

    // Verify that the welcome screen is shown
    expect(find.text('PetCare'), findsWidgets);
  });
}
