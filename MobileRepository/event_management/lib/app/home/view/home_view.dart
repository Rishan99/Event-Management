import 'package:community_material_icon/community_material_icon.dart';
import 'package:event_management/app/core/baseView.dart';
import 'package:event_management/app/home/widget/event_list_view.dart';
import 'package:event_management/app/home/view_model/home_view_model.dart';
import 'package:event_management/app/home/widget/event_grid_widget.dart';
import 'package:event_management/app/home/widget/weather_widget.dart';
import 'package:event_management/app/widgets/error_widget.dart';
import 'package:event_management/app/widgets/loading_widget.dart';
import 'package:event_management/app/widgets/no_result_widget.dart';
import 'package:event_management/core/route/routes.dart';
import 'package:event_management/core/utils/enum/enum.dart';
import 'package:event_management/core/utils/ui_helper.dart';
import 'package:event_management/data/core/http_service.dart';
import 'package:event_management/data/data.dart';
import 'package:event_management/services/provider/city_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    locator<HttpService>().init(context);
    return Scaffold(
      appBar: AppBar(
          leading: IconButton(
              tooltip: 'Log out',
              onPressed: () {
                locator<PreferenceService>().clearSession();
                Navigator.of(context).pushNamedAndRemoveUntil(Routes.authenticationPage, (route) => false);
              },
              icon: const Icon(Icons.logout)),
          title: Text("Festivalika".toUpperCase()),
          actions: [
            IconButton(
              tooltip: 'Select City',
              onPressed: () {
                Navigator.of(context).pushNamed(Routes.cityPage);
              },
              icon: const Icon(
                CommunityMaterialIcons.city,
              ),
            )
          ]),
      body: SingleChildScrollView(
        child: Consumer<CityProvider>(builder: (context, provider, child) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              formSeperatorBox(),
              Padding(
                padding: pageSidePadding,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Weather Forcaset For ${provider.selectedCity}",
                      style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 18),
                    ),
                    formSeperatorBox(),
                    WeatherWidget(weatherModel: provider.weatherList),
                  ],
                ),
              ),
              formSeperatorBox(),
              Divider(),
              // formSeperatorBox(),
              Padding(
                padding: EdgeInsets.only(left: pageSidePadding.left),
                child: EventListView(
                  key: ValueKey(provider.selectedCity),
                ),
              ),
            ],
          );
        }),
      ),
    );
  }
}
