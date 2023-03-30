import 'package:community_material_icon/community_material_icon.dart';
import 'package:event_management/app/core/core.dart';
import 'package:event_management/app/home/widget/event_grid_widget.dart';
import 'package:event_management/app/widgets/error_widget.dart';
import 'package:event_management/app/home/widget/event_filter_widget.dart';
import 'package:event_management/app/widgets/loading_widget.dart';
import 'package:event_management/app/widgets/no_result_widget.dart';
import 'package:event_management/core/utils/ui_helper.dart';
import 'package:event_management/core/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';

import '../view_model/home_view_model.dart';

class EventListView extends StatelessWidget {
  const EventListView({super.key});

  @override
  Widget build(BuildContext context) {
    return BaseView<HomeViewModel>(onModelReady: (x) {
      x.getEventList();
    }, builder: ((context, model, child) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          formSeperatorBox(),
          Row(
            children: [
              Expanded(
                child: Text(
                  "Events For You",
                  style: Theme.of(context).textTheme.titleLarge!.copyWith(fontWeight: FontWeight.w500),
                ),
              ),
              if (model.state == ViewState.idle)
                IconButton(
                  onPressed: () {
                    showFlexibleBottomSheet(
                        context,
                        'Filter Events',
                        EventFilterWidget(
                          onFilter: (startDate, endDate) {
                            model.onFilterValueUpdate(startDate, endDate);
                          },
                          endDate: model.filterEndDate,
                          startDate: model.filterStartDate,
                        ));
                  },
                  icon: const Icon(
                    CommunityMaterialIcons.filter_outline,
                    color: Colors.black,
                  ),
                )
            ],
          ),
          const SizedBox(
            height: 5,
          ),
          Padding(
            padding: EdgeInsets.only(right: pageSidePadding.right),
            child: Builder(builder: (context) {
              switch (model.state) {
                case ViewState.busy:
                  return const LoadingWidget();
                case ViewState.error:
                  return CustomErrorWidget(message: model.errorMessage);
                case ViewState.idle:
                  if (model.eventList.isEmpty) {
                    return const NoResultWidget(
                      message: "No Events Found",
                    );
                  }
                  return GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: model.eventList.length,
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2, crossAxisSpacing: 20, mainAxisSpacing: 20),
                    itemBuilder: (x, i) {
                      final currentData = model.eventList[i];
                      return EventGridWidget(eventModel: currentData);
                    },
                  );

                default:
                  return const SizedBox.shrink();
              }
            }),
          ),
          const SizedBox(
            height: 20,
          )
        ],
      );
    }));
  }
}
