import '../models/property_model.dart';

class MockDataService {
  static List<PropertyModel> getMockProperties() {
    return [
      PropertyModel(
        id: '1',
        title: 'सुन्दर २ बेडरुम अपार्टमेन्ट',
        description: 'ललितपुरको शान्त क्षेत्रमा रहेको सुन्दर अपार्टमेन्ट',
        price: 8000,
        address: 'ललितपुर, कुपन्डोल',
        latitude: 27.7172,
        longitude: 85.3240,
        images: [],
        amenities: ['WiFi', 'Parking', 'Furnished'],
        bedrooms: 2,
        bathrooms: 2,
        area: 550,
        landlordId: 'landlord1',
        status: PropertyStatus.available,  // 🔴 यो available हुनुपर्छ
        createdAt: DateTime.now(),
      ),
      PropertyModel(
        id: '2',
        title: 'आधुनिक स्टुडियो अपार्टमेन्ट',
        description: 'काठमाडौंको केन्द्रमा आधुनिक स्टुडियो',
        price: 12000,
        address: 'काठमाडौं, बानेश्वर',
        latitude: 27.7120,
        longitude: 85.3390,
        images: [],
        amenities: ['WiFi', 'AC', 'Gym'],
        bedrooms: 1,
        bathrooms: 1,
        area: 350,
        landlordId: 'landlord1',
        status: PropertyStatus.available,  // 🔴 यो available हुनुपर्छ
        createdAt: DateTime.now(),
      ),
    ];
  }
}