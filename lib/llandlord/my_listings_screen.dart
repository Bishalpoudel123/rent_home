import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/property_provider.dart';
import '../widgets/property_card.dart';
import '../screens/property_detail_screen.dart';

class MyListingsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final propertyProvider = Provider.of<PropertyProvider>(context);
    
    // In real app, filter by landlord ID
    final myProperties = propertyProvider.properties;
    
    return Scaffold(
      appBar: AppBar(
        title: Text('My Listings'),
      ),
      body: myProperties.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.house, size: 80, color: Colors.grey),
                  SizedBox(height: 16),
                  Text(
                    'No listings yet',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 8),
                  Text('Tap + to post your first property'),
                ],
              ),
            )
          : ListView.builder(
              padding: EdgeInsets.all(16),
              itemCount: myProperties.length,
              itemBuilder: (context, index) {
                final property = myProperties[index];
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
}