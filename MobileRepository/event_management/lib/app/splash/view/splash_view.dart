import 'package:event_management/app/core/core.dart';
import 'package:event_management/app/splash/view_model/splash_view_model.dart';
import 'package:event_management/core/constant/constant.dart';
import 'package:event_management/core/route/route.dart';
import 'package:event_management/core/utils/utils.dart';
import 'package:flutter/material.dart';

class SplashView extends StatelessWidget {
  const SplashView({super.key});

  void wrapper(BuildContext context, SplashViewModel model) async {
    //Delay to keep showing splash screen
    await Future.delayed(const Duration(seconds: 1));
    final state = model.checkForUserState();
    if ((state == UserAuthenticationState.notLoggedIn) || state == UserAuthenticationState.expired) {
      Navigator.of(context).pushNamedAndRemoveUntil(Routes.authenticationPage, (value) => false);
    } else {
      Navigator.of(context).pushNamedAndRemoveUntil(Routes.cityPage, (value) => false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        body: BaseView<SplashViewModel>(onModelReady: (model) {
          wrapper(context, model);
        }, builder: (context, model, child) {
          return Center(
            child: Image.asset(
              AppImage.logoWhite,
              fit: BoxFit.fill,
            ),
          );
        }),
      ),
    );
  }
}
