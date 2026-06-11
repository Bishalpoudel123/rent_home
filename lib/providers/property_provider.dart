import 'package:flutter/material.dart';
import '../models/property_model.dart';

class PropertyProvider extends ChangeNotifier {
  List<PropertyModel> _properties = [];
  List<PropertyModel> _filteredProperties = [];
  bool _isLoading = false;

  List<PropertyModel> get properties => _filteredProperties.isEmpty ? _properties : _filteredProperties;
  bool get isLoading => _isLoading;

  Future<void> fetchProperties() async {
    _isLoading = true;
    notifyListeners();
    
    await Future.delayed(Duration(milliseconds: 500));
    
    _properties = [
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
        status: PropertyStatus.available,
        createdAt: DateTime.now(),
        ownerName: 'राम श्रेष्ठ',           // ✅ थप्नुहोस्
        ownerPhone: '9812345678',           // ✅ थप्नुहोस्
        ownerEmail: 'ram@example.com',      // ✅ थप्नुहोस्
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
        landlordId: 'landlord2',
        status: PropertyStatus.available,
        createdAt: DateTime.now(),
        ownerName: 'सीता गिरी',             // ✅ थप्नुहोस्
        ownerPhone: '9876543210',           // ✅ थप्नुहोस्
        ownerEmail: 'sita@example.com',     // ✅ थप्नुहोस्
      ),
    ];
    
    _isLoading = false;
    notifyListeners();
  }

  Future<void> addProperty(PropertyModel property) async {
    _properties.add(property);
    notifyListeners();
  }

  Future<void> updateProperty(PropertyModel updatedProperty) async {
    final index = _properties.indexWhere((p) => p.id == updatedProperty.id);
    if (index != -1) {
      _properties[index] = updatedProperty;
      notifyListeners();
    }
  }

  Future<PropertyModel?> getPropertyById(String id) async {
    return _properties.firstWhere((property) => property.id == id);
  }

  void searchProperties(String query) {
    if (query.isEmpty) {
      _filteredProperties = [];
    } else {
      _filteredProperties = _properties.where((property) =>
        property.title.toLowerCase().contains(query.toLowerCase()) ||
        property.address.toLowerCase().contains(query.toLowerCase())
      ).toList();
    }
    notifyListeners();
  }

  void filterByPrice(double minPrice, double maxPrice) {
    _filteredProperties = _properties.where((property) =>
      property.price >= minPrice && property.price <= maxPrice
    ).toList();
    notifyListeners();
  }

  void filterByBedrooms(int bedrooms) {
    if (bedrooms > 0) {
      _filteredProperties = _properties.where((property) =>
        property.bedrooms == bedrooms
      ).toList();
    } else {
      _filteredProperties = [];
    }
    notifyListeners();
  }

  void clearFilters() {
    _filteredProperties = [];
    notifyListeners();
  }
}