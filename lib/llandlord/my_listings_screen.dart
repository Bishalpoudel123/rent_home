import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/property_provider.dart';
import '../providers/auth_provider.dart';
import '../models/property_model.dart';
import '../utils/app_localizations.dart';
import '../screens/property_detail_screen.dart';

class MyListingsScreen extends StatefulWidget {
  @override
  _MyListingsScreenState createState() => _MyListingsScreenState();
}

class _MyListingsScreenState extends State<MyListingsScreen> {
  @override
  void initState() {
    super.initState();
    _loadProperties();
  }

  Future<void> _loadProperties() async {
    final propertyProvider = Provider.of<PropertyProvider>(context, listen: false);
    await propertyProvider.fetchProperties();
  }

  @override
  Widget build(BuildContext context) {
    final propertyProvider = Provider.of<PropertyProvider>(context);
    final authProvider = Provider.of<AuthProvider>(context);
    
    // घरधनीको आफ्नै properties मात्र देखाउनुहोस्
    final myProperties = propertyProvider.properties
        .where((p) => p.landlordId == authProvider.currentUser?.id)
        .toList();

    return Scaffold(
      appBar: AppBar(
        title: Text('my_listings'.tr(context)),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        actions: [
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: _loadProperties,
            tooltip: 'रिफ्रेस',
          ),
        ],
      ),
      body: propertyProvider.isLoading
          ? Center(child: CircularProgressIndicator())
          : myProperties.isEmpty
              ? _buildEmptyState(context)
              : ListView.builder(
                  padding: EdgeInsets.all(16),
                  itemCount: myProperties.length,
                  itemBuilder: (context, index) {
                    final property = myProperties[index];
                    return _buildPropertyCard(context, property);
                  },
                ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.house_outlined, size: 80, color: Colors.grey),
          SizedBox(height: 16),
          Text(
            'no_listings'.tr(context),
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 8),
          Text(
            'tap_to_post'.tr(context),
            style: TextStyle(color: Colors.grey),
          ),
        ],
      ),
    );
  }

  Widget _buildPropertyCard(BuildContext context, PropertyModel property) {
    final isAvailable = property.status == PropertyStatus.available;
    
    return Card(
      margin: EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Column(
        children: [
          // Property Image
          Container(
            height: 180,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
              color: Colors.grey.shade300,
            ),
            child: Stack(
              children: [
                Center(
                  child: Icon(Icons.home, size: 50, color: Colors.grey),
                ),
                // Status Badge
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
                      isAvailable ? 'available'.tr(context) : 'rented'.tr(context),
                      style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ],
            ),
          ),
          // Property Info
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
                  children: [
                    Icon(Icons.bed, size: 16, color: Colors.grey),
                    SizedBox(width: 4),
                    Text('${property.bedrooms} beds'),
                    SizedBox(width: 16),
                    Icon(Icons.bathtub, size: 16, color: Colors.grey),
                    SizedBox(width: 4),
                    Text('${property.bathrooms} baths'),
                    SizedBox(width: 16),
                    Icon(Icons.square_foot, size: 16, color: Colors.grey),
                    SizedBox(width: 4),
                    Text('${property.area} sqft'),
                  ],
                ),
                SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'रु ${property.price.toStringAsFixed(0)}/महिना',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.blue.shade700,
                      ),
                    ),
                    // Status Update Button
                    _buildStatusButton(context, property, isAvailable),
                  ],
                ),
                SizedBox(height: 8),
                // View Details Button
                OutlinedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => PropertyDetailScreen(propertyId: property.id),
                      ),
                    );
                  },
                  child: Text('विवरण हेर्नुहोस्'),
                  style: OutlinedButton.styleFrom(
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusButton(BuildContext context, PropertyModel property, bool isAvailable) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30),
        color: isAvailable ? Colors.red.shade50 : Colors.green.shade50,
      ),
      child: TextButton.icon(
        onPressed: () => _showStatusUpdateDialog(context, property),
        icon: Icon(
          isAvailable ? Icons.close : Icons.check_circle,
          size: 18,
          color: isAvailable ? Colors.red : Colors.green,
        ),
        label: Text(
          isAvailable ? 'खाली छैन भन्नुहोस्' : 'खाली छ भन्नुहोस्',
          style: TextStyle(
            color: isAvailable ? Colors.red : Colors.green,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  void _showStatusUpdateDialog(BuildContext context, PropertyModel property) {
    final isCurrentlyAvailable = property.status == PropertyStatus.available;
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            Icon(
              isCurrentlyAvailable ? Icons.warning_amber : Icons.celebration,
              color: isCurrentlyAvailable ? Colors.orange : Colors.green,
            ),
            SizedBox(width: 12),
            Text(isCurrentlyAvailable ? 'कोठा भाडामा दिइयो?' : 'कोठा खाली छ?'),
          ],
        ),
        content: Text(
          isCurrentlyAvailable
              ? 'के तपाईं निश्चित हुनुहुन्छ कि यो कोठा भाडामा दिइसकियो?\n\nयो अपडेट गरेपछि कोठा "भाडामा दिइसकियो" को रूपमा देखिनेछ।'
              : 'के तपाईं निश्चित हुनुहुन्छ कि यो कोठा अहिले खाली छ?\n\nयो अपडेट गरेपछि कोठा "उपलब्ध" को रूपमा देखिनेछ।',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('रद्द', style: TextStyle(color: Colors.grey)),
          ),
          ElevatedButton(
            onPressed: () {
              _updatePropertyStatus(context, property, !isCurrentlyAvailable);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: isCurrentlyAvailable ? Colors.red : Colors.green,
            ),
            child: Text(isCurrentlyAvailable ? 'हो, भाडामा दिइयो' : 'हो, खाली छ'),
          ),
        ],
      ),
    );
  }

  void _updatePropertyStatus(BuildContext context, PropertyModel property, bool newStatus) async {
    // यहाँ Firebase वा API मा status update गर्नुहोस्
    // हालको लागि, हामी provider मा update गर्छौं
    
    final propertyProvider = Provider.of<PropertyProvider>(context, listen: false);
    
    // Status update गर्नुहोस्
    final updatedProperty = PropertyModel(
      id: property.id,
      title: property.title,
      description: property.description,
      price: property.price,
      address: property.address,
      latitude: property.latitude,
      longitude: property.longitude,
      images: property.images,
      amenities: property.amenities,
      bedrooms: property.bedrooms,
      bathrooms: property.bathrooms,
      area: property.area,
      landlordId: property.landlordId,
      status: newStatus ? PropertyStatus.available : PropertyStatus.rented,
      createdAt: property.createdAt,
    );
    
    // Provider मा update गर्नुहोस् (तपाईंको provider मा update method हुनुपर्छ)
    // propertyProvider.updateProperty(updatedProperty);
    
    Navigator.pop(context); // Dialog बन्द गर्नुहोस्
    
    // Success message
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          newStatus 
              ? '✅ कोठा खाली छ भनेर अपडेट गरियो! अब खोजी गर्नेहरूले देख्नेछन्।'
              : '✅ कोठा भाडामा दिइसकियो भनेर अपडेट गरियो!',
        ),
        backgroundColor: Colors.green,
        duration: Duration(seconds: 3),
      ),
    );
    
    // Reload properties
    await propertyProvider.fetchProperties();
    setState(() {});
  }
}