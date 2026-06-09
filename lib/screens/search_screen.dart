import 'package:flutter/material.dart';
import 'package:nepal_rent_app/models/property_model.dart';
import 'package:provider/provider.dart';
import '../providers/property_provider.dart';
import '../widgets/property_card.dart';
import 'property_detail_screen.dart';

class SearchScreen extends StatefulWidget {
  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  double _minPrice = 0;
  double _maxPrice = 50000;
  int _bedrooms = 0;
  bool _showFilters = false;
  String _selectedDistrict = 'सबै';
  
  final List<String> _districts = [
    'सबै', 'काठमाडौं', 'ललितपुर', 'भक्तपुर', 
    'पोखरा', 'चितवन', 'विराटनगर', 'विरगञ्ज'
  ];
  
  @override
  Widget build(BuildContext context) {
    final propertyProvider = Provider.of<PropertyProvider>(context);
    final availableProperties = propertyProvider.properties
        .where((p) => p.status == PropertyStatus.available)
        .toList();
    
    return Scaffold(
      appBar: AppBar(
        title: Text('कोठा खोज्नुहोस्', 
          style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(60),
          child: Padding(
            padding: EdgeInsets.all(12),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(30),
              ),
              child: TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  hintText: 'कोठा, ठेगाना वा स्थान खोज्नुहोस्...',
                  hintStyle: TextStyle(color: Colors.grey[500]),
                  prefixIcon: Icon(Icons.search, color: Colors.blue),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _showFilters ? Icons.filter_alt : Icons.filter_alt_outlined,
                      color: _showFilters ? Colors.blue : Colors.grey,
                    ),
                    onPressed: () {
                      setState(() {
                        _showFilters = !_showFilters;
                      });
                    },
                  ),
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(vertical: 12),
                ),
                onChanged: (value) {
                  propertyProvider.searchProperties(value);
                },
              ),
            ),
          ),
        ),
      ),
      body: Column(
        children: [
          if (_showFilters) _buildFilters(propertyProvider),
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
                : propertyProvider.properties.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.search_off, size: 64, color: Colors.grey[400]),
                            SizedBox(height: 16),
                            Text(
                              'कुनै कोठा फेला परेन',
                              style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                            ),
                            SizedBox(height: 8),
                            Text(
                              'फरक खोजी शब्द प्रयोग गर्नुहोस्',
                              style: TextStyle(fontSize: 13, color: Colors.grey[500]),
                            ),
                          ],
                        ),
                      )
                    : ListView.builder(
                        padding: EdgeInsets.all(12),
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
        ],
      ),
    );
  }
  
  Widget _buildFilters(PropertyProvider provider) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(20),
          bottomRight: Radius.circular(20),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 4,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'फिल्टरहरू',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              TextButton(
                onPressed: () {
                  setState(() {
                    _minPrice = 0;
                    _maxPrice = 50000;
                    _bedrooms = 0;
                    _selectedDistrict = 'सबै';
                  });
                  provider.clearFilters();
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('सबै फिल्टर हटाइयो')),
                  );
                },
                child: Text('सबै हटाउनुहोस्', style: TextStyle(color: Colors.red)),
              ),
            ],
          ),
          SizedBox(height: 16),
          
          // Location/District Filter
          Text('जिल्ला', style: TextStyle(fontWeight: FontWeight.w600)),
          SizedBox(height: 8),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 12),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey.shade300),
              borderRadius: BorderRadius.circular(12),
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                value: _selectedDistrict,
                isExpanded: true,
                items: _districts.map((district) {
                  return DropdownMenuItem(
                    value: district,
                    child: Text(district),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedDistrict = value!;
                  });
                  // Filter by district logic here
                },
              ),
            ),
          ),
          SizedBox(height: 16),
          
          // Price Range
          Text('मूल्य दायरा (रु.)', style: TextStyle(fontWeight: FontWeight.w600)),
          SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: Text('रु. ${_minPrice.toInt()}'),
              ),
              Expanded(
                child: Text('रु. ${_maxPrice.toInt()}',
                  textAlign: TextAlign.right,
                ),
              ),
            ],
          ),
          RangeSlider(
            values: RangeValues(_minPrice, _maxPrice),
            min: 0,
            max: 50000,
            divisions: 50,
            activeColor: Colors.blue,
            labels: RangeLabels(
              'रु. ${_minPrice.toInt()}',
              'रु. ${_maxPrice.toInt()}',
            ),
            onChanged: (values) {
              setState(() {
                _minPrice = values.start;
                _maxPrice = values.end;
              });
              provider.filterByPrice(_minPrice, _maxPrice);
            },
          ),
          SizedBox(height: 16),
          
          // Bedrooms
          Text('शयनकक्ष', style: TextStyle(fontWeight: FontWeight.w600)),
          SizedBox(height: 8),
          Row(
            children: [
              Text('कुनै पनि', style: TextStyle(fontSize: 13)),
              Expanded(
                child: Slider(
                  value: _bedrooms.toDouble(),
                  min: 0,
                  max: 5,
                  divisions: 5,
                  label: _bedrooms == 0 ? 'कुनै पनि' : '$_bedrooms वटा',
                  activeColor: Colors.blue,
                  onChanged: (value) {
                    setState(() {
                      _bedrooms = value.toInt();
                    });
                    if (_bedrooms > 0) {
                      provider.filterByBedrooms(_bedrooms);
                    } else {
                      provider.clearFilters();
                    }
                  },
                ),
              ),
              Text(
                _bedrooms == 0 ? 'कुनै पनि' : '$_bedrooms',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ],
          ),
          SizedBox(height: 16),
          
          // Apply Filters Button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                setState(() {
                  _showFilters = false;
                });
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('फिल्टर लागू गरियो')),
                );
              },
              child: Text('फिल्टर लागू गर्नुहोस्'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                padding: EdgeInsets.symmetric(vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
  
  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
}