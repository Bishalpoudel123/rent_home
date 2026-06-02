import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/property_model.dart';
import '../providers/favorite_provider.dart';
import '../utils/app_theme.dart';

class PropertyDetailScreen extends StatefulWidget {
  final Property property;
  const PropertyDetailScreen({super.key, required this.property});

  @override
  State<PropertyDetailScreen> createState() => _PropertyDetailScreenState();
}

class _PropertyDetailScreenState extends State<PropertyDetailScreen> {
  int _currentImage = 0;
  final PageController _pageCtrl = PageController();

  @override
  void dispose() {
    _pageCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final p = widget.property;
    final favProvider = context.watch<FavoriteProvider>();
    final isFav = favProvider.isFavorite(p.id);

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          // Image gallery
          SliverAppBar(
            expandedHeight: 300,
            pinned: true,
            backgroundColor: Colors.black,
            leading: GestureDetector(
              onTap: () => Navigator.pop(context),
              child: Container(
                margin: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.4),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(Icons.arrow_back, color: Colors.white),
              ),
            ),
            actions: [
              GestureDetector(
                onTap: () => favProvider.toggleFavorite(p),
                child: Container(
                  margin: const EdgeInsets.all(8),
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.4),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(
                    isFav ? Icons.favorite : Icons.favorite_border,
                    color: isFav ? AppTheme.primaryRed : Colors.white,
                    size: 20,
                  ),
                ),
              ),
            ],
            flexibleSpace: FlexibleSpaceBar(
              background: Stack(
                children: [
                  PageView.builder(
                    controller: _pageCtrl,
                    itemCount: p.images.length,
                    onPageChanged: (i) => setState(() => _currentImage = i),
                    itemBuilder: (_, i) => Image.network(
                      p.images[i],
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => Container(
                        color: Colors.grey.shade200,
                        child: const Icon(Icons.home, size: 60),
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 12,
                    left: 0,
                    right: 0,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(
                        p.images.length,
                        (i) => AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          margin: const EdgeInsets.symmetric(horizontal: 3),
                          width: _currentImage == i ? 20 : 6,
                          height: 6,
                          decoration: BoxDecoration(
                            color: _currentImage == i
                                ? Colors.white
                                : Colors.white.withOpacity(0.5),
                            borderRadius: BorderRadius.circular(3),
                          ),
                        ),
                      ),
                    ),
                  ),
                  if (p.isVerified)
                    Positioned(
                      top: 16,
                      left: 60,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: AppTheme.success,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: const Row(
                          children: [
                            Icon(Icons.verified, color: Colors.white, size: 14),
                            SizedBox(width: 4),
                            Text('Verified',
                                style: TextStyle(
                                    color: Colors.white, fontSize: 12)),
                          ],
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),

          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Price and type
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(p.title,
                                style: const TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.w700,
                                    color: AppTheme.textDark)),
                            const SizedBox(height: 6),
                            Row(
                              children: [
                                const Icon(Icons.location_on,
                                    size: 14, color: AppTheme.textGrey),
                                const SizedBox(width: 2),
                                Text(p.address,
                                    style: const TextStyle(
                                        color: AppTheme.textGrey,
                                        fontSize: 13)),
                              ],
                            ),
                          ],
                        ),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(p.formattedPrice,
                              style: const TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.w800,
                                  color: AppTheme.primaryRed)),
                          Text('/${p.priceType == 'monthly' ? 'महिना' : 'वर्ष'}',
                              style: const TextStyle(
                                  fontSize: 12, color: AppTheme.textGrey)),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),

                  // Stats
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppTheme.backgroundLight,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _StatItem(
                            icon: Icons.bed,
                            label: '${p.bedrooms} कोठा',
                            sub: 'बेडरूम'),
                        _Divider(),
                        _StatItem(
                            icon: Icons.bathroom,
                            label: '${p.bathrooms} बाथ',
                            sub: 'बाथरूम'),
                        _Divider(),
                        _StatItem(
                            icon: Icons.square_foot,
                            label: '${p.areaSqFt.round()} sqft',
                            sub: 'क्षेत्रफल'),
                        _Divider(),
                        _StatItem(
                            icon: Icons.chair,
                            label: _furnishLabel(p.furnishingStatus),
                            sub: 'फर्निचर'),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Description
                  const Text('विवरण',
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: AppTheme.textDark)),
                  const SizedBox(height: 8),
                  Text(p.description,
                      style: const TextStyle(
                          color: AppTheme.textGrey,
                          height: 1.7,
                          fontSize: 14)),
                  const SizedBox(height: 24),

                  // Amenities
                  const Text('सुविधाहरू',
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: AppTheme.textDark)),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 10,
                    runSpacing: 10,
                    children: p.amenities
                        .map((a) => Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 12, vertical: 8),
                              decoration: BoxDecoration(
                                color: AppTheme.primaryRed.withOpacity(0.08),
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(
                                    color: AppTheme.primaryRed.withOpacity(0.2)),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const Icon(Icons.check_circle,
                                      color: AppTheme.primaryRed, size: 14),
                                  const SizedBox(width: 6),
                                  Text(a,
                                      style: const TextStyle(
                                          fontSize: 13,
                                          color: AppTheme.primaryRed,
                                          fontWeight: FontWeight.w500)),
                                ],
                              ),
                            ))
                        .toList(),
                  ),
                  const SizedBox(height: 24),

                  // Owner info
                  const Text('घर मालिक',
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: AppTheme.textDark)),
                  const SizedBox(height: 12),
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      border:
                          Border.all(color: AppTheme.dividerColor),
                    ),
                    child: Row(
                      children: [
                        CircleAvatar(
                          radius: 28,
                          backgroundImage: NetworkImage(p.ownerImage),
                          onBackgroundImageError: (_, __) {},
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(p.ownerName,
                                  style: const TextStyle(
                                      fontWeight: FontWeight.w700,
                                      fontSize: 15,
                                      color: AppTheme.textDark)),
                              const SizedBox(height: 2),
                              const Text('घर मालिक',
                                  style: TextStyle(
                                      color: AppTheme.textGrey, fontSize: 12)),
                            ],
                          ),
                        ),
                        Row(
                          children: [
                            _ContactBtn(
                              icon: Icons.phone,
                              color: AppTheme.success,
                              onTap: () =>
                                  _showContactSheet(context, p.ownerPhone),
                            ),
                            const SizedBox(width: 8),
                            _ContactBtn(
                              icon: Icons.chat_bubble_outline,
                              color: AppTheme.primaryBlue,
                              onTap: () {},
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 100),
                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 16,
              offset: const Offset(0, -4),
            ),
          ],
        ),
        child: Row(
          children: [
            Expanded(
              child: OutlinedButton.icon(
                onPressed: () => favProvider.toggleFavorite(p),
                icon: Icon(
                    isFav ? Icons.favorite : Icons.favorite_border,
                    size: 18),
                label: Text(isFav ? 'सेभ भयो' : 'सेभ गर्नुहोस्'),
                style: OutlinedButton.styleFrom(
                  foregroundColor:
                      isFav ? AppTheme.primaryRed : AppTheme.textGrey,
                  side: BorderSide(
                      color: isFav
                          ? AppTheme.primaryRed
                          : AppTheme.dividerColor),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              flex: 2,
              child: ElevatedButton.icon(
                onPressed: () => _showContactSheet(context, p.ownerPhone),
                icon: const Icon(Icons.phone, size: 18),
                label: const Text('सम्पर्क गर्नुहोस्'),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showContactSheet(BuildContext context, String phone) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (_) => Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(2))),
            const SizedBox(height: 20),
            const Text('सम्पर्क नम्बर',
                style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: AppTheme.textDark)),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              decoration: BoxDecoration(
                color: AppTheme.backgroundLight,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Text(
                phone,
                style: const TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 2,
                    color: AppTheme.primaryRed),
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.phone),
                label: const Text('फोन गर्नुहोस्'),
              ),
            ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }

  String _furnishLabel(String status) {
    switch (status) {
      case 'furnished':
        return 'सबै छ';
      case 'semi-furnished':
        return 'केही छ';
      default:
        return 'छैन';
    }
  }
}

class _StatItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final String sub;
  const _StatItem(
      {required this.icon, required this.label, required this.sub});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(icon, color: AppTheme.primaryRed, size: 22),
        const SizedBox(height: 4),
        Text(label,
            style: const TextStyle(
                fontWeight: FontWeight.w700,
                fontSize: 12,
                color: AppTheme.textDark)),
        Text(sub,
            style: const TextStyle(fontSize: 10, color: AppTheme.textGrey)),
      ],
    );
  }
}

class _Divider extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Container(
        width: 1,
        height: 40,
        color: AppTheme.dividerColor,
      );
}

class _ContactBtn extends StatelessWidget {
  final IconData icon;
  final Color color;
  final VoidCallback onTap;
  const _ContactBtn(
      {required this.icon, required this.color, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 38,
        height: 38,
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(icon, color: color, size: 18),
      ),
    );
  }
}