import 'package:event_management/app/widgets/error_widget.dart';
import 'package:event_management/app/widgets/loading_widget.dart';
import 'package:event_management/core/utils/utils.dart';
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
        body: Padding(
          padding: pageSidePadding,
          child: Builder(builder: (context) {
            switch (model.state) {
              case ViewState.busy:
                return const LoadingWidget();
              case ViewState.error:
                return CustomErrorWidget(message: model.errorMessage);
              case ViewState.idle:
                return SizedBox.shrink();

              default:
                return const SizedBox.shrink();
            }
          }),
        ),
      ),
    );
  }
}
