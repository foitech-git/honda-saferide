import '../../domain/entities/user.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/mock_auth_datasource.dart';
import '../../core/constants/environment.dart';

class AuthRepositoryImpl implements AuthRepository {
  final MockAuthDataSource mockDataSource;

  AuthRepositoryImpl({required this.mockDataSource});

  @override
  Future<User> login(String identifier, String password) async {
    if (Environment.current.useMockData) {
      return await mockDataSource.login(identifier, password);
    }
    throw UnimplementedError('Real API not implemented yet');
  }

  @override
  Future<User> signUp(String name, String identifier, String password) async {
    if (Environment.current.useMockData) {
      return await mockDataSource.signUp(name, identifier, password);
    }
    throw UnimplementedError('Real API not implemented yet');
  }

  @override
  Future<void> logout() async {
    if (Environment.current.useMockData) {
      return await mockDataSource.logout();
    }
    throw UnimplementedError('Real API not implemented yet');
  }

  @override
  Future<User?> checkSession() async {
    if (Environment.current.useMockData) {
      return await mockDataSource.checkSession();
    }
    throw UnimplementedError('Real API not implemented yet');
  }

  @override
  Future<void> resetPassword(String identifier) async {
    if (Environment.current.useMockData) {
      return await mockDataSource.resetPassword(identifier);
    }
    throw UnimplementedError('Real API not implemented yet');
  }
}
