import 'package:dio/dio.dart';
import 'package:event_management/core/api_url/api_url.dart';
import 'package:event_management/data/core/error_handler.dart';
import 'package:event_management/model/weather_model.dart';
import 'package:event_management/services/weather/weather_repository.dart';

class WeatherRepositoryImpl implements WeatherRepository {
  final Dio _dio;

  final String apiKey;

  WeatherRepositoryImpl(this._dio, this.apiKey);

  @override
  Future<dynamic> getWeather(String cityName) async {
    try {
      final response = await _dio.get(
        ApiUrl.weatherApiBaseUrl + ApiUrl.hourlyCityUrl,
        queryParameters: {
          "q": cityName,
          "appid": apiKey,
        },
      );
      if ((response.data['list'] ?? []).isEmpty) {
        throw Exception("Cannot find weather forecast for $cityName");
      }
      return response.data;
      // return;
    } catch (e) {
      ErrorHandler.handleDioError(e);
      rethrow;
    }
  }
}
