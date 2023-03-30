import 'package:event_management/core/constant/constant.dart';
import 'package:event_management/core/route/route.dart';
import 'package:event_management/core/theme/app_colors.dart';
import 'package:event_management/core/utils/ui_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:intl/intl.dart';
import 'package:timeago/timeago.dart' as timeago;

import 'package:event_management/model/event_model.dart';

class EventGridWidget extends StatelessWidget {
  final EventModel eventModel;
  const EventGridWidget({
    Key? key,
    required this.eventModel,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(context, Routes.eventDetailPage, arguments: {'id': eventModel.id});
      },
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: AppColors.widgetBorderColor, width: 1),
        ),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Expanded(
            child: ClipRRect(
              borderRadius: const BorderRadius.only(topLeft: Radius.circular(8), topRight: Radius.circular(12)),
              child: Image.network(
                'src',
                width: double.maxFinite,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => Image.asset(
                  AppImage.error,
                  width: double.maxFinite,
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  eventModel.name,
                  maxLines: 1,
                  overflow: TextOverflow.clip,
                  style: Theme.of(context).textTheme.bodyLarge!.copyWith(fontWeight: FontWeight.bold),
                ),
                Text(
                  eventModel.address,
                  maxLines: 1,
                  overflow: TextOverflow.clip,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                Text(DateFormat("dd MMM, yyyy (EE)").format(DateTime.parse(eventModel.startDate))),
                Text(eventModel.ticketType.name),
              ],
            ),
          )
        ]),
      ),
    );
  }
}
