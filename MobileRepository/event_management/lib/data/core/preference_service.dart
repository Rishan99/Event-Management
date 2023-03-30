import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PreferenceService {
  //Private Constructor to restrict creating instance of class
  PreferenceService._();

  static SharedPreferences? _sharedPreferences;

  //Instancing SharedPreference
  //If sharedPreference is already intialized then prevent initialization and return old instance
  static Future<PreferenceService> getInstance() async {
    _sharedPreferences ??= await SharedPreferences.getInstance();
    return PreferenceService._();
  }

  set accessToken(String value) {
    _sharedPreferences!.setString("accessToken", value);
  }

  String get accessToken {
    return _sharedPreferences!.getString("accessToken") ?? '';
  }

  set userName(String value) {
    _sharedPreferences!.setString("userName", value);
  }

  String get userName {
    return _sharedPreferences!.getString("userName") ?? '';
  }

  void clearSession() {
    _sharedPreferences!.clear();
  }
}
