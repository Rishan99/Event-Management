import 'package:community_material_icon/community_material_icon.dart';
import 'package:event_management/app/core/baseView.dart';
import 'package:event_management/app/home/widget/event_list_view.dart';
import 'package:event_management/app/home/view_model/home_view_model.dart';
import 'package:event_management/app/home/widget/event_grid_widget.dart';
import 'package:event_management/app/widgets/error_widget.dart';
import 'package:event_management/app/widgets/loading_widget.dart';
import 'package:event_management/app/widgets/no_result_widget.dart';
import 'package:event_management/core/route/routes.dart';
import 'package:event_management/core/utils/enum/enum.dart';
import 'package:event_management/core/utils/ui_helper.dart';
import 'package:event_management/services/provider/city_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:provider/provider.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Festivalika".toUpperCase()), actions: [
        IconButton(
          onPressed: () {
            Navigator.of(context).pushNamed(Routes.cityPage);
          },
          icon: const Icon(
            CommunityMaterialIcons.city,
          ),
        )
      ]),
      body: Padding(
        padding: EdgeInsets.only(left: pageSidePadding.left),
        child: SingleChildScrollView(
          child: Consumer<CityProvider>(builder: (context, provider, child) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                formSeperatorBox(),
                Padding(
                  padding: EdgeInsets.only(right: pageSidePadding.right),
                  child: Text(provider.selectedCity ?? ''),
                ),
                formSeperatorBox(),
                EventListView(
                  key: ValueKey(provider.selectedCity),
                ),
              ],
            );
          }),
        ),
      ),
    );
  }
}
