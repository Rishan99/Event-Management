import 'package:dio/dio.dart';
import 'package:event_management/data/core/http_service.dart';

import 'package:event_management/data/repository/weather_repository.dart';
import 'package:event_management/services/weather/weather_repository.dart';
import 'package:get_it/get_it.dart';

import '../core/constant/constant.dart';
import '../services/service.dart';
import 'data.dart';
import 'repository/event_repository.dart';

final locator = GetIt.instance;

Future<void> setupData() async {
  ///[Repository]
  locator.registerSingletonAsync<PreferenceService>(
    () => PreferenceService.getInstance(),
  );
  final preferenceService = await locator.getAsync<PreferenceService>();
  locator.registerSingleton<HttpService>(HttpService(preferenceService));
  final httpService = locator.get<HttpService>();
  locator.registerSingleton<AuthRepository>(AuthRepositoryImpl(httpService));
  locator.registerSingleton<EventRepository>(EventRepositoryImpl(httpService));
  locator.registerSingleton<WeatherRepository>(WeatherRepositoryImpl(Dio(), kOpenWeatherKey));
}
