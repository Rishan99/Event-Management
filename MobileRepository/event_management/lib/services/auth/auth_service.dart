import 'package:event_management/model/auth/login_model.dart';
import 'package:event_management/model/auth/register_model.dart';

import 'package:event_management/services/service.dart';

import 'auth_repository.dart';

class AuthService {
  final AuthRepository _authRepository;
  AuthService(
    this._authRepository,
  );

  Future<Map<String, dynamic>> loginUser(LoginModel loginModel) async {
    try {
      final Map<String, dynamic>? data = await _authRepository.login(loginModel.userName, loginModel.password);
      if (data != null && (data['accessToken'] ?? '').toString().isNotEmpty) {
        return data;
      }
      throw Exception("Error Logging in, Please try again");
    } catch (e) {
      rethrow;
    }
  }

  Future<void> registerUser(RegisterModel model) async {
    try {
      await _authRepository.register(model.name, model.userName, model.password);
    } catch (e) {
      rethrow;
    }
  }
}
