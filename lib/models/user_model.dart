import 'package:cloud_firestore/cloud_firestore.dart';

enum UserType { tenant, landlord }

class UserModel {
  final String id;
  final String name;
  final String email;
  final String phone;
  final UserType userType;
  final DateTime createdAt;

  UserModel({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    required this.userType,
    required this.createdAt,
  });

  // Firestore मा save गर्न
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'phone': phone,
      'userType': userType.name,          // 'tenant' or 'landlord'
      'createdAt': Timestamp.fromDate(createdAt),
    };
  }

  // Firestore बाट read गर्न
  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      id: map['id'] ?? '',
      name: map['name'] ?? '',
      email: map['email'] ?? '',
      phone: map['phone'] ?? '',
      userType: UserType.values.firstWhere(
        (e) => e.name == map['userType'],
        orElse: () => UserType.tenant,
      ),
      createdAt: map['createdAt'] is Timestamp
          ? (map['createdAt'] as Timestamp).toDate()
          : DateTime.now(),
    );
  }
}