import 'dart:convert';

class TicketType {
  final int id;
  final String name;
  TicketType({
    required this.id,
    required this.name,
  });

  TicketType copyWith({
    int? id,
    String? name,
  }) {
    return TicketType(
      id: id ?? this.id,
      name: name ?? this.name,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
    };
  }

  factory TicketType.fromMap(Map<String, dynamic> map) {
    return TicketType(
      id: map['id']?.toInt() ?? 0,
      name: map['name'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory TicketType.fromJson(String source) => TicketType.fromMap(json.decode(source));

  @override
  String toString() => 'TicketType(id: $id, name: $name)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is TicketType && other.id == id && other.name == name;
  }

  @override
  int get hashCode => id.hashCode ^ name.hashCode;
}
