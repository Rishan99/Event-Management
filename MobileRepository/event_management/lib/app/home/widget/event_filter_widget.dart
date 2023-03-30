import 'package:event_management/app/widgets/date_selector.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';

import 'package:event_management/app/widgets/form_title_widget.dart';
import 'package:event_management/core/utils/ui_helper.dart';

class EventFilterWidget extends StatefulWidget {
  final Function(DateTime?, DateTime?) onFilter;
  final DateTime? startDate;
  final DateTime? endDate;
  const EventFilterWidget({
    Key? key,
    required this.onFilter,
    this.startDate,
    this.endDate,
  }) : super(key: key);

  @override
  State<EventFilterWidget> createState() => _EventFilterWidgetState();
}

class _EventFilterWidgetState extends State<EventFilterWidget> {
  DateTime? startDate;
  DateTime? endDate;

  @override
  void initState() {
    super.initState();
    startDate = widget.startDate;
    endDate = widget.endDate;
  }

  GlobalKey<FormState> formKey = GlobalKey();
  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: Column(
        children: [
          FormTitleWidget(
            title: 'Start Date',
            child: FormField(validator: (value) {
              if (isDateValidated()) {
                return "Start Date must be before end date";
              }
              return null;
            }, builder: (state) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  DateSelector(
                      selectedDateTime: startDate,
                      finalDate: endDate,
                      onDateChanged: (value) {
                        setState(() {
                          startDate = value;
                        });
                      }),
                  if (state.hasError && state.errorText != null)
                    Text(
                      state.errorText!,
                      style: Theme.of(context).inputDecorationTheme.errorStyle,
                    )
                ],
              );
            }),
          ),
          formSeperatorBox(),
          FormTitleWidget(
            title: 'End Date',
            child: FormField(validator: (value) {
              if (isDateValidated()) {
                return "End Date must be after start date";
              }
              return null;
            }, builder: (state) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  DateSelector(
                      selectedDateTime: endDate,
                      initialDate: startDate,
                      onDateChanged: (value) {
                        setState(() {
                          endDate = value;
                        });
                      }),
                  if (state.hasError && state.errorText != null)
                    Text(
                      state.errorText!,
                      style: Theme.of(context).inputDecorationTheme.errorStyle,
                    )
                ],
              );
            }),
          ),
          formSeperatorBox(),
          Row(
            children: [
              Expanded(
                child: TextButton(
                  onPressed: () {
                    if (formKey.currentState!.validate()) {
                      if (isDateValidated()) {
                      } else {
                        Navigator.of(context).pop();
                        widget.onFilter(startDate, endDate);
                      }
                    }
                  },
                  child: const Text('Filter'),
                ),
              ),
              const SizedBox(
                width: 15,
              ),
              Expanded(
                child: OutlinedButton(
                  style: const ButtonStyle(),
                  onPressed: () {
                    setState(() {
                      startDate = null;
                      endDate = null;
                    });
                    formKey.currentState!.reset();
                  },
                  child: Text(
                    'Reset Filter',
                    style: TextStyle(color: Colors.blue[600]),
                  ),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }

  bool isDateValidated() => (startDate != null && endDate != null && startDate!.isAfter(endDate!));
}
