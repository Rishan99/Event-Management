import 'dart:convert';

import 'package:event_management/model/event_model.dart';

class EventDetailModel extends EventModel {
  final dynamic booking;
  EventDetailModel({
    required this.booking,
    required super.id,
    required super.name,
    required super.city,
    required super.address,
    super.description,
    required super.startDate,
    super.endDate,
    required super.ticketType,
    required super.ticketTypeId,
    required super.ticketPrice,
  });

  factory EventDetailModel.fromMap(Map<String, dynamic> map) {
    final eventModel = EventModel.fromMap(map);
    return EventDetailModel(
      booking: map['booking'] ?? null,
      address: eventModel.address,
      city: eventModel.address,
      id: eventModel.id,
      name: eventModel.address,
      startDate: eventModel.address,
      ticketPrice: eventModel.ticketPrice,
      ticketType: eventModel.ticketType,
      ticketTypeId: eventModel.ticketTypeId,
      description: eventModel.description,
      endDate: eventModel.endDate,
    );
  }

  factory EventDetailModel.fromJson(String source) => EventDetailModel.fromMap(json.decode(source));

  @override
  Map<String, dynamic> toMap() {
    final data = super.toMap();
    data.addAll({
      'booking': booking,
    });
    return data;
  }

  String toJson() => json.encode(toMap());
}
