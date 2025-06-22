import 'package:flutter_dotenv/flutter_dotenv.dart';

class EnvConfig {
  static String get authToken => dotenv.get('AUTH_TOKEN');
  static String get apiUrl => dotenv.get('BASE_URL');
}
