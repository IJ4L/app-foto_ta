import 'package:http/http.dart' as http;

class AuthService {
  final http.Client client;
  AuthService(this.client);

  Future<bool> login(String username, String password) async {
    return true;
  }

  Future<void> logout() async {}
}
