import 'dart:convert';

import 'ticket_type.dart';

class EventModel {
  final int id;
  final String name;
  final String city;
  final String address;
  final String? description;
  final String startDate;
  final String? endDate;
  final TicketType ticketType;
  final int ticketTypeId;
  final double ticketPrice;
  EventModel({
    required this.id,
    required this.name,
    required this.city,
    required this.address,
    this.description,
    required this.startDate,
    this.endDate,
    required this.ticketType,
    required this.ticketTypeId,
    required this.ticketPrice,
  });

  factory EventModel.fromMap(Map<String, dynamic> map) {
    return EventModel(
      id: map['id']?.toInt() ?? 0,
      name: map['name'] ?? '',
      city: map['city'] ?? '',
      address: map['address'] ?? '',
      description: map['description'],
      startDate: map['startDate'] ?? '',
      endDate: map['endDate'],
      ticketType: TicketType.fromMap(map['ticketType']),
      ticketTypeId: map['ticketTypeId']?.toInt() ?? 0,
      ticketPrice: map['ticketPrice']?.toDouble() ?? 0.0,
    );
  }

  factory EventModel.fromJson(String source) => EventModel.fromMap(json.decode(source));

  @override
  String toString() {
    return 'EventModel(id: $id, name: $name, city: $city, address: $address, description: $description, startDate: $startDate, endDate: $endDate, ticketType: $ticketType, ticketTypeId: $ticketTypeId, ticketPrice: $ticketPrice)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is EventModel &&
        other.id == id &&
        other.name == name &&
        other.city == city &&
        other.address == address &&
        other.description == description &&
        other.startDate == startDate &&
        other.endDate == endDate &&
        other.ticketType == ticketType &&
        other.ticketTypeId == ticketTypeId &&
        other.ticketPrice == ticketPrice;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        name.hashCode ^
        city.hashCode ^
        address.hashCode ^
        description.hashCode ^
        startDate.hashCode ^
        endDate.hashCode ^
        ticketType.hashCode ^
        ticketTypeId.hashCode ^
        ticketPrice.hashCode;
  }

  EventModel copyWith({
    int? id,
    String? name,
    String? city,
    String? address,
    String? description,
    String? startDate,
    String? endDate,
    TicketType? ticketType,
    int? ticketTypeId,
    double? ticketPrice,
  }) {
    return EventModel(
      id: id ?? this.id,
      name: name ?? this.name,
      city: city ?? this.city,
      address: address ?? this.address,
      description: description ?? this.description,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      ticketType: ticketType ?? this.ticketType,
      ticketTypeId: ticketTypeId ?? this.ticketTypeId,
      ticketPrice: ticketPrice ?? this.ticketPrice,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'city': city,
      'address': address,
      'description': description,
      'startDate': startDate,
      'endDate': endDate,
      'ticketType': ticketType.toMap(),
      'ticketTypeId': ticketTypeId,
      'ticketPrice': ticketPrice,
    };
  }

  String toJson() => json.encode(toMap());
}
