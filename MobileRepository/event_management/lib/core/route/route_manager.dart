import 'package:event_management/app/auth/authentication_view.dart';
import 'package:event_management/app/city/view/city_view.dart';
import 'package:event_management/app/event_detail/view/event_detail.dart';
import 'package:event_management/app/event_detail/view_model/event_detail_view_model.dart';
import 'package:event_management/app/home/view/home_view.dart';
import 'package:event_management/app/splash/view/splash_view.dart';
import 'package:event_management/core/route/routes.dart';
import 'package:event_management/data/data.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

Route generateRoutes(RouteSettings settings) {
  debugPrint("----------");
  debugPrint('Route:${settings.name}');
  debugPrint('Arguments:${settings.arguments}');
  debugPrint("----------");
  final args = (settings.arguments as dynamic) ?? {};
  if (locator<PreferenceService>().accessToken.isEmpty && !([Routes.authenticationPage, Routes.splashPage].contains(settings.name))) {
    return buildRoute(settings, const AuthenticationView());
  }
  switch (settings.name) {
    ///---- Unrestricted Pages Section Starts----
    case Routes.splashPage:
      return buildRoute(settings, const SplashView());
    case Routes.authenticationPage:
      {
        return buildRoute(settings, const AuthenticationView());
      }

    ///---- Unrestricted Pages Section Ends ----
    ///
    ///---- Restricted Pages Section Starts ----
    case Routes.cityPage:
      {
        return buildRoute(settings, const CityView(), fullscreenDialog: true);
      }
    case Routes.homePage:
      {
        return buildRoute(settings, const HomeView());
      }
    case Routes.eventDetailPage:
      {
        return buildRoute(
            settings,
            EventDetailView(
              id: args['id'],
            ));
      }

    default:
      return buildRoute(settings, const SplashView());
  }
}

CupertinoPageRoute buildRoute(RouteSettings settings, Widget builder, {bool fullscreenDialog = false}) {
  return CupertinoPageRoute(settings: settings, builder: (BuildContext context) => builder, fullscreenDialog: fullscreenDialog);
}
