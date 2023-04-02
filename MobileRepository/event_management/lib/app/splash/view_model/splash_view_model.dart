import 'package:event_management/app/core/core.dart';
import 'package:event_management/core/utils/utils.dart';
import 'package:event_management/data/data.dart';

class SplashViewModel extends BaseViewModel {
  final PreferenceService _preferenceService;

  SplashViewModel(this._preferenceService);

  UserAuthenticationState checkForUserState() {
    // return UserAuthenticationState.expired;
    if (_preferenceService.accessToken.isEmpty) return UserAuthenticationState.expired;
    return UserAuthenticationState.loggedIn;
  }
}
