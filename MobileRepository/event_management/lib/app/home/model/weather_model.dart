import 'dart:convert';

class WeatherModel {
  final String weather;
  final String dateTime;
  final String description;
  final String icon;
  WeatherModel({
    required this.weather,
    required this.dateTime,
    required this.description,
    required this.icon,
  });

  WeatherModel copyWith({
    String? weather,
    String? dateTime,
    String? description,
    String? icon,
  }) {
    return WeatherModel(
      weather: weather ?? this.weather,
      dateTime: dateTime ?? this.dateTime,
      description: description ?? this.description,
      icon: icon ?? this.icon,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'weather': weather,
      'dateTime': dateTime,
      'description': description,
      'icon': icon,
    };
  }

  factory WeatherModel.fromMap(Map<String, dynamic> map) {
    return WeatherModel(
      weather: map['weather'] ?? '',
      dateTime: map['dateTime'] ?? '',
      description: map['description'] ?? '',
      icon: map['icon'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory WeatherModel.fromJson(String source) => WeatherModel.fromMap(json.decode(source));

  @override
  String toString() {
    return 'WeatherModel(weather: $weather, dateTime: $dateTime, description: $description, icon: $icon)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is WeatherModel && other.weather == weather && other.dateTime == dateTime && other.description == description && other.icon == icon;
  }

  @override
  int get hashCode {
    return weather.hashCode ^ dateTime.hashCode ^ description.hashCode ^ icon.hashCode;
  }
}
