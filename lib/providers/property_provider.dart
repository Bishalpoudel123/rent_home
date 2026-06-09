import 'package:flutter/material.dart';
import '../models/property_model.dart';
import '../services/mock_data_service.dart';

class PropertyProvider extends ChangeNotifier {
  List<PropertyModel> _properties = [];
  List<PropertyModel> _filteredProperties = [];
  bool _isLoading = false;

  List<PropertyModel> get properties => _filteredProperties.isEmpty ? _properties : _filteredProperties;
  bool get isLoading => _isLoading;

  Future<void> fetchProperties() async {
    _isLoading = true;
    notifyListeners();
    
    await Future.delayed(Duration(seconds: 1));
    _properties = MockDataService.getMockProperties();
    _filteredProperties = [];
    
    _isLoading = false;
    notifyListeners();
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
    _filteredProperties = _properties.where((property) =>
      property.bedrooms == bedrooms
    ).toList();
    notifyListeners();
  }

  void clearFilters() {
    _filteredProperties = [];
    notifyListeners();
  }
}