import 'package:event_management/app/core/core.dart';
import 'package:event_management/app/home/model/weather_model.dart';
import 'package:event_management/core/utils/utils.dart';
import 'package:event_management/data/core/preference_service.dart';
import 'package:event_management/model/weather_model.dart';
import 'package:event_management/services/weather/weather_repository.dart';
import 'package:event_management/services/weather/weather_service.dart';
import 'package:flutter/material.dart';

class CityProvider extends BaseViewModel {
  final WeatherService _weatherService;
  final PreferenceService _preferenceService;
  String? _selectedCity;
  CityProvider(this._weatherService, this._preferenceService) {
    _selectedCity = _preferenceService.lastSearchedCity;
  }
  String? get selectedCity => _selectedCity;
  //tracks is city name has been updated to new value
  //to restrict weather api call if city name has not changed
  bool hasCityNameChanged = true;
  List<WeatherModel> weatherList = [];

  updateCity(String city) {
    hasCityNameChanged = _selectedCity != city;
    _selectedCity = city.trim();
    if (_selectedCity != null) {
      _preferenceService.lastSearchedCity = _selectedCity!;
    }
    updateState(ViewState.idle);
  }

  Future<void> getWeather() async {
    if (_selectedCity == null) throw Exception("Select city to get weather information");
    if (!hasCityNameChanged && weatherList.isNotEmpty) return;
    updateState(ViewState.busy);
    try {
      weatherList = await _weatherService.getFiveDaysWeatherForeCast(_selectedCity!);
      updateState(ViewState.idle);
    } catch (e) {
      updateState(ViewState.error);
      rethrow;
    }
  }
}
