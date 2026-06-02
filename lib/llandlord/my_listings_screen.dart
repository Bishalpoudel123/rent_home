import 'package:flutter/material.dart';
import 'package:nepal_rent_app/llandlord/e%20post_room_screen.dart';
import 'package:provider/provider.dart';
import '../../models/property_model.dart';
import '../../providers/property_provider.dart';
import '../../utils/app_theme.dart';
//import 'post_room_screen.dart';

class MyListingsScreen extends StatelessWidget {
  const MyListingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final props = context.watch<PropertyProvider>().allProperties.take(3).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('मेरा कोठाहरू'),
        actions: [
          TextButton.icon(
            onPressed: () => Navigator.push(context,
                MaterialPageRoute(builder: (_) => const PostRoomScreen())),
            icon: const Icon(Icons.add, size: 18),
            label: const Text('थप्नुहोस्'),
          ),
        ],
      ),
      body: Column(
        children: [
          // Stats row
          Container(
            padding: const EdgeInsets.all(16),
            color: Colors.white,
            child: Row(
              children: [
                _StatCard(label: 'कुल कोठा', value: '${props.length}', color: AppTheme.primaryRed),
                const SizedBox(width: 12),
                _StatCard(label: 'उपलब्ध', value: '${props.where((p) => p.isAvailable).length}', color: AppTheme.success),
                const SizedBox(width: 12),
                _StatCard(label: 'भाडामा', value: '${props.where((p) => !p.isAvailable).length}', color: AppTheme.primaryBlue),
              ],
            ),
          ),
          const Divider(height: 1),

          Expanded(
            child: props.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.home_work_outlined, size: 64, color: Color(0xFFD1D5DB)),
                        const SizedBox(height: 16),
                        const Text('कुनै कोठा छैन',
                            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                        const SizedBox(height: 8),
                        ElevatedButton.icon(
                          onPressed: () => Navigator.push(context,
                              MaterialPageRoute(builder: (_) => const PostRoomScreen())),
                          icon: const Icon(Icons.add, size: 16),
                          label: const Text('पहिलो कोठा थप्नुहोस्'),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: props.length,
                    itemBuilder: (_, i) => _LandlordRoomCard(property: props[i]),
                  ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.push(
            context, MaterialPageRoute(builder: (_) => const PostRoomScreen())),
        backgroundColor: AppTheme.primaryRed,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final String label, value;
  final Color color;
  const _StatCard({required this.label, required this.value, required this.color});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: color.withOpacity(0.08),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          children: [
            Text(value,
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.w700, color: color)),
            Text(label,
                style: const TextStyle(fontSize: 11, color: AppTheme.textGrey)),
          ],
        ),
      ),
    );
  }
}

class _LandlordRoomCard extends StatefulWidget {
  final Property property;
  const _LandlordRoomCard({required this.property});

  @override
  State<_LandlordRoomCard> createState() => _LandlordRoomCardState();
}

class _LandlordRoomCardState extends State<_LandlordRoomCard> {
  late bool _isAvailable;

  @override
  void initState() {
    super.initState();
    _isAvailable = widget.property.isAvailable;
  }

  @override
  Widget build(BuildContext context) {
    final p = widget.property;
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE5E7EB)),
      ),
      child: Column(
        children: [
          // Image + status
          Stack(
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                child: Image.network(
                  p.images.first,
                  height: 140,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => Container(
                    height: 140,
                    color: const Color(0xFFE5E7EB),
                    child: const Icon(Icons.home, size: 50),
                  ),
                ),
              ),
              Positioned(
                top: 10,
                right: 10,
                child: GestureDetector(
                  onTap: () => setState(() => _isAvailable = !_isAvailable),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    decoration: BoxDecoration(
                      color: _isAvailable ? AppTheme.success : AppTheme.textGrey,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      _isAvailable ? 'उपलब्ध' : 'भाडामा',
                      style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.w600),
                    ),
                  ),
                ),
              ),
            ],
          ),

          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(p.title,
                    style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
                const SizedBox(height: 4),
                Row(
                  children: [
                    const Icon(Icons.location_on, size: 12, color: AppTheme.textGrey),
                    Text(p.address,
                        style: const TextStyle(fontSize: 11, color: AppTheme.textGrey)),
                    const Spacer(),
                    Text(p.formattedPrice,
                        style: const TextStyle(
                            fontWeight: FontWeight.w700,
                            color: AppTheme.primaryRed,
                            fontSize: 14)),
                  ],
                ),
                const SizedBox(height: 10),
                const Divider(height: 1),
                const SizedBox(height: 10),

                // Action buttons
                Row(
                  children: [
                    _ActionBtn(icon: Icons.edit_outlined, label: 'सम्पादन', onTap: () {}),
                    const SizedBox(width: 8),
                    _ActionBtn(icon: Icons.bar_chart, label: 'Analytics', onTap: () {}),
                    const SizedBox(width: 8),
                    _ActionBtn(
                        icon: Icons.delete_outline,
                        label: 'मेटाउनुहोस्',
                        onTap: () => _confirmDelete(context),
                        isDestructive: true),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _confirmDelete(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('कोठा मेटाउने?'),
        content: const Text('यो कोठा permanently हटाइनेछ।'),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('रद्द गर्नुहोस्')),
          ElevatedButton(
            onPressed: () => Navigator.pop(context),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('मेटाउनुहोस्'),
          ),
        ],
      ),
    );
  }
}

class _ActionBtn extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final bool isDestructive;

  const _ActionBtn({
    required this.icon,
    required this.label,
    required this.onTap,
    this.isDestructive = false,
  });

  @override
  Widget build(BuildContext context) {
    final color = isDestructive ? Colors.red : AppTheme.textGrey;
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 7),
          decoration: BoxDecoration(
            color: isDestructive
                ? Colors.red.withOpacity(0.05)
                : const Color(0xFFF3F4F6),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 13, color: color),
              const SizedBox(width: 4),
              Text(label,
                  style: TextStyle(fontSize: 11, color: color, fontWeight: FontWeight.w500)),
            ],
          ),
        ),
      ),
    );
  }
}