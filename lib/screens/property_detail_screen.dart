import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import '../models/property_model.dart';
import '../models/user_model.dart';
import '../providers/property_provider.dart';
import '../providers/auth_provider.dart';
import '../providers/favorite_provider.dart';
import 'contact_owner_screen.dart';
import '../models/user_model.dart';
class PropertyDetailScreen extends StatefulWidget {
  final String propertyId;
  
  const PropertyDetailScreen({Key? key, required this.propertyId}) : super(key: key);
  
  @override
  State<PropertyDetailScreen> createState() => _PropertyDetailScreenState();
}

class _PropertyDetailScreenState extends State<PropertyDetailScreen> {
  PropertyModel? _property;
  bool _isLoading = true;
  bool _isRequesting = false;

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
    final authProvider = Provider.of<AuthProvider>(context);
    final isTenant = authProvider.currentUser?.userType == UserType.tenant;
    
    if (_isLoading) {
      return Scaffold(
        body: const Center(child: CircularProgressIndicator()),
      );
    }
    
    if (_property == null) {
      return Scaffold(
        body: const Center(child: Text('कोठा फेला परेन')),
      );
    }
    
    final isAvailable = _property!.status == PropertyStatus.available;
    
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          // App Bar with Image
          SliverAppBar(
            expandedHeight: 250,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                color: Colors.grey.shade300,
                child: const Center(
                  child: Icon(Icons.home, size: 80, color: Colors.grey),
                ),
              ),
            ),
            actions: [
              // Favorite Button
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
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(isFav ? 'मनपर्नेबाट हटाइयो' : 'मनपर्नेमा थपियो'),
                          duration: const Duration(seconds: 1),
                        ),
                      );
                    },
                  );
                },
              ),
            ],
          ),
          
          // Property Details
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title and Status
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          _property!.title,
                          style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: isAvailable ? Colors.green : Colors.red,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          isAvailable ? '✅ उपलब्ध' : '❌ भाडामा दिइसकियो',
                          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  
                  // Address
                  Row(
                    children: [
                      Icon(Icons.location_on, size: 16, color: Colors.grey[600]),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          _property!.address,
                          style: TextStyle(color: Colors.grey[600]),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  
                  // Specifications
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.blue.shade50,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _buildSpecChip(Icons.bed, '${_property!.bedrooms} शयनकक्ष'),
                        _buildSpecChip(Icons.bathtub, '${_property!.bathrooms} स्नानगृह'),
                        _buildSpecChip(Icons.square_foot, '${_property!.area} वर्गफिट'),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                  
                  // Description
                  const Text(
                    'विवरण',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    _property!.description,
                    style: const TextStyle(fontSize: 14, height: 1.5),
                  ),
                  const SizedBox(height: 24),
                  
                  // Amenities
                  const Text(
                    'सुविधाहरू',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: _property!.amenities.map((amenity) {
                      return Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: Colors.grey.shade200,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(amenity, style: const TextStyle(fontSize: 12)),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 24),
                  
                  // Owner Info
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade50,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.grey.shade200),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'घरधनीको जानकारी',
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            CircleAvatar(
                              backgroundColor: Colors.blue.shade100,
                              child: Text(
                                _property!.ownerName[0].toUpperCase(),
                                style: TextStyle(color: Colors.blue.shade700),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    _property!.ownerName,
                                    style: const TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                  Text(
                                    _property!.ownerPhone,
                                    style: TextStyle(fontSize: 12, color: Colors.grey),
                                  ),
                                ],
                              ),
                            ),
                            // Contact Button
                            OutlinedButton.icon(
                              onPressed: () {
                                _showContactOptions(context);
                              },
                              icon: const Icon(Icons.contact_phone, size: 16),
                              label: const Text('सम्पर्क'),
                              style: OutlinedButton.styleFrom(
                                side: const BorderSide(color: Colors.green),
                                foregroundColor: Colors.green,
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
                  const SizedBox(height: 24),
                  
                  // Price
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey.shade300),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('मासिक भाडा:', style: TextStyle(fontSize: 16)),
                        Text(
                          'रु. ${_property!.price.toStringAsFixed(0)}',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.blue.shade700,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 30),
                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: _buildBottomBar(context, isAvailable, isTenant),
    );
  }

  Widget _buildSpecChip(IconData icon, String label) {
    return Row(
      children: [
        Icon(icon, size: 20, color: Colors.blue.shade700),
        const SizedBox(width: 4),
        Text(label, style: const TextStyle(fontWeight: FontWeight.w500)),
      ],
    );
  }

  Widget _buildBottomBar(BuildContext context, bool isAvailable, bool isTenant) {
    if (!isAvailable) {
      return Container(
        padding: const EdgeInsets.all(16),
        color: Colors.red.shade50,
        child: const Center(
          child: Text(
            'यो कोठा भाडामा दिइसकियो',
            style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
          ),
        ),
      );
    }
    
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        child: Row(
          children: [
            // Contact Owner Button
            Expanded(
              child: OutlinedButton.icon(
                onPressed: () {
                  _showContactOptions(context);
                },
                icon: const Icon(Icons.contact_phone),
                label: const Text('सम्पर्क'),
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  side: const BorderSide(color: Colors.green),
                  foregroundColor: Colors.green,
                ),
              ),
            ),
            const SizedBox(width: 12),
            
            // Request Room Button
            Expanded(
              child: ElevatedButton.icon(
                onPressed: _isRequesting ? null : () => _requestRoom(context),
                icon: _isRequesting
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                      )
                    : const Icon(Icons.home_work),
                label: const Text('कोठा लिन चाहन्छु'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  padding: const EdgeInsets.symmetric(vertical: 14),
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

  void _showContactOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'घरधनीलाई सम्पर्क गर्नुहोस्',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            
            // Phone Call
            _buildContactOption(
              icon: Icons.phone,
              title: 'फोन गर्नुहोस्',
              subtitle: _property!.ownerPhone,
              color: Colors.green,
              onTap: () {
                Navigator.pop(context);
                _makePhoneCall(_property!.ownerPhone);
              },
            ),
            
            // SMS
            _buildContactOption(
              icon: Icons.message,
              title: 'एसएमएस पठाउनुहोस्',
              subtitle: _property!.ownerPhone,
              color: Colors.blue,
              onTap: () {
                Navigator.pop(context);
                _sendSMS(_property!.ownerPhone);
              },
            ),
            
            // Email
            _buildContactOption(
              icon: Icons.email,
              title: 'इमेल पठाउनुहोस्',
              subtitle: _property!.ownerEmail,
              color: Colors.red,
              onTap: () {
                Navigator.pop(context);
                _sendEmail(_property!.ownerEmail);
              },
            ),
            
            // Full Contact Screen
            _buildContactOption(
              icon: Icons.contact_page,
              title: 'पूरा सम्पर्क जानकारी',
              subtitle: 'सबै विकल्पहरू हेर्नुहोस्',
              color: Colors.purple,
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => ContactOwnerScreen(
                      ownerName: _property!.ownerName,
                      ownerPhone: _property!.ownerPhone,
                      ownerEmail: _property!.ownerEmail,
                      propertyTitle: _property!.title,
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContactOption({
    required IconData icon,
    required String title,
    required String subtitle,
    required Color color,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: CircleAvatar(
        backgroundColor: color.withOpacity(0.1),
        child: Icon(icon, color: color),
      ),
      title: Text(title),
      subtitle: Text(subtitle, style: const TextStyle(fontSize: 12)),
      trailing: const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
      onTap: onTap,
    );
  }

  Future<void> _makePhoneCall(String phoneNumber) async {
    final Uri launchUri = Uri(scheme: 'tel', path: phoneNumber);
    try {
      if (await canLaunchUrl(launchUri)) {
        await launchUrl(launchUri);
      } else {
        _showError('फोन गर्न सकिएन');
      }
    } catch (e) {
      _showError('फोन गर्न सकिएन');
    }
  }

  Future<void> _sendSMS(String phoneNumber) async {
    final Uri launchUri = Uri(scheme: 'sms', path: phoneNumber);
    try {
      if (await canLaunchUrl(launchUri)) {
        await launchUrl(launchUri);
      } else {
        _showError('एसएमएस पठाउन सकिएन');
      }
    } catch (e) {
      _showError('एसएमएस पठाउन सकिएन');
    }
  }

  Future<void> _sendEmail(String email) async {
    final Uri launchUri = Uri(
      scheme: 'mailto',
      path: email,
      query: 'subject=कोठाको बारेमा जानकारी चाहियो&body=नमस्ते, म तपाईंको कोठाको बारेमा जानकारी लिन चाहन्छु...',
    );
    try {
      if (await canLaunchUrl(launchUri)) {
        await launchUrl(launchUri);
      } else {
        _showError('इमेल पठाउन सकिएन');
      }
    } catch (e) {
      _showError('इमेल पठाउन सकिएन');
    }
  }

  Future<void> _requestRoom(BuildContext context) async {
    setState(() {
      _isRequesting = true;
    });
    
    await Future.delayed(const Duration(seconds: 1));
    
    setState(() {
      _isRequesting = false;
    });
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Row(
          children: [
            Icon(Icons.check_circle, color: Colors.green),
            SizedBox(width: 8),
            Text('अनुरोध पठाइयो'),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('तपाईंको कोठा लिने अनुरोध घरधनीलाई पठाइएको छ।'),
            const SizedBox(height: 8),
            Text(
              'घरधनी: ${_property!.ownerName}',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text('घरधनीले तपाईंलाई चाँडै सम्पर्क गर्नेछन्।'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('ठीक छ'),
          ),
        ],
      ),
    );
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: Colors.red),
    );
  }
}