import 'package:event_management/app/auth/authentication_view_model.dart';
import 'package:event_management/app/auth/login/login_view_model.dart';
import 'package:event_management/app/auth/register/register_view_model.dart';
import 'package:event_management/app/event_detail/view/event_detail.dart';
import 'package:event_management/app/event_detail/view_model/event_detail_view_model.dart';
import 'package:event_management/app/home/view/home_view.dart';
import 'package:event_management/app/home/view_model/home_view_model.dart';
import 'package:event_management/app/splash/view_model/splash_view_model.dart';
import 'package:event_management/data/core/preference_service.dart';
import 'package:event_management/services/auth/auth_service.dart';
import 'package:event_management/services/event/event_service.dart';
import 'package:get_it/get_it.dart';

import '../dependency_injection.dart';

setupViewModel() {
  ///[View Model]
  final PreferenceService _preferenceService = locator<PreferenceService>();
  locator.registerFactory<SplashViewModel>(() => SplashViewModel(_preferenceService));
  locator.registerFactory<AuthenticationViewModel>(() => AuthenticationViewModel());
  locator.registerFactory<LoginViewModel>(() => LoginViewModel(locator<AuthService>(), _preferenceService));
  locator.registerFactory<RegisterViewModel>(() => RegisterViewModel(
        locator<AuthService>(),
      ));

  locator.registerFactory<HomeViewModel>(() => HomeViewModel(locator<EventService>()));
  locator.registerFactory<EventDetailViewModel>(() => EventDetailViewModel(locator<EventService>()));
}
