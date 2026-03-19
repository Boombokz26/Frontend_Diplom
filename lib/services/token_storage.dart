import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class TokenStorage {

  static const _storage = FlutterSecureStorage();

  static Future<void> saveToken(String token) async {
    await _storage.write(key: "jwt_token", value: token);
  }

  static Future<String?> getToken() async {
    return await _storage.read(key: "jwt_token");
  }

  static Future<void> clearToken() async {
    await _storage.delete(key: "jwt_token");
  }

  static Future<void> saveEmail(String email) async {
    await _storage.write(key: "user_email", value: email);
  }

  static Future<String?> getEmail() async {
    return await _storage.read(key: "user_email");
  }

}