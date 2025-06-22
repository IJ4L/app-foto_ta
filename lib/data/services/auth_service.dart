import 'package:http/http.dart' as http;

class AuthService {
  final http.Client client;

  AuthService(this.client);

  Future<void> signInWithGoogle() async {}
}
