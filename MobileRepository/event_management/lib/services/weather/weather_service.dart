import 'package:event_management/core/utils/exception/exception.dart';

import 'weather_repository.dart';

class WeatherService {
  final WeatherRepository weatherRepository;
  WeatherService(this.weatherRepository);

  Future<List<dynamic>> getFiveDaysWeatherForeCast(String cityName) async {
    try {
      final List<dynamic> data = await weatherRepository.getWeather(cityName);
      return [];
    } on SessionExpiredException catch (e) {
      throw SessionExpiredException(message: "Invalid Api key, Please try again");
    } catch (e) {
      rethrow;
    }
  }
}
