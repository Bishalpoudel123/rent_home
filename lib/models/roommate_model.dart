class RoommateProfile {
  final String id;
  final String userId;
  final String name;
  final int age;
  final String gender;
  final String occupation;
  final double budget;
  final List<String> preferences;
  final String description;
  final String? profileImage;
  final List<String> hobbies;
  final bool isSmoker;
  final bool hasPets;
  final DateTime createdAt;

  RoommateProfile({
    required this.id,
    required this.userId,
    required this.name,
    required this.age,
    required this.gender,
    required this.occupation,
    required this.budget,
    required this.preferences,
    required this.description,
    this.profileImage,
    required this.hobbies,
    required this.isSmoker,
    required this.hasPets,
    required this.createdAt,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'userId': userId,
    'name': name,
    'age': age,
    'gender': gender,
    'occupation': occupation,
    'budget': budget,
    'preferences': preferences,
    'description': description,
    'profileImage': profileImage,
    'hobbies': hobbies,
    'isSmoker': isSmoker,
    'hasPets': hasPets,
    'createdAt': createdAt.toIso8601String(),
  };

  factory RoommateProfile.fromJson(Map<String, dynamic> json) => RoommateProfile(
    id: json['id'],
    userId: json['userId'],
    name: json['name'],
    age: json['age'],
    gender: json['gender'],
    occupation: json['occupation'],
    budget: json['budget'],
    preferences: List<String>.from(json['preferences']),
    description: json['description'],
    profileImage: json['profileImage'],
    hobbies: List<String>.from(json['hobbies']),
    isSmoker: json['isSmoker'],
    hasPets: json['hasPets'],
    createdAt: DateTime.parse(json['createdAt']),
  );
}