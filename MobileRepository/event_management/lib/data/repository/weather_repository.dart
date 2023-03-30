import 'package:dio/dio.dart';
import 'package:event_management/core/api_url/api_url.dart';
import 'package:event_management/data/core/error_handler.dart';
import 'package:event_management/services/weather/weather_repository.dart';

class WeatherRepositoryImpl implements WeatherRepository {
  final Dio _dio;

  final String apiKey;

  WeatherRepositoryImpl(this._dio, this.apiKey);

  @override
  Future<List<dynamic>> getWeather(String cityName) async {
    try {
      return [];
      final response = await _dio.get(
        ApiUrl.weaterApiBaseUrl + ApiUrl.hourlyCityUrl,
        queryParameters: {
          "q": cityName,
          "appid": apiKey,
        },
      );
      return response.data as List<dynamic>;
    } catch (e) {
      ErrorHandler.handleDioError(e);
      rethrow;
    }
  }
}
