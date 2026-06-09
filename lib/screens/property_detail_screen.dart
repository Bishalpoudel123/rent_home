import 'package:flutter/material.dart';
import 'package:nepal_rent_app/models/user_model.dart';
import 'package:provider/provider.dart';
import '../models/property_model.dart';
import '../providers/property_provider.dart';
import '../providers/favorite_provider.dart';
import '../providers/auth_provider.dart';
import '../shared/chat_screen.dart';

class PropertyDetailScreen extends StatefulWidget {
  final String propertyId;
  
  PropertyDetailScreen({required this.propertyId});
  
  @override
  _PropertyDetailScreenState createState() => _PropertyDetailScreenState();
}

class _PropertyDetailScreenState extends State<PropertyDetailScreen> {
  PropertyModel? _property;
  bool _isLoading = true;
  int _selectedImageIndex = 0;
  
  @override
  void initState() {
    super.initState();
    _loadProperty();
  }
  
  Future<void> _loadProperty() async {
    final propertyProvider = Provider.of<PropertyProvider>(context, listen: false);
    final property = await propertyProvider.getPropertyById(widget.propertyId);
    
    setState(() {
      _property = property;
      _isLoading = false;
    });
  }
  
  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }
    
    if (_property == null) {
      return Scaffold(
        body: Center(child: Text('Property not found')),
      );
    }
    
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 300,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              background: _buildImageCarousel(),
            ),
            actions: [
              Consumer<FavoriteProvider>(
                builder: (context, favoriteProvider, child) {
                  final isFav = favoriteProvider.isFavorite(_property!.id);
                  return IconButton(
                    icon: Icon(
                      isFav ? Icons.favorite : Icons.favorite_border,
                      color: isFav ? Colors.red : Colors.white,
                    ),
                    onPressed: () {
                      favoriteProvider.toggleFavorite(_property!.id);
                    },
                  );
                },
              ),
            ],
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          _property!.title,
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: _property!.status == PropertyStatus.available
                              ? Colors.green
                              : Colors.orange,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          _property!.status.toString().split('.').last.toUpperCase(),
                          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 8),
                  Row(
                    children: [
                      Icon(Icons.location_on, size: 16, color: Colors.grey),
                      SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          _property!.address,
                          style: TextStyle(color: Colors.grey[600]),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 16),
                  Container(
                    padding: EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.blue.shade50,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _buildInfoChip(Icons.bed, '${_property!.bedrooms} Beds'),
                        _buildInfoChip(Icons.bathtub, '${_property!.bathrooms} Baths'),
                        _buildInfoChip(Icons.square_foot, '${_property!.area} sqft'),
                      ],
                    ),
                  ),
                  SizedBox(height: 24),
                  Text(
                    'Description',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    _property!.description,
                    style: TextStyle(fontSize: 14, height: 1.5),
                  ),
                  SizedBox(height: 24),
                  Text(
                    'Amenities',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 12),
                  Wrap(
                    spacing: 8,
                    children: _property!.amenities.map((amenity) {
                      return Chip(
                        label: Text(amenity),
                        backgroundColor: Colors.blue.shade100,
                      );
                    }).toList(),
                  ),
                  SizedBox(height: 24),
                  Text(
                    'Price Details',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 12),
                  Container(
                    padding: EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey.shade300),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Monthly Rent',
                          style: TextStyle(fontSize: 16),
                        ),
                        Text(
                          '\$${_property!.price.toStringAsFixed(0)}',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.blue.shade700,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 24),
                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: _buildBottomBar(context),
    );
  }
  
  Widget _buildImageCarousel() {
    if (_property!.images.isEmpty) {
      return Container(color: Colors.grey.shade300);
    }
    
    return Stack(
      children: [
        PageView.builder(
          onPageChanged: (index) {
            setState(() {
              _selectedImageIndex = index;
            });
          },
          itemCount: _property!.images.length,
          itemBuilder: (context, index) {
            return Container(
              color: Colors.grey.shade300,
              child: Center(
                child: Icon(Icons.image, size: 50, color: Colors.grey),
              ),
            );
          },
        ),
        Positioned(
          bottom: 16,
          right: 16,
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: Colors.black54,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              '${_selectedImageIndex + 1}/${_property!.images.length}',
              style: TextStyle(color: Colors.white, fontSize: 12),
            ),
          ),
        ),
      ],
    );
  }
  
  Widget _buildInfoChip(IconData icon, String label) {
    return Row(
      children: [
        Icon(icon, size: 20, color: Colors.blue.shade700),
        SizedBox(width: 4),
        Text(label, style: TextStyle(fontWeight: FontWeight.w500)),
      ],
    );
  }
  
  Widget _buildBottomBar(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final isLandlord = authProvider.currentUser?.userType == UserType.landlord;
    
    if (isLandlord) return SizedBox.shrink();
    
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 10,
            offset: Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        child: Row(
          children: [
            Expanded(
              child: ElevatedButton.icon(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => ChatScreen(
                        receiverId: _property!.landlordId,
                        receiverName: 'Landlord',
                      ),
                    ),
                  );
                },
                icon: Icon(Icons.chat),
                label: Text('Message Landlord'),
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ),
            SizedBox(width: 12),
            Expanded(
              child: ElevatedButton.icon(
                onPressed: () {
                  // Schedule viewing
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Viewing request sent!')),
                  );
                },
                icon: Icon(Icons.calendar_today),
                label: Text('Schedule Visit'),
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(vertical: 12),
                  backgroundColor: Colors.green,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}