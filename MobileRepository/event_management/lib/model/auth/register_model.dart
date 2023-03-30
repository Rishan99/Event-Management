import 'package:event_management/model/auth/authentication_model.dart';

class RegisterModel extends AuthenticationUserModel {
  final String name;
  RegisterModel(this.name, super.username, super.password);
}
