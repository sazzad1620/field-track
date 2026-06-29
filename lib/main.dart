import 'package:field_track/app.dart';
import 'package:field_track/core/di/injection.dart';
import 'package:flutter/material.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await setupInjection();
  runApp(const FieldTrackApp());
}
