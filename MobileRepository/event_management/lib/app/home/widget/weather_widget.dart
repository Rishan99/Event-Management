import 'package:event_management/app/widgets/image_widget.dart';
import 'package:event_management/core/api_url/api_url.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';

import 'package:event_management/app/home/model/weather_model.dart';
import 'package:intl/intl.dart';

class WeatherWidget extends StatelessWidget {
  final List<WeatherModel> weatherModel;
  const WeatherWidget({
    Key? key,
    required this.weatherModel,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 90,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: weatherModel.map((e) => weatherDataWidget(e)).toList(),
      ),
    );
  }

  Widget weatherDataWidget(WeatherModel weatherModel) {
    var iconName = weatherModel.icon.replaceAll('n', 'd');
    return Column(
      children: [
        Text(
          DateFormat("EEEE").format(DateTime.parse(weatherModel.dateTime)),
          style: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
          ),
        ),
        Expanded(child: ImageWidget(imageUrl: "${ApiUrl.weatherImageBaseUrl}$iconName.png")),
        Text(weatherModel.weather)
      ],
    );
  }
}
