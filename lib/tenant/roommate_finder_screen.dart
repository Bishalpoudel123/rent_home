import 'package:flutter/material.dart';
import '../../models/roommate_model.dart';
import '../../utils/app_theme.dart';

class RoommateFinderScreen extends StatefulWidget {
  const RoommateFinderScreen({super.key});

  @override
  State<RoommateFinderScreen> createState() => _RoommateFinderScreenState();
}

class _RoommateFinderScreenState extends State<RoommateFinderScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabCtrl;

  final List<RoommatePost> _posts = [
    RoommatePost(
      id: '1',
      userId: 'u1',
      userName: 'सञ्जय कुमार',
      userImage: 'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=200',
      userPhone: '9841111111',
      preferredArea: 'कोटेश्वर',
      district: 'काठमाडौँ',
      minBudget: 5000,
      maxBudget: 8000,
      genderPreference: 'male',
      lifestyle: ['विद्यार्थी', 'शाकाहारी', 'धूम्रपान नगर्ने'],
      description: 'TU को student हुँ। शान्त र सफा साथी खोज्दैछु। Koteshwor वा नजिकको area मा कोठा खोज्दैछु।',
      postedDate: DateTime.now().subtract(const Duration(days: 2)),
      isActive: true,
    ),
    RoommatePost(
      id: '2',
      userId: 'u2',
      userName: 'प्रिया श्रेष्ठ',
      userImage: 'https://images.unsplash.com/photo-1494790108377-be9c29b29330?w=200',
      userPhone: '9851111111',
      preferredArea: 'लजिम्पाट',
      district: 'काठमाडौँ',
      minBudget: 8000,
      maxBudget: 12000,
      genderPreference: 'female',
      lifestyle: ['Office जागिरे', 'शाकाहारी'],
      description: 'IT company मा job गर्छु। Clean र respectful साथी चाहिन्छ। Lazmipat area prefer गर्छु।',
      postedDate: DateTime.now().subtract(const Duration(days: 1)),
      isActive: true,
    ),
    RoommatePost(
      id: '3',
      userId: 'u3',
      userName: 'अमित तामाङ',
      userImage: 'https://images.unsplash.com/photo-1472099645785-5658abf4ff4e?w=200',
      userPhone: '9861111111',
      preferredArea: 'थमेल',
      district: 'काठमाडौँ',
      minBudget: 6000,
      maxBudget: 10000,
      genderPreference: 'any',
      lifestyle: ['विद्यार्थी', 'Early riser'],
      description: 'Thamel वा नजिकको area मा share room खोज्दैछु। Budget flexible छ।',
      postedDate: DateTime.now().subtract(const Duration(hours: 5)),
      isActive: true,
    ),
  ];

  @override
  void initState() {
    super.initState();
    _tabCtrl = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Roommate खोज्नुहोस्'),
        bottom: TabBar(
          controller: _tabCtrl,
          labelColor: AppTheme.primaryRed,
          unselectedLabelColor: AppTheme.textGrey,
          indicatorColor: AppTheme.primaryRed,
          tabs: const [
            Tab(text: 'खोज्दैछन्'),
            Tab(text: 'मेरो Post'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabCtrl,
        children: [
          _buildPostsList(),
          _buildMyPost(),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showPostSheet(context),
        backgroundColor: AppTheme.primaryRed,
        icon: const Icon(Icons.add, color: Colors.white),
        label: const Text('Post गर्नुहोस्', style: TextStyle(color: Colors.white)),
      ),
    );
  }

  Widget _buildPostsList() {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: _posts.length,
      itemBuilder: (_, i) => _RoommateCard(post: _posts[i]),
    );
  }

  Widget _buildMyPost() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.person_search, size: 72, color: Colors.grey.shade300),
            const SizedBox(height: 16),
            const Text('तपाईंले अझै post गर्नुभएको छैन',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
            const SizedBox(height: 8),
            const Text('आफ्नो requirement post गर्नुहोस् र roommate खोज्नुहोस्',
                style: TextStyle(color: AppTheme.textGrey), textAlign: TextAlign.center),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: () => _showPostSheet(context),
              icon: const Icon(Icons.add),
              label: const Text('Post गर्नुहोस्'),
            ),
          ],
        ),
      ),
    );
  }

  void _showPostSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (_) => Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
          left: 20, right: 20, top: 20,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Roommate खोज्ने Post',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700)),
            const SizedBox(height: 16),
            const TextField(
              decoration: InputDecoration(labelText: 'preferred area'),
            ),
            const SizedBox(height: 12),
            const TextField(
              keyboardType: TextInputType.number,
              decoration: InputDecoration(labelText: 'Max budget (NPR)'),
            ),
            const SizedBox(height: 12),
            const TextField(
              maxLines: 3,
              decoration: InputDecoration(labelText: 'आफ्नो बारेमा लेख्नुहोस्'),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Post गर्नुहोस्'),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}

class _RoommateCard extends StatelessWidget {
  final RoommatePost post;
  const _RoommateCard({required this.post});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE5E7EB)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 22,
                backgroundImage: NetworkImage(post.userImage),
                backgroundColor: const Color(0xFFE5E7EB),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(post.userName,
                        style: const TextStyle(
                            fontWeight: FontWeight.w600, fontSize: 14)),
                    Row(
                      children: [
                        const Icon(Icons.location_on, size: 11, color: AppTheme.textGrey),
                        Text(post.preferredArea,
                            style: const TextStyle(fontSize: 11, color: AppTheme.textGrey)),
                      ],
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: AppTheme.primaryRed.withOpacity(0.08),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(post.genderLabel,
                    style: const TextStyle(
                        fontSize: 11, color: AppTheme.primaryRed, fontWeight: FontWeight.w600)),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(post.description,
              style: const TextStyle(fontSize: 12, color: AppTheme.textGrey, height: 1.5)),
          const SizedBox(height: 10),
          Wrap(
            spacing: 6,
            runSpacing: 6,
            children: [
              _Tag(label: post.budgetRange, icon: Icons.currency_rupee, color: AppTheme.success),
              ...post.lifestyle.map((l) => _Tag(label: l, icon: Icons.check, color: AppTheme.primaryBlue)),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.chat_bubble_outline, size: 14),
                  label: const Text('Message'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppTheme.primaryBlue,
                    side: const BorderSide(color: AppTheme.primaryBlue),
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    textStyle: const TextStyle(fontSize: 12),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.phone, size: 14),
                  label: const Text('फोन'),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    textStyle: const TextStyle(fontSize: 12),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _Tag extends StatelessWidget {
  final String label;
  final IconData icon;
  final Color color;
  const _Tag({required this.label, required this.icon, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.08),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 10, color: color),
          const SizedBox(width: 4),
          Text(label, style: TextStyle(fontSize: 10, color: color, fontWeight: FontWeight.w500)),
        ],
      ),
    );
  }
}