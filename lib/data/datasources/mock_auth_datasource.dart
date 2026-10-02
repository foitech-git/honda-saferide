import 'package:shared_preferences/shared_preferences.dart';
import '../../domain/entities/user.dart';
import '../../core/errors/failures.dart';

class MockAuthDataSource {
  static const String _sessionKey = 'mock_session_user_id';

  Future<User> login(String identifier, String password) async {
    await Future.delayed(const Duration(seconds: 1)); // simulate network
    if (password == 'wrong') {
      throw const ServerFailure('Invalid credentials');
    }
    
    final user = User(
      id: 'usr_${DateTime.now().millisecondsSinceEpoch}',
      name: 'Demo Rider',
      emailOrMobile: identifier,
    );
    
    await _persistSession(user.id);
    return user;
  }

  Future<User> signUp(String name, String identifier, String password) async {
    await Future.delayed(const Duration(seconds: 1));
    final user = User(
      id: 'usr_${DateTime.now().millisecondsSinceEpoch}',
      name: name,
      emailOrMobile: identifier,
    );
    
    await _persistSession(user.id);
    return user;
  }

  Future<void> logout() async {
    await Future.delayed(const Duration(milliseconds: 500));
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_sessionKey);
  }

  Future<User?> checkSession() async {
    await Future.delayed(const Duration(milliseconds: 500));
    final prefs = await SharedPreferences.getInstance();
    final userId = prefs.getString(_sessionKey);
    
    if (userId != null) {
      return User(
        id: userId,
        name: 'Demo Rider',
        emailOrMobile: 'demo@saferide.com',
      );
    }
    return null;
  }

  Future<void> resetPassword(String identifier) async {
    await Future.delayed(const Duration(seconds: 1));
  }

  Future<void> _persistSession(String userId) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_sessionKey, userId);
  }
}
