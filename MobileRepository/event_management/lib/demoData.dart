import 'dart:ffi';

import 'package:event_management/model/event_detail_model.dart';
import 'package:event_management/model/event_model.dart';
import 'package:event_management/model/ticket_type.dart';

Future<void> demoDelay() => Future.delayed(Duration(seconds: 2));

List<EventModel> events = List.generate(
  10,
  (i) => EventModel(
    id: i,
    name: "name$i",
    city: "city$i",
    address: "address$i",
    startDate: DateTime.now().add(Duration(days: i)).toIso8601String(),
    ticketTypeId: i,
    ticketType: TicketType(id: i, name: "ticker $i"),
    description: List.generate(i * 10, (index) => String.fromCharCode(index + 50)).join(),
    ticketPrice: i * 100.0,
  ),
);

EventDetailModel eventModel(int i) => EventDetailModel(
      booking: null,
      id: i,
      name: "name$i",
      city: "city$i",
      address: "address$i",
      startDate: DateTime.now().add(Duration(days: i)).toIso8601String(),
      ticketTypeId: i,
      ticketType: TicketType(id: i, name: "ticker $i"),
      ticketPrice: i * 100.0,
    );
