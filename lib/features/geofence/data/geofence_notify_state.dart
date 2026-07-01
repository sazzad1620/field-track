import 'dart:convert';
import 'dart:io';

import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

class GeofenceNotifyState {
  static const _fileName = 'geofence_notify_state.json';

  static Future<File> _file() async {
    final dir = await getApplicationDocumentsDirectory();
    return File(p.join(dir.path, _fileName));
  }

  static Future<Set<String>> _load() async {
    final file = await _file();
    if (!await file.exists()) return {};
    final list = jsonDecode(await file.readAsString()) as List<dynamic>;
    return list.cast<String>().toSet();
  }

  static Future<void> _save(Set<String> ids) async {
    await (await _file()).writeAsString(jsonEncode(ids.toList()));
  }

  static Future<bool> isNotifiedInside(String id) async {
    return (await _load()).contains(id);
  }

  static Future<void> markInside(String id) async {
    final ids = await _load();
    ids.add(id);
    await _save(ids);
  }

  static Future<void> clearInside(String id) async {
    final ids = await _load();
    ids.remove(id);
    await _save(ids);
  }

  static Future<void> clearAll() async {
    final file = await _file();
    if (await file.exists()) {
      await file.delete();
    }
  }
}
