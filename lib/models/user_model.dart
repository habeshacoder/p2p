// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class User {
  User({
    this.id,
    this.token,
    required this.userPublicId,
    required this.firstName,
    required this.lastName,
    required this.userName,
    required this.userPassword,
    required this.email,
    this.role,
    this.createdAt,
    this.address,
  });
  final dynamic id;
  final String? token;
  final String? userPublicId;
  final String? firstName;
  final String? lastName;
  final String? userName;
  final String? userPassword;
  final String? email;
  final String? role;
  final String? createdAt;
  final Address? address;

  factory User.fromJson(Map<String, dynamic> json, [String? token]) {
    return User(
      id: json["id"],
      token: token ?? null,
      userPublicId: json["userPublicId"],
      firstName: json["firstName"],
      lastName: json["lastName"],
      userName: json["userName"],
      userPassword: json["userPassword"],
      email: json["email"],
      address:
          json["address"] == null ? null : Address.fromJson(json["address"]),
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'token': token,
      'userPublicId': userPublicId,
      'firstName': firstName,
      'lastName': lastName,
      'userName': userName,
      'userPassword': userPassword,
      'email': email,
      'role': role,
      'createdAt': createdAt,
      'address': address?.toJson(),
    };
  }

  // String toJson() => json.encode(toMap());

  @override
  String toString() {
    return 'User(token: $token, userPublicId: $userPublicId, firstName: $firstName, lastName: $lastName, userName: $userName, userPassword: $userPassword, email: $email, role: $role, createdAt: $createdAt, address: $address)';
  }
}

class Address {
  Address({
    required this.id,
    required this.street,
    required this.city,
    required this.createdOn,
    required this.updatedOn,
  });

  final dynamic id;
  final String? street;
  final String? city;
  final DateTime? createdOn;
  final DateTime? updatedOn;

  factory Address.fromJson(Map<String, dynamic> json) {
    return Address(
      id: json["id"],
      street: json["street"],
      city: json["city"],
      createdOn: DateTime.tryParse(json["createdOn"] ?? ""),
      updatedOn: DateTime.tryParse(json["updatedOn"] ?? ""),
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'id': id,
      'street': street,
      'city': city,
      'createdOn': createdOn?.millisecondsSinceEpoch,
      'updatedOn': updatedOn?.millisecondsSinceEpoch,
    };
  }

  factory Address.fromMap(Map<String, dynamic> map) {
    return Address(
      id: map['id'] != null ? map['id'] : null,
      street: map['street'] != null ? map['street'] as String : null,
      city: map['city'] != null ? map['city'] as String : null,
      createdOn: map['createdOn'] != null
          ? DateTime.fromMillisecondsSinceEpoch(map['createdOn'])
          : null,
      updatedOn: map['updatedOn'] != null
          ? DateTime.fromMillisecondsSinceEpoch(map['updatedOn'])
          : null,
    );
  }

  @override
  String toString() {
    return 'Address(id: $id, street: $street, city: $city, createdOn: $createdOn, updatedOn: $updatedOn)';
  }
}
