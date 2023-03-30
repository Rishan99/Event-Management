import 'dart:convert';

class UserModel {
  final String id;
  final String name;
  final String username;
  final String createdDate;
  UserModel({
    required this.id,
    required this.name,
    required this.username,
    required this.createdDate,
  });

  UserModel copyWith({
    String? id,
    String? name,
    String? username,
    String? createdDate,
  }) {
    return UserModel(
      id: id ?? this.id,
      name: name ?? this.name,
      username: username ?? this.username,
      createdDate: createdDate ?? this.createdDate,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'username': username,
      'createdDate': createdDate,
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      id: map['id'] ?? '',
      name: map['name'] ?? '',
      username: map['username'] ?? '',
      createdDate: map['createdDate'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory UserModel.fromJson(String source) => UserModel.fromMap(json.decode(source));

  @override
  String toString() {
    return 'UserModel(id: $id, name: $name, username: $username, createdDate: $createdDate)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is UserModel && other.id == id && other.name == name && other.username == username && other.createdDate == createdDate;
  }

  @override
  int get hashCode {
    return id.hashCode ^ name.hashCode ^ username.hashCode ^ createdDate.hashCode;
  }
}
