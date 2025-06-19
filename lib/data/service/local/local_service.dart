import 'package:shared_preferences/shared_preferences.dart';

class LocalService {
  final SharedPreferences sharedPreferences;
  LocalService(this.sharedPreferences);

  Future<void> saveToken(String key, dynamic value) async {}
}
