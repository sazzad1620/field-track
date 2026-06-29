import 'package:field_track/app.dart';
import 'package:field_track/core/di/injection.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  setUp(() async {
    await sl.reset();
    await setupInjection();
  });

  testWidgets('app builds splash then login', (tester) async {
    await tester.pumpWidget(const FieldTrackApp());
    await tester.pump();

    expect(find.text('Field Track'), findsOneWidget);

    await tester.pump(const Duration(milliseconds: 800));
    await tester.pumpAndSettle();

    expect(find.text('Login'), findsWidgets);
  });
}
