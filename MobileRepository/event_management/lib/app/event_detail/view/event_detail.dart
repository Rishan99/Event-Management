import 'package:community_material_icon/community_material_icon.dart';
import 'package:event_management/app/event_detail/widget/date_widget.dart';
import 'package:event_management/app/widgets/error_widget.dart';
import 'package:event_management/app/widgets/image_slider.dart';
import 'package:event_management/app/widgets/loading_widget.dart';
import 'package:event_management/core/constant/app_images.dart';
import 'package:event_management/core/utils/utils.dart';
import 'package:event_management/model/event_detail_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';

import 'package:event_management/app/core/baseView.dart';
import 'package:event_management/app/event_detail/view_model/event_detail_view_model.dart';
import 'package:event_management/core/utils/ui_helper.dart';

class EventDetailView extends StatelessWidget {
  final int id;
  const EventDetailView({
    Key? key,
    required this.id,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BaseView<EventDetailViewModel>(
      onModelReady: (x) {
        x.intializeValue(id);
      },
      builder: (context, model, child) => Scaffold(
        appBar: AppBar(),
        bottomNavigationBar: model.eventModel != null && model.allowBooking
            ? Material(
                color: Colors.white,
                elevation: 10,
                // shadowColor: Colors.black,
                child: Padding(
                  padding: pageSidePadding.copyWith(top: 10, bottom: 10),
                  child: Row(children: [
                    Expanded(
                      child: Text(
                        'Price: Rs.${model.eventModel?.ticketPrice}',
                      ),
                    ),
                    const SizedBox(
                      width: 20,
                    ),
                    TextButton(
                      style: ButtonStyle(minimumSize: MaterialStateProperty.resolveWith((states) => Size(150, 46))),
                      onPressed: () {
                        //
                      },
                      child: const Text("Buy Ticket"),
                    )
                  ]),
                ),
              )
            : null,
        body: Builder(builder: (context) {
          switch (model.state) {
            case ViewState.busy:
              return const LoadingWidget();
            case ViewState.error:
              return CustomErrorWidget(message: model.errorMessage);
            case ViewState.idle:
              return _body(context, model.eventModel!);

            default:
              return const SizedBox.shrink();
          }
        }),
      ),
    );
  }

  Widget _body(BuildContext context, EventDetailModel eventDetailModel) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: 200,
            child: ImageSlider(
              boxFit: BoxFit.cover,
              imageList: eventDetailModel.images,
            ),
          ),
          formSeperatorBox(),
          Padding(
            padding: pageSidePadding,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  eventDetailModel.name,
                  style: Theme.of(context).textTheme.headlineSmall!.copyWith(fontWeight: FontWeight.bold),
                ),
                Row(
                  children: [
                    const Icon(
                      CommunityMaterialIcons.map_marker_outline,
                      size: 18,
                    ),
                    const SizedBox(
                      width: 2,
                    ),
                    Expanded(
                        child: Text(
                      eventDetailModel.address,
                      style: const TextStyle(fontSize: 16),
                    ))
                  ],
                ),
                formSeperatorBox(),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Ticket Information',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    Text(
                      "Ticket Type : ${eventDetailModel.ticketType.name}",
                      // style: Theme.of(context).textTheme.titleMedium,
                    ),
                    Text(
                      "Price : Rs. ${eventDetailModel.ticketPrice}",
                      // style: Theme.of(context).textTheme.titleMedium,
                    ),
                  ],
                ),
                formSeperatorBox(),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Event Date',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: DateWidget(
                            title: "Start Date",
                            content: eventDetailModel.startDate,
                          ),
                        ),
                        if (eventDetailModel.endDate != null)
                          Expanded(
                            child: DateWidget(
                              title: "End Date",
                              content: eventDetailModel.endDate ?? '',
                            ),
                          ),
                      ],
                    )
                  ],
                ),
                formSeperatorBox(),
                if (eventDetailModel.description != null)
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Description',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      const SizedBox(
                        height: 8,
                      ),
                      Text(
                        eventDetailModel.description ?? '',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                    ],
                  )
              ],
            ),
          )
        ],
      ),
    );
  }
}
