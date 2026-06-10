import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/property_provider.dart';
import '../providers/auth_provider.dart';
import '../widgets/property_card.dart';
import '../widgets/category_chip.dart';
import '../models/property_model.dart';
import 'property_detail_screen.dart';
import 'search_screen.dart';

class HomeScreen extends StatelessWidget {
  final List<String> categories = ['सबै', 'अपार्टमेन्ट', 'घर', 'साझा', 'स्टुडियो'];
  
  @override
  Widget build(BuildContext context) {
    final propertyProvider = Provider.of<PropertyProvider>(context);
    final authProvider = Provider.of<AuthProvider>(context);
    
    // 🔴 Only show available properties
    final availableProperties = propertyProvider.properties
        .where((p) => p.status == PropertyStatus.available)
        .toList();
    
    print('Total properties: ${propertyProvider.properties.length}'); // Debug
    print('Available properties: ${availableProperties.length}'); // Debug
    
    return Scaffold(
      appBar: AppBar(
        title: Text('तपाईंको घर खोज्नुहोस्',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
        centerTitle: false,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
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
          Container(
            margin: EdgeInsets.only(right: 12),
            child: CircleAvatar(
              radius: 18,
              backgroundColor: Colors.blue.shade100,
              child: Text(
                authProvider.currentUser?.name[0].toUpperCase() ?? 'यू',
                style: TextStyle(fontWeight: FontWeight.bold, color: Colors.blue.shade700),
              ),
            ),
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () => propertyProvider.fetchProperties(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [Colors.blue.shade50, Colors.white],
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'नमस्ते, ${authProvider.currentUser?.name ?? "प्रिय प्रयोगकर्ता"}!',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue.shade800,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'आजै आफ्नो सही कोठा खोज्नुहोस्',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ),
            
            Padding(
              padding: EdgeInsets.fromLTRB(16, 20, 16, 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'श्रेणीहरू',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  TextButton(
                    onPressed: () {},
                    child: Text('सबै हेर्नुहोस्',
                      style: TextStyle(color: Colors.blue, fontSize: 13)),
                  ),
                ],
              ),
            ),
            
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              padding: EdgeInsets.only(left: 16, bottom: 8),
              child: Row(
                children: categories.map((category) {
                  return CategoryChip(label: category);
                }).toList(),
              ),
            ),
            
            Expanded(
              child: propertyProvider.isLoading
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          CircularProgressIndicator(color: Colors.blue),
                          SizedBox(height: 16),
                          Text('लोड हुँदैछ...', style: TextStyle(color: Colors.grey)),
                        ],
                      ),
                    )
                  : availableProperties.isEmpty
                      ? Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.home_work_outlined, size: 64, color: Colors.grey[400]),
                              SizedBox(height: 16),
                              Text(
                                'हाल कुनै कोठा उपलब्ध छैन',
                                style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                              ),
                              SizedBox(height: 8),
                              Text(
                                'नयाँ कोठा पोस्ट गर्न "मेरो सूची" मा + बटन थिच्नुहोस्',
                                style: TextStyle(fontSize: 13, color: Colors.grey[500]),
                              ),
                            ],
                          ),
                        )
                      : ListView.builder(
                          padding: EdgeInsets.all(12),
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
          ],
        ),
      ),
    );
  }
}