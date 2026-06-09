import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/favorite_provider.dart';
import '../providers/property_provider.dart';
import '../widgets/property_card.dart';
import 'property_detail_screen.dart';

class FavoritesScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final favoriteProvider = Provider.of<FavoriteProvider>(context);
    final propertyProvider = Provider.of<PropertyProvider>(context);
    
    final favoriteProperties = propertyProvider.properties
        .where((property) => favoriteProvider.favoritePropertyIds.contains(property.id))
        .toList();
    
    return Scaffold(
      appBar: AppBar(
        title: Text('Favorites'),
        actions: [
          if (favoriteProperties.isNotEmpty)
            IconButton(
              icon: Icon(Icons.delete),
              onPressed: () {
                _showClearFavoritesDialog(context, favoriteProvider);
              },
            ),
        ],
      ),
      body: favoriteProperties.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.favorite_border,
                    size: 80,
                    color: Colors.grey[400],
                  ),
                  SizedBox(height: 16),
                  Text(
                    'No favorites yet',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Colors.grey[600],
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Start adding properties to your favorites',
                    style: TextStyle(
                      color: Colors.grey[500],
                    ),
                  ),
                  SizedBox(height: 24),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text('Browse Properties'),
                  ),
                ],
              ),
            )
          : ListView.builder(
              padding: EdgeInsets.all(16),
              itemCount: favoriteProperties.length,
              itemBuilder: (context, index) {
                final property = favoriteProperties[index];
                return PropertyCard(
                  property: property,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => PropertyDetailScreen(propertyId: property.id),
                      ),
                    );
                  },
                );
              },
            ),
    );
  }
  
  void _showClearFavoritesDialog(BuildContext context, FavoriteProvider provider) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Clear Favorites'),
        content: Text('Are you sure you want to remove all properties from favorites?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              for (var id in provider.favoritePropertyIds.toList()) {
                provider.removeFavorite(id);
              }
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('All favorites removed')),
              );
            },
            child: Text('Clear', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}