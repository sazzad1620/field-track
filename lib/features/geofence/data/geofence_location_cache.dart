import 'dart:convert';
import 'dart:io';

import 'package:field_track/features/locations/domain/entities/location.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

class GeofenceLocationCache {
  static const _fileName = 'geofence_locations.json';

  static Future<File> _file() async {
    final dir = await getApplicationDocumentsDirectory();
    return File(p.join(dir.path, _fileName));
  }

  static Future<void> save(List<Location> locations) async {
    final map = {
      for (final location in locations) location.id: location.locationName,
    };
    await (await _file()).writeAsString(jsonEncode(map));
  }

  static Future<String?> nameFor(String id) async {
    final file = await _file();
    if (!await file.exists()) return null;
    final map = jsonDecode(await file.readAsString()) as Map<String, dynamic>;
    return map[id] as String?;
  }
}
