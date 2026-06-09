import 'package:flutter/material.dart';

class RoommateFinderScreen extends StatefulWidget {
  @override
  _RoommateFinderScreenState createState() => _RoommateFinderScreenState();
}

class _RoommateFinderScreenState extends State<RoommateFinderScreen> {
  double _budgetRange = 10000;
  double _ageRange = 28;
  
  final List<RoommateProfile> _roommates = [
    RoommateProfile(
      name: 'आलिसा श्रेष्ठ',
      age: '25',
      occupation: 'सफ्टवेयर इन्जिनियर',
      budget: '8000',
      interests: ['कोडिङ', 'गेमिङ', 'सङ्गीत'],
      imageUrl: null,
      location: 'ललितपुर',
      cleanliness: 'सफा',
    ),
    RoommateProfile(
      name: 'विवेक शर्मा',
      age: '28',
      occupation: 'ग्राफिक डिजाइनर',
      budget: '7500',
      interests: ['कला', 'फोटोग्राफी', 'यात्रा'],
      imageUrl: null,
      location: 'काठमाडौं',
      cleanliness: 'मिलनसार',
    ),
    RoommateProfile(
      name: 'सृजना कार्की',
      age: '24',
      occupation: 'विद्यार्थी',
      budget: '6000',
      interests: ['पुस्तक पढ्ने', 'योग', 'खाना पकाउने'],
      imageUrl: null,
      location: 'भक्तपुर',
      cleanliness: 'व्यवस्थित',
    ),
    RoommateProfile(
      name: 'रोहित गिरी',
      age: '26',
      occupation: 'ब्याङ्कर',
      budget: '10000',
      interests: ['फुटबल', 'सिनेमा', 'भ्रमण'],
      imageUrl: null,
      location: 'पोखरा',
      cleanliness: 'सफा',
    ),
    RoommateProfile(
      name: 'प्रिया थापा',
      age: '23',
      occupation: 'नर्स',
      budget: '7000',
      interests: ['योग', 'ध्यान', 'पढाइ'],
      imageUrl: null,
      location: 'काठमाडौं',
      cleanliness: 'धेरै सफा',
    ),
  ];
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'रूममेट खोज्नुहोस्',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
        centerTitle: false,
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: () {
              _showFilterDialog(context);
            },
            tooltip: 'फिल्टर गर्नुहोस्',
          ),
        ],
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(12),
        itemCount: _roommates.length,
        itemBuilder: (context, index) {
          final roommate = _roommates[index];
          return _buildRoommateCard(context, roommate);
        },
      ),
    );
  }
  
  Widget _buildRoommateCard(BuildContext context, RoommateProfile roommate) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: _getAvatarColor(roommate.name),
                  ),
                  child: Center(
                    child: Text(
                      roommate.name[0],
                      style: const TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        roommate.name,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${roommate.age} वर्ष · ${roommate.occupation}',
                        style: TextStyle(
                          fontSize: 13,
                          color: Colors.grey[600],
                        ),
                      ),
                      const SizedBox(height: 2),
                      Row(
                        children: [
                          Icon(Icons.location_on, size: 12, color: Colors.grey[500]),
                          const SizedBox(width: 2),
                          Text(
                            roommate.location,
                            style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.blue.shade50,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: Colors.blue.shade200),
                  ),
                  child: Column(
                    children: [
                      const Text(
                        'बजेट',
                        style: TextStyle(fontSize: 10, color: Colors.grey),
                      ),
                      Text(
                        'रु. ${roommate.budget}',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Colors.blue.shade700,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            
            const SizedBox(height: 16),
            
            const Text(
              'रुचिहरू:',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: roommate.interests.map((interest) {
                return Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.purple.shade50,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: Colors.purple.shade200),
                  ),
                  child: Text(
                    interest,
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.purple.shade700,
                    ),
                  ),
                );
              }).toList(),
            ),
            
            const SizedBox(height: 16),
            
            Row(
              children: [
                const Icon(Icons.cleaning_services, size: 16, color: Colors.grey),
                const SizedBox(width: 4),
                const Text('सरसफाइ:', style: TextStyle(fontSize: 12, color: Colors.grey)),
                const SizedBox(width: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  decoration: BoxDecoration(
                    color: _getCleanlinessColor(roommate.cleanliness).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    roommate.cleanliness,
                    style: TextStyle(
                      fontSize: 11,
                      color: _getCleanlinessColor(roommate.cleanliness),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
            
            const SizedBox(height: 16),
            
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {
                      _showProfileDialog(context, roommate);
                    },
                    style: OutlinedButton.styleFrom(
                      side: BorderSide(color: Colors.blue.shade300),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text('प्रोफाइल हेर्नुहोस्'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      _showConnectDialog(context, roommate);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text('सम्पर्क गर्नुहोस्'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
  
  void _showFilterDialog(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return Container(
              padding: const EdgeInsets.all(20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'फिल्टर गर्नुहोस्',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 20),
                  const Text('बजेट दायरा (रु.)', style: TextStyle(fontWeight: FontWeight.w600)),
                  const SizedBox(height: 8),
                  Text('रु. ० - रु. ${_budgetRange.toInt()}'),
                  Slider(
                    min: 0,
                    max: 20000,
                    divisions: 20,
                    value: _budgetRange,
                    onChanged: (value) {
                      setState(() {
                        _budgetRange = value;
                      });
                    },
                  ),
                  const SizedBox(height: 20),
                  const Text('उमेर दायरा', style: TextStyle(fontWeight: FontWeight.w600)),
                  const SizedBox(height: 8),
                  Text('${_ageRange.toInt()} वर्ष'),
                  Slider(
                    min: 18,
                    max: 40,
                    divisions: 22,
                    value: _ageRange,
                    onChanged: (value) {
                      setState(() {
                        _ageRange = value;
                      });
                    },
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: const Text('फिल्टर लागू गर्नुहोस्'),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
  
  void _showProfileDialog(BuildContext context, RoommateProfile roommate) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Row(
          children: [
            Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: _getAvatarColor(roommate.name),
              ),
              child: Center(
                child: Text(
                  roommate.name[0],
                  style: const TextStyle(fontSize: 24, color: Colors.white),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    roommate.name,
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    '${roommate.age} वर्ष · ${roommate.occupation}',
                    style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                  ),
                ],
              ),
            ),
          ],
        ),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildInfoRow(Icons.location_on, 'स्थान', roommate.location),
              _buildInfoRow(Icons.currency_rupee, 'मासिक बजेट', 'रु. ${roommate.budget}'),
              _buildInfoRow(Icons.favorite, 'रुचिहरू', roommate.interests.join(', ')),
              _buildInfoRow(Icons.cleaning_services, 'सरसफाइ', roommate.cleanliness),
              const SizedBox(height: 12),
              const Text(
                'बारेमा:',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 4),
              Text(
                '${roommate.name} एक ${roommate.occupation} हुन्। उनीहरू ${roommate.location} मा बस्छन्। ${roommate.cleanliness} र मिलनसार स्वभावका छन्।',
                style: const TextStyle(fontSize: 13),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('बन्द गर्नुहोस्'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              _showConnectDialog(context, roommate);
            },
            child: const Text('सम्पर्क गर्नुहोस्'),
          ),
        ],
      ),
    );
  }
  
  void _showConnectDialog(BuildContext context, RoommateProfile roommate) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text('सम्पर्क अनुरोध'),
        content: Text(
          'के तपाईं ${roommate.name} लाई सम्पर्क गर्न चाहनुहुन्छ?\n\nउनीहरूलाई तपाईंको इच्छा बारे सूचित गरिनेछ।',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('रद्द'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('सम्पर्क अनुरोध पठाइयो!'),
                  backgroundColor: Colors.green,
                ),
              );
            },
            child: const Text('पठाउनुहोस्'),
          ),
        ],
      ),
    );
  }
  
  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Icon(icon, size: 16, color: Colors.blue),
          const SizedBox(width: 8),
          SizedBox(
            width: 60,
            child: Text(label, style: const TextStyle(fontWeight: FontWeight.w500)),
          ),
          const Text(':'),
          const SizedBox(width: 8),
          Expanded(child: Text(value)),
        ],
      ),
    );
  }
  
  Color _getAvatarColor(String name) {
    final colors = [
      Colors.blue,
      Colors.green,
      Colors.orange,
      Colors.purple,
      Colors.red,
      Colors.teal,
      Colors.pink,
    ];
    return colors[name.length % colors.length];
  }
  
  Color _getCleanlinessColor(String cleanliness) {
    switch (cleanliness) {
      case 'धेरै सफा':
        return Colors.green;
      case 'सफा':
        return Colors.blue;
      case 'व्यवस्थित':
        return Colors.orange;
      case 'मिलनसार':
        return Colors.purple;
      default:
        return Colors.grey;
    }
  }
}

class RoommateProfile {
  final String name;
  final String age;
  final String occupation;
  final String budget;
  final List<String> interests;
  final String? imageUrl;
  final String location;
  final String cleanliness;
  
  RoommateProfile({
    required this.name,
    required this.age,
    required this.occupation,
    required this.budget,
    required this.interests,
    this.imageUrl,
    required this.location,
    required this.cleanliness,
  });
}