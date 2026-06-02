class Property {
  final String id;
  final String title;
  final String description;
  final String address;
  final String city;
  final String district;
  final double price;
  final String priceType; // monthly, yearly
  final PropertyType type;
  final int bedrooms;
  final int bathrooms;
  final double areaSqFt;
  final List<String> images;
  final List<String> amenities;
  final String ownerName;
  final String ownerPhone;
  final String ownerImage;
  final double latitude;
  final double longitude;
  final bool isVerified;
  final bool isAvailable;
  final DateTime postedDate;
  final String furnishingStatus; // furnished, semi-furnished, unfurnished

  const Property({
    required this.id,
    required this.title,
    required this.description,
    required this.address,
    required this.city,
    required this.district,
    required this.price,
    required this.priceType,
    required this.type,
    required this.bedrooms,
    required this.bathrooms,
    required this.areaSqFt,
    required this.images,
    required this.amenities,
    required this.ownerName,
    required this.ownerPhone,
    required this.ownerImage,
    required this.latitude,
    required this.longitude,
    required this.isVerified,
    required this.isAvailable,
    required this.postedDate,
    required this.furnishingStatus,
  });

  String get formattedPrice {
    if (price >= 100000) {
      return 'रू ${(price / 100000).toStringAsFixed(1)} लाख';
    }
    return 'रू ${price.toStringAsFixed(0)}';
  }

  String get typeLabel {
    switch (type) {
      case PropertyType.room:
        return 'कोठा';
      case PropertyType.apartment:
        return 'अपार्टमेन्ट';
      case PropertyType.house:
        return 'घर';
      case PropertyType.flat:
        return 'फ्ल्याट';
      case PropertyType.office:
        return 'अफिस';
      case PropertyType.land:
        return 'जग्गा';
    }
  }

  factory Property.fromJson(Map<String, dynamic> json) {
    return Property(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      address: json['address'],
      city: json['city'],
      district: json['district'],
      price: json['price'].toDouble(),
      priceType: json['priceType'],
      type: PropertyType.values.firstWhere(
        (e) => e.name == json['type'],
        orElse: () => PropertyType.room,
      ),
      bedrooms: json['bedrooms'],
      bathrooms: json['bathrooms'],
      areaSqFt: json['areaSqFt'].toDouble(),
      images: List<String>.from(json['images']),
      amenities: List<String>.from(json['amenities']),
      ownerName: json['ownerName'],
      ownerPhone: json['ownerPhone'],
      ownerImage: json['ownerImage'],
      latitude: json['latitude'].toDouble(),
      longitude: json['longitude'].toDouble(),
      isVerified: json['isVerified'],
      isAvailable: json['isAvailable'],
      postedDate: DateTime.parse(json['postedDate']),
      furnishingStatus: json['furnishingStatus'],
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'description': description,
        'address': address,
        'city': city,
        'district': district,
        'price': price,
        'priceType': priceType,
        'type': type.name,
        'bedrooms': bedrooms,
        'bathrooms': bathrooms,
        'areaSqFt': areaSqFt,
        'images': images,
        'amenities': amenities,
        'ownerName': ownerName,
        'ownerPhone': ownerPhone,
        'ownerImage': ownerImage,
        'latitude': latitude,
        'longitude': longitude,
        'isVerified': isVerified,
        'isAvailable': isAvailable,
        'postedDate': postedDate.toIso8601String(),
        'furnishingStatus': furnishingStatus,
      };
}

enum PropertyType { room, apartment, house, flat, office, land }