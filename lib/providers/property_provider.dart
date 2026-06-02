import 'package:flutter/foundation.dart';
import '../models/property_model.dart';
import '../services/mock_data_service.dart';

class PropertyProvider extends ChangeNotifier {
  List<Property> _allProperties = [];
  List<Property> _filteredProperties = [];
  bool _isLoading = false;
  String _searchQuery = '';
  String? _selectedDistrict;
  PropertyType? _selectedType;
  double _minPrice = 0;
  double _maxPrice = 200000;
  String _sortBy = 'newest';

  List<Property> get properties => _filteredProperties;
  List<Property> get allProperties => _allProperties;
  bool get isLoading => _isLoading;
  String get searchQuery => _searchQuery;
  String? get selectedDistrict => _selectedDistrict;
  PropertyType? get selectedType => _selectedType;
  double get minPrice => _minPrice;
  double get maxPrice => _maxPrice;
  String get sortBy => _sortBy;

  PropertyProvider() {
    loadProperties();
  }

  Future<void> loadProperties() async {
    _isLoading = true;
    notifyListeners();

    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 800));
    _allProperties = MockDataService.getProperties();
    _filteredProperties = List.from(_allProperties);
    _isLoading = false;
    notifyListeners();
  }

  void setSearchQuery(String query) {
    _searchQuery = query;
    _applyFilters();
  }

  void setDistrict(String? district) {
    _selectedDistrict = district;
    _applyFilters();
  }

  void setPropertyType(PropertyType? type) {
    _selectedType = type;
    _applyFilters();
  }

  void setPriceRange(double min, double max) {
    _minPrice = min;
    _maxPrice = max;
    _applyFilters();
  }

  void setSortBy(String sortBy) {
    _sortBy = sortBy;
    _applyFilters();
  }

  void clearFilters() {
    _searchQuery = '';
    _selectedDistrict = null;
    _selectedType = null;
    _minPrice = 0;
    _maxPrice = 200000;
    _sortBy = 'newest';
    _filteredProperties = List.from(_allProperties);
    notifyListeners();
  }

  void _applyFilters() {
    _filteredProperties = _allProperties.where((property) {
      // Search query
      if (_searchQuery.isNotEmpty) {
        final query = _searchQuery.toLowerCase();
        if (!property.title.toLowerCase().contains(query) &&
            !property.address.toLowerCase().contains(query) &&
            !property.city.toLowerCase().contains(query)) {
          return false;
        }
      }

      // District filter
      if (_selectedDistrict != null && _selectedDistrict!.isNotEmpty) {
        if (property.district != _selectedDistrict) return false;
      }

      // Type filter
      if (_selectedType != null) {
        if (property.type != _selectedType) return false;
      }

      // Price filter
      if (property.price < _minPrice || property.price > _maxPrice) {
        return false;
      }

      return true;
    }).toList();

    // Sort
    switch (_sortBy) {
      case 'price_low':
        _filteredProperties.sort((a, b) => a.price.compareTo(b.price));
        break;
      case 'price_high':
        _filteredProperties.sort((a, b) => b.price.compareTo(a.price));
        break;
      case 'newest':
        _filteredProperties
            .sort((a, b) => b.postedDate.compareTo(a.postedDate));
        break;
    }

    notifyListeners();
  }

  Property? getPropertyById(String id) {
    try {
      return _allProperties.firstWhere((p) => p.id == id);
    } catch (e) {
      return null;
    }
  }

  List<Property> getFeaturedProperties() {
    return _allProperties.where((p) => p.isVerified).take(4).toList();
  }

  List<Property> getNearbyProperties(String city) {
    return _allProperties.where((p) => p.city == city).take(6).toList();
  }
}