import 'package:shared_preferences/shared_preferences.dart';

class LocalService {
  final SharedPreferences sharedPreferences;

  LocalService(this.sharedPreferences);

  Future<void> setString(String key, String value) async {
    await sharedPreferences.setString(key, value);
  }

  Future<String?> getString(String key) async {
    return sharedPreferences.getString(key);
  }

  Future<void> remove(String key) async {
    await sharedPreferences.remove(key);
  }

  Future<bool> containsKey(String key) async {
    return sharedPreferences.containsKey(key);
  }
}