import 'package:flutter/material.dart';
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
  double _maxPrice = 5000;
  int _bedrooms = 0;
  bool _showFilters = false;
  
  @override
  Widget build(BuildContext context) {
    final propertyProvider = Provider.of<PropertyProvider>(context);
    
    return Scaffold(
      appBar: AppBar(
        title: Text('Search Properties'),
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(60),
          child: Padding(
            padding: EdgeInsets.all(8),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search by title or address...',
                prefixIcon: Icon(Icons.search),
                suffixIcon: IconButton(
                  icon: Icon(Icons.filter_list),
                  onPressed: () {
                    setState(() {
                      _showFilters = !_showFilters;
                    });
                  },
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: Colors.white,
              ),
              onChanged: (value) {
                propertyProvider.searchProperties(value);
              },
            ),
          ),
        ),
      ),
      body: Column(
        children: [
          if (_showFilters) _buildFilters(propertyProvider),
          Expanded(
            child: propertyProvider.isLoading
                ? Center(child: CircularProgressIndicator())
                : propertyProvider.properties.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.search_off, size: 64, color: Colors.grey),
                            SizedBox(height: 16),
                            Text(
                              'No properties found',
                              style: TextStyle(fontSize: 18, color: Colors.grey),
                            ),
                          ],
                        ),
                      )
                    : ListView.builder(
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
        ],
      ),
    );
  }
  
  Widget _buildFilters(PropertyProvider provider) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 4,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: Text('Price Range: \$${_minPrice.toInt()} - \$${_maxPrice.toInt()}'),
              ),
              TextButton(
                onPressed: () {
                  setState(() {
                    _minPrice = 0;
                    _maxPrice = 5000;
                    _bedrooms = 0;
                  });
                  provider.clearFilters();
                },
                child: Text('Clear'),
              ),
            ],
          ),
          RangeSlider(
            values: RangeValues(_minPrice, _maxPrice),
            min: 0,
            max: 5000,
            divisions: 50,
            onChanged: (values) {
              setState(() {
                _minPrice = values.start;
                _maxPrice = values.end;
              });
              provider.filterByPrice(_minPrice, _maxPrice);
            },
          ),
          SizedBox(height: 16),
          Row(
            children: [
              Text('Bedrooms: '),
              Expanded(
                child: Slider(
                  value: _bedrooms.toDouble(),
                  min: 0,
                  max: 5,
                  divisions: 5,
                  label: _bedrooms == 0 ? 'Any' : '$_bedrooms',
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
              Text(_bedrooms == 0 ? 'Any' : '$_bedrooms'),
            ],
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