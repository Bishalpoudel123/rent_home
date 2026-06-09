import 'package:flutter/material.dart';

class FavoriteProvider extends ChangeNotifier {
  List<String> _favoritePropertyIds = [];

  List<String> get favoritePropertyIds => _favoritePropertyIds;
  int get favoritesCount => _favoritePropertyIds.length;

  void addFavorite(String propertyId) {
    if (!_favoritePropertyIds.contains(propertyId)) {
      _favoritePropertyIds.add(propertyId);
      notifyListeners();
    }
  }

  void removeFavorite(String propertyId) {
    _favoritePropertyIds.remove(propertyId);
    notifyListeners();
  }

  bool isFavorite(String propertyId) {
    return _favoritePropertyIds.contains(propertyId);
  }

  void toggleFavorite(String propertyId) {
    if (isFavorite(propertyId)) {
      removeFavorite(propertyId);
    } else {
      addFavorite(propertyId);
    }
  }
}