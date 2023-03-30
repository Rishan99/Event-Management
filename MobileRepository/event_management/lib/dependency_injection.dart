import 'package:get_it/get_it.dart';
import 'app/app.dart';
import 'data/data.dart';
// import 'data/';

import 'services/service.dart';

final locator = GetIt.instance;

setupLocator() async {
  await setupData();
  setupService();
  setupViewModel();
}
