import '../models/property_model.dart';

class MockDataService {
  static List<PropertyModel> getMockProperties() {
    return [
      PropertyModel(
        id: '1',
        title: 'Cozy Studio Apartment',
        description: 'Beautiful studio apartment in downtown area',
        price: 1200,
        address: '123 Main St, New York, NY',
        latitude: 40.7128,
        longitude: -74.0060,
        images: [],
        amenities: ['WiFi', 'AC', 'Furnished'],
        bedrooms: 1,
        bathrooms: 1,
        area: 550,
        landlordId: 'landlord1',
        status: PropertyStatus.available,
        createdAt: DateTime.now(),
      ),
      PropertyModel(
        id: '2',
        title: 'Spacious 2BR Apartment',
        description: 'Large apartment with great views',
        price: 2200,
        address: '456 Oak Ave, Brooklyn, NY',
        latitude: 40.6782,
        longitude: -73.9442,
        images: [],
        amenities: ['WiFi', 'AC', 'Parking', 'Gym', 'Laundry'],
        bedrooms: 2,
        bathrooms: 2,
        area: 950,
        landlordId: 'landlord2',
        status: PropertyStatus.available,
        createdAt: DateTime.now(),
      ),
      PropertyModel(
        id: '3',
        title: 'Modern Shared Room',
        description: 'Perfect for students, shared kitchen and bathroom',
        price: 800,
        address: '789 Pine St, Queens, NY',
        latitude: 40.7282,
        longitude: -73.7949,
        images: [],
        amenities: ['WiFi', 'Laundry', 'Pet Friendly'],
        bedrooms: 3,
        bathrooms: 2,
        area: 1200,
        landlordId: 'landlord1',
        status: PropertyStatus.available,
        createdAt: DateTime.now(),
      ),
    ];
  }

  static List<String> getNepalDistricts() {
    return [
      'Kathmandu',
      'Lalitpur',
      'Bhaktapur',
      'Pokhara',
      'Chitwan',
      'Butwal',
      'Biratnagar',
      'Dharan',
      'Janakpur',
      'Nepalgunj',
    ];
  }

  static List<String> getAmenities() {
    return [
      'WiFi',
      'Parking',
      'AC',
      'Furnished',
      'Laundry',
      'Attached Bathroom',
      'Kitchen',
      'Water Supply',
      'Electricity',
      'Security',
      'Gym',
      'Balcony',
    ];
  }
}