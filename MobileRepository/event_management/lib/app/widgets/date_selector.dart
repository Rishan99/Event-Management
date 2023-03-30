import 'package:event_management/core/theme/themes.dart';
import 'package:flutter/material.dart' hide TabBar, Tab, TabBarView;
// import 'package:flutter_cupertino_date_picker/flutter_cupertino_date_picker.dart';
import 'package:intl/intl.dart';

class DateSelector extends StatelessWidget {
  final ValueChanged<DateTime> onDateChanged;
  final String? label;
  final DateTime? selectedDateTime;

  ///OPTIONAL [default=2022]
  final DateTime? initialDate;

  ///OPTIONAL [default=2099]
  final DateTime? finalDate;

  const DateSelector({
    super.key,
    required this.onDateChanged,
    this.initialDate,
    this.label,
    this.finalDate,
    this.selectedDateTime,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GestureDetector(
          onTap: () async {
            FocusScope.of(context).requestFocus(FocusNode());
            await showMaterialADDatePicker(context);
          },
          child: InputDecorator(
            decoration: const InputDecoration(
              contentPadding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 0),
            ),
            child: ListTile(
              contentPadding: const EdgeInsets.symmetric(vertical: 0),
              title: Text(
                selectedDateTime == null ? "" : DateFormat("dd MMM, yyyy (EE)").format(selectedDateTime!),
                textAlign: TextAlign.left,
                // style: ((_selectedDateTime == null && (canBeNull)) || popid == null)
                //     ? Theme.of(context).textTheme.caption
                //     : TextStyle(color: ((_selectedDateTime == null && (canBeNull)) || popid == null) ? Theme.of(context).inputDecorationTheme.hintStyle!.color : null),
              ),
              trailing: const Icon(
                Icons.event,
              ),
            ),
          ),
        ),
      ],
    );
  }

  showMaterialADDatePicker(BuildContext context) async {
    final _selectedDateTime = (selectedDateTime ?? DateTime.now());

    final _firstDate = (initialDate ?? DateTime(2022));

    final _lastDate = (finalDate ?? DateTime(2099));
    final DateTime? date = await showDatePicker(
      context: context,
      builder: (context, child) {
        return Theme(data: Themes().theme(), child: child!);
      },
      initialDate: _selectedDateTime.isBefore(_lastDate)
          ? _selectedDateTime.isAfter(_firstDate)
              ? _selectedDateTime
              : _firstDate
          : _lastDate,
      firstDate: _firstDate,
      lastDate: _lastDate,
    );
    if (date != null) onDateChanged(date);
  }
}
