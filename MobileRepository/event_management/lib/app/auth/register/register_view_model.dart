import 'package:event_management/app/core/core.dart';
import 'package:event_management/core/utils/utils.dart';
import 'package:event_management/model/auth/register_model.dart';
import 'package:event_management/services/service.dart';
import 'package:flutter/cupertino.dart';

class RegisterViewModel extends BaseViewModel {
  final AuthService _authService;
  RegisterViewModel(this._authService);

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  bool _obscure = true;

  Future<void> registerUser() async {
    try {
      await _authService.registerUser(RegisterModel(nameController.text, emailController.text, passwordController.text));
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
