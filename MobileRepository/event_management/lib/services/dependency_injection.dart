import 'package:get_it/get_it.dart';

import '../data/dependency_injection.dart';
import 'service.dart';

setupService() {
  locator.registerSingleton<AuthService>(AuthService(locator<AuthRepository>()));
  locator.registerSingleton<UserService>(UserService(locator<UserRepository>()));
}
