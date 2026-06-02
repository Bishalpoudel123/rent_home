import 'package:flutter/foundation.dart';
import '../models/property_model.dart';

class FavoriteProvider extends ChangeNotifier {
  final List<Property> _favorites = [];

  List<Property> get favorites => _favorites;

  bool isFavorite(String propertyId) {
    return _favorites.any((p) => p.id == propertyId);
  }

  void toggleFavorite(Property property) {
    if (isFavorite(property.id)) {
      _favorites.removeWhere((p) => p.id == property.id);
    } else {
      _favorites.add(property);
    }
    notifyListeners();
  }

  int get count => _favorites.length;
}