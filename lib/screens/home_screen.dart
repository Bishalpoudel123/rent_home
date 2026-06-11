import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/property_provider.dart';
import '../providers/auth_provider.dart';
import '../models/property_model.dart';
import '../widgets/property_card.dart';
import 'property_detail_screen.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    _loadProperties();
  }

  Future<void> _loadProperties() async {
    final provider = Provider.of<PropertyProvider>(context, listen: false);
    await provider.fetchProperties();
  }

  @override
  Widget build(BuildContext context) {
    final propertyProvider = Provider.of<PropertyProvider>(context);
    final authProvider = Provider.of<AuthProvider>(context);
    
    // ✅ Available properties मात्र देखाउने
    final availableProperties = propertyProvider.properties
        .where((p) => p.status == PropertyStatus.available)
        .toList();
    
    print('📊 Total: ${propertyProvider.properties.length}');
    print('✅ Available: ${availableProperties.length}');
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('तपाईंको घर खोज्नुहोस्'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadProperties,
            tooltip: 'रिफ्रेस',
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: _loadProperties,
        child: propertyProvider.isLoading
            ? const Center(child: CircularProgressIndicator())
            : availableProperties.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.home_work_outlined, size: 64, color: Colors.grey[400]),
                        const SizedBox(height: 16),
                        Text('हाल कुनै कोठा उपलब्ध छैन'),
                        const SizedBox(height: 8),
                        Text('नयाँ कोठा पोस्ट हुँदैछ', style: TextStyle(color: Colors.grey)),
                      ],
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.all(12),
                    itemCount: availableProperties.length,
                    itemBuilder: (context, index) {
                      final property = availableProperties[index];
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
    );
  }
}