import '../entities/user.dart';

abstract class AuthRepository {
  Future<User> login(String identifier, String password);
  Future<User> signUp(String name, String identifier, String password);
  Future<void> logout();
  Future<User?> checkSession();
  Future<void> resetPassword(String identifier);
}
