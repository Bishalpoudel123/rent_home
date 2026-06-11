import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/property_provider.dart';
import '../providers/auth_provider.dart';
import '../models/property_model.dart';
import '../screens/property_detail_screen.dart';
import 'room_status_update_screen.dart';

class MyListingsScreen extends StatefulWidget {
  const MyListingsScreen({Key? key}) : super(key: key);

  @override
  State<MyListingsScreen> createState() => _MyListingsScreenState();
}

class _MyListingsScreenState extends State<MyListingsScreen> {
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadProperties();
  }

  Future<void> _loadProperties() async {
    setState(() {
      _isLoading = true;
    });
    
    final propertyProvider = Provider.of<PropertyProvider>(context, listen: false);
    await propertyProvider.fetchProperties();
    
    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final propertyProvider = Provider.of<PropertyProvider>(context);
    final authProvider = Provider.of<AuthProvider>(context);
    
    // Owner को आफ्नै properties मात्र देखाउने
    final myProperties = propertyProvider.properties
        .where((p) => p.landlordId == authProvider.currentUser?.id)
        .toList();
    
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'मेरो सूचीहरू',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
        centerTitle: false,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadProperties,
            tooltip: 'रिफ्रेस गर्नुहोस्',
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: _isLoading
          ? const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(color: Colors.blue),
                  SizedBox(height: 16),
                  Text('लोड हुँदैछ...'),
                ],
              ),
            )
          : myProperties.isEmpty
              ? _buildEmptyState(context)
              : RefreshIndicator(
                  onRefresh: _loadProperties,
                  child: ListView.builder(
                    padding: const EdgeInsets.all(12),
                    itemCount: myProperties.length,
                    itemBuilder: (context, index) {
                      final property = myProperties[index];
                      return _buildPropertyCard(context, property);
                    },
                  ),
                ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.house_outlined, size: 80, color: Colors.grey[400]),
          const SizedBox(height: 16),
          const Text(
            'हाल कुनै सूची छैन',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Text(
            'नयाँ कोठा पोस्ट गर्न + बटन थिच्नुहोस्',
            style: TextStyle(color: Colors.grey[600]),
          ),
        ],
      ),
    );
  }

  Widget _buildPropertyCard(BuildContext context, PropertyModel property) {
    final isAvailable = property.status == PropertyStatus.available;
    
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 2,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Property Image Section
          Stack(
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                child: Container(
                  height: 160,
                  width: double.infinity,
                  color: Colors.grey.shade300,
                  child: Center(
                    child: Icon(Icons.home, size: 50, color: Colors.grey.shade500),
                  ),
                ),
              ),
              // Status Badge
              Positioned(
                top: 12,
                right: 12,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: isAvailable ? Colors.green : Colors.red,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black26,
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        isAvailable ? Icons.check_circle : Icons.cancel,
                        color: Colors.white,
                        size: 14,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        isAvailable ? 'उपलब्ध' : 'भाडामा दिइसकियो',
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          
          // Property Info Section
          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Title
                Text(
                  property.title,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                
                // Address
                Row(
                  children: [
                    Icon(Icons.location_on, size: 14, color: Colors.grey[600]),
                    const SizedBox(width: 4),
                    Expanded(
                      child: Text(
                        property.address,
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey[600],
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                
                // Specifications Row
                Row(
                  children: [
                    _buildSpecChip(Icons.bed, '${property.bedrooms} शयनकक्ष'),
                    const SizedBox(width: 12),
                    _buildSpecChip(Icons.bathtub, '${property.bathrooms} स्नानगृह'),
                    const SizedBox(width: 12),
                    _buildSpecChip(Icons.square_foot, '${property.area} वर्गफिट'),
                  ],
                ),
                const SizedBox(height: 12),
                
                // Price and Action Buttons Row
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'मासिक भाडा',
                          style: TextStyle(fontSize: 11, color: Colors.grey),
                        ),
                        Text(
                          'रु. ${property.price.toStringAsFixed(0)}',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.blue.shade700,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        // View Details Button
                        OutlinedButton.icon(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => PropertyDetailScreen(propertyId: property.id),
                              ),
                            );
                          },
                          icon: const Icon(Icons.visibility, size: 16),
                          label: const Text('हेर्नुहोस्'),
                          style: OutlinedButton.styleFrom(
                            side: BorderSide(color: Colors.blue.shade300),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                          ),
                        ),
                        const SizedBox(width: 8),
                        // Status Update Button
                        _buildStatusButton(context, property, isAvailable),
                      ],
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

  Widget _buildSpecChip(IconData icon, String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Icon(icon, size: 14, color: Colors.grey[600]),
          const SizedBox(width: 4),
          Text(label, style: TextStyle(fontSize: 12, color: Colors.grey[700])),
        ],
      ),
    );
  }

  Widget _buildStatusButton(BuildContext context, PropertyModel property, bool isAvailable) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30),
        color: isAvailable ? Colors.orange.shade50 : Colors.green.shade50,
      ),
      child: TextButton.icon(
        onPressed: () => _showStatusUpdateDialog(context, property),
        icon: Icon(
          isAvailable ? Icons.edit : Icons.check_circle,
          size: 16,
          color: isAvailable ? Colors.orange : Colors.green,
        ),
        label: Text(
          isAvailable ? 'स्थिति अपडेट' : 'खाली छ भन्नुहोस्',
          style: TextStyle(
            color: isAvailable ? Colors.orange : Colors.green,
            fontWeight: FontWeight.w600,
            fontSize: 12,
          ),
        ),
        style: TextButton.styleFrom(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        ),
      ),
    );
  }

  void _showStatusUpdateDialog(BuildContext context, PropertyModel property) {
    final isCurrentlyAvailable = property.status == PropertyStatus.available;
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Row(
          children: [
            Icon(
              isCurrentlyAvailable ? Icons.warning_amber : Icons.celebration,
              color: isCurrentlyAvailable ? Colors.orange : Colors.green,
              size: 28,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                isCurrentlyAvailable ? 'कोठा भाडामा दिइयो?' : 'कोठा खाली छ?',
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              isCurrentlyAvailable
                  ? 'के तपाईं निश्चित हुनुहुन्छ कि यो कोठा भाडामा दिइसकियो?\n\nयो अपडेट गरेपछि कोठा "भाडामा दिइसकियो" को रूपमा देखिनेछ। खोजी गर्नेहरूले यो कोठा देख्न पाउने छैनन्।'
                  : 'के तपाईं निश्चित हुनुहुन्छ कि यो कोठा अहिले खाली छ?\n\nयो अपडेट गरेपछि कोठा "उपलब्ध" को रूपमा देखिनेछ। खोजी गर्नेहरूले यो कोठा देख्न सक्नेछन्।',
              style: TextStyle(fontSize: 14, height: 1.4),
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: isCurrentlyAvailable ? Colors.red.shade50 : Colors.green.shade50,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  Icon(
                    isCurrentlyAvailable ? Icons.info_outline : Icons.check_circle_outline,
                    color: isCurrentlyAvailable ? Colors.red : Colors.green,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      isCurrentlyAvailable
                          ? 'कोठा भाडामा दिइसकियो भने, नयाँ प्रयोगकर्ताले यो कोठा देख्न पाउने छैनन्।'
                          : 'कोठा खाली छ भने, नयाँ प्रयोगकर्ताले यो कोठा देख्न सक्नेछन्।',
                      style: TextStyle(
                        fontSize: 12,
                        color: isCurrentlyAvailable ? Colors.red : Colors.green,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('रद्द', style: TextStyle(color: Colors.grey)),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              _updatePropertyStatus(context, property, !isCurrentlyAvailable);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: isCurrentlyAvailable ? Colors.red : Colors.green,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            child: Text(
              isCurrentlyAvailable ? 'हो, भाडामा दिइयो' : 'हो, खाली छ',
              style: const TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _updatePropertyStatus(BuildContext context, PropertyModel property, bool newStatus) async {
    // Show loading indicator
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('अपडेट हुँदैछ...'),
        duration: Duration(seconds: 1),
      ),
    );
    
    await Future.delayed(const Duration(seconds: 1));
    
    final propertyProvider = Provider.of<PropertyProvider>(context, listen: false);
    
    // Update property status
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
      ownerName: property.ownerName,
      ownerPhone: property.ownerPhone,
      ownerEmail: property.ownerEmail,
    );
    
    await propertyProvider.updateProperty(updatedProperty);
    await propertyProvider.fetchProperties();
    
    // Show success message
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          newStatus 
              ? '✅ कोठा खाली छ भनेर अपडेट गरियो! अब खोजी गर्नेहरूले देख्नेछन्।'
              : '✅ कोठा भाडामा दिइसकियो भनेर अपडेट गरियो!',
        ),
        backgroundColor: newStatus ? Colors.green : Colors.orange,
        duration: const Duration(seconds: 3),
      ),
    );
    
    setState(() {});
  }
}