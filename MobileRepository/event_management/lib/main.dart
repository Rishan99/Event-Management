import 'package:event_management/core/theme/themes.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'core/route/route.dart';
import 'data/core/http_service.dart';
import 'dependency_injection.dart';
import 'dart:io';

//Entry Point for Prod Env Variable
void main() async {
  mainApp();
}

mainApp() async {
  HttpOverrides.global = MyHttpOverrides();
  //Ensure that binding is initialized
  WidgetsFlutterBinding.ensureInitialized();
  //Initialize Dependencies
  await setupLocator();
  //Stop Device Landscape View
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
  runApp(const MyApp());
}

final GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey = GlobalKey();

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => TruckProviderService(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        builder: (newContext, child) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            themeMode: ThemeMode.light,
            theme: Themes().theme(),
            initialRoute: Routes.splashPage,
            onGenerateRoute: generateRoutes,
            title: 'Event management',
          );
        },
      ),
    );
  }
}
