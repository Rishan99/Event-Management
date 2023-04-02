import 'package:collection/collection.dart';
import 'package:event_management/app/home/model/weather_model.dart';
import 'package:event_management/core/utils/exception/exception.dart';
import 'package:event_management/model/weather_model.dart';
import 'package:intl/intl.dart';

import 'weather_repository.dart';

class WeatherService {
  final WeatherRepository weatherRepository;
  WeatherService(this.weatherRepository);

  Future<List<WeatherModel>> getFiveDaysWeatherForeCast(String cityName) async {
    try {
      final dynamic data = await weatherRepository.getWeather(cityName);
      final List<WeatherListElement> list = Weather.fromMap(data).list;
      var groupdWeatherByDate = list.groupListsBy((element) => DateFormat("yyyy-MM-dd").format(element.dtTxt));
      List<WeatherModel> weatherModel = [];
      groupdWeatherByDate.forEach((key, value) {
        final firstValue = value.firstOrNull;
        if (firstValue != null) {
          final firstWeather = firstValue.weather.first;
          weatherModel.add(
            WeatherModel(
              weather: firstWeather.main,
              dateTime: key,
              description: firstWeather.description,
              icon: firstWeather.icon,
            ),
          );
        }
      });
      return weatherModel.take(5).toList();
    } on SessionExpiredException catch (e) {
      throw SessionExpiredException(message: "Invalid Api key, Please try again");
    }
  }
}
