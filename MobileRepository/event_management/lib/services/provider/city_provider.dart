import 'package:event_management/app/core/core.dart';
import 'package:event_management/core/utils/utils.dart';
import 'package:event_management/services/weather/weather_repository.dart';
import 'package:event_management/services/weather/weather_service.dart';
import 'package:flutter/material.dart';

class CityProvider extends BaseViewModel {
  final WeatherService _weatherService;
  String? _selectedCity;
  CityProvider(this._weatherService);
  String? get selectedCity => _selectedCity;
  //tracks is city name has been updated to new value
  //to restrict weather api call if city name has not changed
  bool hasCityNameChanged = false;

  updateCity(String city) {
    hasCityNameChanged = _selectedCity != city;
    _selectedCity = city.trim();
    updateState(ViewState.idle);
  }

  Future<void> getWeather() async {
    if (_selectedCity == null) throw Exception("Select city to get weather information");
    if (hasCityNameChanged) return;
    updateState(ViewState.busy);
    try {
      await _weatherService.getFiveDaysWeatherForeCast(_selectedCity!);
      updateState(ViewState.idle);
    } catch (e) {
      updateState(ViewState.error);
      rethrow;
    }
  }
}
