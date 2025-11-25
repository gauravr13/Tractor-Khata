// Tractor Khata App - Basic Widget Test
import 'package:flutter_test/flutter_test.dart';
import 'package:tractor_khata/main.dart';

void main() {
  testWidgets('App launches successfully', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const TractorKhataApp());

    // Verify app initializes without errors
    expect(tester.takeException(), isNull);
  });
}
