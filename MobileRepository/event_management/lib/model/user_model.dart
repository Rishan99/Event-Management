import 'dart:convert';

class UserModel {
  final String id;
  final String name;
  final String createdDate;
  UserModel({
    required this.id,
    required this.name,
    required this.createdDate,
  });

  UserModel copyWith({
    String? id,
    String? name,
    String? createdDate,
  }) {
    return UserModel(
      id: id ?? this.id,
      name: name ?? this.name,
      createdDate: createdDate ?? this.createdDate,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'createdDate': createdDate,
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      id: map['id'] ?? '',
      name: map['name'] ?? '',
      createdDate: map['createdDate'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory UserModel.fromJson(String source) => UserModel.fromMap(json.decode(source));

  @override
  String toString() => 'UserModel(id: $id, name: $name, createdDate: $createdDate)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is UserModel && other.id == id && other.name == name && other.createdDate == createdDate;
  }

  @override
  int get hashCode => id.hashCode ^ name.hashCode ^ createdDate.hashCode;
}
