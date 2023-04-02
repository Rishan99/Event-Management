import 'dart:convert';

import 'package:event_management/model/event_model.dart';

class EventDetailModel extends EventModel {
  final dynamic booking;
  final List<String> images;
  final bool allowBooking;
  final String? ticketStatus;
  final int? ticketStatusId;
  EventDetailModel({
    required this.booking,
    this.ticketStatus,
    this.ticketStatusId,
    required this.images,
    required this.allowBooking,
    required super.id,
    required super.name,
    required super.city,
    required super.address,
    super.description,
    required super.startDate,
    super.endDate,
    required super.ticketType,
    required super.ticketTypeId,
    required super.coverImage,
    required super.ticketPrice,
  });

  factory EventDetailModel.fromMap(Map<String, dynamic> map) {
    final eventModel = EventModel.fromMap(map);
    return EventDetailModel(
      images: (map['eventImages'] ?? []).isEmpty ? <String>[] : (map["eventImages"] as List<dynamic>).map((e) => e['imageName'].toString()).toList(),
      allowBooking: map['allowBooking'] ?? false,
      ticketStatus: map['ticketStatus'],
      booking: map['booking'] ?? null,
      coverImage: map['coverImage'],
      ticketStatusId: map['ticketStatusId'],
      address: eventModel.address,
      city: eventModel.city,
      id: eventModel.id,
      name: eventModel.name,
      startDate: eventModel.startDate,
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
      'images': images,
      'ticketStatusId': ticketStatusId,
      'allowBooking': allowBooking,
      'ticketStatus': ticketStatus,
    });
    return data;
  }

  String toJson() => json.encode(toMap());
}
