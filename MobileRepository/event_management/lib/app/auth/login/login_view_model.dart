import 'package:event_management/app/core/core.dart';
import 'package:event_management/core/utils/utils.dart';
import 'package:event_management/data/data.dart';
import 'package:event_management/model/auth/login_model.dart';
import 'package:event_management/services/service.dart';
import 'package:flutter/cupertino.dart';

class LoginViewModel extends BaseViewModel {
  final AuthService _authService;
  final PreferenceService _preferenceService;

  late final TextEditingController emailController;
  late final TextEditingController passwordController;
  bool _obscure = true;

  LoginViewModel(this._authService, this._preferenceService) {
    emailController = TextEditingController(text: _preferenceService.userName);
    passwordController = TextEditingController();
  }

  Future<void> loginUser() async {
    try {
      final Map<String, dynamic> response = await _authService.loginUser(LoginModel(emailController.text, passwordController.text));
      _preferenceService.accessToken = response['accessToken'];
      _preferenceService.userName = emailController.text;
    } catch (ex) {
      rethrow;
    }
  }

  bool get obscure => _obscure;

  updateObscure() {
    _obscure = !_obscure;
    updateState(ViewState.idle);
  }
}
