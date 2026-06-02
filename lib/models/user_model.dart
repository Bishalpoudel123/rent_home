class UserModel {
  final String id;
  final String name;
  final String email;
  final String phone;
  final String? profileImage;
  final UserRole role;
  final DateTime joinedDate;
  final bool isVerified;

  const UserModel({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    this.profileImage,
    required this.role,
    required this.joinedDate,
    required this.isVerified,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
        id: json['id'],
        name: json['name'],
        email: json['email'],
        phone: json['phone'],
        profileImage: json['profileImage'],
        role: UserRole.values.firstWhere(
          (e) => e.name == json['role'],
          orElse: () => UserRole.tenant,
        ),
        joinedDate: DateTime.parse(json['joinedDate']),
        isVerified: json['isVerified'] ?? false,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'email': email,
        'phone': phone,
        'profileImage': profileImage,
        'role': role.name,
        'joinedDate': joinedDate.toIso8601String(),
        'isVerified': isVerified,
      };
}

enum UserRole { tenant, landlord, agent }