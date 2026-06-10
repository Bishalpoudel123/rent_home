import 'package:flutter/material.dart';
import '../models/property_model.dart';
import '../services/mock_data_service.dart';

class PropertyProvider extends ChangeNotifier {
  List<PropertyModel> _properties = [];
  List<PropertyModel> _filteredProperties = [];
  bool _isLoading = false;

  List<PropertyModel> get properties => _filteredProperties.isEmpty ? _properties : _filteredProperties;
  bool get isLoading => _isLoading;

  // कोठा लोड गर्ने
  Future<void> fetchProperties() async {
    _isLoading = true;
    notifyListeners();
    
    await Future.delayed(Duration(milliseconds: 500));
    _properties = MockDataService.getMockProperties();
    _filteredProperties = [];
    
    _isLoading = false;
    notifyListeners();
  }

  // नयाँ कोठा थप्ने 🔴 यो नै चाहिने मुख्य मेथड
  Future<void> addProperty(PropertyModel property) async {
    _isLoading = true;
    notifyListeners();
    
    await Future.delayed(Duration(milliseconds: 500));
    _properties.add(property);
    _filteredProperties = [];
    
    _isLoading = false;
    notifyListeners();
  }

  // कोठा अपडेट गर्ने
  Future<void> updateProperty(PropertyModel updatedProperty) async {
    final index = _properties.indexWhere((p) => p.id == updatedProperty.id);
    if (index != -1) {
      _properties[index] = updatedProperty;
      _filteredProperties = [];
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