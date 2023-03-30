import 'package:event_management/app/core/core.dart';
import 'package:event_management/core/constant/constant.dart';
import 'package:event_management/core/utils/ui_helper.dart';
import 'package:event_management/core/utils/utils.dart';
import 'package:flutter/material.dart';

import 'authentication_view_model.dart';
import 'login/login_view.dart';
import 'register/register_view.dart';

class AuthenticationView extends StatelessWidget {
  const AuthenticationView({super.key});
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: Scaffold(
          body: BaseView<AuthenticationViewModel>(
        onModelReady: (model) {},
        builder: ((context, model, child) {
          return Padding(
            padding: pageSidePadding,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.35,
                    child: Image.asset(AppImage.logoWhite),
                  ),
                  Builder(builder: (context) {
                    switch (model.authenticationState) {
                      case AuthenticationState.login:
                        return LoginView(authenticationViewModel: model);
                      case AuthenticationState.register:
                        return RegisterView(authenticationViewModel: model);
                      default:
                        return const SizedBox.shrink();
                    }
                  }),
                ],
              ),
            ),
          );
        }),
      )),
    );
  }
}
