import 'package:field_track/app.dart';
import 'package:field_track/core/di/injection.dart';
import 'package:field_track/features/auth/data/datasources/auth_local_datasource.dart';
import 'package:field_track/features/auth/presentation/widgets/field_track_logo.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';

class FakeAuthLocalDatasource extends AuthLocalDatasource {
  FakeAuthLocalDatasource() : super(const FlutterSecureStorage());

  bool hasStoredSession = false;

  @override
  Future<bool> hasSession() async => hasStoredSession;
}

void main() {
  late FakeAuthLocalDatasource fakeLocal;

  setUp(() async {
    await sl.reset();
    fakeLocal = FakeAuthLocalDatasource();
    sl.registerLazySingleton<AuthLocalDatasource>(() => fakeLocal);
    await setupInjection();
  });

  testWidgets('app builds splash then login', (tester) async {
    await tester.pumpWidget(const FieldTrackApp());
    await tester.pump();

    expect(find.byType(FieldTrackLogo), findsOneWidget);

    await tester.pump(const Duration(milliseconds: 700));
    await tester.pumpAndSettle();

    expect(find.text('Welcome back'), findsOneWidget);
    expect(find.text('Sign in'), findsOneWidget);
  });
}
