import 'weather_repository.dart';

class WeatherService {
  final WeatherRepository weatherRepository;
  WeatherService(this.weatherRepository);

  Future<List<dynamic>> getFiveDaysWeatherForeCast(String cityName) async {
    final List<dynamic> data = await weatherRepository.getWeather(cityName);
    return [];
  }
}
