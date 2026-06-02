import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/property_model.dart';
import '../providers/auth_provider.dart';
import '../providers/property_provider.dart';
import '../utils/app_theme.dart';
import '../widgets/property_card.dart';
import '../widgets/category_chip.dart';
import 'property_detail_screen.dart';
import 'search_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  PropertyType? _selectedCategory;

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();
    final provider = context.watch<PropertyProvider>();
    final greeting = _getGreeting();

    return Scaffold(
      backgroundColor: AppTheme.backgroundLight,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 200,
            pinned: true,
            backgroundColor: AppTheme.primaryRed,
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [AppTheme.primaryRed, Color(0xFF8B0000)],
                  ),
                ),
                child: SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(greeting,
                                    style: TextStyle(
                                        color: Colors.white.withOpacity(0.8),
                                        fontSize: 14)),
                                Text(
                                  auth.isLoggedIn
                                      ? auth.currentUser!.name
                                      : 'पाहुना',
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 20,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ],
                            ),
                            Container(
                              width: 42,
                              height: 42,
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.15),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: const Icon(Icons.notifications_none,
                                  color: Colors.white),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        GestureDetector(
                          onTap: () {},
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 12),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Row(
                              children: [
                                const Icon(Icons.search,
                                    color: AppTheme.textGrey, size: 20),
                                const SizedBox(width: 10),
                                Text(
                                  'काठमाडौँ, ललितपुर, भक्तपुर...',
                                  style: TextStyle(
                                    color: Colors.grey.shade400,
                                    fontSize: 14,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            title: const Text('घर ढुन्डो',
                style: TextStyle(color: Colors.white, fontSize: 18)),
          ),

          if (provider.isLoading)
            const SliverFillRemaining(
              child: Center(child: CircularProgressIndicator()),
            )
          else ...[
            // Categories
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('के खोज्दैहुनुहुन्छ?',
                        style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                            color: AppTheme.textDark)),
                  ],
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: SizedBox(
                height: 90,
                child: ListView(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 20, vertical: 12),
                  scrollDirection: Axis.horizontal,
                  children: [
                    CategoryChip(
                      icon: Icons.all_inclusive,
                      label: 'सबै',
                      selected: _selectedCategory == null,
                      onTap: () =>
                          setState(() => _selectedCategory = null),
                    ),
                    ...PropertyType.values.map((type) => CategoryChip(
                          icon: _getTypeIcon(type),
                          label: _getTypeLabel(type),
                          selected: _selectedCategory == type,
                          onTap: () =>
                              setState(() => _selectedCategory = type),
                        )),
                  ],
                ),
              ),
            ),

            // Featured
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 8, 20, 12),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('विशेष घरहरू',
                        style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                            color: AppTheme.textDark)),
                    TextButton(
                      onPressed: () {},
                      child: const Text('सबै हेर्नुहोस्'),
                    ),
                  ],
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: SizedBox(
                height: 280,
                child: ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  scrollDirection: Axis.horizontal,
                  itemCount: provider.getFeaturedProperties().length,
                  itemBuilder: (_, i) {
                    final prop = provider.getFeaturedProperties()[i];
                    return Padding(
                      padding: const EdgeInsets.only(right: 16),
                      child: SizedBox(
                        width: 240,
                        child: PropertyCard(
                          property: prop,
                          onTap: () => _openDetail(prop),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),

            // Nearby
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 20, 20, 12),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('नजिकका घरहरू',
                        style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                            color: AppTheme.textDark)),
                    TextButton(
                      onPressed: () {},
                      child: const Text('सबै हेर्नुहोस्'),
                    ),
                  ],
                ),
              ),
            ),
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              sliver: SliverList(
                delegate: SliverChildBuilderDelegate(
                  (_, i) {
                    final filtered = _selectedCategory == null
                        ? provider.properties
                        : provider.properties
                            .where((p) => p.type == _selectedCategory)
                            .toList();
                    if (i >= filtered.length) return null;
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 16),
                      child: PropertyCard(
                        property: filtered[i],
                        horizontal: true,
                        onTap: () => _openDetail(filtered[i]),
                      ),
                    );
                  },
                  childCount: _selectedCategory == null
                      ? provider.properties.length
                      : provider.properties
                          .where((p) => p.type == _selectedCategory)
                          .length,
                ),
              ),
            ),
            const SliverToBoxAdapter(child: SizedBox(height: 20)),
          ],
        ],
      ),
    );
  }

  void _openDetail(property) {
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (_) => PropertyDetailScreen(property: property)),
    );
  }

  String _getGreeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) return 'शुभ प्रभात 🌅';
    if (hour < 17) return 'शुभ दिन ☀️';
    return 'शुभ सन्ध्या 🌙';
  }

  IconData _getTypeIcon(PropertyType type) {
    switch (type) {
      case PropertyType.room:
        return Icons.bed_rounded;
      case PropertyType.apartment:
        return Icons.apartment_rounded;
      case PropertyType.house:
        return Icons.home_rounded;
      case PropertyType.flat:
        return Icons.domain_rounded;
      case PropertyType.office:
        return Icons.business_rounded;
      case PropertyType.land:
        return Icons.landscape_rounded;
    }
  }

  String _getTypeLabel(PropertyType type) {
    switch (type) {
      case PropertyType.room:
        return 'कोठा';
      case PropertyType.apartment:
        return 'अपार्टमेन्ट';
      case PropertyType.house:
        return 'घर';
      case PropertyType.flat:
        return 'फ्ल्याट';
      case PropertyType.office:
        return 'अफिस';
      case PropertyType.land:
        return 'जग्गा';
    }
  }
}