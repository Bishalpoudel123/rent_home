import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/property_provider.dart';
import '../providers/auth_provider.dart';
import '../widgets/property_card.dart';
import '../widgets/category_chip.dart';
import 'property_detail_screen.dart';
import 'search_screen.dart';

class HomeScreen extends StatelessWidget {
  final List<String> categories = ['All', 'Apartment', 'House', 'Shared', 'Studio'];
  
  @override
  Widget build(BuildContext context) {
    final propertyProvider = Provider.of<PropertyProvider>(context);
    final authProvider = Provider.of<AuthProvider>(context);
    
    return Scaffold(
      appBar: AppBar(
        title: Text('Find Your Home'),
        centerTitle: false,
        actions: [
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => SearchScreen()),
              );
            },
          ),
          CircleAvatar(
            radius: 18,
            backgroundColor: Colors.blue.shade100,
            child: Text(
              authProvider.currentUser?.name[0].toUpperCase() ?? 'U',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          SizedBox(width: 16),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Welcome back, ${authProvider.currentUser?.name ?? "User"}!',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  'Find your perfect room today',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[600],
                  ),
                ),
                SizedBox(height: 20),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: categories.map((category) {
                      return CategoryChip(label: category);
                    }).toList(),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: propertyProvider.isLoading
                ? Center(child: CircularProgressIndicator())
                : RefreshIndicator(
                    onRefresh: () => propertyProvider.fetchProperties(),
                    child: ListView.builder(
                      padding: EdgeInsets.all(16),
                      itemCount: propertyProvider.properties.length,
                      itemBuilder: (context, index) {
                        final property = propertyProvider.properties[index];
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
                  ),
          ),
        ],
      ),
    );
  }
}