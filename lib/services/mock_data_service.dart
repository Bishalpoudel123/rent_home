import '../models/property_model.dart';

class MockDataService {
  static List<PropertyModel> getMockProperties() {
    return [
      PropertyModel(
        id: '1',
        title: 'सुन्दर २ बेडरुम अपार्टमेन्ट',
        description: 'ललितपुरको शान्त क्षेत्रमा रहेको सुन्दर अपार्टमेन्ट। पूरै फर्निस्ड, सुरक्षित क्षेत्र।',
        price: 8000,
        address: 'ललितपुर, कुपन्डोल',
        latitude: 27.7172,
        longitude: 85.3240,
        images: [],
        amenities: ['WiFi', 'Parking', 'Furnished', 'CCTV'],
        bedrooms: 2,
        bathrooms: 2,
        area: 550,
        landlordId: 'landlord1',
        status: PropertyStatus.available,
        createdAt: DateTime.now(),
        ownerName: 'राम श्रेष्ठ',           // ✅ Owner नाम
        ownerPhone: '9812345678',           // ✅ Owner फोन
        ownerEmail: 'ram@example.com',      // ✅ Owner इमेल
      ),
      PropertyModel(
        id: '2',
        title: 'आधुनिक स्टुडियो अपार्टमेन्ट',
        description: 'काठमाडौंको केन्द्रमा आधुनिक स्टुडियो। सबै सुविधा सहित।',
        price: 12000,
        address: 'काठमाडौं, बानेश्वर',
        latitude: 27.7120,
        longitude: 85.3390,
        images: [],
        amenities: ['WiFi', 'AC', 'Gym', 'Parking'],
        bedrooms: 1,
        bathrooms: 1,
        area: 350,
        landlordId: 'landlord1',
        status: PropertyStatus.available,
        createdAt: DateTime.now(),
        ownerName: 'सीता गिरी',             // ✅ Owner नाम
        ownerPhone: '9876543210',           // ✅ Owner फोन
        ownerEmail: 'sita@example.com',     // ✅ Owner इमेल
      ),
      PropertyModel(
        id: '3',
        title: 'परिवारको लागि ३ बेडरुम घर',
        description: 'शान्त वातावरणमा रहेको सुन्दर घर। ठुलो बगैचा सहित।',
        price: 25000,
        address: 'भक्तपुर, सूर्यविनायक',
        latitude: 27.6725,
        longitude: 85.4294,
        images: [],
        amenities: ['WiFi', 'Parking', 'Garden', 'Furnished', 'Security'],
        bedrooms: 3,
        bathrooms: 2,
        area: 1200,
        landlordId: 'landlord2',
        status: PropertyStatus.available,
        createdAt: DateTime.now(),
        ownerName: 'हरि बस्नेत',            // ✅ Owner नाम
        ownerPhone: '9823456789',           // ✅ Owner फोन
        ownerEmail: 'hari@example.com',     // ✅ Owner इमेल
      ),
      PropertyModel(
        id: '4',
        title: 'सस्तो कोठा भाडामा',
        description: 'विद्यार्थीको लागि उपयुक्त सस्तो कोठा।',
        price: 5000,
        address: 'कीर्तिपुर, चोभार',
        latitude: 27.6785,
        longitude: 85.2775,
        images: [],
        amenities: ['WiFi', 'Simple'],
        bedrooms: 1,
        bathrooms: 1,
        area: 200,
        landlordId: 'landlord2',
        status: PropertyStatus.rented,      // ❌ भाडामा दिइसकियो - देखिने छैन
        createdAt: DateTime.now(),
        ownerName: 'गोपाल तामाङ',           // ✅ Owner नाम
        ownerPhone: '9845678901',           // ✅ Owner फोन
        ownerEmail: 'gopal@example.com',    // ✅ Owner इमेल
      ),
    ];
  }
}