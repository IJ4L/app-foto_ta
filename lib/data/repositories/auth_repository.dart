import 'package:foto_ta/data/service/client/auth_service.dart';
import 'package:foto_ta/data/service/local/local_service.dart';

abstract class AuthRepository {
  Future<void> signInWithGoogle();
  Future<void> signOut();
  Future<bool> isSignedIn();
  Future<String?> getCurrentUserEmail();
  Future<String?> getCurrentUserName();
  Future<String?> getCurrentUserPhotoUrl();
}

class AuthRepositoryImpl implements AuthRepository {
  final AuthService authService;
  final LocalService localService;

  AuthRepositoryImpl(this.authService, this.localService);

  @override
  Future<String?> getCurrentUserEmail() {
    throw UnimplementedError();
  }

  @override
  Future<String?> getCurrentUserName() {
    throw UnimplementedError();
  }

  @override
  Future<String?> getCurrentUserPhotoUrl() {
    throw UnimplementedError();
  }

  @override
  Future<bool> isSignedIn() {
    throw UnimplementedError();
  }

  @override
  Future<void> signInWithGoogle() {
    throw UnimplementedError();
  }

  @override
  Future<void> signOut() {
    throw UnimplementedError();
  }
}
