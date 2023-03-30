import 'package:event_management/app/core/core.dart';
import 'package:event_management/core/utils/utils.dart';

class AuthenticationViewModel extends BaseViewModel {
  AuthenticationState authenticationState = AuthenticationState.login;
  AuthenticationViewModel() {
    updateState(ViewState.idle);
  }

  updateAuthenticationState(AuthenticationState authenticationState) {
    this.authenticationState = authenticationState;
    updateState(ViewState.idle);
  }
}
