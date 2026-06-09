import 'package:flutter/material.dart';

class RoommateFinderScreen extends StatelessWidget {
  final List<RoommateProfile> _roommates = [
    RoommateProfile(
      name: 'Alice Johnson',
      age: 25,
      occupation: 'Software Engineer',
      budget: 800,
      interests: ['Coding', 'Gaming', 'Music'],
      imageUrl: null,
    ),
    RoommateProfile(
      name: 'Bob Smith',
      age: 28,
      occupation: 'Graphic Designer',
      budget: 750,
      interests: ['Art', 'Photography', 'Travel'],
      imageUrl: null,
    ),
    RoommateProfile(
      name: 'Carol Davis',
      age: 24,
      occupation: 'Student',
      budget: 600,
      interests: ['Reading', 'Yoga', 'Cooking'],
      imageUrl: null,
    ),
  ];
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Find Roommates'),
      ),
      body: ListView.builder(
        padding: EdgeInsets.all(16),
        itemCount: _roommates.length,
        itemBuilder: (context, index) {
          final roommate = _roommates[index];
          return Card(
            margin: EdgeInsets.only(bottom: 16),
            child: Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      CircleAvatar(
                        radius: 30,
                        backgroundColor: Colors.blue.shade100,
                        child: Text(
                          roommate.name[0],
                          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                        ),
                      ),
                      SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              roommate.name,
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              '${roommate.age} years • ${roommate.occupation}',
                              style: TextStyle(color: Colors.grey[600]),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: Colors.green.shade100,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          '\$${roommate.budget}/mo',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.green.shade800,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 12),
                  Wrap(
                    spacing: 8,
                    children: roommate.interests.map((interest) {
                      return Chip(
                        label: Text(interest),
                        backgroundColor: Colors.blue.shade50,
                      );
                    }).toList(),
                  ),
                  SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () {},
                          child: Text('View Profile'),
                        ),
                      ),
                      SizedBox(width: 8),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {},
                          child: Text('Connect'),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class RoommateProfile {
  final String name;
  final int age;
  final String occupation;
  final double budget;
  final List<String> interests;
  final String? imageUrl;
  
  RoommateProfile({
    required this.name,
    required this.age,
    required this.occupation,
    required this.budget,
    required this.interests,
    this.imageUrl,
  });
}