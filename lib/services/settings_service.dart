import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SettingsService {

  static const _storage = FlutterSecureStorage();

  static Future<void> setGoal(String goal) async {
    await _storage.write(key: "goal", value: goal);
  }

  static Future<String> getGoal() async {
    return await _storage.read(key: "goal") ?? "Build muscle";
  }

  static Future<void> setUnits(String units) async {
    await _storage.write(key: "units", value: units);
  }

  static Future<String> getUnits() async {
    return await _storage.read(key: "units") ?? "Kilograms (kg)";
  }

  static Future<void> setTheme(String theme) async {
    await _storage.write(key: "theme", value: theme);
  }

  static Future<String> getTheme() async {
    return await _storage.read(key: "theme") ?? "Light";
  }
}