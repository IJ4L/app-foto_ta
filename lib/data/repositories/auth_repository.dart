import 'package:foto_ta/data/services/auth_service.dart';
import 'package:foto_ta/data/services/local_service.dart';

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
  Future<String?> getCurrentUserEmail() async {
    try {
      return await localService.getString('user_email');
    } catch (e) {
      print('Error getting current user email: $e');
      return null;
    }
  }

  @override
  Future<String?> getCurrentUserName() async {
    try {
      return await localService.getString('user_name');
    } catch (e) {
      print('Error getting current user name: $e');
      return null;
    }
  }

  @override
  Future<String?> getCurrentUserPhotoUrl() async {
    try {
      return await localService.getString('user_photo_url');
    } catch (e) {
      print('Error getting current user photo URL: $e');
      return null;
    }
  }

  @override
  Future<bool> isSignedIn() async {
    try {
      final userEmail = await localService.getString('user_email');
      return userEmail != null && userEmail.isNotEmpty;
    } catch (e) {
      print('Error checking sign-in status: $e');
      return false;
    }
  }

  @override
  Future<void> signInWithGoogle() async {
    try {
      await localService.setString('user_email', 'user@example.com');
      await localService.setString('user_name', 'Test User');
      await localService.setString(
        'user_photo_url',
        'https://via.placeholder.com/150',
      );

      print('User signed in with Google');
    } catch (e) {
      print('Error signing in with Google: $e');
      throw Exception('Failed to sign in with Google: $e');
    }
  }

  @override
  Future<void> signOut() async {
    try {
      await localService.remove('user_email');
      await localService.remove('user_name');
      await localService.remove('user_photo_url');

      print('User signed out');
    } catch (e) {
      print('Error signing out: $e');
      throw Exception('Failed to sign out: $e');
    }
  }
}
