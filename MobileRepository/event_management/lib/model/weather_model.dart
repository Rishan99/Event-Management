import 'dart:convert';

class Weather {
  final String cod;
  final int message;
  final int cnt;
  final List<WeatherListElement> list;
  final City city;
  Weather({
    required this.cod,
    required this.message,
    required this.cnt,
    required this.list,
    required this.city,
  });

  factory Weather.fromMap(Map<String, dynamic> map) {
    return Weather(
      cod: map['cod'] ?? '',
      message: map['message']?.toInt() ?? 0,
      cnt: map['cnt']?.toInt() ?? 0,
      list: List<WeatherListElement>.from(((map['list'] ?? []) as List<dynamic>).map((x) => WeatherListElement.fromMap(x))),
      city: City.fromMap(map['city']),
    );
  }
}

class City {
  City({
    this.id,
    this.name,
    this.coord,
    this.country,
    this.population,
    this.timezone,
    this.sunrise,
    this.sunset,
  });

  final int? id;
  final String? name;
  final Coord? coord;
  final String? country;
  final int? population;
  final int? timezone;
  final int? sunrise;
  final int? sunset;

  factory City.fromMap(Map<String, dynamic> map) {
    return City(
      id: map['id']?.toInt(),
      name: map['name'],
      coord: map['coord'] != null ? Coord.fromMap(map['coord']) : null,
      country: map['country'],
      population: map['population']?.toInt(),
      timezone: map['timezone']?.toInt(),
      sunrise: map['sunrise']?.toInt(),
      sunset: map['sunset']?.toInt(),
    );
  }
}

class Coord {
  final double lat;
  final double lon;

  Coord(
    this.lat,
    this.lon,
  );

  factory Coord.fromMap(Map<String, dynamic> map) {
    return Coord(
      map['lat']?.toDouble() ?? 0.0,
      map['lon']?.toDouble() ?? 0.0,
    );
  }
}

class WeatherListElement {
  final int dt;
  final List<WeatherElement> weather;
  final DateTime dtTxt;
  WeatherListElement({
    required this.dt,
    required this.weather,
    required this.dtTxt,
  });

  factory WeatherListElement.fromMap(Map<String, dynamic> map) {
    return WeatherListElement(
      dt: map['dt']?.toInt() ?? 0,
      weather: List<WeatherElement>.from(map['weather']?.map((x) => WeatherElement.fromMap(x))),
      dtTxt: DateTime.parse(map['dt_txt']),
    );
  }
}

class WeatherElement {
  final int id;
  final String description;
  final String main;
  final String icon;
  WeatherElement({
    required this.id,
    required this.description,
    required this.main,
    required this.icon,
  });

  factory WeatherElement.fromMap(Map<String, dynamic> map) {
    return WeatherElement(
      id: map['id']?.toInt() ?? 0,
      description: map['description'] ?? '',
      main: map['main'] ?? '',
      icon: map['icon'] ?? '',
    );
  }

  factory WeatherElement.fromJson(String source) => WeatherElement.fromMap(json.decode(source));
}
