import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/property_model.dart';
import '../providers/property_provider.dart';
import '../services/mock_data_service.dart';
import '../utils/app_theme.dart';
import '../widgets/property_card.dart';
import 'property_detail_screen.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final _searchCtrl = TextEditingController();
  bool _showFilters = false;
  RangeValues _priceRange = const RangeValues(0, 200000);

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<PropertyProvider>();
    return Scaffold(
      appBar: AppBar(
        title: const Text('घर खोज्नुहोस्'),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(60),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _searchCtrl,
                    onChanged: provider.setSearchQuery,
                    decoration: InputDecoration(
                      hintText: 'ठेगाना, शहर वा इलाका...',
                      prefixIcon: const Icon(Icons.search, size: 20),
                      suffixIcon: _searchCtrl.text.isNotEmpty
                          ? IconButton(
                              icon: const Icon(Icons.clear, size: 18),
                              onPressed: () {
                                _searchCtrl.clear();
                                provider.setSearchQuery('');
                              },
                            )
                          : null,
                      isDense: true,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                GestureDetector(
                  onTap: () => setState(() => _showFilters = !_showFilters),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: _showFilters
                          ? AppTheme.primaryRed
                          : const Color(0xFFF3F4F6),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      Icons.tune_rounded,
                      color: _showFilters ? Colors.white : AppTheme.textGrey,
                      size: 22,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      body: Column(
        children: [
          if (_showFilters) _buildFilters(provider),
          _buildResultCount(provider),
          Expanded(
            child: provider.isLoading
                ? const Center(child: CircularProgressIndicator())
                : provider.properties.isEmpty
                    ? _buildEmpty()
                    : ListView.builder(
                        padding: const EdgeInsets.all(16),
                        itemCount: provider.properties.length,
                        itemBuilder: (_, i) => Padding(
                          padding: const EdgeInsets.only(bottom: 16),
                          child: PropertyCard(
                            property: provider.properties[i],
                            horizontal: true,
                            onTap: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => PropertyDetailScreen(
                                    property: provider.properties[i]),
                              ),
                            ),
                          ),
                        ),
                      ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilters(PropertyProvider provider) {
    final districts = MockDataService.getNepalDistricts();
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('फिल्टर',
                  style: TextStyle(
                      fontWeight: FontWeight.w700, color: AppTheme.textDark)),
              TextButton(
                onPressed: () {
                  provider.clearFilters();
                  _priceRange = const RangeValues(0, 200000);
                  setState(() {});
                },
                child: const Text('सफा गर्नुहोस्',
                    style: TextStyle(color: AppTheme.primaryRed)),
              ),
            ],
          ),

          // District
          const Text('जिल्ला',
              style: TextStyle(fontSize: 13, color: AppTheme.textGrey)),
          const SizedBox(height: 8),
          SizedBox(
            height: 36,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: districts.length + 1,
              itemBuilder: (_, i) {
                if (i == 0) {
                  return _FilterChip(
                    label: 'सबै',
                    selected: provider.selectedDistrict == null,
                    onTap: () => provider.setDistrict(null),
                  );
                }
                return _FilterChip(
                  label: districts[i - 1],
                  selected: provider.selectedDistrict == districts[i - 1],
                  onTap: () => provider.setDistrict(districts[i - 1]),
                );
              },
            ),
          ),
          const SizedBox(height: 12),

          // Type
          const Text('प्रकार',
              style: TextStyle(fontSize: 13, color: AppTheme.textGrey)),
          const SizedBox(height: 8),
          SizedBox(
            height: 36,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: [
                _FilterChip(
                    label: 'सबै',
                    selected: provider.selectedType == null,
                    onTap: () => provider.setPropertyType(null)),
                ...PropertyType.values.map((t) => _FilterChip(
                      label: _typeLabel(t),
                      selected: provider.selectedType == t,
                      onTap: () => provider.setPropertyType(t),
                    )),
              ],
            ),
          ),
          const SizedBox(height: 12),

          // Price range
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('मूल्य सीमा',
                  style: TextStyle(fontSize: 13, color: AppTheme.textGrey)),
              Text(
                'रू ${(_priceRange.start / 1000).round()}K - रू ${(_priceRange.end / 1000).round()}K',
                style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: AppTheme.primaryRed),
              ),
            ],
          ),
          RangeSlider(
            values: _priceRange,
            min: 0,
            max: 200000,
            divisions: 20,
            activeColor: AppTheme.primaryRed,
            onChanged: (range) {
              setState(() => _priceRange = range);
              provider.setPriceRange(range.start, range.end);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildResultCount(PropertyProvider provider) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      color: AppTheme.backgroundLight,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            '${provider.properties.length} घरहरू भेटिए',
            style: const TextStyle(
                fontWeight: FontWeight.w600, color: AppTheme.textDark),
          ),
          DropdownButton<String>(
            value: provider.sortBy,
            underline: const SizedBox(),
            isDense: true,
            style: const TextStyle(
                fontSize: 12, color: AppTheme.textGrey, fontFamily: 'Poppins'),
            items: const [
              DropdownMenuItem(value: 'newest', child: Text('नयाँ पहिले')),
              DropdownMenuItem(
                  value: 'price_low', child: Text('सस्तो पहिले')),
              DropdownMenuItem(
                  value: 'price_high', child: Text('महँगो पहिले')),
            ],
            onChanged: (v) => provider.setSortBy(v!),
          ),
        ],
      ),
    );
  }

  Widget _buildEmpty() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.search_off_rounded,
              size: 72, color: Colors.grey.shade300),
          const SizedBox(height: 16),
          const Text('कुनै घर भेटिएन',
              style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: AppTheme.textDark)),
          const SizedBox(height: 8),
          const Text('अर्को keyword वा फिल्टर प्रयास गर्नुहोस्',
              style: TextStyle(color: AppTheme.textGrey)),
        ],
      ),
    );
  }

  String _typeLabel(PropertyType type) {
    const map = {
      PropertyType.room: 'कोठा',
      PropertyType.apartment: 'अपार्टमेन्ट',
      PropertyType.house: 'घर',
      PropertyType.flat: 'फ्ल्याट',
      PropertyType.office: 'अफिस',
      PropertyType.land: 'जग्गा',
    };
    return map[type] ?? '';
  }
}

class _FilterChip extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _FilterChip(
      {required this.label, required this.selected, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        margin: const EdgeInsets.only(right: 8),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
        decoration: BoxDecoration(
          color: selected
              ? AppTheme.primaryRed
              : const Color(0xFFF3F4F6),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: selected ? Colors.white : AppTheme.textGrey,
          ),
        ),
      ),
    );
  }
}