import 'package:event_management/services/weather/weather_repository.dart';
import 'package:event_management/services/weather/weather_service.dart';
import 'package:get_it/get_it.dart';

import '../data/dependency_injection.dart';
import 'service.dart';

setupService() {
  locator.registerSingleton<AuthService>(AuthService(locator<AuthRepository>()));
  locator.registerSingleton<WeatherService>(WeatherService(locator<WeatherRepository>()));
  locator.registerSingleton<EventService>(EventService(locator<EventRepository>()));
}
