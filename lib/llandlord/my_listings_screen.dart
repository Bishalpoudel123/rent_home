import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/property_provider.dart';
import '../providers/auth_provider.dart';
import '../models/property_model.dart';
import 'room_status_update_screen.dart';
import '../screens/property_detail_screen.dart';

class MyListingsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final propertyProvider = Provider.of<PropertyProvider>(context);
    final authProvider = Provider.of<AuthProvider>(context);
    
    final myProperties = propertyProvider.properties
        .where((p) => p.landlordId == authProvider.currentUser?.id)
        .toList();
    
    return Scaffold(
      appBar: AppBar(
        title: Text('मेरो सूचीहरू'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
      ),
      body: myProperties.isEmpty
          ? const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.house_outlined, size: 64, color: Colors.grey),
                  SizedBox(height: 16),
                  Text(
                    'हाल कुनै सूची छैन',
                    style: TextStyle(fontSize: 18),
                  ),
                  SizedBox(height: 8),
                  Text('नयाँ कोठा पोस्ट गर्न + बटन थिच्नुहोस्'),
                ],
              ),
            )
          : ListView.builder(
              padding: EdgeInsets.all(12),
              itemCount: myProperties.length,
              itemBuilder: (context, index) {
                final property = myProperties[index];
                return _buildPropertyCard(context, property);
              },
            ),
    );
  }
  
  Widget _buildPropertyCard(BuildContext context, PropertyModel property) {
    final isAvailable = property.status == PropertyStatus.available;
    
    return Card(
      margin: EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Column(
        children: [
          // Property Image
          Container(
            height: 150,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
              color: Colors.grey.shade300,
            ),
            child: Stack(
              children: [
                Center(child: Icon(Icons.home, size: 50, color: Colors.grey)),
                Positioned(
                  top: 12,
                  right: 12,
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: isAvailable ? Colors.green : Colors.red,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      isAvailable ? 'खाली छ' : 'भाडामा दिइसकियो',
                      style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ],
            ),
          ),
          
          Padding(
            padding: EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  property.title,
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 4),
                Row(
                  children: [
                    Icon(Icons.location_on, size: 14, color: Colors.grey),
                    SizedBox(width: 4),
                    Expanded(
                      child: Text(
                        property.address,
                        style: TextStyle(fontSize: 12, color: Colors.grey),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'रु. ${property.price.toStringAsFixed(0)}/महिना',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.blue.shade700,
                      ),
                    ),
                    // यो नै मुख्य "खाली छ" बटन
                    ElevatedButton.icon(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => RoomStatusUpdateScreen(
                              propertyId: property.id,
                              propertyTitle: property.title,
                            ),
                          ),
                        );
                      },
                      icon: Icon(isAvailable ? Icons.edit : Icons.check_circle, size: 16),
                      label: Text(
                        isAvailable ? 'स्थिति अपडेट' : 'खाली छ भन्नुहोस्',
                        style: TextStyle(fontSize: 12),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: isAvailable ? Colors.orange : Colors.green,
                        padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}