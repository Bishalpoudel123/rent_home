class PropertyModel {
  final String id;
  final String title;
  final String description;
  final double price;
  final String address;
  final double latitude;
  final double longitude;
  final List<String> images;
  final List<String> amenities;
  final int bedrooms;
  final int bathrooms;
  final double area;
  final String landlordId;
  final PropertyStatus status;
  final DateTime createdAt;

  PropertyModel({
    required this.id,
    required this.title,
    required this.description,
    required this.price,
    required this.address,
    required this.latitude,
    required this.longitude,
    required this.images,
    required this.amenities,
    required this.bedrooms,
    required this.bathrooms,
    required this.area,
    required this.landlordId,
    required this.status,
    required this.createdAt,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
    'description': description,
    'price': price,
    'address': address,
    'latitude': latitude,
    'longitude': longitude,
    'images': images,
    'amenities': amenities,
    'bedrooms': bedrooms,
    'bathrooms': bathrooms,
    'area': area,
    'landlordId': landlordId,
    'status': status.toString().split('.').last,
    'createdAt': createdAt.toIso8601String(),
  };

  factory PropertyModel.fromJson(Map<String, dynamic> json) => PropertyModel(
    id: json['id'],
    title: json['title'],
    description: json['description'],
    price: json['price'],
    address: json['address'],
    latitude: json['latitude'],
    longitude: json['longitude'],
    images: List<String>.from(json['images']),
    amenities: List<String>.from(json['amenities']),
    bedrooms: json['bedrooms'],
    bathrooms: json['bathrooms'],
    area: json['area'],
    landlordId: json['landlordId'],
    status: PropertyStatus.values.firstWhere(
      (e) => e.toString().split('.').last == json['status']
    ),
    createdAt: DateTime.parse(json['createdAt']),
  );
}

enum PropertyStatus { available, rented, maintenance }