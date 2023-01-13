import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  final String firstName;
  final String lastName;
  final String email;
  final String id;
  final String? profileImage;
  final int phone;
  final DateTime? lastMessageTime;

  UserModel({
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.id,
    this.profileImage,
    required this.phone,
    this.lastMessageTime,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
        firstName: json['firstName'],
        lastName: json['lastName'],
        email: json['email'],
        id: json['id'],
        profileImage: json['profileImage'],
        phone: json['phone'],
        lastMessageTime: toDateTime(json['lastMessageTime']),
      );

  Map<String, dynamic> toJson() => {
        'firstName': firstName,
        'lastName': lastName,
        'email': email,
        'id': id,
        'profileImage': profileImage,
        'phone': phone,
        'lastMessageTime': fromDateTimeToJson(lastMessageTime),
      };

  static dynamic fromDateTimeToJson(DateTime? date) {
    if (date == null) return null;
    return date.toUtc();
  }

  static DateTime? toDateTime(Timestamp? value) {
    if (value == null) return null;
    return value.toDate();
  }
}
